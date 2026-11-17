import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:likelemba_app/core/errors/failures.dart';
import 'package:likelemba_app/core/utils/statuses.dart';
import 'package:likelemba_app/features/tontine/domain/entities/member.dart';
import 'package:likelemba_app/features/tontine/domain/entities/tontine.dart';
import 'package:likelemba_app/features/tontine/domain/usecases/add_member_usecase.dart';
import 'package:likelemba_app/features/tontine/domain/usecases/get_members_usecase.dart';
import 'package:likelemba_app/features/tontine/domain/usecases/get_tontine_usecase.dart';
import 'package:likelemba_app/features/tontine/domain/usecases/remove_member_usecase.dart';
import 'package:likelemba_app/features/tontine/domain/usecases/update_member_usecase.dart';

export 'package:likelemba_app/core/utils/statuses.dart';

part 'tontine_detail_state.dart';

/// Une tontine et ses membres. Les actions (ajouter, modifier, retirer)
/// ne sont proposées par l'écran que si `tontine.canManage` ; l'API les
/// refuse de toute façon (403) à un simple membre.
class TontineDetailCubit extends Cubit<TontineDetailState> {
  new({
    required this._getTontine,
    required this._getMembers,
    required this._addMember,
    required this._updateMember,
    required this._removeMember,
  }) : super(const TontineDetailState());

  final GetTontineUseCase _getTontine;
  final GetMembersUseCase _getMembers;
  final AddMemberUseCase _addMember;
  final UpdateMemberUseCase _updateMember;
  final RemoveMemberUseCase _removeMember;

  Future<void> load(String tontineId) async {
    emit(state.copyWith(status: LoadStatus.loading, tontineId: tontineId));
    try {
      final (tontine, members) = await _fetch();
      emit(
        state.copyWith(
          status: LoadStatus.success,
          tontine: tontine,
          members: members,
        ),
      );
    } on Failure catch (failure) {
      emit(state.copyWith(status: LoadStatus.failure, failure: failure));
    }
  }

  Future<void> addMember({required String fullName, required String phone}) =>
      _act(
        () => _addMember(
          AddMemberParams(
            tontineId: state.tontineId,
            fullName: fullName,
            phone: phone,
          ),
        ),
      );

  Future<void> updateMember(
    Member member, {
    String? fullName,
    String? phone,
    MemberRole? role,
  }) => _act(
    () => _updateMember(
      UpdateMemberParams(
        tontineId: state.tontineId,
        memberId: member.id,
        fullName: fullName,
        phone: phone,
        role: role,
      ),
    ),
  );

  Future<void> removeMember(Member member) => _act(
    () => _removeMember(
      RemoveMemberParams(tontineId: state.tontineId, memberId: member.id),
    ),
  );

  /// Exécute une action puis recharge la tontine (nombre de membres,
  /// cagnotte) et la liste. Un échec n'efface pas l'écran : il est rangé
  /// dans actionFailure, que la page affiche dans un SnackBar.
  Future<void> _act(Future<Object?> Function() action) async {
    emit(state.copyWith(isActing: true, clearActionFailure: true));
    try {
      await action();
      final (tontine, members) = await _fetch();
      emit(state.copyWith(isActing: false, tontine: tontine, members: members));
    } on Failure catch (failure) {
      emit(state.copyWith(isActing: false, actionFailure: failure));
    }
  }

  Future<(Tontine, List<Member>)> _fetch() async {
    final tontine = await _getTontine(state.tontineId);
    final members = await _getMembers(state.tontineId);
    return (tontine, members);
  }
}
