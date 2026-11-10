import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:likelemba_app/core/l10n/l10n.dart';
import 'package:likelemba_app/core/theme/theme.dart';
import 'package:likelemba_app/core/widgets/widgets.dart';
import 'package:likelemba_app/features/auth/domain/entities/user.dart';
import 'package:likelemba_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:material_ui/material_ui.dart';

/// Accueil après connexion. Les tontines arriveront dans les leçons
/// suivantes (feature contribution).
class HomePage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final user = context.select<AuthBloc, User?>((bloc) => bloc.state.user);
    if (user == null) return const SizedBox.shrink();
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;

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
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: scheme.primaryContainer,
                foregroundColor: scheme.onPrimaryContainer,
                child: Text(user.initials),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.homeGreeting(user.firstName),
                      style: textTheme.titleLarge,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Chip(
                      label: Text(
                        user.role == UserRole.treasurer
                            ? l10n.roleTreasurer
                            : l10n.roleMember,
                      ),
                      backgroundColor: scheme.secondaryContainer,
                      labelStyle: TextStyle(color: scheme.onSecondaryContainer),
                      side: BorderSide.none,
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                children: [
                  Icon(
                    Icons.groups_2_outlined,
                    size: 48,
                    color: scheme.primary,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(l10n.homeEmptyTitle, style: textTheme.titleMedium),
                  const SizedBox(height: AppSpacing.sm),
                  Text(l10n.homeEmptyBody, textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
