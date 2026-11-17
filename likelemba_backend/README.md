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
| GET | `/users/me` | jeton | 200 `{"user"}` · 401 |
| GET | `/tontines` | jeton | 200 `{"tontines": [...]}`, chacune avec `my_role` |
| POST | `/tontines` | `{"name", "contribution_amount", "frequency": "weekly" \| "monthly", "start_date"}` | 201 `{"tontine"}` : le créateur en devient trésorier |
| GET | `/tontines/:id` | jeton | 200 `{"tontine"}` · 404 si je n'en suis pas membre |
| GET | `/tontines/:id/members` | jeton | 200 `{"members": [...]}` dans l'ordre de passage |
| POST | `/tontines/:id/members` | `{"full_name", "phone"}` | 201 · 403 `not_treasurer` · 409 `phone_already_member` |
| PATCH | `/tontines/:id/members/:memberId` | `{"full_name"?, "phone"?, "role"?}` | 200 · 403 · 409 `last_treasurer` |
| DELETE | `/tontines/:id/members/:memberId` | — | 204 · 403 · 409 `last_treasurer` |

« jeton » = en-tête `Authorization: Bearer <jeton>`. Les droits de modification dépendent
du rôle de l'appelant **dans la tontine visée**, jamais d'un rôle global : il n'y en a pas.

Une erreur a toujours la forme `{"code": "...", "message": "..."}`. L'application lit
`code`, jamais `message`.

Un `user` : `{"id", "full_name", "email", "phone", "created_at"}` (pas de rôle).
Un `member` : `{"id", "tontine_id", "full_name", "phone", "payout_order", "role", "has_account"}`.

Comptes de démonstration (mot de passe `likelemba2026`) : `tresorier1@likelemba.test`
(Grâce : trésorière de tnt-001, membre de tnt-002), `tresorier2@likelemba.test`
(Patrick : trésorier de tnt-002), `membre1@likelemba.test` (Esther : membre de tnt-001).

## Organisation

```
routes/                       une route = un fichier (convention Dart Frog)
├── _middleware.dart          injection : provider<UserRepository>, provider<TokenService>
├── index.dart                GET /
├── auth/login.dart           POST /auth/login
├── auth/register.dart        POST /auth/register
├── users/
│   ├── _middleware.dart      requireUser() : protège tout /users
│   └── me.dart               GET /users/me
└── tontines/
    ├── _middleware.dart      requireUser() : protège tout /tontines
    ├── index.dart            GET, POST /tontines
    └── [id]/
        ├── index.dart        GET /tontines/:id
        └── members/
            ├── index.dart    GET, POST /tontines/:id/members
            └── [memberId].dart  PATCH, DELETE
lib/src/
├── user.dart                 User, sans rôle (toJson n'expose pas le mot de passe)
├── tontine.dart, member.dart Tontine ; Member = l'appartenance, qui porte le rôle
├── tontine_repository.dart   tontines et membres en mémoire + données de démonstration
├── tontine_access.dart       accès à une tontine (404 si non membre, 403 si non trésorier)
├── authentication.dart       requireUser() : jeton → User
├── user_repository.dart      stockage en mémoire + comptes de démonstration
├── password_hasher.dart      SHA-256 salé (en production : bcrypt ou argon2)
├── token_service.dart        JWT signés HS256 (dart_jsonwebtoken)
└── api_error.dart            forme commune des erreurs
```
