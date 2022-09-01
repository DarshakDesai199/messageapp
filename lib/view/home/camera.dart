import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:messageapp/main.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage>
    with SingleTickerProviderStateMixin {
  int i = 1;
  int lensPosition = 0;
  late CameraController controller;
  late AnimationController _flashModeControlRowAnimationController;
  late Animation<double> _flashModeControlRowAnimation;
  XFile? pictureFile;

  @override
  void initState() {
    super.initState();
    setState(() {
      controller = CameraController(
        cameraData[lensPosition],
        // lensPosition,
        ResolutionPreset.high,
      );
    });

    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
    _flashModeControlRowAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _flashModeControlRowAnimation = CurvedAnimation(
      parent: _flashModeControlRowAnimationController,
      curve: Curves.easeInCubic,
    );
  }

  @override
  void dispose() {
    _flashModeControlRowAnimationController.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return const SizedBox(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    if (pictureFile == null) {
      return Stack(
        // alignment: Alignment.bottomCenter,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: SizedBox(
                height: height,
                width: width,
                child: CameraPreview(controller),
              ),
            ),
          ),
          GestureDetector(
            onTap: () async {
              pictureFile = await controller.takePicture();
              setState(() {});
            },
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: height * 0.04),
                child: Container(
                    height: height * 0.08,
                    width: height * 0.08,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 4)),
                    child: CircleAvatar(
                      radius: height * 0.035,
                      backgroundColor: Colors.transparent,
                      child: CircleAvatar(
                          radius: height * 0.03, backgroundColor: Colors.white),
                    )),
              ),
            ),
          ),
          // Align(
          //   alignment: Alignment.bottomLeft,
          //   child: SizeTransition(
          //     sizeFactor: _flashModeControlRowAnimation,
          //     child: ClipRect(
          //       child: Padding(
          //         padding: EdgeInsets.only(
          //             bottom: height * 0.05, left: width * 0.12),
          //         child: Row(
          //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //           mainAxisSize: MainAxisSize.max,
          //           children: <Widget>[
          //             IconButton(
          //               icon: const Icon(Icons.flash_off),
          //               color: controller?.value.flashMode == FlashMode.off
          //                   ? Colors.orange
          //                   : Colors.blue,
          //               onPressed: controller != null
          //                   ? () => onSetFlashModeButtonPressed(FlashMode.off)
          //                   : null,
          //             ),
          //             IconButton(
          //               icon: const Icon(Icons.flash_auto),
          //               color: controller?.value.flashMode == FlashMode.auto
          //                   ? Colors.orange
          //                   : Colors.blue,
          //               onPressed: controller != null
          //                   ? () => onSetFlashModeButtonPressed(FlashMode.auto)
          //                   : null,
          //             ),
          //             IconButton(
          //               icon: const Icon(Icons.flash_on),
          //               color: controller?.value.flashMode == FlashMode.always
          //                   ? Colors.orange
          //                   : Colors.blue,
          //               onPressed: controller != null
          //                   ? () =>
          //                       onSetFlashModeButtonPressed(FlashMode.always)
          //                   : null,
          //             ),
          //             IconButton(
          //               icon: const Icon(Icons.highlight),
          //               color: controller?.value.flashMode == FlashMode.torch
          //                   ? Colors.orange
          //                   : Colors.blue,
          //               onPressed: controller != null
          //                   ? () => onSetFlashModeButtonPressed(FlashMode.torch)
          //                   : null,
          //             ),
          //           ],
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
          GestureDetector(
            onTap: () {
              setState(() {
                // i = 1;
                i++;
                print('+++++++++++++$i');
                i == 3 ? i = 0 : null;
                i == 1
                    ? controller.setFlashMode(FlashMode.always)
                    : i == 2
                        ? controller.setFlashMode(FlashMode.auto)
                        : controller.setFlashMode(FlashMode.off);
              });
              print('Tap>>>>>>>>>>');
            },
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                padding:
                    EdgeInsets.only(bottom: height * 0.05, left: width * 0.12),
                child: i == 1
                    ? Icon(
                        Icons.flash_on,
                        color: Colors.white,
                        size: height * 0.05,
                      )
                    : i == 2
                        ? Icon(
                            Icons.flash_auto,
                            color: Colors.white,
                            size: height * 0.05,
                          )
                        : Icon(
                            Icons.flash_off,
                            color: Colors.white,
                            size: height * 0.05,
                          ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                // lensPosition = 0;
                lensPosition++;
                lensPosition == 2 ? lensPosition = 0 : null;
                print('---------------$lensPosition');
              });
            },
            child: Align(
              alignment: Alignment.bottomRight,
              child: Container(
                  padding: EdgeInsets.only(
                      bottom: height * 0.05, right: width * 0.12),
                  child: Icon(
                    Icons.flip_camera_android_rounded,
                    color: Colors.white,
                    size: height * 0.05,
                  )),
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: ElevatedButton(
          //     onPressed: () async {
          //       pictureFile = await controller.takePicture();
          //       setState(() {});
          //     },
          //     child: const Text('Capture Image'),
          //   ),
          // ),
        ],
      );
    } else {
      controller.setFlashMode(FlashMode.off);
      return Stack(
        children: [
          Image.file(File(pictureFile!.path), height: height, width: width),
        ],
      );
    }
  }
}
