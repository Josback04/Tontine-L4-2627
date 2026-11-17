part of 'tontine_detail_cubit.dart';

final class TontineDetailState extends Equatable {
  const new({
    this.tontineId = '',
    this.status = LoadStatus.loading,
    this.tontine,
    this.members = const [],
    this.failure,
    this.isActing = false,
    this.actionFailure,
  });

  final String tontineId;
  final LoadStatus status;
  final Tontine? tontine;
  final List<Member> members;

  /// Échec du chargement : l'écran affiche une erreur à la place du contenu.
  final Failure? failure;

  /// Une action (ajout, modification, retrait) est en cours.
  final bool isActing;

  /// Échec d'une action : affiché dans un SnackBar, la liste reste visible.
  final Failure? actionFailure;

  TontineDetailState copyWith({
    String? tontineId,
    LoadStatus? status,
    Tontine? tontine,
    List<Member>? members,
    Failure? failure,
    bool? isActing,
    Failure? actionFailure,
    bool clearActionFailure = false,
  }) => TontineDetailState(
    tontineId: tontineId ?? this.tontineId,
    status: status ?? this.status,
    tontine: tontine ?? this.tontine,
    members: members ?? this.members,
    failure: failure ?? this.failure,
    isActing: isActing ?? this.isActing,
    actionFailure: clearActionFailure
        ? null
        : actionFailure ?? this.actionFailure,
  );

  @override
  List<Object?> get props => [
    tontineId,
    status,
    tontine,
    members,
    failure,
    isActing,
    actionFailure,
  ];
}
