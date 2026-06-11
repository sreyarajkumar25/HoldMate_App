import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

extension Translate on BuildContext {
  String tr(String key) {
    return AppLocalizations.of(this)?.translate(key) ?? key;
  }
}
