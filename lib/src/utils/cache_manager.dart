import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';

class CacheManager {
  static const int maxCacheSize = 200 * 1024 * 1024; // 200 MB
  static const Duration maxAge = Duration(days: 7);
  
  static Future<void> cleanCache() async {
    try {
      final tempDir = await getTemporaryDirectory();
      final cacheDir = Directory('${tempDir.path}/vs_story_designer_cache');
      
      if (await cacheDir.exists()) {
        int totalSize = 0;
        final List<FileSystemEntity> files = await cacheDir.list().toList();
        
        // Sort files by last access time
        files.sort((a, b) {
          return a.statSync().accessed.compareTo(b.statSync().accessed);
        });

        for (var file in files) {
          if (file is File) {
            final DateTime lastAccessed = file.statSync().accessed;
            final bool isOld = DateTime.now().difference(lastAccessed) > maxAge;
            
            if (isOld) {
              await file.delete();
              continue;
            }

            totalSize += await file.length();
          }
        }

        // If cache is too large, delete oldest files
        if (totalSize > maxCacheSize) {
          for (var file in files) {
            if (file is File) {
              await file.delete();
              totalSize -= await file.length();
              if (totalSize <= maxCacheSize) break;
            }
          }
        }
      }
    } catch (e) {
      debugPrint('Cache cleanup error: $e');
    }
  }

  static Future<File> cacheFile(File sourceFile) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final cacheDir = Directory('${tempDir.path}/vs_story_designer_cache');
      
      if (!await cacheDir.exists()) {
        await cacheDir.create(recursive: true);
      }

      final String fileName = DateTime.now().millisecondsSinceEpoch.toString() + 
                            '_' + 
                            sourceFile.path.split('/').last;
      final File cachedFile = File('${cacheDir.path}/$fileName');
      
      await sourceFile.copy(cachedFile.path);
      return cachedFile;
    } catch (e) {
      debugPrint('File caching error: $e');
      return sourceFile; // Return original file if caching fails
    }
  }
}
