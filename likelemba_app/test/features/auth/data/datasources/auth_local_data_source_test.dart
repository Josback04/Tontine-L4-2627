import 'package:flutter_test/flutter_test.dart';
import 'package:likelemba_app/core/errors/exceptions.dart';
import 'package:likelemba_app/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../helpers/helpers.dart';

void main() {
  late AuthLocalDataSourceImpl source;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    source = AuthLocalDataSourceImpl(await SharedPreferences.getInstance());
  });

  group(AuthLocalDataSourceImpl, () {
    test('vide au départ', () {
      expect(source.getToken(), isNull);
      expect(source.getCachedUser, throwsA(isA<CacheException>()));
    });

    test('saveSession puis lecture', () async {
      await source.saveSession(token: 'jeton', user: tUserModel);
      expect(source.getToken(), 'jeton');
      expect(source.getCachedUser(), tUserModel);
    });

    test('clearSession efface tout', () async {
      await source.saveSession(token: 'jeton', user: tUserModel);
      await source.clearSession();
      expect(source.getToken(), isNull);
      expect(source.getCachedUser, throwsA(isA<CacheException>()));
    });

    test('un cache illisible lève CacheException', () async {
      SharedPreferences.setMockInitialValues({'auth.user': 'pas du json'});
      source = AuthLocalDataSourceImpl(await SharedPreferences.getInstance());
      expect(source.getCachedUser, throwsA(isA<CacheException>()));
    });
  });
}
