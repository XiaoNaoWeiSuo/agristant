import 'package:agristant/common/adapter.dart';
import 'package:agristant/pages/detial.dart';
import 'package:flutter/material.dart';

class Tips extends StatefulWidget {
  const Tips(
      {super.key,
      required this.title,
      required this.color,
      required this.data});
  final String title;

  final Color color;
  final Map data;
  @override
  State<Tips> createState() => _TipsState();
}

class _TipsState extends State<Tips> {
  @override
  Widget build(BuildContext context) {
    Adapt.initialize(context);
    return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Detial(
                      title: widget.title,
                      color: widget.color,
                      data: widget.data)));
        },
        child: Container(
            margin: const EdgeInsets.only(left: 15, bottom: 10),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10)),
                      gradient: LinearGradient(
                          colors: [widget.color.withAlpha(120), widget.color],
                          end: Alignment.topCenter,
                          begin: Alignment.bottomCenter)),
                  padding: const EdgeInsets.all(5),
                  child: Text(widget.title,
                      style:
                          const TextStyle(color: Colors.white, fontSize: 15))),
              Container(
                  width: Adapt.screenWidth - 30,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                          topRight: Radius.circular(10)),
                      gradient: LinearGradient(
                          colors: [widget.color.withAlpha(120), widget.color],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter)),
                  padding: const EdgeInsets.all(10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.white),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 7, vertical: 5),
                            margin: const EdgeInsets.only(bottom: 5),
                            child: Text(widget.data['rcmd'],
                                style: TextStyle(
                                    color: widget.color,
                                    fontSize: 18,
                                    height: 1))),
                        SizedBox(
                            width: Adapt.pt(350),
                            height: Adapt.pt(30),
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: widget.data['list'].length,
                                itemBuilder: (context, index) {
                                  return Container(
                                      margin: const EdgeInsets.only(right: 5),
                                      padding: const EdgeInsets.fromLTRB(
                                          15, 1, 15, 1),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: Colors.amber),
                                      child: Center(
                                          child: Text(
                                              widget.data['list'][index],
                                              style: const TextStyle(
                                                  height: 1, fontSize: 16))));
                                })),
                        const SizedBox(height: 5),
                        Text("\"${widget.data['resn']}\"")
                      ]))
            ])));
  }
}
