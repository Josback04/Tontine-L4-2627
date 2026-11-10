import 'package:material_ui/material_ui.dart';

/// Bouton principal : affiche un indicateur et se désactive pendant
/// le chargement, pour empêcher un double envoi du formulaire.
class PrimaryButton extends StatelessWidget {
  const new({
    required this.label,
    required this.onPressed,
    super.key,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: isLoading ? null : onPressed,
      child: isLoading
          ? const SizedBox.square(
              dimension: 22,
              child: CircularProgressIndicator(strokeWidth: 2.5),
            )
          : Text(label),
    );
  }
}
