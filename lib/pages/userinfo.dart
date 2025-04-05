import 'package:agristant/common/iofile.dart';
import 'package:agristant/pages/selectposition.dart';
import 'package:flutter/material.dart';

class Userinfo extends StatefulWidget {
  const Userinfo({super.key});

  @override
  State<Userinfo> createState() => _UserinfoState();
}

class _UserinfoState extends State<Userinfo> {
  CounterStorage counterStorage = CounterStorage(filename: 'default.json');

  CounterStorage suStorage = CounterStorage(filename: 'suggest.json');
  String location = "101200102";
  String cityname = "";
  String updatetime = "";
  @override
  void initState() {
    super.initState();

    counterStorage.readCounter().then((value) {
      location = value['location'];
      cityname = value['cityname'];
      suStorage.readCounter().then((fvalue) {
        updatetime = fvalue['updatetime'];
        setState(() {});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: [
      const SizedBox(height: 100),
      const Center(
          child: CircleAvatar(
        radius: 50,
        child: Icon(Icons.import_contacts),
      )),
      const SizedBox(height: 20),
      const Center(
          child: Text("user_129eh91e28ue",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600))),
      const SizedBox(height: 50),
      ListTile(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return const Selectposition();
            })).then((value) {
              setState(() {
                location = value['location'];
                cityname = value['cityname'];
              });
            });
          },
          leading: const Icon(Icons.location_city),
          title: const Text("城市"),
          trailing: Text(cityname)),
      ListTile(
          onTap: () {},
          leading: const Icon(Icons.code),
          title: const Text("代码"),
          trailing: Text(location)),
      ListTile(
          onTap: () {},
          leading: const Icon(Icons.data_exploration),
          title: const Text("更新时间"),
          trailing: Text(updatetime))
    ]));
  }
}
