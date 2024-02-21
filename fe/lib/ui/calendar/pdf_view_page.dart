import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdf_render/pdf_render_widgets.dart';

class PdfViewPage extends StatefulWidget {
  const PdfViewPage({
    required this.data,
    super.key,
  });

  final Uint8List data;

  @override
  State<PdfViewPage> createState() => _PdfViewPageState();
}

class _PdfViewPageState extends State<PdfViewPage> {
  final controller = PdfViewerController();
  late TapDownDetails? _doubleTapDetails;

  @override
  void initState() {
    _doubleTapDetails = TapDownDetails();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ValueListenableBuilder<Matrix4>(
          valueListenable: controller,
          builder: (context, _, child) =>
              Text('Kalendar nastave'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.zoom_out),
            onPressed: () {
              controller.ready?.setZoomRatio(
                zoomRatio: 1,
                center: _doubleTapDetails!.localPosition,
              );
            },
          ),
        ],
      ),
      body: GestureDetector(
        onDoubleTapDown: (details) => _doubleTapDetails = details,
        onDoubleTap: () => controller.ready?.setZoomRatio(
          zoomRatio: controller.zoomRatio * 1.5,
          center: _doubleTapDetails!.localPosition,
        ),
        child: PdfViewer.openData(
          widget.data,
          viewerController: controller,
          onError: print,
          params: const PdfViewerParams(
            padding: 10,
            minScale: 1,
            // scrollDirection: Axis.horizontal,
          ),
        ),
      ),
    );
  }
}
