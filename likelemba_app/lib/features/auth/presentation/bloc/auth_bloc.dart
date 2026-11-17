import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:likelemba_app/core/errors/error_handler.dart';
import 'package:likelemba_app/core/utils/enum.dart';
import 'package:likelemba_app/features/auth/domain/entities/user.dart';
import 'package:likelemba_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:likelemba_app/features/auth/presentation/widgets/failure_message.dart';

export 'package:likelemba_app/core/utils/enum.dart';

part 'auth_bloc.g.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  new({required this._login}) : super(const AuthState()) {
    on<LoginEvent>(_onLoginEvent);
  }

  final LoginUseCase _login;

  FutureOr<void> _onLoginEvent(LoginEvent event, Emitter<AuthState> emit) =>
      errorHandler(() async {
        emit(
          state.copyWith(
            loginState: AuthenticationState.loading,

            message: null,
          ),
        );
        final user = await _login(
          LoginParams(email: event.email, password: event.password),
        );

        emit(
          state.copyWith(
            loginState: AuthenticationState.authenticated,
            user: user,
          ),
        );
      }).either(
        (left) => emit(
          state.copyWith(
            loginState: AuthenticationState.failed,
            message: left.message,
          ),
        ),

        (right) => null,
      );
}
