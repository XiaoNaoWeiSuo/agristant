import 'dart:convert';

import 'package:agristant/common/adapter.dart';
import 'package:agristant/common/getweather.dart';
import 'package:agristant/common/iofile.dart';
import 'package:agristant/pages/tips.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class Generate extends StatefulWidget {
  const Generate({super.key});

  @override
  State<Generate> createState() => _GenerateState();
}

class _GenerateState extends State<Generate> {
  List sourcedata = [];
  List data = [];
  String cityname = "";
  WeatherApi weatherApi = WeatherApi();
  bool isloading = true;
  String location = "101200102";
  CounterStorage counterStorage = CounterStorage(filename: 'default.json');
  CounterStorage suStorage = CounterStorage(filename: 'suggest.json');
  static const Map forma = {
    'irrigation': {
      'rcmd': '灌溉建议,需给出明确的灌溉方法和时间',
      'list': ["名称，如:'滴灌'"],
      'resn': 'Give reasons for suggestions'
    },
    'plants': {
      'rcmd': '种植建议，需给出明确的适宜种植的作物品种',
      'list': ["名称，如:'玉米'"],
      'resn': 'Give reasons for suggestions'
    },
    'fertilization': {
      'rcmd': '施肥建议，需给出明确的施肥方法和时间，和施肥剂品牌名称',
      'list': ["名称，如:'氮肥'"],
      'resn': 'During early growth stages'
    },
    'pestControl': {
      'rcmd': '病虫害防治建议，需给出明确的病虫害防治措施和杀虫剂品牌名称或化学名称',
      'list': ["名称，如:'氯氰菊酯'"],
      'resn': 'Give reasons for suggestions'
    },
    'weeding': {
      'rcmd': '除草建议，需给出明确的除草方法和除草剂名称',
      'list': ["名称，如:'百草枯'"],
      'resn': 'Give reasons for suggestions'
    }
  };
  Map result = {
    "updatetime": DateTime.now().toString().split(' ')[0],
    "data": {}
  };
  @override
  void initState() {
    super.initState();
    suStorage.readCounter().then((fvalue) {
      if (fvalue.isNotEmpty &&
          fvalue['updatetime'] == DateTime.now().toString().split(' ')[0]) {
        setState(() {
          result = fvalue;
          isloading = false;
        });
      } else {
        counterStorage.readCounter().then((value) {
          location = value['location'];
          cityname = value['cityname'];
          setState(() {});
          weatherApi.futureseven(location).then((value) {
            sourcedata = value;
            List formatindex = [
              "日期",
              "月相",
              "最高温度",
              "最低温度",
              "天气状况",
              "风速",
              "降水量",
              "紫外线强度",
              "湿度"
            ];
            for (Map item in sourcedata) {
              data.add([
                item['fxDate'],
                item['moonPhase'],
                item['tempMax'],
                item['tempMin'],
                item['textDay'],
                item['windSpeedDay'],
                item['precip'],
                item['uvIndex'],
                item['humidity']
              ]);
            }
            data.insert(0, formatindex);
            ask(data.toString(), cityname);
          });
        });
      }
    });
  }

  void ask(String question, String cityame) {
    final body = {
      "model": "gpt-4o-mini",
      "messages": [
        {
          "role": "system",
          "content":
              "你是一个农业专家，气象学家兼地理学家，用户将会提供城市位置，以及该城市未来七天的天气情况和对应时间，请你根据$forma的模版，格式化输出，使用中文填写value值，但是list值需要多样化，尽量不要只写一个，不要有多余文字，你的输出将会被根据格式化断言，严禁添加或减少键值和参数"
        },
        {"role": "user", "content": "城市名：$cityame，未来七天天气数据：$question"}
      ]
    };
    setState(() {});
    Dio()
        .post("https://api.chatanywhere.tech/v1/chat/completions",
            data: body,
            options: Options(headers: {
              "Authorization":
                  "Bearer sk-hPdt8DTEYdPz6PgkDTu9b1UWqh4nqlHzxv7LB5iz633mShNd",
              "Content-Type": "application/json; charset=UTF-8"
            }))
        .then((respose) {
      result['updatetime'] = DateTime.now().toString().split(' ')[0];
      suStorage.writeCounter(result);
      setState(() {
        result['data'] = jsonDecode(
            respose.data['choices'][0]['message']['content'].toString());
        isloading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Adapt.initialize(context);
    return Scaffold(
        appBar: AppBar(
            actions: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      isloading = true;
                    });
                    counterStorage.readCounter().then((value) {
                      location = value['location'];
                      cityname = value['cityname'];
                      setState(() {});
                      weatherApi.futureseven(location).then((value) {
                        sourcedata = value;
                        List formatindex = [
                          "日期",
                          "月相",
                          "最高温度",
                          "最低温度",
                          "天气状况",
                          "风速",
                          "降水量",
                          "紫外线强度",
                          "湿度"
                        ];
                        for (Map item in sourcedata) {
                          data.add([
                            item['fxDate'],
                            item['moonPhase'],
                            item['tempMax'],
                            item['tempMin'],
                            item['textDay'],
                            item['windSpeedDay'],
                            item['precip'],
                            item['uvIndex'],
                            item['humidity']
                          ]);
                        }
                        data.insert(0, formatindex);
                        ask(data.toString(), cityname);
                      });
                    });
                  },
                  icon: const Icon(
                    Icons.refresh,
                    size: 30,
                  )),
              const SizedBox(width: 20)
            ],
            title: const Row(
                children: [Icon(Icons.tips_and_updates), Text("每日农业小建议")])),
        body: isloading
            ? const Center(child: CircularProgressIndicator())
            : ListView(children: [
                Tips(
                    title: "作物推荐",
                    color: Colors.green,
                    data: result['data']['plants']),
                Tips(
                    title: "灌溉建议",
                    color: Colors.blue,
                    data: result['data']['irrigation']),
                Tips(
                    title: "施肥建议",
                    color: Colors.brown,
                    data: result['data']['fertilization']),
                Tips(
                    title: "病虫害防治",
                    color: Colors.purple,
                    data: result['data']['pestControl']),
                Tips(
                    title: "除草",
                    color: Colors.amber,
                    data: result['data']['weeding'])
              ]));
  }
}
