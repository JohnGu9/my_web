import 'package:flutter/material.dart';
import 'package:my_web/core/data/app_data.dart';

class Camera extends StatelessWidget {
  static final appData = AppData(
    app: const Camera(),
    icon: const Icon(
      Icons.photo_camera,
      color: Colors.black,
      size: 56,
    ),
    iconBackground: Container(
      color: Colors.grey.shade300,
      height: double.infinity,
      width: double.infinity,
    ),
    name: 'Camera',
  );
  const Camera({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              height: 64,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.flash_auto),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.expand_more),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.blur_circular),
                    ),
                  ],
                ),
              ),
            ),
            const Expanded(child: _Grid()),
            SizedBox(
              height: 100,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const AspectRatio(
                      aspectRatio: 1,
                      child: SizedBox(),
                    ),
                    Expanded(
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Container(
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Colors.white),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.black),
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Container(
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    AspectRatio(
                      aspectRatio: 1,
                      child: FittedBox(
                        child: IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.restart_alt)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Grid extends StatelessWidget {
  const _Grid();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        for (var i = 0; i < 3; i++)
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                for (var i = 0; i < 3; i++)
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white30),
                      ),
                    ),
                  )
              ],
            ),
          ),
      ],
    );
  }
}
