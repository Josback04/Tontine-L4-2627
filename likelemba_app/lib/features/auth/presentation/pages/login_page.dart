import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:likelemba_app/core/l10n/l10n.dart';
import 'package:likelemba_app/core/theme/theme.dart';
import 'package:likelemba_app/core/utils/validators.dart';
import 'package:likelemba_app/core/widgets/widgets.dart';
import 'package:likelemba_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:likelemba_app/features/auth/presentation/widgets/auth_layout.dart';
import 'package:likelemba_app/features/auth/presentation/widgets/password_field.dart';
import 'package:material_ui/material_ui.dart';

/// Une page = une route. L'AuthBloc est fourni plus haut, par App :
/// la page le lit, elle ne le crée pas.
class LoginPage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) => const LoginView();
}

class LoginView extends StatefulWidget {
  const new({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    // L'interface ne fait qu'ANNONCER une action : elle ajoute un Event.
    context.read<AuthBloc>().add(
      LoginEvent(email: _email.text, password: _password.text),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    // BlocListener : réagit une fois (SnackBar, navigation…),
    // sans reconstruire l'écran.
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) =>
          previous.loginState != current.loginState,
      listener: (context, state) {
        final message = switch (state.loginState) {
          AuthenticationState.authenticated => l10n.welcomeMessage(
            state.user!.firstName,
          ),
          AuthenticationState.failed => state.message,
          _ => null,
        };
        if (message == null) return;
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(message)));
      },
      child: AuthLayout(
        title: l10n.loginTitle,
        subtitle: l10n.loginSubtitle,
        child: Form(
          key: _formKey,
          child: AutofillGroup(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  key: const Key('emailField'),
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  autofillHints: const [AutofillHints.email],
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: l10n.emailLabel,
                    prefixIcon: const Icon(Icons.alternate_email),
                  ),
                  validator: (value) =>
                      Validators.isEmail(value) ? null : l10n.invalidEmail,
                ),
                const SizedBox(height: AppSpacing.md),
                PasswordField(
                  controller: _password,
                  onSubmitted: (_) => _submit(),
                  validator: (value) =>
                      (value ?? '').isEmpty ? l10n.invalidPassword(1) : null,
                ),
                const SizedBox(height: AppSpacing.lg),
                // BlocSelector : ne reconstruit que le bouton, et seulement
                // quand « en chargement » change.
                BlocSelector<AuthBloc, AuthState, bool>(
                  selector: (state) => state.loginState.isInProgress,
                  builder: (context, isLoading) => PrimaryButton(
                    key: const Key('loginButton'),
                    label: l10n.loginButton,
                    isLoading: isLoading,
                    onPressed: _submit,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
