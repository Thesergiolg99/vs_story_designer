import 'package:flutter/material.dart';

class VSStoryDesignerLocalizations {
  final Locale locale;

  VSStoryDesignerLocalizations(this.locale);

  static VSStoryDesignerLocalizations of(BuildContext context) {
    return Localizations.of<VSStoryDesignerLocalizations>(
      context,
      VSStoryDesignerLocalizations,
    )!;
  }

  static const _localizedValues = {
    'en': {
      'done': 'Done',
      'cancel': 'Cancel',
      'discard': 'Discard',
      'discardEdits': 'Discard Edits?',
      'discardWarning': 'If you go back now, you\'ll lose all the edits you\'ve made.',
      'designToSave': 'Design something to save image',
      'successfullySaved': 'Successfully saved',
      'ready': 'Ready',
    },
    'es': {
      'done': 'Listo',
      'cancel': 'Cancelar', 
      'discard': 'Descartar',
      'discardEdits': '¿Descartar cambios?',
      'discardWarning': 'Si regresas ahora, perderás todos los cambios que has realizado.',
      'designToSave': 'Diseña algo para guardar la imagen',
      'successfullySaved': 'Guardado exitosamente',
      'ready': 'Listo',
    },
  };

  String get done => _localizedValues[locale.languageCode]!['done']!;
  String get cancel => _localizedValues[locale.languageCode]!['cancel']!;
  String get discard => _localizedValues[locale.languageCode]!['discard']!;
  String get discardEdits => _localizedValues[locale.languageCode]!['discardEdits']!;
  String get discardWarning => _localizedValues[locale.languageCode]!['discardWarning']!;
  String get designToSave => _localizedValues[locale.languageCode]!['designToSave']!;
  String get successfullySaved => _localizedValues[locale.languageCode]!['successfullySaved']!;
  String get ready => _localizedValues[locale.languageCode]!['ready']!;
}
