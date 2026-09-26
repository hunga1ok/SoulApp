import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:soul_app/app/app_state.dart';
import 'package:soul_app/data/local/image_store.dart';
import 'package:soul_app/data/repositories/vision_repository.dart';

import '../helpers/soul_test_harness.dart';

NewVision _vision(String id, {List<String> feelings = const ['CALM']}) =>
    NewVision(
      id: id,
      categoryCode: 'PEACE',
      statement: '  I make space for quiet mornings.  ',
      feelingCodes: feelings,
      answers: {
        'CAT09_Q01': (valueCodes: ['SLOW_MORNINGS'], customText: ' tea '),
      },
      locale: SoulLocale.en,
    );

void main() {
  test('creating is idempotent and keeps feeling order', () async {
    final database = testDatabase();
    final repository = VisionRepository(database);

    await repository.create(_vision('v1', feelings: ['SAFE', 'CALM', 'FREE']));
    await repository.create(_vision('v1', feelings: ['SAFE', 'CALM', 'FREE']));

    final visions = await repository.active();
    expect(visions, hasLength(1));
    expect(visions.single.statement, 'I make space for quiet mornings.');
    expect(visions.single.feelingCodes, ['SAFE', 'CALM', 'FREE']);
    final answer = (await database.select(database.visionAnswers).get()).single;
    expect(answer.valueCodes, '["SLOW_MORNINGS"]');
    expect(answer.customText, 'tea');
  });

  test('a Vision needs one to three feelings', () async {
    final repository = VisionRepository(testDatabase());

    expect(
      () => repository.create(_vision('none', feelings: const [])),
      throwsArgumentError,
    );
    expect(
      () => repository.create(
        _vision('four', feelings: const ['A', 'B', 'C', 'D']),
      ),
      throwsArgumentError,
    );
  });

  test('newest Visions come first and archived ones leave the board '
      'without being deleted', () async {
    final database = testDatabase();
    var clock = DateTime(2026, 9, 26, 8);
    final repository = VisionRepository(database, now: () => clock);
    await repository.create(_vision('older'));
    clock = clock.add(const Duration(minutes: 1));
    await repository.create(_vision('newer'));

    expect((await repository.active()).map((v) => v.id), ['newer', 'older']);

    await repository.archive('newer');
    expect((await repository.active()).map((v) => v.id), ['older']);
    final archived = await repository.find('newer');
    expect(archived, isNotNull);
    expect(await database.select(database.visions).get(), hasLength(2));
  });

  test('images are copied under visions/ and resolved from a relative '
      'path', () async {
    final root = await Directory.systemTemp.createTemp('soul_images');
    addTearDown(() => root.delete(recursive: true));
    final source = File('${root.path}/picked.PNG')..writeAsBytesSync([1, 2, 3]);
    final store = ImageStore(() async => root);

    final relative = await store.saveVisionImage(source.path);

    expect(relative, startsWith('visions/'));
    expect(relative, endsWith('.png'));
    expect((await store.resolve(relative)).readAsBytesSync(), [1, 2, 3]);
    await store.delete(relative);
    expect((await store.resolve(relative)).existsSync(), isFalse);
  });
}
