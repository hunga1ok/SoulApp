import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
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
    final rawExt = p.extension(sourcePath).toLowerCase();
    final extension =
        (rawExt.isEmpty || rawExt.contains('?')) ? '.jpg' : rawExt;
    final relative = p.posix.join('visions', '${const Uuid().v4()}$extension');
    final target = File(p.join((await _root()).path, relative));
    target.parent.createSync(recursive: true);

    final sourceFile = File(sourcePath);
    if (sourceFile.existsSync()) {
      target.writeAsBytesSync(sourceFile.readAsBytesSync(), flush: true);
    } else {
      final bytes = await XFile(sourcePath).readAsBytes();
      await target.writeAsBytes(bytes, flush: true);
    }
    return relative;
  }

  Future<File> resolve(String relativePath) async =>
      File(p.join((await _root()).path, relativePath));

  Future<void> delete(String relativePath) async {
    final file = await resolve(relativePath);
    if (await file.exists()) await file.delete();
  }
}
