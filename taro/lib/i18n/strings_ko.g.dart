///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:slang/generated.dart';
import 'strings.g.dart';

// Path: <root>
class TranslationsKo extends Translations with BaseTranslations<AppLocale, Translations> {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsKo({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.ko,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ),
		  super(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver) {
		super.$meta.setFlatMapFunction($meta.getTranslation); // copy base translations to super.$meta
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <ko>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key) ?? super.$meta.getTranslation(key);

	late final TranslationsKo _root = this; // ignore: unused_field

	@override 
	TranslationsKo $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsKo(meta: meta ?? this.$meta);

	// Translations
	@override String get appName => '타로 물어보기';
	@override late final _TranslationsHomeKo home = _TranslationsHomeKo._(_root);
	@override late final _TranslationsHistoryKo history = _TranslationsHistoryKo._(_root);
	@override late final _TranslationsMenuKo menu = _TranslationsMenuKo._(_root);
}

// Path: home
class _TranslationsHomeKo extends TranslationsHomeEn {
	_TranslationsHomeKo._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => '타로 물어보기';
	@override String get awaitingQuestion => '질문을 기다리고 있습니다';
	@override String get focusMessage => '질문에 집중하고 카드가 당신을 안내하도록 하세요. 답변이 기다리고 있습니다.';
	@override String get questionHint => '여기에 질문을 입력하세요...';
	@override String get drawCard => '카드 뽑기';
}

// Path: history
class _TranslationsHistoryKo extends TranslationsHistoryEn {
	_TranslationsHistoryKo._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => '리딩 기록';
	@override late final _TranslationsHistoryEmptyKo empty = _TranslationsHistoryEmptyKo._(_root);
	@override late final _TranslationsHistoryClearDialogKo clearDialog = _TranslationsHistoryClearDialogKo._(_root);
	@override String get reversed => '역방향';
}

// Path: menu
class _TranslationsMenuKo extends TranslationsMenuEn {
	_TranslationsMenuKo._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get settings => '설정';
	@override String get about => '정보';
	@override String get help => '도움말';
}

// Path: history.empty
class _TranslationsHistoryEmptyKo extends TranslationsHistoryEmptyEn {
	_TranslationsHistoryEmptyKo._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => '아직 리딩 기록이 없습니다';
	@override String get message => '타로 리딩 기록이 여기에 표시됩니다';
}

// Path: history.clearDialog
class _TranslationsHistoryClearDialogKo extends TranslationsHistoryClearDialogEn {
	_TranslationsHistoryClearDialogKo._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => '기록 삭제';
	@override String get message => '모든 리딩 기록을 삭제하시겠습니까?';
	@override String get cancel => '취소';
	@override String get confirm => '삭제';
}

/// The flat map containing all translations for locale <ko>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsKo {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'appName' => '타로 물어보기',
			'home.title' => '타로 물어보기',
			'home.awaitingQuestion' => '질문을 기다리고 있습니다',
			'home.focusMessage' => '질문에 집중하고 카드가 당신을 안내하도록 하세요. 답변이 기다리고 있습니다.',
			'home.questionHint' => '여기에 질문을 입력하세요...',
			'home.drawCard' => '카드 뽑기',
			'history.title' => '리딩 기록',
			'history.empty.title' => '아직 리딩 기록이 없습니다',
			'history.empty.message' => '타로 리딩 기록이 여기에 표시됩니다',
			'history.clearDialog.title' => '기록 삭제',
			'history.clearDialog.message' => '모든 리딩 기록을 삭제하시겠습니까?',
			'history.clearDialog.cancel' => '취소',
			'history.clearDialog.confirm' => '삭제',
			'history.reversed' => '역방향',
			'menu.settings' => '설정',
			'menu.about' => '정보',
			'menu.help' => '도움말',
			_ => null,
		};
	}
}
