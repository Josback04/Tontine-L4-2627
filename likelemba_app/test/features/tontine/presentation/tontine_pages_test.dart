import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:likelemba_app/features/tontine/domain/entities/tontine.dart';
import 'package:likelemba_app/features/tontine/presentation/cubit/create_tontine_cubit.dart';
import 'package:likelemba_app/features/tontine/presentation/cubit/tontine_detail_cubit.dart';
import 'package:likelemba_app/features/tontine/presentation/pages/create_tontine_page.dart';
import 'package:likelemba_app/features/tontine/presentation/pages/tontine_detail_page.dart';
import 'package:likelemba_app/features/tontine/presentation/widgets/tontine_card.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/helpers.dart';

class _MockCreateTontineCubit extends MockCubit<CreateTontineState>
    implements CreateTontineCubit;

class _MockTontineDetailCubit extends MockCubit<TontineDetailState>
    implements TontineDetailCubit;

void main() {
  setUpAll(() => registerFallbackValue(ContributionFrequency.monthly));

  group(CreateTontineView, () {
    late CreateTontineCubit cubit;

    setUp(() {
      cubit = _MockCreateTontineCubit();
      when(() => cubit.state).thenReturn(const CreateTontineState());
      when(
        () => cubit.submit(
          name: any(named: 'name'),
          contributionAmount: any(named: 'contributionAmount'),
          frequency: any(named: 'frequency'),
          startDate: any(named: 'startDate'),
        ),
      ).thenAnswer((_) async {});
    });

    Future<void> pump(WidgetTester tester) => tester.pumpApp(
      BlocProvider.value(value: cubit, child: const CreateTontineView()),
    );

    testWidgets('refuse un montant nul', (tester) async {
      await pump(tester);
      await tester.enterText(
        find.byKey(const Key('tontineNameField')),
        'Famille Mbuyi',
      );
      await tester.enterText(find.byKey(const Key('tontineAmountField')), '0');
      await tester.tap(find.byKey(const Key('createTontineButton')));
      await tester.pump();
      expect(find.text('Enter an amount greater than 0.'), findsOneWidget);
    });

    testWidgets('envoie la fréquence choisie', (tester) async {
      await pump(tester);
      await tester.enterText(
        find.byKey(const Key('tontineNameField')),
        'Famille Mbuyi',
      );
      await tester.enterText(
        find.byKey(const Key('tontineAmountField')),
        '5000',
      );
      await tester.tap(find.text('Weekly'));
      await tester.pump();
      await tester.tap(find.byKey(const Key('createTontineButton')));
      verify(
        () => cubit.submit(
          name: 'Famille Mbuyi',
          contributionAmount: 5000,
          frequency: ContributionFrequency.weekly,
          startDate: any(named: 'startDate'),
        ),
      ).called(1);
    });
  });

  group('ajout d’un membre', () {
    testWidgets('le formulaire transmet nom et téléphone au cubit', (
      tester,
    ) async {
      final cubit = _MockTontineDetailCubit();
      when(() => cubit.state).thenReturn(
        TontineDetailState(
          tontineId: 'tnt-001',
          status: LoadStatus.success,
          tontine: tMarket,
          members: const [tGrace],
        ),
      );
      when(
        () => cubit.addMember(
          fullName: any(named: 'fullName'),
          phone: any(named: 'phone'),
        ),
      ).thenAnswer((_) async {});
      await tester.pumpApp(
        BlocProvider<TontineDetailCubit>.value(
          value: cubit,
          child: const TontineDetailView(),
        ),
      );

      await tester.tap(find.byKey(const Key('addMemberButton')));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const Key('memberNameField')),
        'Junior Bokele',
      );
      await tester.enterText(
        find.byKey(const Key('memberPhoneField')),
        '0834567890',
      );
      await tester.tap(find.byKey(const Key('memberSubmitButton')));
      await tester.pumpAndSettle();

      verify(
        () => cubit.addMember(fullName: 'Junior Bokele', phone: '0834567890'),
      ).called(1);
    });
  });

  testWidgets('TontineCard affiche mon rôle et la cotisation', (tester) async {
    var tapped = false;
    await tester.pumpApp(
      TontineCard(tontine: tTeachers, onTap: () => tapped = true),
    );
    expect(find.text('Member'), findsOneWidget);
    expect(find.textContaining('10 000 FC per round'), findsOneWidget);
    await tester.tap(find.byType(TontineCard));
    expect(tapped, isTrue);
  });
}
