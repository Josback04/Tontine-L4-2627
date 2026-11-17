# Plan du cours — Flutter et Clean Architecture, de zéro au projet

Ce plan couvre tout le cours, de la première ligne de Dart au projet de synthèse. Il
complète le **guide d'animation des paliers 1 à 4** (méthode, boucle d'une étape, place de
l'IA, évaluation) : ce guide reste la référence pour la façon d'animer ; ce plan dit
**quoi** enseigner, **dans quel ordre**, et **ce que l'étudiant doit savoir faire** à la fin
de chaque séance.

Tout est construit autour de l'application finie `likelemba_app/`. Chaque palier ajoute une
couche ; rien de ce que l'étudiant écrit n'est jetable : le `Formatters.amount` du premier
jour s'affiche encore sur la carte de tontine du projet final.

## 1. Vue d'ensemble

### Les quatre phases

| Phase | Paliers | Question à laquelle elle répond | L'étudiant repart avec |
| --- | --- | --- | --- |
| A. Dart seul | 0.1 à 0.3 | « Comment Dart pense-t-il ? » | Des fonctions et des classes testées, en console, sans Flutter |
| B. L'interface | 1 à 3 | « Comment dessiner, saisir, naviguer ? » | Une application qui marche, avec tout dans les pages (dette volontaire) |
| C. L'architecture | 4 à 8 | « Où ranger chaque chose, et pourquoi ? » | La même application, en couches, sur une vraie API |
| D. La qualité | 9 à 12 | « Comment livrer quelque chose de fiable ? » | Une feature complète, traduite, testée, CI verte |

L'ordre est voulu : **la douleur avant le remède**. On écrit d'abord tout dans les pages
(phase B), puis on sent le problème (« si l'API renomme un champ, combien de fichiers
ouvrir ? ») avant de découvrir les couches (phase C). Une architecture enseignée avant la
douleur est récitée ; enseignée après, elle est comprise.

### Le calendrier (17 séances de 3 h)

| Séance | Palier | Thème | Fichiers de référence | Évaluation |
| --- | --- | --- | --- | --- |
| S1 | 0.1 | Outils, bases de Dart, **null safety** | `core/utils/formatters.dart`, `validators.dart` | Ticket de sortie |
| S2 | 0.2 | Modéliser : classes, égalité, `enum`, `switch`, records, `sealed` | `domain/entities/tontine.dart`, `member.dart` | Ticket |
| S3 | 0.3 | L'asynchrone et les erreurs : `Future`, `async`, `Stream`, exceptions | `core/errors/`, `_guard` de `tontine_repository_impl.dart` | Ticket |
| S4 | 1 | Premiers widgets et thème | `tontine_card.dart`, `role_badge.dart`, `core/theme/` | Ticket |
| S5 | 2 | Formulaires et état local | `password_field.dart`, `member_form_sheet.dart` | Ticket |
| S6 | 3 | Navigation | `core/router/` | Ticket |
| S7 | 4 | Architecture en couches : le domaine | `features/tontine/domain/`, `tool/check_architecture.sh` | Ticket |
| S8 | 5 | La couche data : API, JSON, dépôts | `features/tontine/data/`, `likelemba_backend/` | Ticket |
| S9 | 6 | L'état avec Cubit, et ses tests | `presentation/cubit/` | Ticket |
| S10 | 7 | La session : connexion, stockage, redirection | `auth_bloc.dart`, `auth_interceptor.dart`, `app_router.dart` | **Écrit individuel (45 min, sans IA)** en début de séance |
| S11 | 8 | Injection des dépendances, saveurs | `core/di/`, `*_injection.dart`, `main_*.dart` | Ticket |
| S12 | 9 | Traduction et messages d'échec | `core/l10n/`, `failure_message.dart` | Ticket |
| S13 | 10 | Tests de widgets, couverture, CI | `test/`, `.github/workflows/` | Ticket |
| S14 | 11 | Gérer les membres en autonomie, et revoir un modèle | `tontine_detail_*`, `docs/lecons/07-tontines-et-membres.md` | Ticket |
| S15 | 12 | Projet de synthèse : lancement (feature cotisations) | `features/contribution/` (à créer) | Point d'étape |
| S16 | 12 | Projet de synthèse : atelier | — | Revue croisée |
| S17 | — | Soutenances orales individuelles | Le projet de l'étudiant | **Soutenance** |

**Si vous avez moins de séances** : fusionnez 0.2 et 0.3 si la classe a déjà fait de la
programmation objet ; fusionnez 8 et 9 (deux sujets courts) ; le palier 11 peut devenir un
devoir. Ne fusionnez jamais 4 et 5 : c'est la charnière du cours.

**Si vous en avez plus** : ajoutez le palier bonus « côté serveur » (section 8) entre 5
et 6, ou donnez deux séances au palier 6.

## 2. Ce que l'étudiant doit savoir faire à la fin

Ce référentiel sert à écrire les tickets de sortie, l'écrit et les questions de
soutenance. Chaque ligne est vérifiable sans IA.

| Phase | L'étudiant sait… |
| --- | --- |
| A | lire une erreur du compilateur et dire si elle arrive à la compilation ou à l'exécution ; choisir entre `T` et `T?` et justifier ; lire un `T?` sans `!` ; écrire une classe immuable avec égalité par valeur ; écrire un `switch` exhaustif ; prédire l'ordre d'exécution d'un code `async` ; dire pourquoi un `try` sans `await` laisse passer l'erreur |
| B | dessiner l'arbre de widgets d'un écran ; expliquer un débordement par la règle des contraintes ; dire quand un widget doit être `Stateful` ; suivre le cycle de vie d'un `State` ; libérer ce qu'il a créé ; choisir entre `go` et `push` ; renvoyer une valeur d'un écran à l'autre |
| C | classer n'importe quel fichier en `domain`, `data` ou `presentation` et dire pourquoi ; écrire un cas d'usage à partir de son test ; transformer du JSON en entité sans faire fuir le JSON ; traduire une exception technique en `Failure` ; écrire un Cubit et son `blocTest` ; expliquer qui crée quoi dans `get_it` |
| D | traduire un écran sans chaîne en dur ; écrire un test de widget qui retrouve un champ par sa `Key` ; lire un échec de CI ; livrer une feature complète dont le script d'architecture affiche cinq ✓ |

## 3. Le fil rouge Dart : où chaque notion vit dans l'application

C'est la réponse à « pourquoi apprendre ça ? ». Chaque notion de la phase A réapparaît
dans un vrai fichier de l'application. Montrez la ligne quand vous enseignez la notion,
puis reprenez-la au palier où elle revient.

| Notion | Apprise | Revient au palier | La ligne dans Likelemba |
| --- | --- | --- | --- |
| `final`, `const` | 0.1 | 1 (widgets `const`) | `const SizedBox(height: AppSpacing.sm)` dans `tontine_card.dart` |
| Paramètres nommés, `required` | 0.1 | partout | `const new({required this.tontine, required this.onTap, super.key})` dans `TontineCard` |
| `??` (valeur de repli) | 0.1 | 5 | `json['member_count'] as int? ?? 0` dans `tontine_model.dart` |
| `?.` (propager le null) | 0.1 | 1, 2 | `textTheme.labelMedium?.copyWith(...)` dans `role_badge.dart` ; `widget.initial?.fullName` |
| `?.` et `??` ensemble | 0.1 | 2 | `_email.hasMatch(value?.trim() ?? '')` dans `validators.dart` |
| `!` (affirmation) | 0.1 | 2, 3, 6 | `_formKey.currentState!`, `state.pathParameters['id']!`, `state.failure!` |
| `late final` | 0.1 | 2, 3 | `late final _fullName = TextEditingController(text: widget.initial?.fullName)` ; `late final GoRouter _router` dans `app.dart` |
| Éléments de collection nuls (`?x`) | 0.1 | 5 | `'full_name': ?fullName` dans `updateMember` du dépôt |
| Collections, `where`/`map`/`join` | 0.1 | 4 | `initialsOf` dans `user.dart` |
| Copie avant tri (`[...l]..sort`) | 0.1 | 4 | `GetMyTontinesUseCase` |
| Classe immuable, getters calculés | 0.2 | 4 | `Tontine.potAmount`, `Tontine.canManage` |
| Égalité par valeur, `Equatable` | 0.2 | 4, 6 | toutes les entités, tous les états |
| `enum`, `values.asNameMap()` | 0.2 | 5 | `MemberRole.values.asNameMap()[json['my_role']]` |
| `switch` expression exhaustif | 0.2 | 1, 5, 9 | `roleLabel`, `_guard`, `commonFailureMessage` |
| Garde `when` dans un `switch` | 0.2 | 5 | `_ when error.statusCode == 401 => ...` |
| Records, `typedef` | 0.2 | 2 | `typedef MemberFormResult = ({String fullName, String phone})` |
| `sealed class` | 0.2 | 7 | `sealed class AuthEvent` |
| `abstract interface class` | 0.2 | 4 | `TontineRepository`, `UseCase` |
| `abstract final class` (espace de noms) | 0.2 | 3 | `AppRoutes`, `Formatters`, `Validators` |
| Méthodes d'extension | 0.2 | 9 | `context.l10n`, `failure.message(l10n)` |
| Constructeurs nommés | 0.2 | 7 | `AuthState.authenticated(user)` |
| `Future`, `async`/`await` | 0.3 | 3, 4 | `await context.push<Tontine>(...)` |
| `try`/`on`/`catch`, `rethrow` | 0.3 | 5, 6 | `on Failure catch (failure)` dans les Cubits |
| `return await` dans un `try` | 0.3 | 5 | `_guard` de `TontineRepositoryImpl` |
| Fonctions génériques, types fonction | 0.3 | 5, 7 | `Future<T> _guard<T>(Future<T> Function() call)` ; `String? Function() _readToken` |
| Record renvoyé et déstructuré | 0.2 | 6 | `Future<(Tontine, List<Member>)> _fetch()` puis `final (tontine, members) = await _fetch();` dans `tontine_detail_cubit.dart` |
| `Future.wait` | 0.3 | 6 (défi) | `_fetch` attend la tontine puis les membres ; le défi du palier 6 les charge en parallèle |
| `Stream`, abonnement | 0.3 | 6, 7 | un Bloc est un flux d'états ; `GoRouterRefreshStream(authBloc.stream)` |
| `unawaited` | 0.3 | 6 | `unawaited(cubit.load())` dans `home_page.dart` |
| Classe appelable (`call`) | 0.3 | 4 | `await createTontine(params)` |

### La syntaxe récente du projet

L'application vise Dart 3.13 et utilise des formes que la plupart des tutoriels et des
assistants IA ne montrent pas encore. Prévenez dès la séance 1, sinon les étudiants
croiront à des fautes :

| Dans le projet | Forme des tutoriels | Où |
| --- | --- | --- |
| `const new({required this.id})` | `const Tontine({required this.id})` | toutes les classes |
| `const new unknown() : this._(...)` | `const AuthState.unknown() : this._(...)` | `auth_state.dart` |
| `factory fromJson(Map<String, dynamic> json)` | `factory TontineModel.fromJson(...)` | `tontine_model.dart` |
| `new({required this._getMyTontines})` (paramètre nommé privé) | `TontinesCubit({required GetMyTontinesUseCase getMyTontines}) : _getMyTontines = getMyTontines` | Cubits, intercepteur |
| `'full_name': ?fullName` | `if (fullName != null) 'full_name': fullName` | `tontine_repository_impl.dart` |
| `package:material_ui/material_ui.dart` | `package:flutter/material.dart` | tous les widgets |

Faites-en un exercice du palier 0.2 : réécrire une classe du projet dans la forme des
tutoriels, puis revenir. Un étudiant qui reconnaît les deux formes lit aussi bien le code
d'un tutoriel que celui d'une IA.

## 4. Phase A — Dart sans Flutter

**Pourquoi trois séances de Dart pur ?** Parce que la moitié des blocages des paliers
suivants ne sont pas des problèmes de Flutter : un `!` qui plante, un `try` qui n'attrape
rien, une liste modifiée sur place qui ne redessine pas l'écran. En console, sans widget,
l'erreur est seule à l'écran et on la lit.

**Point de départ commun** : un paquet Dart créé par les étudiants eux-mêmes,

```bash
dart create -t package likelemba_kata
```

avec `package:test` et `very_good_analysis` dans `dev_dependencies`, et le même
`analysis_options.yaml` que l'application. Vous fournissez les fichiers de test ; ils
écrivent le code. Le niveau d'aide est celui du palier 1 : **code à trous et tests
fournis**.

En fin de phase A, le paquet contient `Formatters`, `Validators`, `initialsOf`, les
classes `Tontine` et `Member`, et un faux service asynchrone : on les recopie au palier 1.

### Palier 0.1 — Les outils, les bases et la null safety

À la fin de la séance, chaque étudiant a écrit et testé `Formatters.amount` et
`Validators`, sans un seul `!` dans son code.

**Mise en place (30 premières minutes de S1, remplace la revue)** : `flutter doctor`
vert, l'éditeur avec l'extension Dart, `git` configuré, la charte IA lue ensemble. Les
quatre commandes du jour : `dart run`, `dart test`, `dart analyze`, `dart format .`.

**Le besoin** : montrez la carte de tontine de l'application finie (« 50 000 FC par tour
· Mensuelle · 12 membres ») et le formulaire qui refuse « 081 23 ». « Avant de dessiner
ces écrans, il faut savoir produire ce texte et vérifier cette saisie. C'est du Dart pur. »

#### Les quatre étapes de live-coding

| Étape | Notion | Résultat visible | Pour casser |
| --- | --- | --- | --- |
| 1. Des valeurs | `var`, `final`, `const`, inférence, `int`/`double`/`String`/`bool`, interpolation `'$a ${b.c}'`, `dynamic` contre `Object` | `dart run` affiche « Mamans du marché : 50000 FC » | Réaffecter un `final` ; écrire `const now = DateTime.now()` : lire les deux messages |
| 2. Des fonctions | paramètres positionnels, nommés `{required ...}`, optionnels `[...]`, valeurs par défaut, `=>`, une fonction passée en valeur | `Formatters.amount(1250000)` donne « 1 250 000 FC », test au vert | Appeler sans un paramètre `required` : l'erreur arrive **avant** l'exécution |
| 3. La null safety | `String?`, `??`, `?.`, `??=`, `!`, promotion par `if (x == null) return`, `late` | `Validators.isEmail(null)` renvoie `false` au lieu de planter | Écrire `value.trim()` sur un `String?` (erreur de compilation), puis `value!.trim()` avec `null` (plantage à l'exécution) : comparer les deux moments |
| 4. Les collections | `List`, `Map`, `Set`, `const [...]`, `if` et `for` dans une collection, `...`, `where`/`map`/`take`/`join`, cascade `..` | `initialsOf('Grâce Mbuyi')` donne « GM » | `const [1, 2]..add(3)` : « Unsupported operation » ; `liste.sort()` modifie l'original |

L'étape 3 est le cœur de la séance. Terminez-la par les cinq règles ci-dessous, écrites au
tableau et recopiées par les étudiants.

#### La null safety en cinq règles

1. **Un type sans `?` ne vaut jamais `null`.** Le compilateur le garantit ; on n'a pas à
   le vérifier.
2. **`?` est une décision de modélisation, pas une rustine.** `Tontine.name` n'est jamais
   absent : `String`. Dans l'état de session, on peut ne pas être connecté : `User? user`.
   On se demande « cette donnée peut-elle manquer dans la réalité ? », pas « comment faire
   taire l'erreur ? ».
3. **Pour lire un `T?`, dans cet ordre de préférence** : `??` (une valeur de repli),
   `?.` (propager l'absence), un test `if (x == null) return;` (le compilateur « promeut »
   ensuite `x` en `T`), et seulement en dernier `!`.
4. **`!` veut dire « fais-moi confiance ».** Il déplace l'erreur de la compilation vers
   l'exécution. Chaque `!` doit pouvoir être justifié à voix haute.
5. **`late` est une promesse** : « la valeur sera là avant la première lecture ». Une
   promesse rompue donne `LateInitializationError` à l'exécution.

Ajoutez la limite de la promotion, qui piège tout le monde : elle fonctionne sur une
variable locale et sur un champ **privé et `final`**, pas sur un champ public ni sur un
getter (le compilateur ne peut pas prouver qu'il renverra deux fois la même valeur). Le
réflexe : copier dans une variable locale, `final user = state.user; if (user == null) ...`.

#### Exercice autonome (60 min, tests fournis)

**Énoncé** : faire passer les tests de `Validators` (`isEmail`, `isPhone`, `isPassword`,
`isFullName`) et de `Formatters.date`.

**Critères de réussite** :

- `dart test` au vert, `dart analyze` ne signale rien ;
- « 081 234 5678 » et « 0812345678 » sont tous deux des téléphones valides ;
- aucun `!` et aucun `dynamic` dans le code écrit ;
- l'étudiant sait dire, pour chaque paramètre, pourquoi il est `String?` et non `String`
  (réponse : un champ de formulaire peut transmettre `null`).

**Défi pour les rapides** : `Formatters.amount(-5000)` donne « -5 000 FC » ; ajouter
`Validators.isAmount(String?)` avec `int.tryParse`, qui renvoie un `int?`.

#### Erreurs fréquentes

| Symptôme | Cause | Réflexe à enseigner |
| --- | --- | --- |
| « The method 'trim' can't be unconditionally invoked because the receiver can be 'null' » | Méthode appelée sur un `T?` | `?.` puis `??`, ou un test de null |
| « Null check operator used on a null value » | Un `!` sur une valeur nulle | Remplacer le `!` par `??` ou un test ; se demander si le type devait être nullable |
| `LateInitializationError` | `late` lu avant d'être affecté | Initialiser à la déclaration, ou ne pas utiliser `late` |
| La promotion « ne marche pas » sur `this.user` | Champ public ou getter | Copier dans une variable locale |
| `5 / 2` donne `2.5` et casse un `int` | `/` renvoie toujours un `double` | `~/` pour la division entière |
| Avertissement `avoid_print` | `print` interdit par `very_good_analysis` | `log` (de `dart:developer`) en console, `debugPrint` dans Flutter |

#### Ticket de sortie

1. Quelle différence entre `final` et `const` ? Donnez un exemple qui peut être `final`
   mais pas `const`.
2. `value!.trim()` compile, mais plante quand `value` est `null`. Pourquoi le compilateur
   ne l'a-t-il pas empêché ?
3. Que donnent `null ?? 'x'` et `null?.length` ?

**Devoir** : la « chasse aux `!` ». Dans `likelemba_app/`, lancer
`grep -rn '!\.' lib --include='*.dart'` et `grep -rn '!)' lib --include='*.dart'`
(apostrophes obligatoires sous zsh, le shell par défaut de macOS), choisir
trois résultats et écrire en une phrase pourquoi chacun est sûr (ou ne l'est pas). Les
trois réponses attendues : `_formKey.currentState!` (le `Form` est construit avant qu'on
puisse appuyer), `state.pathParameters['id']!` (le chemin `/tontines/:id` garantit le
paramètre), `state.failure!` (sûr seulement parce que le statut vaut `failure` : le type
ne l'exprime pas, on y revient au palier 6). **Pont vers 0.2** : « on manipule des
nombres et des chaînes isolés ; une tontine, c'est un nom, un montant, une fréquence et
un rôle qui vont ensemble. »

### Palier 0.2 — Modéliser avec des classes

À la fin de la séance, chaque étudiant a écrit `Tontine` et `Member` en Dart pur, avec
égalité par valeur, un rôle exprimé par un `enum`, et un `switch` exhaustif qui en donne
le libellé.

**Le besoin** : posez deux tontines identiques côte à côte et demandez « sont-elles
égales ? ». Puis : « Grâce peut-elle être autre chose que trésorière ou membre ? Comment
empêcher qu'on écrive `role = 'tresoriere'` avec une faute ? »

#### Les quatre étapes de live-coding

| Étape | Notion | Résultat visible | Pour casser |
| --- | --- | --- | --- |
| 1. Une classe | champs `final`, constructeur `const new({required this.x})`, getter calculé (`potAmount`), `toString` | `print(tontine)` affiche quelque chose de lisible ; `potAmount` vaut 100 000 | Retirer `required` d'un champ non nullable : le compilateur refuse |
| 2. L'égalité | `==` compare les identités par défaut ; écrire `operator ==` et `hashCode` à la main, puis `Equatable` et `props` | `expect(a, b)` passe pour deux tontines aux mêmes valeurs | Mettre deux tontines identiques dans un `Set` sans `==` : il en contient deux ; oublier `hashCode` : le `Set` se trompe encore |
| 3. Enums et `switch` | `enum MemberRole`, `switch` expression exhaustive, `values.asNameMap()`, garde `when` | `roleLabel(MemberRole.treasurer)` donne « Trésorier » | Ajouter `secretary` à l'enum : le compilateur liste chaque `switch` à compléter. Puis ajouter un `default` : il se tait, et c'est pire |
| 4. Les formes modernes | records `({String fullName, String phone})` et `typedef`, déstructuration, `sealed class` et filtrage par motif, `abstract interface class`, `abstract final class`, extensions | Un `switch` sur une hiérarchie `sealed` sans `default` | Ajouter une sous-classe à la hiérarchie `sealed` : le `switch` devient non exhaustif |

Retenez l'idée de l'étape 3 : **un `switch` exhaustif transforme le compilateur en liste
de tâches**. C'est la raison pour laquelle le projet n'écrit jamais `default` sur un
`enum` ou une classe `sealed`.

Le tableau des modificateurs de classe, à recopier :

| Modificateur | Sens | Dans Likelemba |
| --- | --- | --- |
| `abstract interface class` | un contrat : on l'implémente, on ne l'étend pas | `TontineRepository`, `UseCase` |
| `abstract final class` | une boîte à fonctions statiques, ni instanciable ni extensible | `Formatters`, `Validators`, `AppRoutes` |
| `sealed class` | une famille fermée de cas, connue du compilateur | `AuthEvent` |
| `final class` | personne ne peut en hériter hors de ce fichier | `TontinesState`, les événements d'auth |

#### Exercice autonome (60 min, tests fournis)

**Énoncé** : écrire `Tontine` (nom, cotisation, fréquence, date de début, nombre de
membres, mon rôle) et `Member` (nom, téléphone, ordre de passage, rôle), avec `potAmount`,
`canManage`, `initials`, `isTreasurer`, `roleLabel` et `frequencyLabel` (textes français
en dur). Les tests fournis vérifient les getters et l'égalité.

**Critères de réussite** :

- tous les champs sont `final`, les constructeurs sont `const` ;
- deux objets aux mêmes valeurs sont égaux (testé) ;
- aucun `default` dans les `switch` ;
- aucune importation de Flutter : ces classes deviendront les entités du palier 4.

**Défi pour les rapides** : `copyWith` sur `Member`. Puis la question piège : comment
remettre un champ nullable à `null` avec `copyWith(phone: null)` ? (On ne peut pas
distinguer « pas passé » de « passé à `null` » : c'est une vraie limite, connue.)

**Exercice de lecture (10 min, sans IA)** : réécrire `AuthState` (constructeurs
nommés `new unknown()`, `new authenticated(...)`) dans la forme des tutoriels, puis
revenir à la forme du projet.

#### Erreurs fréquentes

| Symptôme | Cause | Réflexe à enseigner |
| --- | --- | --- |
| Deux objets « pareils » ne sont pas égaux | `==` par identité | `Equatable`, avec **tous** les champs dans `props` |
| Un test d'égalité passe alors qu'un champ diffère | Champ oublié dans `props` | Relire `props` à chaque champ ajouté |
| Un nouveau cas d'`enum` n'apparaît nulle part | `default` dans le `switch` | `switch` exhaustif, sans `default` |
| « Can't define a const constructor for a class with non-final fields » | Champ modifiable | Tous les champs `final` |
| Confusion `extends` / `implements` | Héritage de code contre respect d'un contrat | `implements` pour un contrat (`interface`) |

#### Ticket de sortie

1. Pourquoi un constructeur `const` exige-t-il que tous les champs soient `final` ?
2. Que gagne-t-on à ne pas écrire `default` dans un `switch` sur un `enum` ?
3. Différence entre `abstract interface class` et `sealed class` ?

**Devoir** : une hiérarchie `sealed class PaymentStatus` avec trois cas (`Paid`,
`Pending`, `Late(int days)`) et une fonction `label` qui utilise une garde `when` pour
écrire « En retard (plus d'une semaine) » au-delà de 7 jours. **Pont vers 0.3** : « nos
données sont en mémoire et répondent tout de suite. Une vraie API met 300 ms à répondre,
et parfois ne répond pas. »

### Palier 0.3 — L'asynchrone et les erreurs

À la fin de la séance, chaque étudiant a un faux service qui répond après un délai et
échoue parfois, et un code appelant qui traite chaque cas sans planter.

**Le besoin** : « l'écran demande la liste des tontines. Le serveur est à Kinshasa, le
téléphone en 3G. Que fait l'écran pendant ces 2 secondes ? Et si le réseau tombe ? »

#### Les quatre étapes de live-coding

| Étape | Notion | Résultat visible | Pour casser |
| --- | --- | --- | --- |
| 1. Attendre | `Future`, `Future.delayed`, `async`/`await`, type de retour `Future<List<Tontine>>`, boucle d'événements à un seul fil | Les tontines s'affichent après 300 ms | **Prédire l'ordre** de quatre `print` avec et sans `await` : c'est la question de l'écrit |
| 2. Échouer | `throw`, `try`/`on`/`catch`/`finally`, `rethrow`, `Exception` contre `Error`, exceptions maison (`NetworkException`, `ServerException(statusCode, code)`) | « Pas de réseau » affiché au lieu d'une trace rouge | Écrire `try { return api.fetch(); } on NetworkException { ... }` **sans `await`** : l'erreur traverse le `catch` |
| 3. Généraliser | fonction générique `Future<T> guard<T>(Future<T> Function() call)`, types fonction, `Future.wait` | Une seule fonction traduit les erreurs de tous les appels | `Future.wait` avec un appel qui échoue : tout échoue, lire le message |
| 4. Écouter | `Stream`, `async*`/`yield`, `listen`, `StreamController`, `cancel` | Un compte à rebours s'affiche seconde après seconde | Oublier `cancel` : les messages continuent après la « fermeture » |

L'étape 2 contient la phrase à retenir : **un `try` n'attrape que ce qui échoue pendant
qu'on attend à l'intérieur**. C'est exactement pourquoi `_guard` dans
`tontine_repository_impl.dart` écrit `return await call();` et non `return call();`.
Montrez la ligne.

L'étape 4 prépare deux paliers : un Bloc est un flux d'états (palier 6), et le routeur
écoute le flux de la session (palier 7).

Différence à faire noter : une `Exception` est une situation **prévue** (le réseau tombe,
le mot de passe est faux) ; on l'attrape et on la traite. Une `Error` est un **bogue du
programmeur** (`!` sur `null`, index hors limites) ; on ne l'attrape pas, on corrige le
code.

#### Exercice autonome (60 min, tests fournis)

**Énoncé** : écrire `FakeTontineApi` (`getMyTontines()` répond après 300 ms et lève une
`NetworkException` un appel sur trois, avec un `Random` à graine fixe pour que les tests
soient reproductibles) et une fonction `loadTontines()` qui renvoie la liste ou un message
d'erreur lisible.

**Critères de réussite** :

- les tests au vert, dont un `expect(..., throwsA(isA<NetworkException>()))` ;
- aucun `catch` sans `on` (on n'attrape pas « tout ») ;
- l'étudiant sait prédire l'ordre des `print` d'un code `async` qu'on lui montre.

**Défi pour les rapides** : `getMembers` et `getTontine` lancés en parallèle avec
`Future.wait`, puis comparer le temps total avec deux `await` successifs.

#### Erreurs fréquentes

| Symptôme | Cause | Réflexe à enseigner |
| --- | --- | --- |
| L'erreur n'est pas attrapée | `return` sans `await` dans un `try` | `return await` |
| Un traitement « finit » avant les données | `Future` lancé sans `await` | Lint `unawaited_futures` ; `unawaited(...)` quand c'est voulu |
| `forEach` avec `async` ne s'attend pas | `forEach` ignore les `Future` | Une boucle `for` avec `await` |
| Tout est attrapé, même les bogues | `catch (e)` ou `on Object` | `on UneException` précise |
| Le programme ne s'arrête pas | Abonnement à un `Stream` jamais annulé | `cancel()` (au palier 2 : dans `dispose`) |

#### Ticket de sortie

1. Dans quel ordre s'affichent ces quatre lignes ? (extrait de 8 lignes au tableau)
2. Pourquoi `return await` dans un `try`, et pas seulement `return` ?
3. `Exception` ou `Error` : laquelle attrape-t-on, et pourquoi ?

**Devoir** : lire `tontine_repository_impl.dart` et répondre par écrit : que devient une
`NetworkException` levée par la source distante ? Quel `switch` choisit la `Failure`, et
que fait la garde `when` ? **Pont vers le palier 1** : « tout ça tourne en console. La
prochaine fois, on le dessine. »

## 5. Phase B — L'interface (paliers 1 à 3)

Le déroulé détaillé (live-coding, exercice, erreurs fréquentes, ticket, piège IA) est
dans le **guide d'animation des paliers 1 à 4**. Ce plan y ajoute trois choses par
palier : ce que la phase A change au point de départ, les notions propres à Flutter qu'il
faut nommer explicitement, et le fil Dart.

### Palier 1 — Premiers widgets et thème

**Point de départ, ajusté** : les classes `Tontine` et `Member` et `Formatters` du paquet
`likelemba_kata` sont recopiées dans le projet Flutter. L'étudiant affiche ses propres
classes : le lien entre les deux phases est concret.

**Les trois idées de Flutter à nommer, au tableau, avant le premier widget** :

1. **Tout est widget, et un widget est une description immuable.** `build` décrit ce
   qu'on veut voir ; Flutter compare et redessine ce qui change. D'où les champs `final`
   et les constructeurs `const` vus en 0.2.
2. **Les contraintes descendent, les tailles remontent, le parent place.** C'est la
   règle qui explique tous les débordements de la séance : une `Row` donne à ses enfants
   une largeur illimitée, d'où la bande jaune et noire, d'où `Expanded`.
3. **Rechargement à chaud (hot reload) contre redémarrage (hot restart)** : le premier
   garde l'état et rejoue `build`, le second repart de `main()`.

**Le fil Dart** : `const` sur les widgets (et pourquoi l'analyseur le réclame), `super.key`,
`VoidCallback` comme type fonction (vu en 0.3), le `switch` exhaustif de `RoleBadge` (vu
en 0.2), et le `?.` de `textTheme.labelMedium?.copyWith(...)` : le thème peut ne pas
définir ce style, d'où le type nullable.

**Ajout au ticket de sortie** : « Pourquoi `labelMedium?.copyWith` et pas
`labelMedium.copyWith` ? »

### Palier 2 — Formulaires et état local

**Les notions de Flutter à nommer** : la séparation `StatefulWidget` (la configuration,
immuable) et `State` (la mémoire, qui survit aux reconstructions) ; le cycle de vie
complet, à afficher avec `debugPrint` : `initState`, `didChangeDependencies`, `build`,
`didUpdateWidget`, `dispose`.

**Le fil Dart, très présent ici** :

- `validator` renvoie un `String?` : **le null porte le sens** (« pas d'erreur »). C'est
  la null safety utilisée comme langage, pas comme contrainte ;
- `late final _fullName = TextEditingController(text: widget.initial?.fullName)` : `late`
  est nécessaire parce que `widget` n'existe pas encore quand les champs sont initialisés ;
- `_formKey.currentState!` : le premier `!` justifié du cours (voir le devoir de 0.1) ;
- `int.tryParse` renvoie `int?` ; `showDatePicker` renvoie `Future<DateTime?>` parce que
  l'utilisateur peut annuler ;
- le `typedef` de record (`MemberFormResult`) vu en 0.2.

**Ajout au ticket de sortie** : « Pourquoi `showDatePicker` renvoie-t-il un `DateTime?`
et non un `DateTime` ? »

### Palier 3 — Navigation

**Les notions de Flutter à nommer** : la pile d'écrans, `BuildContext` comme « adresse
dans l'arbre » (d'où `context.mounted` : après un `await`, l'adresse peut ne plus exister).

**Le fil Dart** :

- `await context.push<Tontine>(...)` renvoie un `Tontine?` : `null` si l'utilisateur
  revient avec la flèche. Le générique et le nullable se lisent ensemble ;
- `state.pathParameters['id']!` : un `Map` renvoie toujours un nullable, et le chemin
  garantit la clé ;
- `abstract final class AppRoutes` et `static String tontine(String id)` (vu en 0.2) ;
- `late final GoRouter _router`, créé dans `initState` de `app.dart`.

**Ajout au ticket de sortie** : « Que vaut `created` si l'utilisateur appuie sur retour
sans créer ? Montrez la ligne qui le gère dans `_create`. »

## 6. Phase C — L'architecture (paliers 4 à 8)

### Palier 4 — Architecture en couches : le domaine

Voir le guide d'animation. **Le fil Dart** : `abstract interface class` et `implements`
(0.2), le générique `UseCase<Result, Params>`, la classe appelable (`call`) qui permet
d'écrire `await createTontine(params)`, `Failure extends Equatable implements Exception`
(une `Failure` se lève avec `throw` et se compare dans les tests), et le piège de
`GetMyTontinesUseCase` : `[...tontines]..sort(...)` copie la liste avant de la trier, car
`sort` modifie l'original, qui appartient au dépôt.

**Ajout au ticket de sortie** : « Pourquoi `GetMyTontinesUseCase` écrit-il
`[...tontines]..sort` et non `tontines..sort` ? »

### Palier 5 — La couche data : API, JSON et dépôts

À la fin de la séance, l'application lit et crée de vraies tontines sur l'API, et une
coupure du serveur affiche un message au lieu de planter. Les écrans ne changent pas :
c'est la récompense du palier 4.

**Point de départ** : le projet du palier 4, plus `likelemba_backend/` lancé avec
`dart_frog dev` (on le lit, on ne l'écrit pas ; voir le palier bonus) et
`core/network/dio_factory.dart` fourni. La session n'arrive qu'au palier 7 : en attendant,
l'étudiant obtient un jeton avec `curl` et le colle dans une constante de développement.
C'est une **dette volontaire**, notée dans `DETTE.md`.

**Le besoin (0 h 15)** : faites la requête à la main, devant eux.

```bash
curl -s -X POST localhost:8080/auth/login -H 'Content-Type: application/json' \
  -d '{"email":"tresorier1@likelemba.test","password":"likelemba2026"}'
```

Puis `GET /tontines` avec le jeton. Posez le JSON à côté de l'entité `Tontine` :
`contribution_amount` contre `contributionAmount`, `"monthly"` (une chaîne) contre
`ContributionFrequency.monthly`, une date en texte UTC contre un `DateTime`. « Qui
traduit ? Et où le range-t-on pour que le domaine n'en sache rien ? »

#### Les quatre étapes de live-coding

| Étape | Fichier de référence | Notion | Résultat visible | Pour casser |
| --- | --- | --- | --- | --- |
| 1. Parler HTTP | `dio_factory.dart`, `app_environment.dart`, `likelemba_backend/routes/tontines/index.dart` | Verbes et codes HTTP, `Dio`, `baseUrl`, délais, saveur de développement | Le JSON brut s'affiche dans la console de l'application | Lancer sur l'émulateur Android avec `localhost` : c'est l'émulateur lui-même ; d'où `10.0.2.2` |
| 2. Le modèle | `tontine_model.dart`, `member_model.dart` | `TontineModel extends Tontine`, `factory fromJson`, `as String`, `as int? ?? 0`, `asNameMap()[...] ?? valeur`, `DateTime.parse` | Test de `fromJson` sur un JSON d'exemple au vert | Envoyer `"contribution_amount": 5000.0` : « type 'double' is not a subtype of type 'int' » |
| 3. La source distante | `tontine_remote_data_source.dart` | Contrat et implémentation, `DioException` traduite en `NetworkException` ou `ServerException(statusCode, code)` | Arrêter le serveur : une `NetworkException`, pas une `DioException` | Ne rien attraper : la `DioException` remonte jusqu'à l'écran, qui ne sait pas la lire |
| 4. Le dépôt | `tontine_repository_impl.dart` | `implements TontineRepository`, `_guard`, `switch` sur `error.code` avec garde `when` ; remplacer `InMemoryTontineRepository` dans `main.dart` | Les mêmes écrans, sur de vraies données ; serveur arrêté : « Pas de réseau » | Retirer le `await` de `_guard` : les `Failure` ne sont plus produites (le piège de 0.3) |

Le moment à souligner : à l'étape 4, **on change une ligne dans `main.dart` et aucune
page**. Faites compter les fichiers touchés, et rappelez la question de la fin du
palier 3.

Le tableau des trois couches d'erreur, à recopier :

| Couche | Ce qu'elle lève | Exemple | Qui l'attrape |
| --- | --- | --- | --- |
| La bibliothèque | `DioException` | délai dépassé | la source distante |
| `data/` | `NetworkException`, `ServerException` | `ServerException(409, 'phone_already_member')` | le dépôt (`_guard`) |
| `domain/` | `Failure` | `PhoneAlreadyMemberFailure` | la page (palier 5), puis le Cubit (palier 6) |

#### Exercice autonome (60 min, tests qui échouent)

**Énoncé** : `MemberModel.fromJson`, puis `getMembers` et `addMember` dans la source
distante et dans le dépôt, avec la traduction de `phone_already_member` en
`PhoneAlreadyMemberFailure`. Tests fournis : `tontine_remote_data_source_test.dart` et
`tontine_repository_impl_test.dart`, réduits aux méthodes demandées.

**Critères de réussite** :

- les tests au vert ;
- `bash tool/check_architecture.sh` affiche cinq ✓ (la règle 3 : `data/` ignore
  l'interface) ;
- serveur arrêté, l'écran affiche un message ;
- aucun `Map<String, dynamic>` ne sort de `data/`.

**Défi pour les rapides** : `updateMember`, qui n'envoie que les champs modifiés, avec
les éléments de collection nuls : `{'full_name': ?fullName, 'phone': ?phone}`.

#### Erreurs fréquentes

| Symptôme | Cause | Réflexe à enseigner |
| --- | --- | --- |
| « Connection refused » sur l'émulateur Android | `localhost` désigne l'émulateur | `10.0.2.2`, ou `--dart-define=API_URL=http://<ip-du-poste>:8080` sur un vrai téléphone |
| « Cleartext HTTP traffic not permitted » | Android bloque le HTTP non chiffré | `usesCleartextTraffic` dans la seule saveur development (voir `android/app/src/development/AndroidManifest.xml`) |
| « type 'Null' is not a subtype of type 'String' » | Clé absente du JSON | Vérifier le JSON réel ; `as String?` et une valeur de repli quand le champ est vraiment optionnel |
| Dates décalées d'une heure | L'API envoie de l'UTC | `toUtc()` à l'envoi, `toLocal()` à l'affichage (`Formatters.date`) |
| Une page importe `tontine_model.dart` | Le modèle fuit hors de `data/` | La page ne voit que l'entité ; règle 2 du script |

#### Ticket de sortie

1. Pourquoi `fromJson` est-il dans `TontineModel` et pas dans `Tontine` ?
2. Quel fichier connaît le nom `contribution_amount` ? Un seul.
3. Une `DioException` de délai dépassé : que devient-elle à chaque couche jusqu'à l'écran ?

**Devoir** : `createTontine` de bout en bout, avec un test du dépôt pour
`validation_error`. **Pont vers le palier 6** : « nos pages font des `try`/`catch`, gèrent
“chargement”, “erreur” et “succès” avec trois booléens et `setState`. Chaque page
réinvente la même chose. Combien de combinaisons de trois booléens sont impossibles ? »
(Réponse : la plupart. On veut un état qui ne puisse pas mentir.)

### Palier 6 — L'état avec Cubit

À la fin de la séance, l'accueil et la création sont pilotés par des Cubits testés avec
`bloc_test`, et les pages ne contiennent plus aucun `try`/`catch`.

**Point de départ** : le projet du palier 5, plus `core/utils/statuses.dart`
(`LoadStatus`, `FormStatus`) fourni.

**Le besoin** : montrez la page d'accueil du palier 5 et comptez à voix haute ses
`setState`, ses booléens et ses `try`. Puis l'idée du jour, au tableau : **l'écran est une
fonction de l'état** : `écran = build(état)`. On ne modifie plus l'écran, on émet un
nouvel état.

#### Les quatre étapes de live-coding

| Étape | Fichier de référence | Notion | Résultat visible | Pour casser |
| --- | --- | --- | --- | --- |
| 1. Un état immuable | `tontines_state.dart`, `tontines_cubit.dart` | `Cubit<S>`, `emit`, état `Equatable` avec valeurs par défaut `const`, `part`/`part of` | `load()` émet chargement puis succès (visible avec `AppBlocObserver`) | `state.tontines.add(t); emit(state);` : rien ne se redessine (même objet, donc égal) |
| 2. Brancher l'écran | `home_page.dart` | `BlocProvider(create:)`, `BlocBuilder`, `switch (state.status)`, `context.read` / `watch` / `select` | La liste, l'indicateur de chargement, le message d'échec | `context.watch` dans un `onPressed` : lire le message ; un `BlocProvider` et sa lecture dans le même `build` : `ProviderNotFoundException` |
| 3. Un formulaire | `create_tontine_cubit.dart`, `create_tontine_page.dart` | `FormStatus`, `BlocListener` pour les effets uniques (naviguer, `SnackBar`), `listenWhen` | Création, puis retour à l'accueil avec la tontine | Naviguer dans un `BlocBuilder` : navigation déclenchée à chaque reconstruction |
| 4. Tester | `tontines_cubits_test.dart` | `blocTest(build:, act:, expect:)`, faux cas d'usage `mocktail` | Trois tests au vert : succès, échec, rafraîchissement | Retirer `Equatable` de l'état : `expect` échoue alors que « c'est pareil » |

#### Le débat de fin de séance (15 min) : `status` + `failure?`, ou `sealed` ?

Le projet écrit l'état ainsi : un `status`, une liste et un `Failure? failure`. Ce choix
oblige à écrire `state.failure!` dans la branche d'échec (voir le devoir de 0.1).
L'alternative :

```dart
sealed class TontinesState {}
final class TontinesLoading extends TontinesState {}
final class TontinesLoaded extends TontinesState { final List<Tontine> tontines; ... }
final class TontinesFailed extends TontinesState { final Failure failure; ... }
```

Plus de `!` (la `Failure` n'existe que dans le cas où elle a un sens), mais on perd la
liste affichée pendant un rafraîchissement, que le projet garde volontairement (voir le
commentaire de `load()`). Faites voter, puis argumenter. Comme au palier 4, pas de bonne
réponse : l'objectif est de savoir dire ce que chaque forme rend impossible.

#### Exercice autonome (60 min, tests qui échouent)

**Énoncé** : `TontineDetailCubit` : charger la tontine puis ses membres, renvoyés ensemble
dans un record `(Tontine, List<Member>)` et déstructurés (vu en 0.2), puis `addMember`,
qui recharge la liste. Tests fournis : `tontine_detail_cubit_test.dart`, réduit aux deux
méthodes.

**Critères de réussite** :

- les tests au vert ;
- la page de détail n'a plus de `try` ;
- l'ajout d'un téléphone déjà membre affiche le message, la feuille reste utilisable ;
- l'étudiant sait expliquer la différence entre `BlocBuilder` et `BlocListener`.

**Défi pour les rapides** : charger la tontine et les membres **en parallèle** avec
`Future.wait` (vu en 0.3), puis mesurer le gain avec le serveur ralenti ; ensuite
`removeMember` avec la confirmation `showDialog<bool>` du palier 2.

#### Erreurs fréquentes

| Symptôme | Cause | Réflexe à enseigner |
| --- | --- | --- |
| « Cannot emit new states after calling close » | Un `await` se termine après la fermeture de la page | `if (isClosed) return;` après l'`await`, ou ne pas lancer de travail orphelin |
| L'écran ne bouge pas après `emit` | État modifié sur place, ou `Equatable` incomplet | Toujours un nouvel objet ; tous les champs dans `props` |
| `ProviderNotFoundException` | Le `context` est au-dessus du `BlocProvider` | Une page qui fournit, une vue qui lit (`HomePage` / `HomeView`) |
| Le Cubit n'est jamais fermé, ou fermé trop tôt | `BlocProvider.value` utilisé pour créer | `create:` pour créer (le provider ferme), `.value` pour transmettre un existant |
| « type 'Null' is not a subtype of Future » dans un `blocTest` | Cas d'usage factice non configuré | `when(() => useCase(any())).thenAnswer(...)` |

#### Ticket de sortie

1. Pourquoi l'état doit-il être un nouvel objet à chaque `emit` ?
2. `context.read`, `context.watch`, `context.select` : laquelle dans un `onPressed`,
   laquelle dans `build` ?
3. Pourquoi naviguer dans un `BlocListener` et non dans un `BlocBuilder` ?

**Devoir** : réviser pour l'écrit (les quatre types de questions sont dans le guide).
**Pont vers le palier 7** : « le bouton “Se connecter” mène toujours à l'accueil, et le
jeton est collé dans le code. Qui se souvient que je suis connecté quand je ferme
l'application ? »

### Palier 7 — La session : connexion, stockage, redirection

À la fin de la séance, la connexion est réelle, l'application redémarrée reste connectée,
et une session expirée ramène à l'écran de connexion. Deux dettes sont remboursées : le
jeton collé dans le code et le bouton qui mène directement à l'accueil.

**Point de départ** : le projet du palier 6. La feature `auth` a déjà son domaine
(`User`, `AuthRepository`, `LoginUseCase` du palier 4) ; il lui manque ses données et sa
session.

**Le besoin** : posez trois questions. « Où garder le jeton quand l'application est
fermée ? », « qui doit savoir que je suis connecté : la page de connexion, l'accueil, le
routeur, le client HTTP ? » (tous), « que fait l'application quand le serveur répond 401
au milieu d'une session ? ».

#### Les quatre étapes de live-coding

| Étape | Fichier de référence | Notion | Résultat visible | Pour casser |
| --- | --- | --- | --- | --- |
| 1. Retenir | `auth_local_data_source.dart`, `auth_remote_data_source.dart`, `auth_repository_impl.dart` | `SharedPreferences`, `saveSession` / `getToken` / `clearSession`, `CacheException` | Redémarrer l'application : le jeton est toujours là | Lire le stockage avant `WidgetsFlutterBinding.ensureInitialized()` : lire l'erreur |
| 2. Un Bloc de session | `auth_bloc.dart`, `auth_event.dart`, `auth_state.dart` | `Bloc<Event, State>` contre `Cubit`, `sealed class AuthEvent`, `on<E>(...)`, constructeurs nommés d'état | `AuthStarted` mène à `authenticated` ou `unauthenticated` | Retirer un `on<...>` : l'événement est ignoré, lire l'erreur de `bloc` |
| 3. Rediriger | `app_router.dart`, `go_router_refresh_stream.dart`, `splash_page.dart` | `redirect`, `refreshListenable` branché sur `authBloc.stream` (le `Stream` de 0.3), écran de démarrage pendant `unknown` | Connexion, déconnexion, et l'écran suit tout seul | Rediriger `/login` vers `/login` : « redirect loop detected » |
| 4. Le 401 | `auth_interceptor.dart`, `injection_container.dart` | `Interceptor`, en-tête `Bearer`, l'intercepteur reçoit des **fonctions** et non des classes de features | Avec `TOKEN_TTL_MINUTES=1 dart_frog dev`, retour automatique à la connexion une minute après | Traiter aussi le 401 de `/auth/login` : un mauvais mot de passe « expire la session » |

**Quand un Bloc plutôt qu'un Cubit ?** Quand plusieurs sources différentes déclenchent
des changements et qu'on veut les nommer : ici le démarrage, la page de connexion, le
bouton de déconnexion et l'intercepteur. Un `sealed class AuthEvent` en donne la liste
complète, et le compilateur la connaît.

**Pourquoi des fonctions dans l'intercepteur ?** Montrez la règle 4 du script :
`core/` ne dépend d'aucune feature. L'intercepteur demande « une fonction qui lit le
jeton » sans savoir qui la fournit ; le point d'assemblage branche `AuthLocalDataSource`.
C'est l'inversion de dépendance en une ligne.

#### Exercice autonome (60 min, tests qui échouent)

**Énoncé** : l'inscription (`RegisterCubit`, qui envoie `AuthUserAuthenticated` en cas
de succès) et le bouton de déconnexion. Tests fournis : `register_cubit_test.dart`,
`auth_bloc_test.dart`.

**Critères de réussite** :

- inscription réussie : l'accueil s'affiche sans `context.go` dans la page (c'est le
  routeur qui redirige) ;
- déconnexion : retour à la connexion, et le bouton retour ne ramène pas à l'accueil ;
- application redémarrée : toujours connecté ;
- la constante du jeton en dur a disparu, et la ligne est cochée dans `DETTE.md`.

**Défi pour les rapides** : afficher « Votre session a expiré » sur l'écran de connexion
quand `sessionExpired` est vrai.

#### Erreurs fréquentes

| Symptôme | Cause | Réflexe à enseigner |
| --- | --- | --- |
| « redirect loop detected » | `redirect` renvoie une route qui redirige à son tour | Renvoyer `null` quand on est déjà au bon endroit |
| Le routeur ne réagit pas à la connexion | Pas de `refreshListenable` | Brancher le flux du Bloc |
| Mauvais mot de passe : « session expirée » | Le 401 de `/auth/*` traité comme une expiration | Exclure les routes d'authentification (voir l'intercepteur) |
| La page navigue ET le routeur redirige | Deux responsables de la même décision | Un seul : le routeur |
| Jeton lisible dans les fichiers de l'appareil | `SharedPreferences` n'est pas chiffré | Dette assumée ; `flutter_secure_storage` en palier bonus |

#### Ticket de sortie

1. Pourquoi `AuthBloc` est-il un Bloc et `LoginCubit` un Cubit ?
2. Qui décide d'afficher l'écran de connexion après une déconnexion ?
3. Pourquoi l'intercepteur reçoit-il des fonctions plutôt que `AuthBloc` ?

**Devoir** : écrire le test de l'intercepteur pour le cas « 401 sur `/auth/login` ne
déconnecte pas ». **Pont vers le palier 8** : « ouvrez `main.dart`. Comptez les `new`.
Qui crée `Dio` ? Qui le donne au dépôt ? Que faut-il changer pour qu'un test utilise un
faux dépôt ? »

### Palier 8 — Injection des dépendances et saveurs

À la fin de la séance, `main.dart` ne construit plus rien à la main, chaque feature a son
fichier d'injection, et les trois saveurs pointent chacune sur leur API.

**Point de départ** : le projet du palier 7, dont le `main.dart` assemble une trentaine
d'objets à la main (dette notée au palier 4).

**Le besoin** : lisez ce `main.dart` à voix haute. Puis : « pour tester l'accueil avec un
faux dépôt, que faut-il modifier ? » Réponse : `main.dart` lui-même, donc le code de
production.

#### Les quatre étapes de live-coding

| Étape | Fichier de référence | Notion | Résultat visible | Pour casser |
| --- | --- | --- | --- | --- |
| 1. Un point d'assemblage | `core/di/injection_container.dart`, `bootstrap.dart` | Composition root, `GetIt.instance`, `registerSingleton`, `registerLazySingleton<Contrat>(() => Impl(sl()))`, `registerFactory` | L'application démarre, `main.dart` fait trois lignes | Oublier un enregistrement : lire « … is not registered inside GetIt » |
| 2. Un fichier par feature | `auth_injection.dart`, `tontine_injection.dart` | `initTontineFeature(sl)`, ordre data → domaine → presentation, cascade `..` | Ajouter une feature ne touche qu'une ligne de `injection_container.dart` | Enregistrer `TontinesCubit` en singleton : rouvrir la création affiche l'état « succès » de la fois précédente |
| 3. Les saveurs | `main_development.dart`, `app_environment.dart` | `bootstrap(..., environment:)`, `--flavor`, `--target`, `--dart-define` | `development` sur l'API locale, `staging` sur une autre adresse | Lancer sans `--flavor` sur Android : lire l'erreur de construction |
| 4. Tester grâce à l'injection | `app.dart` (`App(authBloc:)`), `test/helpers/pump_app.dart` | La racine reçoit `AuthBloc` en paramètre ; seules les pages appellent `sl<...>()` | Un test de l'application avec un faux `AuthBloc` | Appeler `sl` dans un widget profond : le test exige alors tout `get_it` |

**La règle à recopier** : `sl` n'est appelé qu'aux points d'assemblage :
`*_injection.dart`, `injection_container.dart` et la création d'un `BlocProvider` dans
une page. Partout ailleurs, une classe reçoit ses dépendances par son constructeur.

**Factory ou singleton ?** Un dépôt, un client HTTP, un cas d'usage n'ont pas d'état
propre à un écran : un seul suffit (`registerLazySingleton`). Un Cubit d'écran porte
l'état de cet écran : un neuf par ouverture (`registerFactory`). `AuthBloc` est
l'exception : la session est partagée par toute l'application.

#### Exercice autonome (60 min, consigne et critères)

**Énoncé** : en saveur `development`, enregistrer une `FakeTontineRemoteDataSource` (des
données en mémoire, réutilisez le faux service du palier 0.3) à la place de la vraie,
pour travailler sans serveur.

**Critères de réussite** :

- `flutter run --flavor development` fonctionne serveur arrêté ;
- `staging` utilise toujours la vraie source ;
- aucune page n'a changé ;
- la ligne « `main.dart` assemble à la main » est cochée dans `DETTE.md`.

**Défi pour les rapides** : expliquer par écrit pourquoi
`registerLazySingleton(() => TontineRepositoryImpl(sl()))`, sans le type du contrat,
fait échouer `sl<TontineRepository>()`.

#### Erreurs fréquentes

| Symptôme | Cause | Réflexe à enseigner |
| --- | --- | --- |
| « TontineRepository is not registered » alors qu'il l'est | Enregistré sous le type de l'implémentation | `registerLazySingleton<TontineRepository>(...)` |
| L'état d'un écran réapparaît | Cubit enregistré en singleton | `registerFactory` pour les Cubits d'écran |
| Erreur avant `runApp` | Initialisation asynchrone sans `ensureInitialized` | `WidgetsFlutterBinding.ensureInitialized()` en tête de `bootstrap` |
| Les tests se marchent dessus | `get_it` global partagé entre tests | Passer les dépendances en paramètre ; `sl.reset()` si nécessaire |

#### Ticket de sortie

1. Différence entre `registerFactory` et `registerLazySingleton`, avec un exemple de
   chaque dans Likelemba.
2. Pourquoi enregistre-t-on le dépôt sous le type du contrat ?
3. Où a-t-on le droit d'écrire `sl<...>()` ?

**Devoir** : schéma papier de qui crée qui, de `bootstrap` jusqu'à `TontinesCubit`.
**Pont vers le palier 9** : « faites `grep -rn "Text('" lib/features` : combien de
textes français en dur ? Et si l'application doit sortir en anglais ? »

## 7. Phase D — La qualité (paliers 9 à 12)

### Palier 9 — Traduction et messages d'échec

À la fin de la séance, aucune chaîne n'est écrite en dur dans les widgets, l'application
fonctionne en français et en anglais, et chaque `Failure` a son message.

**Point de départ** : le projet du palier 8 ; `l10n.yaml` et `core/l10n/` fournis vides.

#### Les quatre étapes de live-coding

| Étape | Fichier de référence | Notion | Résultat visible | Pour casser |
| --- | --- | --- | --- | --- |
| 1. Les fichiers ARB | `l10n.yaml`, `app_fr.arb`, `app_en.arb` | Le français comme langue de référence, génération (`generate: true`), fichiers générés à ne jamais modifier | `AppLocalizations` existe | Une clé présente en français, absente en anglais : lire l'avertissement de génération |
| 2. Lire une traduction | `core/l10n/l10n.dart` | L'extension `context.l10n` (une méthode d'extension, vue en 0.2) | L'écran de connexion en anglais en changeant la langue du téléphone | Lire `context.l10n` dans `initState` : il n'est pas encore disponible |
| 3. Paramètres et pluriels | `perRound`, `membersCount` | Paramètre `{amount}`, pluriel ICU `{count, plural, =0{…} =1{…} other{…}}` | « Aucun membre », « 1 membre », « 12 membres » | Retirer `other` : la génération refuse |
| 4. Les messages d'échec | `failure_l10n.dart`, `features/*/presentation/widgets/failure_message.dart` | Une extension par feature (`failure.message(l10n)`), repli sur `commonFailureMessage` | Chaque échec a un message traduit | Ajouter une `Failure` sans message : le repli affiche « erreur serveur », générique |

Faites remarquer où vit la traduction des échecs : dans la **présentation**. Le domaine
dit *ce qui* a échoué (`PhoneAlreadyMemberFailure`), l'interface dit *comment le dire*.

#### Exercice autonome (60 min)

**Énoncé** : traduire toute la feature tontine, y compris `frequencyLabel` et `roleLabel`,
et écrire `TontineFailureMessage`.

**Critères de réussite** : `grep` ne trouve plus de texte en dur dans
`features/*/presentation` ; l'application est complète en anglais ; la ligne « textes en
dur » est cochée dans `DETTE.md`.

**Défi pour les rapides** : `Formatters.amount` dépend-il de la langue ? (« 1 250 000 FC »
en français, « 1,250,000 FC » en anglais.) Proposer une solution avec `intl`.

#### Ticket de sortie

1. Pourquoi ne modifie-t-on jamais les fichiers de `core/l10n/gen/` ?
2. Pourquoi le message d'une `Failure` n'est-il pas dans la `Failure` elle-même ?
3. Écrivez la clé ARB qui donne « 1 tour » et « 5 tours ».

**Pont vers le palier 10** : « tout marche. Comment le prouver dans six mois, après que
quelqu'un aura modifié `LoginView` ? »

### Palier 10 — Tests de widgets, couverture et intégration continue

À la fin de la séance, les écrans clés sont testés, la couverture dépasse le seuil fixé,
et la CI GitHub vérifie analyse, tests et architecture à chaque envoi.

**Point de départ** : le projet du palier 9, `test/helpers/pump_app.dart` et les
`fixtures` fournis.

#### Les quatre étapes de live-coding

| Étape | Fichier de référence | Notion | Résultat visible | Pour casser |
| --- | --- | --- | --- | --- |
| 1. Un test de widget | `login_page_test.dart`, `pump_app.dart` | `testWidgets`, `pumpApp` (thème, traductions, providers), `find.byKey(const Key('emailField'))`, `enterText`, `tap` | Le test « e-mail invalide affiche un message » au vert | Supprimer la `Key` du champ : le test ne le trouve plus. D'où les `Key` conservées depuis le palier 1 |
| 2. Simuler un Cubit | `tontine_pages_test.dart` | `MockCubit`, `whenListen`, états préparés | L'écran d'accueil testé en chargement, en succès et en échec | `pumpAndSettle` pendant le chargement : délai dépassé (l'indicateur tourne sans fin) ; utiliser `pump` |
| 3. La couverture | `very_good test --coverage` | Lire le rapport, `min_coverage` | Le pourcentage, fichier par fichier | Viser 100 % : montrer un test qui couvre une ligne sans rien vérifier |
| 4. La CI | `.github/workflows/main.yaml` | `very_good_workflows`, une étape `bash tool/check_architecture.sh` à ajouter | Une coche verte sur GitHub | Pousser un import de `dio` dans une entité : la CI devient rouge |

La CI actuelle du projet vérifie l'analyse, les tests et une couverture de 70 % ; elle
ne lance pas encore le script d'architecture. L'ajouter est l'étape 4.

#### Exercice autonome (60 min)

**Énoncé** : tester `RegisterView` (champs, validation, envoi), puis remonter
`min_coverage` à 80.

**Critères de réussite** : les tests au vert en local et en CI ; chaque test vérifie un
comportement visible, pas un détail d'implémentation ; l'étudiant explique la différence
entre `pump` et `pumpAndSettle`.

#### Ticket de sortie

1. Pourquoi retrouver un champ par sa `Key` plutôt que par son texte ?
2. Quand `pumpAndSettle` ne se termine-t-il jamais ?
3. Que prouve, et que ne prouve pas, une couverture de 90 % ?

### Palier 11 — Gérer les membres en autonomie, et revoir un modèle

À la fin de la séance, l'étudiant a écrit seul une fonctionnalité qui traverse les trois
couches (modifier un membre, le promouvoir trésorier), et il sait expliquer pourquoi le
rôle vit dans `Member` et non dans `User`.

**Première heure : l'étude de cas.** Suivez `docs/lecons/07-tontines-et-membres.md` : la
première version du projet portait le rôle sur `User`, compilait, passait ses tests, et
était fausse. Racontez Grâce, trésorière au marché de Gambela et simple membre chez les
enseignants de Lemba. Écrivez la phrase à retenir en fin d'heure, pas au début :
**le rôle appartient à l'appartenance à un groupe, pas à la personne.**

**Deuxième partie : l'autonomie.** Le niveau d'aide est celui du palier 4 : **énoncé et
tests seuls**. Pas de live-coding.

**Énoncé** : `UpdateMemberUseCase`, puis le dépôt, puis le Cubit, puis l'écran :
modifier le nom ou le téléphone d'un membre, et le promouvoir trésorier. Règles métier :
une tontine garde au moins un trésorier (`LastTreasurerFailure`), un téléphone n'apparaît
qu'une fois (`PhoneAlreadyMemberFailure`).

**Critères de réussite** : tests fournis au vert, cinq ✓ au script, messages traduits, et
l'étudiant sait dire à quelle couche appartient chaque règle (et quelle règle seul le
serveur peut vérifier).

**Ticket de sortie** : « Un nouveau besoin : un membre peut être “secrétaire” dans une
tontine. Quels fichiers changez-vous, dans quel ordre ? » La bonne réponse commence par
`MemberRole`, et le compilateur donne la suite (voir 0.2).

### Palier 12 — Projet de synthèse : la feature cotisations

Trois séances (S15 à S17). L'étudiant, en binôme, construit `features/contribution/` de
bout en bout : qui a payé à chaque tour, qui est en retard, le total collecté. C'est la
seule feature qu'il conçoit lui-même, de l'entité à la CI.

**À préparer de votre côté** : les routes de cotisations dans `likelemba_backend`
(reprises de l'ancien `likelemba_api/`) et un énoncé avec les règles métier (montant égal
à la cotisation de la tontine, un seul paiement par membre et par tour, seul le trésorier
enregistre).

**Livrables** :

- domaine, données et présentation, avec leurs tests ;
- `flutter analyze` propre, CI verte, script d'architecture à cinq ✓ ;
- textes traduits en français et en anglais ;
- `DETTE.md` à jour (les raccourcis pris pendant le projet, assumés et datés) ;
- `JOURNAL_IA.md` : trois entrées au moins, notées sur la critique ;
- un historique Git d'un commit par étape.

**Déroulé** : S15, conception sur papier sans IA (entités, cas d'usage, écrans) validée
par vous avant la première ligne ; S16, atelier et revue croisée entre binômes ; S17,
soutenance individuelle (déroulé dans le guide : expliquer un fichier, prédire une
suppression, modifier en direct, question d'architecture).

## 8. Paliers bonus (pour les rapides, ou comme devoir long)

| Bonus | Après le palier | Contenu | Fichiers |
| --- | --- | --- | --- |
| Côté serveur | 5 | Dart Frog : routes, middleware, `provider`, JWT ; ajouter `PATCH /users/me` | `likelemba_backend/routes/`, `lib/src/` |
| Stockage sécurisé | 7 | Remplacer `SharedPreferences` par `flutter_secure_storage` pour le jeton, sans toucher au domaine | `auth_local_data_source.dart` |
| Hors ligne | 10 | Cache local des tontines : le dépôt lit le cache quand le réseau tombe | `features/tontine/data/` |
| État scellé | 6 | Réécrire `TontinesState` en `sealed` (le débat du palier 6), et mesurer ce que ça change dans les tests | `presentation/cubit/` |

Le bonus « côté serveur » est le meilleur exercice de transfert : les étudiants y
retrouvent les mêmes idées (contrat, dépôt, injection par `provider`) dans un autre
contexte, et comprennent les codes d'erreur que leur application traduit en `Failure`.

## 9. Le fil rouge : la dette volontaire, complétée

Le tableau du guide, prolongé jusqu'au palier 9. Chaque ligne entre dans `DETTE.md` le
jour où on prend le raccourci et se coche le jour où on le rembourse.

| Raccourci pris | Palier | Remboursé au palier | Comment |
| --- | --- | --- | --- |
| Textes français en dur dans les widgets | 1 à 8 | 9 | Fichiers ARB, `context.l10n` |
| Petites classes `Tontine` et `Member` du paquet de la phase A | 1 à 3 | 4 | Entités du domaine, avec `Equatable` |
| Liste de tontines en mémoire dans les pages | 3 | 4, puis 5 | Dépôt en mémoire derrière un contrat, puis vraie API |
| `_submit` qui affiche avec `debugPrint` | 2 | 6 | `_submit` appelle un Cubit |
| Pages qui appellent les cas d'usage et attrapent les `Failure` | 4 | 6 | Le Cubit attrape et émet un état d'échec |
| **Jeton obtenu avec `curl` et collé dans le code** | 5 | 7 | Connexion réelle, stockage local, intercepteur |
| Connexion qui mène à l'accueil par un simple bouton | 3 | 7 | `AuthBloc` et `redirect` |
| `main.dart` qui assemble les objets à la main | 4 à 7 | 8 | `get_it`, un fichier d'injection par feature |
| **Jeton stocké en clair** | 7 | bonus | `flutter_secure_storage` |
| **Script d'architecture absent de la CI** | 4 à 9 | 10 | Une étape dans `.github/workflows/main.yaml` |

## 10. `REGLES_IA.md`, palier par palier

Le fichier que l'étudiant donne à son assistant. Il grandit d'une à trois règles par
palier ; chacune doit pouvoir être vérifiée par une commande ou un test.

| Palier | Règle ajoutée | Comment la vérifier |
| --- | --- | --- |
| 0.1 | Aucun `!` sans commentaire qui le justifie ; aucun `dynamic` hors de `data/` | `grep` |
| 0.2 | Aucun `default` dans un `switch` sur un `enum` ou une classe `sealed` | `grep -n "default:"` |
| 0.3 | Dans un `try`, `return await`, jamais `return` seul ; jamais `catch` sans `on` | Relecture |
| 1 | Aucune couleur en dur dans un widget, tout vient du thème | `grep -rn "Colors\.\|Color(0x" lib/features` |
| 2 | Les contrôleurs sont des champs du `State` et sont libérés dans `dispose` | Relecture |
| 3 | Les chemins passent par `AppRoutes` | `grep -rn "'/" lib/features` |
| 4 | Les cinq règles du script d'architecture | `bash tool/check_architecture.sh` |
| 5 | Le JSON ne sort jamais de `data/` ; les dates partent en UTC | Script, règle 2 |
| 6 | Un état est immuable et `Equatable` ; on navigue dans un `BlocListener` | Tests `blocTest` |
| 8 | `sl` n'est appelé qu'aux points d'assemblage | `grep -rn "sl<" lib/features` |
| 9 | Aucune chaîne visible en dur ; les `Failure` se traduisent dans la présentation | `grep` |
| 10 | Tout comportement nouveau arrive avec son test | Couverture en CI |

## 11. Préparer les points de départ

Le guide le dit : l'application finie ne se donne pas telle quelle. Voici ce qu'il faut
fabriquer, palier par palier, avant le cours. Organisation conseillée du dépôt du cours :
une branche `depart/palier-N` par point de départ, et un tag `palier-N-etape-k` par étape
de live-coding (pour la règle « jamais bloqué »).

| Palier | À fabriquer |
| --- | --- |
| 0.1 à 0.3 | Le paquet `likelemba_kata` : `pubspec.yaml`, `analysis_options.yaml`, les fichiers de test qui échouent (`formatters_test.dart`, `validators_test.dart`, `tontine_test.dart`, `member_test.dart`, `fake_tontine_api_test.dart`) et des fichiers source à trous |
| 1 | Projet Flutter neuf avec les dépendances du `pubspec.yaml`, `TontineCard` et `RoleBadge` à trous (`// TODO`), textes en dur, capture du résultat attendu |
| 2 | `MemberFormSheet` en squelette (classe et champs), `AuthLayout` fourni, `_submit` en `debugPrint` |
| 3 | `HomePage` et `TontineDetailPage` statiques, liste de tontines en mémoire |
| 4 | Dossiers `domain/` vides, `check_architecture.sh`, `InMemoryTontineRepository`, tests rouges de `AddMemberUseCase` et `LoginUseCase` |
| 5 | `dio_factory.dart`, constante de jeton à remplir, tests rouges de la source distante et du dépôt réduits à `getMembers`/`addMember` |
| 6 | `statuses.dart`, tests rouges de `TontineDetailCubit` |
| 7 | Tests rouges de `RegisterCubit` et `AuthBloc` |
| 8 | Un `main.dart` volontairement long, qui assemble tout à la main |
| 9 | `l10n.yaml`, fichiers ARB vides |
| 10 | `pump_app.dart`, fixtures |
| 12 | Routes de cotisations dans le backend, énoncé |

Pour chaque point de départ, la vérification est la même : le projet compile,
`flutter analyze` ne signale rien, et les tests rouges échouent pour la bonne raison (un
`UnimplementedError`, pas une erreur de compilation qui bloquerait tout le fichier).
