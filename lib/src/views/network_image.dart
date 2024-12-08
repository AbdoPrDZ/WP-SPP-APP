import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:storage_database/storage_explorer/explorer_file.dart';
import 'package:storage_database/storage_explorer/explorer_network_files.dart';

import '../../services/main.service.dart';

class MNetworkImage extends StatefulWidget {
  final String url;
  final Widget Function(File image) build;
  final Widget onLoadingWidget;
  final Widget onFailedWidget;

  const MNetworkImage({
    super.key,
    required this.url,
    required this.build,
    required this.onLoadingWidget,
    required this.onFailedWidget,
  });

  @override
  State<MNetworkImage> createState() => _MNetworkImageState();
}

class _MNetworkImageState extends State<MNetworkImage> {
  bool loading = true;
  bool hasError = false;

  File? image;

  ExplorerNetworkFiles get networkFiles =>
      Get.find<MainService>().storageDatabase.explorer.networkFiles;

  @override
  void initState() {
    loadImage();

    super.initState();
  }

  Future loadImage() async {
    ExplorerFile? file;

    try {
      file = await networkFiles.file(
        widget.url,
        log: true,
      );

      if (file != null) image = file.ioFile;
      hasError = file == null;
    } catch (e) {
      hasError = true;
    }

    try {
      setState(() {});
    } catch (e) {
      log('Error: $e');
    }

    loading = false;
  }

  @override
  Widget build(BuildContext context) => loading
      ? widget.onLoadingWidget
      : hasError
          ? widget.onFailedWidget
          : widget.build(image!);
}
