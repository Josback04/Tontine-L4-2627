import 'package:likelemba_app/core/theme/theme.dart';
import 'package:material_ui/material_ui.dart';

class LikelembaLogo extends StatelessWidget {
  const new({super.key, this.size = 72});

  final double size;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: scheme.primary,
        borderRadius: BorderRadius.circular(size * 0.3),
      ),
      alignment: Alignment.center,
      child: Icon(
        Icons.savings_rounded,
        size: size * 0.55,
        color: AppColors.gold,
      ),
    );
  }
}
