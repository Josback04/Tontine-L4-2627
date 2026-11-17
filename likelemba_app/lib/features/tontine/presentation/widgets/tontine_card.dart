import 'package:likelemba_app/core/l10n/l10n.dart';
import 'package:likelemba_app/core/theme/theme.dart';
import 'package:likelemba_app/core/utils/formatters.dart';
import 'package:likelemba_app/features/tontine/domain/entities/tontine.dart';
import 'package:likelemba_app/features/tontine/presentation/widgets/role_badge.dart';
import 'package:material_ui/material_ui.dart';

String frequencyLabel(ContributionFrequency frequency, AppLocalizations l10n) =>
    switch (frequency) {
      ContributionFrequency.weekly => l10n.frequencyWeekly,
      ContributionFrequency.monthly => l10n.frequencyMonthly,
    };

/// Une tontine dans la liste de l'accueil, avec MON rôle dedans.
class TontineCard extends StatelessWidget {
  const new({required this.tontine, required this.onTap, super.key});

  final Tontine tontine;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(tontine.name, style: textTheme.titleMedium),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  RoleBadge(role: tontine.myRole),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                [
                  l10n.perRound(Formatters.amount(tontine.contributionAmount)),
                  frequencyLabel(tontine.frequency, l10n),
                ].join(' · '),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(l10n.membersCount(tontine.memberCount)),
            ],
          ),
        ),
      ),
    );
  }
}
