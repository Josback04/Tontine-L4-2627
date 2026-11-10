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
import 'package:likelemba_app/features/auth/presentation/cubit/register_cubit.dart';
import 'package:likelemba_app/features/auth/presentation/widgets/auth_layout.dart';
import 'package:likelemba_app/features/auth/presentation/widgets/failure_message.dart';
import 'package:likelemba_app/features/auth/presentation/widgets/password_field.dart';
import 'package:material_ui/material_ui.dart';

class RegisterPage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<RegisterCubit>(),
      child: const RegisterView(),
    );
  }
}

class RegisterView extends StatefulWidget {
  const new({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final _fullName = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _fullName.dispose();
    _email.dispose();
    _phone.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    unawaited(
      context.read<RegisterCubit>().submit(
        fullName: _fullName.text,
        email: _email.text,
        phone: _phone.text,
        password: _password.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocListener<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state.status == FormStatus.success) {
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
        title: l10n.registerTitle,
        subtitle: l10n.registerSubtitle,
        child: Form(
          key: _formKey,
          child: AutofillGroup(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _fullName,
                  textCapitalization: TextCapitalization.words,
                  autofillHints: const [AutofillHints.name],
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: l10n.fullNameLabel,
                    prefixIcon: const Icon(Icons.person_outline),
                  ),
                  validator: (value) => Validators.isFullName(value)
                      ? null
                      : l10n.invalidFullName,
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
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
                TextFormField(
                  controller: _phone,
                  keyboardType: TextInputType.phone,
                  autofillHints: const [AutofillHints.telephoneNumber],
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: l10n.phoneLabel,
                    hintText: l10n.phoneHint,
                    prefixIcon: const Icon(Icons.phone_outlined),
                  ),
                  validator: (value) =>
                      Validators.isPhone(value) ? null : l10n.invalidPhone,
                ),
                const SizedBox(height: AppSpacing.md),
                PasswordField(
                  controller: _password,
                  onSubmitted: (_) => _submit(),
                  validator: (value) => Validators.isPassword(value)
                      ? null
                      : l10n.invalidPassword(Validators.minPasswordLength),
                ),
                const SizedBox(height: AppSpacing.lg),
                BlocSelector<RegisterCubit, RegisterState, bool>(
                  selector: (state) => state.status == FormStatus.submitting,
                  builder: (context, isLoading) => PrimaryButton(
                    label: l10n.registerButton,
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
                    Text(l10n.haveAccountPrompt),
                    TextButton(
                      onPressed: () => context.go(AppRoutes.login),
                      child: Text(l10n.loginLink),
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
