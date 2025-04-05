import 'package:agristant/common/adapter.dart';
import 'package:agristant/common/getweather.dart';
import 'package:agristant/common/iofile.dart';
import 'package:flutter/material.dart';

class Selectposition extends StatefulWidget {
  const Selectposition({super.key});

  @override
  State<Selectposition> createState() => _SelectpositionState();
}

class _SelectpositionState extends State<Selectposition> {
  WeatherApi weatherApi = WeatherApi();
  Map index = {};
  String location = "101200102";
  CounterStorage counterStorage = CounterStorage(filename: 'default.json');
  TextEditingController searchController = TextEditingController();
  bool isloading = false;
  String cityname = "";
  List searchlist = [];
  @override
  Widget build(BuildContext context) {
    Adapt.initialize(context);

    return Scaffold(
      body: Column(children: [
        SizedBox(height: Adapt.statusBarHeight * 1.5),
        Container(
            padding: EdgeInsets.symmetric(horizontal: Adapt.pt(20)),
            width: Adapt.pt(400),
            height: Adapt.pt(50),
            child: Row(children: [
              Expanded(
                  child: TextField(
                      controller: searchController,
                      maxLines: 1,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                          isDense: false,
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 2, color: Colors.black),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(13),
                                  bottomLeft: Radius.circular(13))),
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 1, color: Colors.black),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(13),
                                  bottomLeft: Radius.circular(13)))))),
              InkWell(
                  onTap: () {
                    setState(() {
                      isloading = true;
                    });
                    weatherApi.searchCity(searchController.text).then((value) {
                      setState(() {
                        isloading = false;
                        searchlist = value;
                      });
                    });
                  },
                  child: Container(
                      decoration: const BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(13),
                              bottomRight: Radius.circular(13))),
                      height: Adapt.pt(50),
                      width: Adapt.pt(80),
                      child: const Center(
                          child: Text("搜索",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 15)))))
            ])),
        const SizedBox(height: 10),
        Expanded(
            child: isloading
                ? const Center(
                    child: SizedBox(
                        width: 100,
                        height: 100,
                        child: CircularProgressIndicator()))
                : searchlist.isEmpty
                    ? const Center(
                        child:
                            Text("该城市暂无搜索结果", style: TextStyle(fontSize: 15)))
                    : MediaQuery.removePadding(
                        removeTop: true,
                        context: context,
                        child: ListView.builder(
                            itemCount: searchlist.length,
                            itemBuilder: (context, sindex) {
                              return InkWell(
                                  onTap: () {
                                    setState(() {
                                      isloading = true;
                                    });
                                    location = searchlist[sindex]['id'];
                                    cityname = searchlist[sindex]['name'];
                                    counterStorage.writeCounter({
                                      'location': location,
                                      'cityname': cityname
                                    });
                                    Navigator.pop(context, {
                                      'location': location,
                                      'cityname': cityname
                                    });
                                  },
                                  child: Container(
                                      height: Adapt.pt(70),
                                      decoration: BoxDecoration(
                                          border: sindex == 0
                                              ? null
                                              : const Border(
                                                  top: BorderSide(
                                                      width: 1,
                                                      color: Colors.black))),
                                      margin: EdgeInsets.symmetric(
                                          horizontal: Adapt.pt(25)),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: Adapt.pt(10)),
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Row(children: [
                                              Text(searchlist[sindex]['name'],
                                                  style: const TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              Expanded(
                                                  child: Align(
                                                      alignment:
                                                          Alignment.centerRight,
                                                      child: Text(
                                                        "${searchlist[sindex]['adm1']} - ${searchlist[sindex]['adm2']}",
                                                        maxLines: 2,
                                                        style: const TextStyle(
                                                            fontSize: 12),
                                                      )))
                                            ]),
                                            Row(children: [
                                              Text(
                                                "${searchlist[sindex]['country']}",
                                                style: const TextStyle(
                                                    color: Colors.black54),
                                              ),
                                              const Spacer(),
                                              Text(
                                                  "经度：${searchlist[sindex]['lat']} 纬度：${searchlist[sindex]['lon']}")
                                            ])
                                          ])));
                            })))
      ]),
    );
  }
}
