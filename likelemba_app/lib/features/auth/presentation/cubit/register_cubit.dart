import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:likelemba_app/core/errors/failures.dart';
import 'package:likelemba_app/features/auth/domain/entities/user.dart';
import 'package:likelemba_app/features/auth/domain/usecases/register_usecase.dart';
import 'package:likelemba_app/features/auth/presentation/cubit/form_status.dart';

export 'form_status.dart';

part 'register_state.dart';

/// L'état du formulaire d'inscription (un cubit neuf par page).
class RegisterCubit extends Cubit<RegisterState> {
  new({required this._register}) : super(const RegisterState());

  final RegisterUseCase _register;

  Future<void> submit({
    required String fullName,
    required String email,
    required String phone,
    required String password,
  }) async {
    if (state.status == FormStatus.submitting) return;
    emit(const RegisterState(status: FormStatus.submitting));
    try {
      final user = await _register(
        RegisterParams(
          fullName: fullName,
          email: email,
          phone: phone,
          password: password,
        ),
      );
      emit(RegisterState(status: FormStatus.success, user: user));
    } on Failure catch (failure) {
      emit(RegisterState(status: FormStatus.failure, failure: failure));
    }
  }
}
