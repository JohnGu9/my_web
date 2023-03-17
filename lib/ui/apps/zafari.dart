import 'package:flutter/material.dart';
import 'package:my_web/core/data/app_data.dart';

class Zafari extends StatelessWidget {
  const Zafari({super.key});
  static final appData = AppData(
    app: const Zafari(),
    icon: const Icon(
      Icons.explore,
      color: Colors.blue,
      size: 56,
    ),
    iconBackground: Container(
      color: Colors.white,
      height: double.infinity,
      width: double.infinity,
    ),
    name: 'Zafari',
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            child: Container(
          color: Colors.black87,
        )),
        Material(
          child: SafeArea(
            top: false,
            bottom: true,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Material(
                    color: Colors.white30,
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    child: InkWell(
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      onTap: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(Icons.search),
                          ),
                          Text("Search or enter website"),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(Icons.mic),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const IconButton(
                        onPressed: null,
                        icon: Icon(Icons.arrow_back_ios),
                      ),
                      const IconButton(
                        onPressed: null,
                        icon: Icon(Icons.arrow_forward_ios),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.ios_share),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.bookmark),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.content_copy),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
