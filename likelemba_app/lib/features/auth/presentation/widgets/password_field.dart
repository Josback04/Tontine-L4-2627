import 'package:likelemba_app/core/l10n/l10n.dart';
import 'package:material_ui/material_ui.dart';

/// Champ mot de passe avec bouton « afficher / masquer ».
class PasswordField extends StatefulWidget {
  const new({
    required this.controller,
    super.key,
    this.validator,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onSubmitted;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscured = true;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return TextFormField(
      key: const Key('passwordField'),
      controller: widget.controller,
      obscureText: _obscured,
      autofillHints: const [AutofillHints.password],
      textInputAction: TextInputAction.done,
      validator: widget.validator,
      onFieldSubmitted: widget.onSubmitted,
      decoration: InputDecoration(
        labelText: l10n.passwordLabel,
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          tooltip: _obscured ? l10n.showPassword : l10n.hidePassword,
          icon: Icon(_obscured ? Icons.visibility : Icons.visibility_off),
          onPressed: () => setState(() => _obscured = !_obscured),
        ),
      ),
    );
  }
}
