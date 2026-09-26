import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

final imagePickingProvider = Provider<ImagePicking>(
  (ref) => ImagePicking(ImagePicker()),
);

/// Picks one photo, resized and compressed for on-device storage.
class ImagePicking {
  ImagePicking(this._picker);

  final ImagePicker _picker;

  /// Returns the picked file path, or `null` when the user cancels.
  Future<String?> pick({required bool fromCamera}) async {
    final file = await _picker.pickImage(
      source: fromCamera ? ImageSource.camera : ImageSource.gallery,
      maxWidth: 2048,
      maxHeight: 2048,
      imageQuality: 85,
    );
    return file?.path;
  }
}
