import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:likelemba_app/core/di/injection_container.dart';
import 'package:likelemba_app/core/l10n/l10n.dart';
import 'package:likelemba_app/core/router/app_routes.dart';
import 'package:likelemba_app/core/theme/theme.dart';
import 'package:likelemba_app/core/widgets/widgets.dart';
import 'package:likelemba_app/features/auth/domain/entities/user.dart';
import 'package:likelemba_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:likelemba_app/features/tontine/domain/entities/tontine.dart';
import 'package:likelemba_app/features/tontine/presentation/cubit/tontines_cubit.dart';
import 'package:likelemba_app/features/tontine/presentation/widgets/failure_message.dart';
import 'package:likelemba_app/features/tontine/presentation/widgets/tontine_card.dart';
import 'package:material_ui/material_ui.dart';

/// Accueil : mes tontines, chacune avec MON rôle.
class HomePage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = sl<TontinesCubit>();
        unawaited(cubit.load());
        return cubit;
      },
      child: const HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const new({super.key});

  Future<void> _openTontine(BuildContext context, String id) async {
    final cubit = context.read<TontinesCubit>();
    await context.push(AppRoutes.tontine(id));
    // Au retour : le nombre de membres a peut-être changé.
    await cubit.load();
  }

  Future<void> _create(BuildContext context) async {
    final cubit = context.read<TontinesCubit>();
    final created = await context.push<Tontine>(AppRoutes.newTontine);
    unawaited(cubit.load());
    if (created != null && context.mounted) {
      await _openTontine(context, created.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final user = context.select<AuthBloc, User?>((bloc) => bloc.state.user);
    if (user == null) return const SizedBox.shrink();

    return Scaffold(
      appBar: AppBar(
        title: const LikelembaLogo(size: 36),
        actions: [
          IconButton(
            key: const Key('logoutButton'),
            tooltip: l10n.logoutButton,
            icon: const Icon(Icons.logout),
            onPressed: () =>
                context.read<AuthBloc>().add(const AuthLogoutRequested()),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        key: const Key('createTontineFab'),
        onPressed: () => _create(context),
        icon: const Icon(Icons.add),
        label: Text(l10n.createTontineButton),
      ),
      body: BlocBuilder<TontinesCubit, TontinesState>(
        builder: (context, state) => RefreshIndicator(
          onRefresh: context.read<TontinesCubit>().load,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.md,
              AppSpacing.md,
              96,
            ),
            children: [
              _Greeting(user: user),
              const SizedBox(height: AppSpacing.lg),
              Text(
                l10n.myTontinesTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
              ..._body(context, state),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _body(BuildContext context, TontinesState state) {
    final l10n = context.l10n;
    if (state.tontines.isEmpty) {
      return switch (state.status) {
        LoadStatus.loading => const [
          Padding(
            padding: EdgeInsets.all(AppSpacing.xl),
            child: Center(child: CircularProgressIndicator()),
          ),
        ],
        LoadStatus.failure => [
          Text(state.failure!.message(l10n)),
          const SizedBox(height: AppSpacing.sm),
          Align(
            alignment: Alignment.centerLeft,
            child: OutlinedButton(
              onPressed: context.read<TontinesCubit>().load,
              child: Text(l10n.retryButton),
            ),
          ),
        ],
        LoadStatus.success => [const _EmptyState()],
      };
    }
    return [
      for (final tontine in state.tontines) ...[
        TontineCard(
          tontine: tontine,
          onTap: () => _openTontine(context, tontine.id),
        ),
        const SizedBox(height: AppSpacing.sm),
      ],
    ];
  }
}

class _Greeting extends StatelessWidget {
  const new({required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: scheme.primaryContainer,
          foregroundColor: scheme.onPrimaryContainer,
          child: Text(user.initials),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Text(
            context.l10n.homeGreeting(user.firstName),
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            Icon(
              Icons.groups_2_outlined,
              size: 48,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(l10n.homeEmptyTitle, style: textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            Text(l10n.tontinesEmptyBody, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
