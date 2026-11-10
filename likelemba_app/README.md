# Likelemba App

![coverage][coverage_badge]
[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![License: MIT][license_badge]][license_link]

Générée avec [Very Good CLI][very_good_cli_link], puis organisée en Clean Architecture
(`core/` + `features/`). L'architecture et le plan du cours sont décrits dans le
[README du cours](../README.md).

---

## Démarrer 🚀

1. Lancer l'API : `cd ../likelemba_backend && dart_frog dev`.
2. Lancer une saveur :

```sh
flutter run --flavor development --target lib/main_development.dart
flutter run --flavor staging --target lib/main_staging.dart
flutter run --flavor production --target lib/main_production.dart
```

En development, l'API est jointe sur `http://10.0.2.2:8080` (émulateur Android) ou
`http://localhost:8080` (simulateur iOS, web, bureau). Depuis un téléphone :
`--dart-define=API_URL=http://<ip-du-poste>:8080`.

## Vérifier ✅

```sh
flutter analyze                       # No issues found!
very_good test --coverage             # tous les tests passent
bash tool/check_architecture.sh       # chaque règle affiche ✓
```

---

## Bloc Lints 🔍

This project uses the [bloc_lint](https://pub.dev/packages/bloc_lint) package to enforce best practices using [bloc](https://pub.dev/packages/bloc).

To validate linter errors, run

```bash
dart run bloc_tools:bloc lint .
```

You can also validate with VSCode-based IDEs using the [official bloc extension](https://marketplace.visualstudio.com/items?itemName=FelixAngelov.bloc).

To learn more, visit https://bloclibrary.dev/lint/

---

## Traductions 🌐

Le français est la langue de référence (`lib/core/l10n/arb/app_fr.arb`) ; l'anglais
(`app_en.arb`) suit. Pour ajouter un texte :

1. ajouter la clé dans `app_fr.arb`, puis sa traduction dans `app_en.arb` ;
2. lancer `flutter gen-l10n` (ou simplement `flutter run`) ;
3. l'utiliser dans un widget :

```dart
import 'package:likelemba_app/core/l10n/l10n.dart';

Text(context.l10n.loginTitle);
```

Les fichiers de `lib/core/l10n/gen/` sont générés : ne jamais les modifier à la main.

[coverage_badge]: coverage_badge.svg
[internationalization_link]: https://docs.flutter.dev/ui/internationalization
[arb_documentation_link]: https://github.com/google/app-resource-bundle
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
[very_good_cli_link]: https://github.com/VeryGoodOpenSource/very_good_cli
