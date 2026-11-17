import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:likelemba_app/core/di/injection_container.dart';
import 'package:likelemba_app/core/l10n/l10n.dart';
import 'package:likelemba_app/core/theme/theme.dart';
import 'package:likelemba_app/core/utils/formatters.dart';
import 'package:likelemba_app/core/widgets/widgets.dart';
import 'package:likelemba_app/features/tontine/domain/entities/tontine.dart';
import 'package:likelemba_app/features/tontine/presentation/cubit/create_tontine_cubit.dart';
import 'package:likelemba_app/features/tontine/presentation/widgets/failure_message.dart';
import 'package:likelemba_app/features/tontine/presentation/widgets/tontine_card.dart';
import 'package:material_ui/material_ui.dart';

/// Créer une tontine. En cas de succès, la page se ferme en renvoyant la
/// tontine créée (`context.pop(tontine)`).
class CreateTontinePage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CreateTontineCubit>(),
      child: const CreateTontineView(),
    );
  }
}

class CreateTontineView extends StatefulWidget {
  const new({super.key});

  @override
  State<CreateTontineView> createState() => _CreateTontineViewState();
}

class _CreateTontineViewState extends State<CreateTontineView> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _amount = TextEditingController();
  ContributionFrequency _frequency = ContributionFrequency.monthly;
  DateTime _startDate = DateUtils.dateOnly(DateTime.now());

  @override
  void dispose() {
    _name.dispose();
    _amount.dispose();
    super.dispose();
  }

  Future<void> _pickStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _startDate = picked);
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    unawaited(
      context.read<CreateTontineCubit>().submit(
        name: _name.text,
        contributionAmount: int.parse(_amount.text.replaceAll(' ', '')),
        frequency: _frequency,
        startDate: _startDate,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocListener<CreateTontineCubit, CreateTontineState>(
      listener: (context, state) {
        if (state.status == FormStatus.success) {
          context.pop(state.tontine);
        } else if (state.status == FormStatus.failure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(state.failure!.message(l10n))),
            );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.createTontineTitle)),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(l10n.createTontineHint),
                  const SizedBox(height: AppSpacing.lg),
                  TextFormField(
                    key: const Key('tontineNameField'),
                    controller: _name,
                    textCapitalization: TextCapitalization.sentences,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: l10n.tontineNameLabel,
                      prefixIcon: const Icon(Icons.groups_2_outlined),
                    ),
                    validator: (value) => (value ?? '').trim().length < 3
                        ? l10n.invalidTontineName
                        : null,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextFormField(
                    key: const Key('tontineAmountField'),
                    controller: _amount,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: l10n.contributionAmountLabel,
                      prefixIcon: const Icon(Icons.payments_outlined),
                    ),
                    validator: (value) {
                      final amount = int.tryParse(
                        (value ?? '').replaceAll(' ', ''),
                      );
                      return amount == null || amount <= 0
                          ? l10n.invalidAmount
                          : null;
                    },
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    l10n.frequencyLabel,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  SegmentedButton<ContributionFrequency>(
                    segments: [
                      for (final frequency in ContributionFrequency.values)
                        ButtonSegment(
                          value: frequency,
                          label: Text(frequencyLabel(frequency, l10n)),
                        ),
                    ],
                    selected: {_frequency},
                    onSelectionChanged: (selection) =>
                        setState(() => _frequency = selection.single),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  OutlinedButton.icon(
                    onPressed: _pickStartDate,
                    icon: const Icon(Icons.event_outlined),
                    label: Text(
                      '${l10n.startDateField} : '
                      '${Formatters.date(_startDate)}',
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  BlocSelector<CreateTontineCubit, CreateTontineState, bool>(
                    selector: (state) => state.status == FormStatus.submitting,
                    builder: (context, isLoading) => PrimaryButton(
                      key: const Key('createTontineButton'),
                      label: l10n.createTontineSubmit,
                      isLoading: isLoading,
                      onPressed: _submit,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
