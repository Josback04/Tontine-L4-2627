import 'package:likelemba_app/core/l10n/l10n.dart';
import 'package:likelemba_app/core/theme/theme.dart';
import 'package:likelemba_app/core/utils/validators.dart';
import 'package:likelemba_app/features/tontine/domain/entities/member.dart';
import 'package:material_ui/material_ui.dart';

/// Ce que le formulaire renvoie.
typedef MemberFormResult = ({String fullName, String phone});

/// Ouvre le formulaire d'ajout ([initial] null) ou de modification.
Future<MemberFormResult?> showMemberFormSheet(
  BuildContext context, {
  Member? initial,
}) => showModalBottomSheet<MemberFormResult>(
  context: context,
  isScrollControlled: true,
  showDragHandle: true,
  builder: (_) => MemberFormSheet(initial: initial),
);

class MemberFormSheet extends StatefulWidget {
  const new({super.key, this.initial});

  final Member? initial;

  @override
  State<MemberFormSheet> createState() => _MemberFormSheetState();
}

class _MemberFormSheetState extends State<MemberFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final _fullName = TextEditingController(text: widget.initial?.fullName);
  late final _phone = TextEditingController(text: widget.initial?.phone);

  @override
  void dispose() {
    _fullName.dispose();
    _phone.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).pop((fullName: _fullName.text, phone: _phone.text));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg,
        0,
        AppSpacing.lg,
        AppSpacing.lg + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.initial == null
                  ? l10n.addMemberTitle
                  : l10n.editMemberTitle,
              style: textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(l10n.memberFormHint, style: textTheme.bodyMedium),
            const SizedBox(height: AppSpacing.lg),
            TextFormField(
              key: const Key('memberNameField'),
              controller: _fullName,
              autofocus: true,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: l10n.fullNameLabel,
                prefixIcon: const Icon(Icons.person_outline),
              ),
              validator: (value) =>
                  Validators.isFullName(value) ? null : l10n.invalidFullName,
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              key: const Key('memberPhoneField'),
              controller: _phone,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _submit(),
              decoration: InputDecoration(
                labelText: l10n.phoneLabel,
                hintText: l10n.phoneHint,
                prefixIcon: const Icon(Icons.phone_outlined),
              ),
              validator: (value) =>
                  Validators.isPhone(value) ? null : l10n.invalidPhone,
            ),
            const SizedBox(height: AppSpacing.lg),
            FilledButton(
              key: const Key('memberSubmitButton'),
              onPressed: _submit,
              child: Text(
                widget.initial == null ? l10n.addMemberButton : l10n.saveButton,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
