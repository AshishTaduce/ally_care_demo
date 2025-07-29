class Language {
  final String code;
  final String name;
  final String shortName;
  final String flag;
  final String nativeName;

  const Language({
    required this.code,
    required this.name,
    required this.shortName,
    required this.flag,
    required this.nativeName,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Language && runtimeType == other.runtimeType && code == other.code;

  @override
  int get hashCode => code.hashCode;
}

class AppLanguages {
  static const List<Language> supportedLanguages = [
    Language(
      code: 'en',
      name: 'English',
      shortName: 'Eng',
      flag: '🇺🇸',
      nativeName: 'English',
    ),
    Language(
      code: 'es',
      name: 'Spanish',
      shortName: 'Esp',
      flag: '🇪🇸',
      nativeName: 'Español',
    ),
    Language(
      code: 'fr',
      name: 'French',
      shortName: 'Fra',
      flag: '🇫🇷',
      nativeName: 'Français',
    ),
  ];

  static Language get defaultLanguage => supportedLanguages[0];

  static Language getLanguageByCode(String code) {
    return supportedLanguages.firstWhere(
          (lang) => lang.code == code,
      orElse: () => defaultLanguage,
    );
  }
}