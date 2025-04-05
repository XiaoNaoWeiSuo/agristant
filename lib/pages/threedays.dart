import 'package:agristant/common/adapter.dart';
import 'package:agristant/common/getweather.dart';
import 'package:agristant/common/iofile.dart';
import 'package:flutter/material.dart';

class Threedays extends StatefulWidget {
  const Threedays({super.key});

  @override
  State<Threedays> createState() => _ThreedaysState();
}

class _ThreedaysState extends State<Threedays> {
  CounterStorage counterStorage = CounterStorage(filename: 'default.json');
  String location = "101200102";
  String cityname = "";
  List index = [];
  bool isloading = true;
  WeatherApi weatherApi = WeatherApi();
  @override
  void initState() {
    super.initState();
    counterStorage.readCounter().then((value) {
      location = value['location'];
      cityname = value['cityname'];
      setState(() {});
      weatherApi.futurethree(location).then((value) {
        setState(() {
          index = value;
          isloading = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Adapt.initialize(context);
    return Scaffold(
        appBar: AppBar(title: Text("$cityname - 未来三天")),
        body: isloading
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: index.length,
                itemExtent: Adapt.screenWidth / 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, sindex) {
                  Map days = index[sindex];
                  String date =
                      "${days['fxDate'].split("-")[1]}月${days['fxDate'].split("-")[2]}日";
                  return SizedBox(
                      child: Column(children: [
                    const SizedBox(height: 30),
                    Text(date,
                        style: const TextStyle(
                            fontSize: 12, color: Colors.black54)),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 50,
                      height: 50,
                      child: Image.network(
                          alignment: Alignment.topCenter,
                          "https://a.hecdn.net/img/common/icon/202106d/${days['iconDay']}.png"),
                    ),
                    Text(days['textDay'],
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                    SizedBox(
                      height: Adapt.pt(250),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("${days['tempMax']}°"),
                            Container(
                              width: 8,
                              height: Adapt.pt(10) *
                                  (double.parse(days['tempMax']) -
                                      double.parse(days['tempMin'])),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  gradient: const LinearGradient(
                                      colors: [
                                        Colors.redAccent,
                                        Colors.blueAccent
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter)),
                            ),
                            Text("${days['tempMin']}°"),
                          ]),
                    ),
                    Text(days['textNight'],
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                    SizedBox(
                        width: 50,
                        height: 50,
                        child: Image.network(
                            alignment: Alignment.topCenter,
                            "https://a.hecdn.net/img/common/icon/202106d/${days['iconNight']}.png")),
                    const SizedBox(height: 10),
                    Container(
                        width: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: const Color.fromARGB(255, 173, 197, 238)),
                        child: Center(child: Text(days['windDirDay']))),
                    SizedBox(height: Adapt.pt(5)),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Transform.rotate(
                          angle: (int.parse(days['wind360Day']) / 360) *
                              3.1415926 *
                              2,
                          child: const Icon(Icons.assistant_navigation,
                              size: 18, color: Colors.black)),
                      Text(" ${days['windSpeedDay']} 级")
                    ])
                    // Text(index[sindex].toString())
                  ]));
                }));
  }
}
