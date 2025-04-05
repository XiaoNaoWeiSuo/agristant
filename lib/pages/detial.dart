import 'package:agristant/common/adapter.dart';
import 'package:flutter/material.dart';

class Detial extends StatelessWidget {
  const Detial(
      {super.key,
      required this.title,
      required this.color,
      required this.data});
  final String title;

  final Color color;
  final Map data;
  @override
  Widget build(BuildContext context) {
    Adapt.initialize(context);
    return Scaffold(
        appBar: AppBar(title: Text(title), backgroundColor: color),
        body: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          SizedBox(width: Adapt.screenWidth, height: 10),
          Container(
            width: Adapt.pt(330),
            height: Adapt.pt(100),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: color, borderRadius: BorderRadius.circular(15)),
            child: Center(child: Text(data['rcmd'])),
          ),
          SizedBox(
              width: Adapt.pt(360),
              height: Adapt.pt(150),
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: data['list'].length,
                  itemExtent: Adapt.pt(360) / data['list'].length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.all(20),
                      height: Adapt.pt(100),
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                blurRadius: 10)
                          ],
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.white),
                      child: Center(
                          child: Text(data['list'][index],
                              style: TextStyle(fontSize: Adapt.pt(20)))),
                    );
                  })),
          Container(
            width: Adapt.pt(330),
            height: Adapt.pt(100),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: color.withAlpha(150),
                borderRadius: BorderRadius.circular(15)),
            child: Center(child: Text(data['resn'])),
          ),
        ]));
  }
}
