import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:likelemba_app/features/tontine/domain/entities/tontine.dart';
import 'package:likelemba_app/features/tontine/presentation/cubit/tontine_detail_cubit.dart';
import 'package:likelemba_app/features/tontine/presentation/pages/tontine_detail_page.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/helpers.dart';

class _MockTontineDetailCubit extends MockCubit<TontineDetailState>
    implements TontineDetailCubit;

void main() {
  late TontineDetailCubit cubit;

  setUp(() => cubit = _MockTontineDetailCubit());

  Future<void> pumpWith(WidgetTester tester, Tontine tontine) {
    when(() => cubit.state).thenReturn(
      TontineDetailState(
        tontineId: tontine.id,
        status: LoadStatus.success,
        tontine: tontine,
        members: const [tGrace, tJunior],
      ),
    );
    return tester.pumpApp(
      BlocProvider.value(value: cubit, child: const TontineDetailView()),
    );
  }

  group('l’écran suit MON rôle dans CETTE tontine', () {
    testWidgets('trésorière : bouton « Ajouter un membre »', (tester) async {
      await pumpWith(tester, tMarket);
      expect(find.byKey(const Key('addMemberButton')), findsOneWidget);
      expect(
        find.text(
          'You are a member of this group: only a treasurer can '
          'edit the list.',
        ),
        findsNothing,
      );
    });

    testWidgets('membre : lecture seule, avec explication', (tester) async {
      await pumpWith(tester, tTeachers);
      expect(find.byKey(const Key('addMemberButton')), findsNothing);
      expect(
        find.text(
          'You are a member of this group: only a treasurer can '
          'edit the list.',
        ),
        findsOneWidget,
      );
    });
  });

  testWidgets('un membre sans compte est signalé', (tester) async {
    await pumpWith(tester, tMarket);
    expect(find.textContaining('No account'), findsOneWidget);
  });
}
