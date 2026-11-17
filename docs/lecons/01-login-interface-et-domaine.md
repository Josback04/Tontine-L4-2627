# Séance 1 — L'écran de connexion et la couche domaine

Branche : `start1`. Point de départ : `lib/core/` complet, une seule feature (`auth`),
réduite à la connexion.

## Objectif

Comprendre comment une feature se range en couches, en partant de ce que l'on voit
(l'écran) pour descendre jusqu'au métier (le domaine).

```
features/auth/
├── presentation/          ← ce que l'utilisateur voit
│   ├── pages/login_page.dart        LoginPage (fournit le cubit) + LoginView (dessine)
│   ├── cubit/login_cubit.dart       l'état du formulaire
│   └── widgets/                     AuthLayout, PasswordField, FailureMessage
├── domain/                ← le métier, en Dart pur
│   ├── entities/user.dart           ce qu'est un utilisateur
│   ├── repositories/auth_repository.dart   le CONTRAT (interface)
│   ├── usecases/login_usecase.dart  l'action « se connecter »
│   └── failures/auth_failures.dart  les échecs métier
├── data/                  ← provisoire en séance 1
│   └── repositories/fake_auth_repository.dart   implémentation en mémoire
└── auth_injection.dart    ← le seul fichier qui connaît les trois couches
```

## La règle des dépendances

`presentation → domain ← data`

- `domain/` n'importe ni Flutter, ni dio, ni `presentation/`, ni `data/`.
- `presentation/` connaît le cas d'usage, jamais le dépôt concret.
- `data/` implémente le contrat déclaré par `domain/`.

Vérification en classe : `grep -r "import" lib/features/auth/domain` ne doit montrer
que `equatable` et `core/`.

## Déroulé (3 h)

1. **L'écran** (45 min) — `LoginView` : `Form`, validation avec `core/utils/validators.dart`,
   textes traduits (`context.l10n`), `PasswordField`, `PrimaryButton`.
2. **Le domaine** (45 min) — `User`, puis le contrat `AuthRepository`, puis `LoginUseCase`
   (la règle métier : e-mail sans espaces ni majuscules), puis `InvalidCredentialsFailure`.
3. **Le lien** (45 min) — `LoginCubit` appelle le cas d'usage et expose
   `status` + `user` + `failure` ; la page réagit avec `BlocListener` (message de bienvenue
   ou d'erreur) et `BlocSelector` (bouton en chargement).
4. **L'assemblage** (30 min) — `auth_injection.dart` et `core/di/injection_container.dart` :
   `FakeAuthRepository` est enregistré **sous le type** `AuthRepository`.
5. **Les tests** (15 min) — `flutter test` : cas d'usage, cubit, page, faux dépôt.

## Lancer

```bash
cd likelemba_app && flutter run --flavor development --target lib/main_development.dart
```

Compte : `tresorier1@likelemba.test` / `likelemba2026`. Un autre mot de passe affiche
« E-mail ou mot de passe incorrect. »

## Ce qui vient ensuite

À la séance sur la couche data, on remplace `FakeAuthRepository` par `AuthRepositoryImpl`
(API `likelemba_backend` + stockage local) en changeant **une ligne** dans
`auth_injection.dart`. Le cas d'usage, le cubit et la page ne bougent pas : c'est la preuve
que l'architecture tient.
