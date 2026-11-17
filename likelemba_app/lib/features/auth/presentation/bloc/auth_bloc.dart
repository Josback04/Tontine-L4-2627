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

// Le fichier maître : il déclare les `part`. Les quatre fichiers forment
// une seule bibliothèque Dart.
part 'auth_bloc.g.dart';
part 'auth_event.dart';
part 'auth_state.dart';

/// Reçoit un Event, appelle un UseCase (métier), émet un nouveau State.
///
/// Le BLoC ne connaît que le cas d'usage : ni le dépôt, ni l'API.
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  new({required this._login}) : super(const AuthState()) {
    on<LoginEvent>(_onLoginEvent);
  }

  final LoginUseCase _login;

  FutureOr<void> _onLoginEvent(LoginEvent event, Emitter<AuthState> emit) =>
      errorHandler(() async {
        // 1. On passe en chargement (et on efface l'ancien message).
        emit(
          state.copyWith(
            loginState: AuthenticationState.loading,
            // null EFFACE le message : possible grâce au copyWith généré
            // (un copyWith écrit à la main, `message ?? this.message`,
            // garderait l'ancien). Le lint croit à tort que null est inutile.
            // ignore: avoid_redundant_argument_values
            message: null,
          ),
        );

        // 2. On appelle le cas d'usage (il peut lever une Failure).
        final user = await _login(
          LoginParams(email: event.email, password: event.password),
        );

        // 3. Succès : on émet le nouvel état avec les données.
        emit(
          state.copyWith(
            loginState: AuthenticationState.authenticated,
            user: user,
          ),
        );
      }).either(
        // 4. Échec (Left) : errorHandler a converti l'erreur en Failure,
        //    `left.message` est déjà traduit.
        (left) => emit(
          state.copyWith(
            loginState: AuthenticationState.failed,
            message: left.message,
          ),
        ),
        // 5. Succès (Right) : rien de plus, l'emit a déjà eu lieu.
        (right) => null,
      );
}
