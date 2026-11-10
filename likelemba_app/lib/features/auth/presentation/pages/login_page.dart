import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:likelemba_app/core/di/injection_container.dart';
import 'package:likelemba_app/core/l10n/l10n.dart';
import 'package:likelemba_app/core/router/app_routes.dart';
import 'package:likelemba_app/core/theme/theme.dart';
import 'package:likelemba_app/core/utils/validators.dart';
import 'package:likelemba_app/core/widgets/widgets.dart';
import 'package:likelemba_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:likelemba_app/features/auth/presentation/cubit/login_cubit.dart';
import 'package:likelemba_app/features/auth/presentation/widgets/auth_layout.dart';
import 'package:likelemba_app/features/auth/presentation/widgets/failure_message.dart';
import 'package:likelemba_app/features/auth/presentation/widgets/password_field.dart';
import 'package:material_ui/material_ui.dart';

class LoginPage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    // Point d'injection côté interface : la page demande à get_it un cubit
    // tout prêt, sans connaître ni le cas d'usage ni le dépôt.
    return BlocProvider(
      create: (_) => sl<LoginCubit>(),
      child: const LoginView(),
    );
  }
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
    unawaited(
      context.read<LoginCubit>().submit(
        email: _email.text,
        password: _password.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.status == FormStatus.success) {
          // Le routeur écoute AuthBloc et ouvre l'accueil.
          context.read<AuthBloc>().add(AuthUserAuthenticated(state.user!));
        } else if (state.status == FormStatus.failure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(state.failure!.message(l10n))),
            );
        }
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
                BlocSelector<LoginCubit, LoginState, bool>(
                  selector: (state) => state.status == FormStatus.submitting,
                  builder: (context, isLoading) => PrimaryButton(
                    key: const Key('loginButton'),
                    label: l10n.loginButton,
                    isLoading: isLoading,
                    onPressed: _submit,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                // Wrap, pas Row : le lien passe à la ligne sur un petit écran.
                Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(l10n.noAccountPrompt),
                    TextButton(
                      onPressed: () => context.go(AppRoutes.register),
                      child: Text(l10n.createAccountLink),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
