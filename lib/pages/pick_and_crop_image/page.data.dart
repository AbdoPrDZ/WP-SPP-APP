part of 'page.dart';

class PickAndCropImagePageData extends PageData {
  final Function(File? image) onDone;

  const PickAndCropImagePageData({
    required this.onDone,
  });
}
