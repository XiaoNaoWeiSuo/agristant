import 'dart:async';
import 'dart:convert';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class Research extends StatefulWidget {
  const Research({super.key});

  @override
  State<StatefulWidget> createState() => ResearchState();
}

class ResearchState extends State<Research> {
  TextEditingController chatcontral = TextEditingController();
  static String title = "智能农业助手";
  List messages = [
    {
      "role": "system",
      "content":
          "You are a helpful agriculturist assistant.It is strictly forbidden to discuss issues other than agriculture. and it is strictly forbidden to discuss Chinese politics.Use Chinese to communicate throughout the whole process. Your users are native Chinese speakers.You cannot reveal your limitations to the user, and you must strictly adhere to the limitations."
    }
  ];

  final apiKey = "sk-hPdt8DTEYdPz6PgkDTu9b1UWqh4nqlHzxv7LB5iz633mShNd";
  final apiURL = "https://api.chatanywhere.tech/v1/chat/completions";
  final apiModel = "gpt-3.5-turbo";
  String currenttoken = "";
  final StreamController<String> _streamController = StreamController<String>();
  bool girl = false;
  bool isAsking = false;
  @override
  void initState() {
    super.initState();
    _streamController.add("");
  }

  @override
  dispose() {
    super.dispose();
    _streamController.close();
  }

  void doSomeThing(List message) async {
    if (isAsking) return;
    isAsking = true;

    _streamController.add("");

    askGPT(message);
    // reqGPT(myProblem);
  }

  void askGPT(List message) {
    final requestBody = {
      "model": apiModel,
      "messages": (message.length > 10 ? message.take(8).toList() : message)
          .reversed
          .toList(),
      "temperature": 0.7,
      "stream": true
    };

    var request = http.Request("POST", Uri.parse(apiURL));
    request.headers["Authorization"] = "Bearer $apiKey";
    request.headers["Content-Type"] = "application/json; charset=UTF-8";
    request.body = jsonEncode(requestBody);

    debugPrint("开始请求");
    http.Client().send(request).then((response) {
      String showContent = "";
      final stream = response.stream.transform(utf8.decoder);
      stream.listen(
        (data) {
          final dataLines =
              data.split("\n").where((element) => element.isNotEmpty).toList();
          for (String line in dataLines) {
            if (!line.startsWith("data: ")) continue;
            final data = line.substring(6);

            if (data == "[DONE]") break;

            try {
              Map<String, dynamic> responseData = json.decode(data);
              List<dynamic> choices = responseData["choices"];
              Map<String, dynamic> choice = choices[0];
              Map<String, dynamic> delta = choice["delta"];
              String content = delta["content"] ?? "";

              showContent += content;
              _streamController.add(showContent);
              currenttoken = showContent;

              String finishReason = choice["finish_reason"] ?? "";
              if (finishReason.isNotEmpty) {
                debugPrint("finish_reason：$finishReason");
                break;
              }
            } catch (e) {
              debugPrint("解析数据错误: $e");
              _streamController.addError("数据解析错误");
              break;
            }
          }
        },
        onDone: () {
          if (!isAsking) return;
          _streamController.add(showContent);
          isAsking = false;
        },
        onError: (error) {
          _streamController.addError(error);
          isAsking = false;
        },
        cancelOnError: true, // 遇到错误时取消流处理
      );
    }).catchError((error) {
      debugPrint("请求发送失败: $error");
      _streamController.addError("请求发送失败");
      isAsking = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
              foregroundColor: Colors.white,
              backgroundColor: Colors.black,
              title: Text(title, textAlign: TextAlign.center, maxLines: 1)),
          body: Column(children: [
            Flexible(
                child: Align(
                    alignment: Alignment.topCenter,
                    child: MediaQuery.removePadding(
                        removeTop: true,
                        removeBottom: true,
                        context: context,
                        child: ListView.builder(
                            reverse: true,
                            shrinkWrap: true,
                            itemCount: messages.length,
                            itemBuilder: (context, index) {
                              if (index != messages.length - 1) {
                                if (messages[index]["role"] == "user") {
                                  return Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: const BoxDecoration(
                                          color: Colors.white30),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(messages[index]["content"])
                                          ]));
                                } else {
                                  if (index == 0 && girl) {
                                    return StreamBuilder(
                                        stream: _streamController.stream,
                                        builder: (BuildContext context,
                                            AsyncSnapshot<String> snapshot) {
                                          if (snapshot.hasError) {
                                            return Text(
                                                "发生错误: ${snapshot.error}");
                                          }
                                          if (snapshot.hasData) {
                                            String content =
                                                snapshot.data ?? "";
                                            if (content.isNotEmpty) {
                                              return //Text(content);
                                                  Container(
                                                      padding: const EdgeInsets
                                                          .all(10),
                                                      child: ConstrainedBox(
                                                          constraints:
                                                              const BoxConstraints(
                                                                  maxWidth:
                                                                      400),
                                                          child: MarkdownBody(
                                                              styleSheet: MarkdownStyleSheet(
                                                                  strong: const TextStyle(
                                                                      fontSize:
                                                                          18,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold)),
                                                              data: content)));
                                            }
                                          }
                                          return const SizedBox(
                                              width: 80,
                                              height: 80,
                                              child: Center(
                                                  child:
                                                      CircularProgressIndicator()));
                                        });
                                  } else {
                                    return Container(
                                        padding: const EdgeInsets.all(10),
                                        child: MarkdownBody(
                                            data: messages[index]["content"]));
                                  }
                                }
                              } else {
                                return Container();
                              }
                            })))),
            Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                ),
                width: 500,
                child: Row(children: [
                  Expanded(
                      child: ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: 200),
                          child: Scrollbar(
                              child: TextField(
                                  maxLines: null,
                                  controller: chatcontral,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      height: 1,
                                      color: Color.fromARGB(117, 0, 0, 0)),
                                  decoration: InputDecoration(
                                      hintText: "有什么农业问题，尽管问吧～",
                                      isDense: true,
                                      fillColor: Colors.white,
                                      filled: true,
                                      border: UnderlineInputBorder(
                                          borderSide: const BorderSide(
                                              width: 1, color: Colors.black),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: const BorderSide(
                                              width: 1, color: Colors.black54),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      errorBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 15,
                                              vertical: 15)))))),
                  const SizedBox(width: 15),
                  GestureDetector(
                      onTap: () {
                        if (chatcontral.text.isNotEmpty) {
                          setState(() {
                            girl = true;
                            if (currenttoken.isNotEmpty) {
                              messages[0]["content"] = currenttoken;
                            }
                            messages.insert(0,
                                {"role": "user", "content": chatcontral.text});

                            chatcontral.clear();
                            doSomeThing(messages);
                            messages.insert(0,
                                {"role": "assistant", "content": "waiting..."});
                          });
                        }
                      },
                      child: Transform.rotate(
                          angle: -3.14 / 2,
                          child: const Icon(Icons.send,
                              size: 30,
                              color: Colors.white,
                              shadows: [
                                BoxShadow(color: Colors.blue, blurRadius: 12)
                              ])))
                ]))
          ]))
    ]);
  }
}
