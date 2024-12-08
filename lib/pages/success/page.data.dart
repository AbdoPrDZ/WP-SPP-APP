part of 'page.dart';

class SuccessPageData extends PageData {

  final String image;
  final String title;
  final String? description;
  final bool showLoading;
  final Function? onInit;

  const SuccessPageData({
    required this.image,
    required this.title,
    this.description,
    this.showLoading = true,
    this.onInit,
  });
}