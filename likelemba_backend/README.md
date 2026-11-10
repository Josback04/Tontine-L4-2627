# likelemba_backend

API d'authentification de Likelemba, écrite avec [Dart Frog](https://dart-frog.dev)
(Very Good Ventures). Enseignement uniquement : les comptes vivent en mémoire.

## Lancer

```bash
dart_frog dev                         # http://localhost:8080, rechargement à chaud
TOKEN_TTL_MINUTES=1 dart_frog dev     # jetons courts : scénario « session expirée »
JWT_SECRET=un-secret dart_frog dev    # secret de signature (défaut : likelemba-dev-secret)
dart test                             # tests des routes et du dépôt
```

## Routes

| Méthode | Chemin | Corps | Réponse |
| --- | --- | --- | --- |
| GET | `/` | — | `{"name", "status": "ok"}` |
| POST | `/auth/register` | `{"full_name", "email", "phone", "password"}` | 201 `{"token", "user"}` · 409 `email_already_used` · 422 `validation_error` |
| POST | `/auth/login` | `{"email", "password"}` | 200 `{"token", "user"}` · 401 `invalid_credentials` |
| GET | `/users/me` | en-tête `Authorization: Bearer <jeton>` | 200 `{"user"}` · 401 |

Une erreur a toujours la forme `{"code": "...", "message": "..."}`. L'application lit
`code`, jamais `message`.

Un `user` : `{"id", "full_name", "email", "phone", "role": "treasurer" | "member", "created_at"}`.

Comptes de démonstration (mot de passe `likelemba2026`) : `tresorier1@likelemba.test`,
`tresorier2@likelemba.test`, `membre1@likelemba.test`.

## Organisation

```
routes/                       une route = un fichier (convention Dart Frog)
├── _middleware.dart          injection : provider<UserRepository>, provider<TokenService>
├── index.dart                GET /
├── auth/login.dart           POST /auth/login
├── auth/register.dart        POST /auth/register
└── users/
    ├── _middleware.dart      bearerAuthentication : protège tout /users
    └── me.dart               GET /users/me
lib/src/
├── user.dart                 User, UserRole (toJson n'expose pas le mot de passe)
├── user_repository.dart      stockage en mémoire + comptes de démonstration
├── password_hasher.dart      SHA-256 salé (en production : bcrypt ou argon2)
├── token_service.dart        JWT signés HS256 (dart_jsonwebtoken)
└── api_error.dart            forme commune des erreurs
```
