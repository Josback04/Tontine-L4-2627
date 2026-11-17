# Leçon 7 : tontines et membres, ou pourquoi le rôle n'appartient pas à la personne

Cette leçon a deux objectifs. Le premier est visible : ajouter l'espace du trésorier
(créer une tontine, ajouter et gérer ses membres). Le second compte davantage : montrer
aux étudiants une erreur de modélisation que **nous avons réellement commise** dans la
première version du projet, et la corriger devant eux.

## La phrase à retenir

> **Le rôle appartient à l'appartenance à un groupe, pas à la personne.**

Écrivez-la au tableau en fin de séance, pas au début. Les étudiants doivent la trouver
eux-mêmes.

## 1. Montrer la première version, sans dire qu'elle est fausse (15 min)

Jusqu'à la leçon 6, l'entité `User` portait un rôle :

```dart
enum UserRole { treasurer, member }

class User extends Equatable {
  final String id;
  final String fullName;
  final UserRole role;          // ← ici

  bool get canManageContributions => role == UserRole.treasurer;
}
```

Et l'API renvoyait `"role": "treasurer"` avec l'utilisateur. Tout fonctionnait : les tests
passaient, l'écran affichait un badge « Trésorier ». Rien ne signalait de problème.

Demandez simplement : « Ce modèle vous paraît-il correct ? » La plupart diront oui. C'est
normal, et c'est justement ce qu'il faut leur faire vivre : **un modèle peut compiler,
passer ses tests et être faux**, parce que la question qu'on se pose sur le métier était
mauvaise.

## 2. Raconter une situation réelle (10 min)

Ne parlez pas de code. Racontez :

> Grâce vend au marché de Gambela. Elle tient la caisse de la tontine des mamans du
> marché : c'est elle qui note qui a payé. Le soir, elle cotise aussi dans la tontine des
> enseignants de Lemba, que gère Patrick. Là-bas, elle ne tient rien, elle verse sa part.

Puis : « Avec notre `User`, quel rôle donne-t-on à Grâce ? »

- `treasurer` ? Alors elle pourrait modifier la tontine de Patrick.
- `member` ? Alors elle ne peut plus gérer la sienne.

Il n'existe **aucune** bonne valeur. Ce n'est pas un bug d'implémentation qu'on corrige
avec un `if` : la donnée est rangée au mauvais endroit.

## 3. Faire trouver la bonne place (15 min)

Question : « Le rôle de Grâce dépend de quoi ? » Réponse attendue : de la tontine. Donc le
rôle ne décrit ni Grâce seule, ni une tontine seule, mais **le lien entre les deux**.

Dessinez :

```
User ──────< Member >────── Tontine
(Grâce)     role : treasurer   (Marché Gambela)
            role : member      (Enseignants de Lemba)
```

`Member`, c'est l'appartenance de quelqu'un à une tontine. C'est là que vivent le rôle,
l'ordre de passage pour la cagnotte, et le téléphone sous lequel le trésorier l'a inscrit.

Le même raisonnement s'applique ailleurs : un enseignant est titulaire d'un cours et
simple participant d'un autre ; un développeur est administrateur d'un dépôt GitHub et
lecteur d'un autre. Demandez-leur un troisième exemple.

## 4. Lire la correction dans le code (30 min)

| Avant | Après |
| --- | --- |
| `User.role` | `Member.role` ([member.dart](../../likelemba_app/lib/features/tontine/domain/entities/member.dart)) |
| `User.canManageContributions` | `Tontine.canManage`, calculé à partir de `myRole`, **mon** rôle dans **cette** tontine ([tontine.dart](../../likelemba_app/lib/features/tontine/domain/entities/tontine.dart)) |
| `"role"` dans la réponse de `/auth/login` | `"my_role"` dans chaque tontine de `GET /tontines` |
| Le badge « Trésorier » sur l'accueil, à côté du nom | Un badge par tontine, sur chaque carte |

Points à souligner :

- **La règle métier a déménagé avec la donnée.** `canManage` est sur `Tontine`, parce que
  c'est la seule entité qui sait de quelle tontine on parle.
- **Le serveur applique la même règle.** `POST /tontines/:id/members` regarde le rôle de
  l'appelant *dans cette tontine* : la même Grâce reçoit 201 dans la première et 403 dans
  la seconde. Le masquage du bouton dans l'app est un confort ; la sécurité est sur le
  serveur.
- **`User` n'a plus de rôle du tout**, et le commentaire en tête de
  [user.dart](../../likelemba_app/lib/features/auth/domain/entities/user.dart) explique
  pourquoi. Laissez ce commentaire : il évitera à l'étudiant de l'an prochain de remettre
  le champ.

## 5. Le voir dans l'application (15 min)

Lancez l'API puis l'app, connectez-vous avec `tresorier1@likelemba.test` /
`likelemba2026`. L'accueil montre les deux tontines de Grâce, l'une marquée
**Trésorier**, l'autre **Membre**.

- Dans « Mamans du marché Gambela » : bouton « Ajouter un membre », membres modifiables.
- Dans « Enseignants de Lemba » : aucun bouton, et un bandeau « Vous êtes membre de cette
  tontine : seul un trésorier peut modifier la liste ».

Un seul compte, deux comportements. C'est la démonstration la plus parlante de la leçon.

Faites aussi tester « Retirer le rôle de trésorier » sur Grâce dans sa tontine : l'API
refuse (« La tontine doit garder au moins un trésorier »). Encore une règle qui n'a de
sens qu'au niveau du groupe.

## 6. Les tests qui fixent la décision

Deux tests portent explicitement le nom de la règle. Montrez-les :

- côté API : `test/src/tontine_repository_test.dart`, groupe
  *« le rôle appartient à l'appartenance, pas à la personne »* ;
- côté app : `test/features/tontine/domain/tontine_test.dart`, même nom.

Un test peut documenter une décision de conception, pas seulement vérifier un calcul. Si
quelqu'un remet un rôle sur `User`, ces tests n'échoueront pas forcément, mais leur nom
rappellera pourquoi on l'a retiré.

## Un second point de modélisation : un membre n'a pas toujours de compte

À Kinshasa, beaucoup de membres d'une tontine n'installeront jamais l'application. Le
trésorier doit pouvoir inscrire « Junior Bokele, 0834567890 » sans que Junior crée de
compte. D'où `Member.hasAccount` (et `userId` facultatif côté serveur). Si Junior
s'inscrit un jour avec ce numéro, `POST /auth/register` relie sa fiche à son compte.

Demandez : « Que se passerait-il si `Member` exigeait un `User` ? » Réponse : l'application
ne servirait qu'aux tontines dont tous les membres ont un smartphone, c'est-à-dire presque
aucune.

## Exercices

1. **Ordre de passage.** Permettre au trésorier de changer l'ordre de passage d'un membre
   (`PATCH` avec `payout_order`). Que faut-il faire des autres membres ? Où mettre cette
   règle : domaine, données ou serveur ?
2. **Quitter une tontine.** Un simple membre peut-il se retirer lui-même ? Écrire la règle,
   puis la route et le cas d'usage.
3. **Discussion.** Le rôle « trésorier » suffit-il ? Certaines tontines ont un président
   et un secrétaire. Comment faire évoluer `MemberRole` sans toucher à `User` ?

## Fichiers de la leçon

```
likelemba_backend/
├── lib/src/member.dart, tontine.dart, tontine_repository.dart, tontine_access.dart
└── routes/tontines/   index.dart, [id]/index.dart, [id]/members/index.dart, [id]/members/[memberId].dart

likelemba_app/lib/features/tontine/
├── tontine_injection.dart
├── domain/    entities (Tontine, Member), failures, contrat, 7 cas d'usage
├── data/      TontineModel, MemberModel, source distante, TontineRepositoryImpl
└── presentation/  TontinesCubit, CreateTontineCubit, TontineDetailCubit, pages, widgets
```
