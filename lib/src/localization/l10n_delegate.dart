import 'package:flutter/material.dart';
import 'l10n.dart';

class VSStoryDesignerLocalizationsDelegate
    extends LocalizationsDelegate<VSStoryDesignerLocalizations> {
  const VSStoryDesignerLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'es'].contains(locale.languageCode);
  }

  @override
  Future<VSStoryDesignerLocalizations> load(Locale locale) async {
    return VSStoryDesignerLocalizations(locale);
  }

  @override
  bool shouldReload(VSStoryDesignerLocalizationsDelegate old) => false;
}
