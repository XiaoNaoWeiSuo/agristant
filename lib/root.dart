import 'package:agristant/pages/generate.dart';
import 'package:agristant/pages/research.dart';
import 'package:agristant/pages/scancode.dart';
import 'package:agristant/pages/userinfo.dart';
import 'package:agristant/pages/weather.dart';
import 'package:flutter/material.dart';

class Root extends StatefulWidget {
  const Root({super.key});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  int selectedIndex = 0;
  final PageController _pageController = PageController(initialPage: 0);
  void jump(int index) {
    setState(() {
      selectedIndex = index;
      _pageController.jumpToPage(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomAppBar(
            child: Stack(children: [
          const Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                "订单：联600定金-待交付-m24111202",
                style: TextStyle(color: Colors.grey),
              )),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            IconButton(
                onPressed: () {
                  jump(0);
                },
                icon: selectedIndex == 0
                    ? const Icon(Icons.cloud, color: Colors.blue, size: 35)
                    : const Icon(Icons.cloud_outlined, size: 35)),
            IconButton(
                onPressed: () {
                  jump(1);
                },
                icon: selectedIndex == 1
                    ? const Icon(Icons.chat, color: Colors.blue, size: 35)
                    : const Icon(Icons.chat_outlined, size: 35)),
            IconButton(
                onPressed: () {
                  jump(2);
                },
                icon: selectedIndex == 2
                    ? const Icon(Icons.auto_stories,
                        color: Colors.blue, size: 35)
                    : const Icon(Icons.auto_stories_outlined, size: 35)),
            IconButton(
                onPressed: () {
                  jump(3);
                },
                icon: selectedIndex == 3
                    ? const Icon(Icons.data_array_rounded,
                        color: Colors.blue, size: 35)
                    : const Icon(Icons.data_array, size: 35)),
            IconButton(
                onPressed: () {
                  jump(4);
                },
                icon: selectedIndex == 4
                    ? const Icon(Icons.person, color: Colors.blue, size: 35)
                    : const Icon(Icons.person_outline, size: 35))
          ])
        ])),
        body: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: const [
              Weather(),
              Research(),
              Generate(),
              Scancode(),
              Userinfo()
            ]));
  }
}
