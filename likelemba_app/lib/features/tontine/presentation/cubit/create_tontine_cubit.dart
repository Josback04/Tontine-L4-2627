import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:likelemba_app/core/errors/failures.dart';
import 'package:likelemba_app/core/utils/statuses.dart';
import 'package:likelemba_app/features/tontine/domain/entities/tontine.dart';
import 'package:likelemba_app/features/tontine/domain/usecases/create_tontine_usecase.dart';

export 'package:likelemba_app/core/utils/statuses.dart';

part 'create_tontine_state.dart';

class CreateTontineCubit extends Cubit<CreateTontineState> {
  new({required this._createTontine}) : super(const CreateTontineState());

  final CreateTontineUseCase _createTontine;

  Future<void> submit({
    required String name,
    required int contributionAmount,
    required ContributionFrequency frequency,
    required DateTime startDate,
  }) async {
    if (state.status == FormStatus.submitting) return;
    emit(const CreateTontineState(status: FormStatus.submitting));
    try {
      final tontine = await _createTontine(
        CreateTontineParams(
          name: name,
          contributionAmount: contributionAmount,
          frequency: frequency,
          startDate: startDate,
        ),
      );
      emit(CreateTontineState(status: FormStatus.success, tontine: tontine));
    } on Failure catch (failure) {
      emit(CreateTontineState(status: FormStatus.failure, failure: failure));
    }
  }
}
