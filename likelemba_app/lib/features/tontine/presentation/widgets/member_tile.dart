import 'package:likelemba_app/core/l10n/l10n.dart';
import 'package:likelemba_app/features/tontine/domain/entities/member.dart';
import 'package:likelemba_app/features/tontine/presentation/widgets/role_badge.dart';
import 'package:material_ui/material_ui.dart';

class MemberTile extends StatelessWidget {
  const new({required this.member, super.key, this.onTap});

  final Member member;

  /// Null pour un simple membre : la ligne n'est pas cliquable.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor: scheme.primaryContainer,
        foregroundColor: scheme.onPrimaryContainer,
        child: Text(member.initials),
      ),
      title: Text(member.fullName),
      subtitle: Text(
        [
          l10n.payoutOrder(member.payoutOrder),
          member.phone,
          if (!member.hasAccount) l10n.noAccount,
        ].join(' · '),
      ),
      trailing: member.isTreasurer
          ? const RoleBadge(role: MemberRole.treasurer)
          : null,
    );
  }
}
