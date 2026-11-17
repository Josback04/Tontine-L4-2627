import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:likelemba_app/core/di/injection_container.dart';
import 'package:likelemba_app/core/l10n/l10n.dart';
import 'package:likelemba_app/core/theme/theme.dart';
import 'package:likelemba_app/core/utils/formatters.dart';
import 'package:likelemba_app/features/tontine/domain/entities/member.dart';
import 'package:likelemba_app/features/tontine/domain/entities/tontine.dart';
import 'package:likelemba_app/features/tontine/presentation/cubit/tontine_detail_cubit.dart';
import 'package:likelemba_app/features/tontine/presentation/widgets/failure_message.dart';
import 'package:likelemba_app/features/tontine/presentation/widgets/member_form_sheet.dart';
import 'package:likelemba_app/features/tontine/presentation/widgets/member_tile.dart';
import 'package:likelemba_app/features/tontine/presentation/widgets/role_badge.dart';
import 'package:likelemba_app/features/tontine/presentation/widgets/tontine_card.dart';
import 'package:material_ui/material_ui.dart';

class TontineDetailPage extends StatelessWidget {
  const new({required this.tontineId, super.key});

  final String tontineId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = sl<TontineDetailCubit>();
        unawaited(cubit.load(tontineId));
        return cubit;
      },
      child: const TontineDetailView(),
    );
  }
}

class TontineDetailView extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocConsumer<TontineDetailCubit, TontineDetailState>(
      listenWhen: (previous, current) =>
          current.actionFailure != null &&
          previous.actionFailure != current.actionFailure,
      listener: (context, state) => ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text(state.actionFailure!.message(l10n))),
        ),
      builder: (context, state) {
        final tontine = state.tontine;
        return Scaffold(
          appBar: AppBar(
            title: Text(tontine?.name ?? ''),
            bottom: state.isActing
                ? const PreferredSize(
                    preferredSize: Size.fromHeight(2),
                    child: LinearProgressIndicator(minHeight: 2),
                  )
                : null,
          ),
          // Le bouton n'existe que pour un trésorier de CETTE tontine.
          floatingActionButton: tontine != null && tontine.canManage
              ? FloatingActionButton.extended(
                  key: const Key('addMemberButton'),
                  onPressed: state.isActing ? null : () => _add(context),
                  icon: const Icon(Icons.person_add_alt_1),
                  label: Text(l10n.addMemberButton),
                )
              : null,
          body: switch (state.status) {
            LoadStatus.loading => const Center(
              child: CircularProgressIndicator(),
            ),
            LoadStatus.failure => _LoadError(state: state),
            LoadStatus.success => _Content(
              tontine: tontine!,
              members: state.members,
            ),
          },
        );
      },
    );
  }

  Future<void> _add(BuildContext context) async {
    final cubit = context.read<TontineDetailCubit>();
    final result = await showMemberFormSheet(context);
    if (result == null) return;
    await cubit.addMember(fullName: result.fullName, phone: result.phone);
  }
}

class _Content extends StatelessWidget {
  const new({required this.tontine, required this.members});

  final Tontine tontine;
  final List<Member> members;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return RefreshIndicator(
      onRefresh: () => context.read<TontineDetailCubit>().load(tontine.id),
      child: ListView(
        padding: const EdgeInsets.only(bottom: 96),
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: _Summary(tontine: tontine),
          ),
          if (!tontine.canManage)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: _ReadOnlyNotice(text: l10n.memberReadOnlyNotice),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.lg,
              AppSpacing.md,
              AppSpacing.xs,
            ),
            child: Text(
              '${l10n.membersTitle} (${members.length})',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          for (final member in members)
            MemberTile(
              member: member,
              onTap: tontine.canManage
                  ? () => _showActions(context, member)
                  : null,
            ),
        ],
      ),
    );
  }

  Future<void> _showActions(BuildContext context, Member member) async {
    final l10n = context.l10n;
    final cubit = context.read<TontineDetailCubit>();
    final action = await showModalBottomSheet<_MemberAction>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(
                member.fullName,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: Text(l10n.editMemberAction),
              onTap: () => Navigator.pop(context, _MemberAction.edit),
            ),
            ListTile(
              leading: const Icon(Icons.admin_panel_settings_outlined),
              title: Text(
                member.isTreasurer
                    ? l10n.removeTreasurerAction
                    : l10n.makeTreasurerAction,
              ),
              onTap: () => Navigator.pop(context, _MemberAction.toggleRole),
            ),
            ListTile(
              leading: Icon(
                Icons.person_remove_outlined,
                color: Theme.of(context).colorScheme.error,
              ),
              title: Text(l10n.removeMemberAction),
              onTap: () => Navigator.pop(context, _MemberAction.remove),
            ),
          ],
        ),
      ),
    );
    if (action == null || !context.mounted) return;

    switch (action) {
      case _MemberAction.edit:
        final result = await showMemberFormSheet(context, initial: member);
        if (result == null) return;
        await cubit.updateMember(
          member,
          fullName: result.fullName,
          phone: result.phone,
        );
      case _MemberAction.toggleRole:
        await cubit.updateMember(
          member,
          role: member.isTreasurer ? MemberRole.member : MemberRole.treasurer,
        );
      case _MemberAction.remove:
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            content: Text(l10n.removeMemberConfirm(member.fullName)),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(l10n.cancelButton),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(l10n.removeButton),
              ),
            ],
          ),
        );
        if (confirmed ?? false) await cubit.removeMember(member);
    }
  }
}

enum _MemberAction { edit, toggleRole, remove }

/// En-tête : cotisation, cagnotte, début, et MON rôle dans cette tontine.
class _Summary extends StatelessWidget {
  const new({required this.tontine});

  final Tontine tontine;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;

    Widget fact(String label, String value) => Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: textTheme.bodySmall),
          const SizedBox(height: AppSpacing.xs),
          Text(value, style: textTheme.titleSmall),
        ],
      ),
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.myRoleLabel,
                    style: textTheme.bodyMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ),
                RoleBadge(role: tontine.myRole),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                fact(
                  l10n.contributionLabel,
                  Formatters.amount(tontine.contributionAmount),
                ),
                fact(
                  l10n.frequencyLabel,
                  frequencyLabel(tontine.frequency, l10n),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                fact(l10n.potLabel, Formatters.amount(tontine.potAmount)),
                fact(l10n.startDateLabel, Formatters.date(tontine.startDate)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ReadOnlyNotice extends StatelessWidget {
  const new({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: scheme.primaryContainer,
        borderRadius: BorderRadius.circular(AppSpacing.radius),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: scheme.onPrimaryContainer),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: scheme.onPrimaryContainer),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadError extends StatelessWidget {
  const new({required this.state});

  final TontineDetailState state;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(state.failure!.message(l10n), textAlign: TextAlign.center),
            const SizedBox(height: AppSpacing.md),
            OutlinedButton(
              onPressed: () => unawaited(
                context.read<TontineDetailCubit>().load(state.tontineId),
              ),
              child: Text(l10n.retryButton),
            ),
          ],
        ),
      ),
    );
  }
}
