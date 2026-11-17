import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:likelemba_app/core/errors/failures.dart';
import 'package:likelemba_app/core/usecase/usecase.dart';
import 'package:likelemba_app/core/utils/statuses.dart';
import 'package:likelemba_app/features/tontine/domain/entities/tontine.dart';
import 'package:likelemba_app/features/tontine/domain/usecases/get_my_tontines_usecase.dart';

export 'package:likelemba_app/core/utils/statuses.dart';

part 'tontines_state.dart';

/// La liste de mes tontines (écran d'accueil).
class TontinesCubit extends Cubit<TontinesState> {
  new({required this._getMyTontines}) : super(const TontinesState());

  final GetMyTontinesUseCase _getMyTontines;

  Future<void> load() async {
    // On garde la liste affichée pendant un rafraîchissement.
    emit(TontinesState(tontines: state.tontines));
    try {
      final tontines = await _getMyTontines(const NoParams());
      emit(TontinesState(status: LoadStatus.success, tontines: tontines));
    } on Failure catch (failure) {
      emit(
        TontinesState(
          status: LoadStatus.failure,
          tontines: state.tontines,
          failure: failure,
        ),
      );
    }
  }
}
