import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:likelemba_app/core/usecase/usecase.dart';
import 'package:likelemba_app/features/auth/domain/entities/user.dart';
import 'package:likelemba_app/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:likelemba_app/features/auth/domain/usecases/logout_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

/// L'état de la session, partagé par toute l'application.
///
/// Le routeur l'écoute : unauthenticated envoie vers /login,
/// authenticated vers l'accueil.
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  new({required this._getCurrentUser, required this._logout})
    : super(const AuthState.unknown()) {
    on<AuthStarted>(_onStarted);
    on<AuthUserAuthenticated>(_onUserAuthenticated);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthSessionExpired>(_onSessionExpired);
  }

  final GetCurrentUserUseCase _getCurrentUser;
  final LogoutUseCase _logout;

  Future<void> _onStarted(AuthStarted event, Emitter<AuthState> emit) async {
    try {
      final user = await _getCurrentUser(const NoParams());
      emit(
        user == null
            ? const AuthState.unauthenticated()
            : AuthState.authenticated(user),
      );
    } on Object {
      emit(const AuthState.unauthenticated());
    }
  }

  void _onUserAuthenticated(
    AuthUserAuthenticated event,
    Emitter<AuthState> emit,
  ) => emit(AuthState.authenticated(event.user));

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _logout(const NoParams());
    emit(const AuthState.unauthenticated());
  }

  // La source locale est déjà vidée par AuthInterceptor.
  void _onSessionExpired(AuthSessionExpired event, Emitter<AuthState> emit) =>
      emit(const AuthState.unauthenticated(sessionExpired: true));
}
