///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

part of 'strings.g.dart';

// Path: <root>
typedef TranslationsEn = Translations; // ignore: unused_element
class Translations with BaseTranslations<AppLocale, Translations> {
	/// Returns the current translations of the given [context].
	///
	/// Usage:
	/// final t = Translations.of(context);
	static Translations of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context).translations;

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	Translations({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <en>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	dynamic operator[](String key) => $meta.getTranslation(key);

	late final Translations _root = this; // ignore: unused_field

	Translations $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => Translations(meta: meta ?? this.$meta);

	// Translations

	/// en: 'Ask the Tarot'
	String get appName => 'Ask the Tarot';

	late final TranslationsHomeEn home = TranslationsHomeEn.internal(_root);
	late final TranslationsHistoryEn history = TranslationsHistoryEn.internal(_root);
	late final TranslationsMenuEn menu = TranslationsMenuEn.internal(_root);
}

// Path: home
class TranslationsHomeEn {
	TranslationsHomeEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Ask the Tarot'
	String get title => 'Ask the Tarot';

	/// en: 'Awaiting Your Question'
	String get awaitingQuestion => 'Awaiting Your Question';

	/// en: 'Focus on your question and let the cards guide you. Your answer awaits.'
	String get focusMessage => 'Focus on your question and let the cards guide you. Your answer awaits.';

	/// en: 'Type your question here...'
	String get questionHint => 'Type your question here...';

	/// en: 'Draw a Card'
	String get drawCard => 'Draw a Card';
}

// Path: history
class TranslationsHistoryEn {
	TranslationsHistoryEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Reading History'
	String get title => 'Reading History';

	late final TranslationsHistoryEmptyEn empty = TranslationsHistoryEmptyEn.internal(_root);
	late final TranslationsHistoryClearDialogEn clearDialog = TranslationsHistoryClearDialogEn.internal(_root);

	/// en: 'Reversed'
	String get reversed => 'Reversed';
}

// Path: menu
class TranslationsMenuEn {
	TranslationsMenuEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Settings'
	String get settings => 'Settings';

	/// en: 'About'
	String get about => 'About';

	/// en: 'Help'
	String get help => 'Help';
}

// Path: history.empty
class TranslationsHistoryEmptyEn {
	TranslationsHistoryEmptyEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'No readings yet'
	String get title => 'No readings yet';

	/// en: 'Your tarot reading history will appear here'
	String get message => 'Your tarot reading history will appear here';
}

// Path: history.clearDialog
class TranslationsHistoryClearDialogEn {
	TranslationsHistoryClearDialogEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Clear History'
	String get title => 'Clear History';

	/// en: 'Are you sure you want to clear all reading history?'
	String get message => 'Are you sure you want to clear all reading history?';

	/// en: 'Cancel'
	String get cancel => 'Cancel';

	/// en: 'Clear'
	String get confirm => 'Clear';
}

/// The flat map containing all translations for locale <en>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'appName' => 'Ask the Tarot',
			'home.title' => 'Ask the Tarot',
			'home.awaitingQuestion' => 'Awaiting Your Question',
			'home.focusMessage' => 'Focus on your question and let the cards guide you. Your answer awaits.',
			'home.questionHint' => 'Type your question here...',
			'home.drawCard' => 'Draw a Card',
			'history.title' => 'Reading History',
			'history.empty.title' => 'No readings yet',
			'history.empty.message' => 'Your tarot reading history will appear here',
			'history.clearDialog.title' => 'Clear History',
			'history.clearDialog.message' => 'Are you sure you want to clear all reading history?',
			'history.clearDialog.cancel' => 'Cancel',
			'history.clearDialog.confirm' => 'Clear',
			'history.reversed' => 'Reversed',
			'menu.settings' => 'Settings',
			'menu.about' => 'About',
			'menu.help' => 'Help',
			_ => null,
		};
	}
}
