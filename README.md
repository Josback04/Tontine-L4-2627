# Likelemba — cours de Clean Architecture avec Flutter (L4 2026-2027)

Likelemba est l'outil du trésorier d'une tontine. Le cours le construit de bout en
bout : une API d'authentification en Dart, puis une application Flutter organisée en
`core/` + `features/`, générée avec les outils de Very Good Ventures.

## Les dossiers

| Dossier | Rôle | Généré par |
| --- | --- | --- |
| `likelemba_backend/` | API d'authentification (inscription, connexion, profil) | `dart_frog create` |
| `likelemba_app/` | Application Flutter en Clean Architecture | `very_good create flutter_app` |
| `likelemba/`, `likelemba_api/` | Ancienne version du cours (TP1 à TP6, cotisations), conservée comme référence pour la future feature `contribution` | — |

## Outils (à installer avant la première séance)

| Outil | Version | Installation |
| --- | --- | --- |
| Flutter | 3.47 (Dart 3.13) | `flutter doctor` doit être vert |
| Very Good CLI | 1.6 | `dart pub global activate very_good_cli` |
| Dart Frog CLI | 1.2 | `dart pub global activate dart_frog_cli` |

> Après une mise à jour de Flutter, réactivez les deux CLI (`dart pub global activate …`) :
> sinon `very_good` échoue avec `Invalid kernel binary format version`.

## Démarrer en 2 commandes

```bash
cd likelemba_backend && dart_frog dev          # API sur http://localhost:8080
```

```bash
cd likelemba_app && flutter run --flavor development --target lib/main_development.dart
```

Comptes de démonstration (mot de passe `likelemba2026`) :

| Compte | Mamans du marché Gambela | Enseignants de Lemba |
| --- | --- | --- |
| `tresorier1@likelemba.test` (Grâce) | **trésorière** | membre |
| `tresorier2@likelemba.test` (Patrick) | — | **trésorier** |
| `membre1@likelemba.test` (Esther) | membre | — |

Les noms des comptes datent de la première version : un compte n'est plus « trésorier »
en soi, il l'est dans une tontine donnée (voir la leçon 7).

## Comment les projets ont été générés

On montre ces commandes en séance 0 : les étudiants les tapent eux-mêmes une fois.

```bash
very_good create flutter_app likelemba_app --org-name cd.likelemba --application-id cd.likelemba.app
dart_frog create likelemba_backend
```

Very Good CLI fournit : trois saveurs (development, staging, production),
`very_good_analysis` (règles de lint strictes), `bloc` + `bloc_lint`, la traduction
(ARB), `mocktail` + `bloc_test`, et un CI GitHub Actions. On l'adapte ensuite à
l'architecture du cours :

- suppression de l'exemple `counter/` ;
- création de `core/` (socle partagé) et `features/<feature>/{domain,data,presentation}` ;
- déplacement de `l10n/` vers `core/l10n/`, avec le français comme langue de référence ;
- ajout de `get_it`, `go_router`, `dio`, `shared_preferences` et `equatable`.

## Architecture de l'application

```
lib/
├── main_development.dart  main_staging.dart  main_production.dart
├── bootstrap.dart              démarrage commun : BlocObserver, initDependencies(), runApp
├── app/view/app.dart           MaterialApp.router : thème, traductions, routeur, AuthBloc
├── core/                       SOCLE PARTAGÉ (aucune feature n'y est importée, sauf di/ et router/)
│   ├── config/                 AppEnvironment : URL de l'API par saveur
│   ├── di/                     injection_container.dart : le point d'assemblage
│   ├── errors/                 exceptions (data/) et Failure (domaine, interface)
│   ├── l10n/                   app_fr.arb (référence), app_en.arb
│   ├── network/                dio_factory.dart, auth_interceptor.dart
│   ├── router/                 go_router + redirection selon la session
│   ├── theme/                  AppColors, AppSpacing, AppTheme (clair / sombre)
│   ├── usecase/                contrat UseCase<Result, Params>, NoParams
│   ├── utils/                  Validators (e-mail, téléphone, mot de passe)
│   └── widgets/                LikelembaLogo, PrimaryButton
└── features/
    ├── auth/
    │   ├── auth_injection.dart initAuthFeature(sl) : branche les trois couches
    │   ├── domain/             DART PUR : User (sans rôle !), AuthRepository, cas d'usage, Failure
    │   ├── data/               UserModel, sources distante (dio) et locale, AuthRepositoryImpl
    │   └── presentation/       AuthBloc (session), LoginCubit, RegisterCubit, pages, widgets
    ├── tontine/
    │   ├── tontine_injection.dart
    │   ├── domain/             Tontine, Member (porte le rôle), contrat, 7 cas d'usage
    │   ├── data/               TontineModel, MemberModel, source distante, TontineRepositoryImpl
    │   └── presentation/       liste, création, détail et gestion des membres
    └── home/presentation/      HomePage : mes tontines, chacune avec MON rôle
```

### La règle de dépendance

```
presentation ──▶ domain ◀── data
        ╲                  ╱
         └──── core/ ◀────┘        core/di et core/router assemblent le tout
```

- `domain/` ne dépend de rien d'autre que `core/errors` et `core/usecase` (du Dart pur).
- `data/` implémente les contrats du domaine et transforme les exceptions en `Failure`.
- `presentation/` n'appelle que des cas d'usage et ne connaît pas `data/`.
- `bash tool/check_architecture.sh` vérifie ces règles ; chaque ligne doit afficher ✓.

### Où injecter les dépendances

| Où | Ce qu'on y injecte |
| --- | --- |
| `main_<saveur>.dart` → `bootstrap()` | l'environnement (URL de l'API) |
| `core/di/injection_container.dart` | les outils partagés : `SharedPreferences`, `Dio` et son `AuthInterceptor` |
| `features/auth/auth_injection.dart` | sources de données → dépôt (sous le type du **contrat**) → cas d'usage → blocs |
| constructeurs | partout ailleurs, chaque classe reçoit ses dépendances (`AuthRepositoryImpl(remote:, local:)`) |
| `BlocProvider(create: (_) => sl<LoginCubit>())` | la page demande un cubit tout prêt |
| `App(authBloc: …)` | la racine reçoit `AuthBloc` : les tests y passent un faux |
| `likelemba_backend/routes/_middleware.dart` | côté serveur, `provider<T>()` + `context.read<T>()` |

## Plan des leçons

Chaque leçon se termine par `flutter analyze`, `very_good test` et
`bash tool/check_architecture.sh`, tous au vert.

| # | Leçon | Fichiers clés | Exercice |
| --- | --- | --- | --- |
| 0 | **Mise en place** : générer les deux projets, saveurs, lints, lancer l'app | `pubspec.yaml`, `analysis_options.yaml`, `main_*.dart` | Lancer la saveur staging ; lire une règle de `very_good_analysis` |
| 1 | **L'API d'authentification** (Dart Frog) : routes, middleware, `provider`, JWT | `likelemba_backend/routes/`, `lib/src/` | Ajouter `PATCH /users/me` (modifier son nom) |
| 2 | **Le domaine** : entité `User`, contrat `AuthRepository`, cas d'usage, `Failure` | `features/auth/domain/` | Règle métier : `User.isTreasurer`, avec ses tests |
| 3 | **Les données** : `UserModel`, sources distante et locale, exceptions → `Failure` | `features/auth/data/` | Tester `getCurrentUser` hors ligne sans cache |
| 4 | **L'injection des dépendances** : `get_it`, point d'assemblage, intercepteur | `core/di/`, `auth_injection.dart`, `core/network/` | Remplacer la source distante par une fausse source en mode development |
| 5 | **Le thème et l'interface** : `AppTheme`, `AuthBloc`, cubits de formulaire, routeur | `core/theme/`, `features/auth/presentation/`, `core/router/` | Ajouter une couleur d'accent ; écran « mot de passe oublié » |
| 6 | **Les tests** : `mocktail`, `bloc_test`, tests de widgets, couverture, CI | `test/` | Tester `RegisterView` ; remonter `min_coverage` à 80 |
| 7 | **Tontines et membres** : l'espace du trésorier, et l'erreur de modélisation du rôle ([support détaillé](docs/lecons/07-tontines-et-membres.md)) | `features/tontine/`, `routes/tontines/` | Changer l'ordre de passage ; quitter une tontine |
| 8+ | **Feature `contribution`** : les cotisations de chaque membre, reprises de l'ancien `likelemba/` | `features/contribution/` | Cache SQLite hors ligne |

### La leçon de modélisation à ne pas rater (leçon 7)

> **Le rôle appartient à l'appartenance à un groupe, pas à la personne.**

Jusqu'à la leçon 6, `User` portait un `role` (trésorier ou membre). Le code compilait, les
tests passaient, et le modèle était faux : Grâce tient la caisse des mamans du marché
Gambela et cotise simplement chez les enseignants de Lemba. Aucune valeur unique de
`User.role` ne peut décrire ça. En leçon 7, le rôle déménage dans `Member` (l'appartenance
à une tontine), et la règle « peut gérer » déménage avec lui dans `Tontine.canManage`.
Les données de démonstration sont construites pour le montrer : connectée, Grâce voit une
tontine marquée **Trésorier** et une autre marquée **Membre**.

On garde volontairement cette histoire dans le cours : elle montre qu'un modèle peut
fonctionner et être faux, parce que la question posée au métier était mauvaise.

### Scénario de démonstration « session expirée »

```bash
cd likelemba_backend && TOKEN_TTL_MINUTES=1 dart_frog dev
```

Une minute après la connexion, relancer l'application à chaud : `GET /users/me`
répond 401, l'`AuthInterceptor` vide la session, `AuthBloc` passe à
`unauthenticated(sessionExpired: true)` et le routeur ramène à `/login`.
