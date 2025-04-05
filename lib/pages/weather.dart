import 'package:agristant/common/adapter.dart';
import 'package:agristant/common/getweather.dart';
import 'package:agristant/common/iofile.dart';
import 'package:agristant/pages/threedays.dart';
import 'package:flutter/material.dart';

class Weather extends StatefulWidget {
  const Weather({super.key});

  @override
  State<Weather> createState() => _WeatherState();
}

class _WeatherState extends State<Weather> {
  WeatherApi weatherApi = WeatherApi();
  Map index = {};
  String location = "101200102";
  CounterStorage counterStorage = CounterStorage(filename: 'default.json');
  TextEditingController searchController = TextEditingController();
  bool isloading = true;
  bool haveData = true;
  String cityname = "";
  List searchlist = [];
  @override
  void initState() {
    super.initState();
    counterStorage.readCounter().then((value) {
      if (value.isNotEmpty) {
        location = value['location'];
        cityname = value['cityname'];
        weatherApi.getWeather(location).then((value) {
          setState(() {
            haveData = true;
            index = value;
            isloading = false;
          });
        });
      } else {
        setState(() {
          haveData = false;
          isloading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Adapt.initialize(context);

    return Scaffold(
        body: haveData
            ? isloading
                ? const Center(
                    child: SizedBox(
                        width: 100,
                        height: 100,
                        child: CircularProgressIndicator()))
                : Column(children: [
                    SizedBox(height: Adapt.statusBarHeight),
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      Text(
                        cityname,
                        style: const TextStyle(fontSize: 16),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            haveData = false;
                            isloading = false;
                          });
                        },
                        icon: const Icon(Icons.location_pin),
                      ),
                      const SizedBox(width: 10)
                    ]),
                    const SizedBox(height: 60),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 150,
                            height: 150,
                            child: Image.network(
                                "https://a.hecdn.net/img/common/icon/202106d/${index['now']['icon']}.png"),
                          ),
                          Text(
                            "${index['now']['temp']}",
                            style: const TextStyle(fontSize: 100),
                          ),
                          const Text("°", style: TextStyle(fontSize: 90))
                        ]),
                    const SizedBox(height: 10),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text(
                        index['now']['text'],
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        index['now']['windDir'],
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "${index['now']['windScale']} 级",
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(width: 12),
                      Text("体感温度：${index['now']['feelsLike']}°",
                          style: const TextStyle(fontSize: 16))
                    ]),
                    Expanded(
                        child: Center(
                            child: InkWell(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return const Threedays();
                                  }));
                                },
                                child: const Text("未来三天",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.blueGrey))))),
                    Text("${index['updateTime']}",
                        style: const TextStyle(
                            fontSize: 12, color: Colors.black26)),
                    const SizedBox(height: 10)
                  ])
            : Column(children: [
                SizedBox(height: Adapt.statusBarHeight*1.5),
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
                                      borderSide: BorderSide(
                                          width: 2, color: Colors.black),
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(13),
                                          bottomLeft: Radius.circular(13))),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 1, color: Colors.black),
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(13),
                                          bottomLeft: Radius.circular(13)))))),
                      InkWell(
                          onTap: () {
                            setState(() {
                              isloading = true;
                            });
                            weatherApi
                                .searchCity(searchController.text)
                                .then((value) {
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
                                child: Text("该城市暂无搜索结果",
                                    style: TextStyle(fontSize: 15)))
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
                                            cityname =
                                                searchlist[sindex]['name'];
                                            counterStorage.writeCounter({
                                              'location': location,
                                              'cityname': cityname
                                            });
                                            weatherApi
                                                .getWeather(location)
                                                .then((value) {
                                              setState(() {
                                                isloading = false;
                                                haveData = true;
                                                index = value;
                                                searchlist = [];
                                              });
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
                                                              color: Colors
                                                                  .black))),
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: Adapt.pt(25)),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: Adapt.pt(10)),
                                              child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Row(children: [
                                                      Text(
                                                          searchlist[sindex]
                                                              ['name'],
                                                          style: const TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                      Expanded(
                                                          child: Align(
                                                              alignment: Alignment
                                                                  .centerRight,
                                                              child: Text(
                                                                "${searchlist[sindex]['adm1']} - ${searchlist[sindex]['adm2']}",
                                                                maxLines: 2,
                                                                style:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            12),
                                                              )))
                                                    ]),
                                                    Row(children: [
                                                      Text(
                                                        "${searchlist[sindex]['country']}",
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.black54),
                                                      ),
                                                      const Spacer(),
                                                      Text(
                                                          "经度：${searchlist[sindex]['lat']} 纬度：${searchlist[sindex]['lon']}")
                                                    ])
                                                  ])));
                                    })))
              ]));
  }
}
