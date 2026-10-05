import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

final imageStoreProvider = Provider<ImageStore>(
  (ref) => ImageStore(getApplicationSupportDirectory),
);

/// Private images in the app support directory. The database stores paths
/// relative to that directory so they survive app-container moves.
class ImageStore {
  ImageStore(this._root);

  final Future<Directory> Function() _root;

  /// Copies [sourcePath] into `visions/` and returns its relative path.
  Future<String> saveVisionImage(String sourcePath) async {
    final extension = p.extension(sourcePath).toLowerCase();
    final relative = p.posix.join(
      'visions',
      '${const Uuid().v4()}${extension.isEmpty ? '.jpg' : extension}',
    );
    final target = File(p.join((await _root()).path, relative));
    await target.parent.create(recursive: true);
    await File(sourcePath).copy(target.path);
    return relative;
  }

  Future<File> resolve(String relativePath) async =>
      File(p.join((await _root()).path, relativePath));

  Future<void> delete(String relativePath) async {
    final file = await resolve(relativePath);
    if (await file.exists()) await file.delete();
  }
}
