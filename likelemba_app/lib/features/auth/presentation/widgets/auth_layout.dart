import 'package:likelemba_app/core/theme/theme.dart';
import 'package:likelemba_app/core/widgets/widgets.dart';
import 'package:material_ui/material_ui.dart';

/// Mise en page commune aux écrans de connexion et d'inscription.
class AuthLayout extends StatelessWidget {
  const new({
    required this.title,
    required this.subtitle,
    required this.child,
    super.key,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: LikelembaLogo(size: 56),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(title, style: textTheme.headlineMedium),
                  const SizedBox(height: AppSpacing.sm),
                  Text(subtitle, style: textTheme.bodyMedium),
                  const SizedBox(height: AppSpacing.xl),
                  child,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
