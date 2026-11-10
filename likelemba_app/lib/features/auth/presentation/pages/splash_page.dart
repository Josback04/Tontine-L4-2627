import 'package:likelemba_app/core/l10n/l10n.dart';
import 'package:likelemba_app/core/theme/theme.dart';
import 'package:likelemba_app/core/widgets/widgets.dart';
import 'package:material_ui/material_ui.dart';

/// Affichée pendant la lecture de la session (AuthStatus.unknown).
class SplashPage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const LikelembaLogo(size: 88),
            const SizedBox(height: AppSpacing.lg),
            Text(context.l10n.splashLoading),
          ],
        ),
      ),
    );
  }
}
