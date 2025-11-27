import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taro/common/util/app_storage.dart';
import 'package:taro/i18n/strings.g.dart';

final languageProvider =
    StateNotifierProvider<LanguageNotifier, AppLocale>((ref) {
      return LanguageNotifier(AppStorage());
    });

class LanguageNotifier extends StateNotifier<AppLocale> {
  LanguageNotifier(this._storage) : super(LocaleSettings.currentLocale) {
    _loadStoredLanguage();
  }

  final AppStorage _storage;

  Future<void> _loadStoredLanguage() async {
    final storedCode =
        await _storage.get(AppStorageKey.languagePreference.rawValue);
    if (storedCode.isEmpty) return;

    final storedLocale = _localeFromCode(storedCode);
    if (storedLocale == state) return;

    state = storedLocale;
    await LocaleSettings.setLocale(storedLocale);
  }

  Future<void> updateLanguage(String languageCode) async {
    final newLocale = _localeFromCode(languageCode);
    await _persistLocale(newLocale);
  }

  Future<void> _persistLocale(AppLocale locale) async {
    if (state != locale) {
      state = locale;
      await LocaleSettings.setLocale(locale);
    }
    await _storage.set(
      AppStorageKey.languagePreference.rawValue,
      locale.languageCode,
    );
  }

  AppLocale _localeFromCode(String languageCode) {
    switch (languageCode) {
      case 'ko':
        return AppLocale.ko;
      case 'en':
      default:
        return AppLocale.en;
    }
  }
}

