import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:likelemba_app/core/errors/failures.dart';
import 'package:likelemba_app/features/auth/domain/entities/user.dart';
import 'package:likelemba_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:likelemba_app/features/auth/presentation/cubit/form_status.dart';

export 'form_status.dart';

part 'login_state.dart';

/// L'état du formulaire de connexion (un cubit neuf par page).
class LoginCubit extends Cubit<LoginState> {
  new({required this._login}) : super(const LoginState());

  final LoginUseCase _login;

  Future<void> submit({required String email, required String password}) async {
    if (state.status == FormStatus.submitting) return;
    emit(const LoginState(status: FormStatus.submitting));
    try {
      final user = await _login(LoginParams(email: email, password: password));
      emit(LoginState(status: FormStatus.success, user: user));
    } on Failure catch (failure) {
      emit(LoginState(status: FormStatus.failure, failure: failure));
    }
  }
}
