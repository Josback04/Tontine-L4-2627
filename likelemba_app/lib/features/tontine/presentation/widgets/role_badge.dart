import 'package:likelemba_app/core/l10n/l10n.dart';
import 'package:likelemba_app/core/theme/theme.dart';
import 'package:likelemba_app/features/tontine/domain/entities/member.dart';
import 'package:material_ui/material_ui.dart';

String roleLabel(MemberRole role, AppLocalizations l10n) => switch (role) {
  MemberRole.treasurer => l10n.roleTreasurer,
  MemberRole.member => l10n.roleMember,
};

/// Pastille « Trésorier » (or) ou « Membre » (neutre).
class RoleBadge extends StatelessWidget {
  const new({required this.role, super.key});

  final MemberRole role;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isTreasurer = role == MemberRole.treasurer;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: isTreasurer ? scheme.secondaryContainer : scheme.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radius),
        border: isTreasurer ? null : Border.all(color: scheme.outline),
      ),
      child: Text(
        roleLabel(role, context.l10n),
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: isTreasurer
              ? scheme.onSecondaryContainer
              : scheme.onSurfaceVariant,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
