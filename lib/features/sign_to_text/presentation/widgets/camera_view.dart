import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraView extends StatelessWidget {
  final CameraController controller;

  const CameraView({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.biggest;
        final scale = size.aspectRatio * controller.value.aspectRatio;

        return ClipRect(
          child: Transform.scale(
            scale: scale < 1 ? 1 / scale : scale,
            child: Center(
              child: CameraPreview(controller),
            ),
          ),
        );
      },
    );
  }
}
