import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:likelemba_app/app/app.dart';
import 'package:likelemba_app/core/di/injection_container.dart';
import 'package:likelemba_app/features/auth/presentation/cubit/login_cubit.dart';
import 'package:likelemba_app/features/auth/presentation/pages/login_page.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocktail/mocktail.dart';

class _MockLoginCubit extends MockCubit<LoginState> implements LoginCubit;

void main() {
  setUp(() {
    final loginCubit = _MockLoginCubit();
    when(() => loginCubit.state).thenReturn(const LoginState());
    // Dans les tests, on remplace l'injection réelle par des faux.
    sl.registerFactory<LoginCubit>(() => loginCubit);
  });

  tearDown(sl.reset);

  group(App, () {
    testWidgets("s'ouvre sur la page de connexion", (tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();
      expect(find.byType(LoginPage), findsOneWidget);
    });

    testWidgets('téléphone en français : connexion sans erreur', (
      tester,
    ) async {
      // Régression : avec les délégués de flutter_localizations, les champs
      // de texte plantaient (« No MaterialLocalizations found »).
      tester.platformDispatcher.localesTestValue = const [Locale('fr')];
      addTearDown(tester.platformDispatcher.clearLocalesTestValue);
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.text('Bon retour !'), findsOneWidget);
      expect(find.text('Mot de passe'), findsOneWidget);
    });
  });
}
