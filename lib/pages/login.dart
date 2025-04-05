
import 'package:agristant/pages/register.dart';
import 'package:agristant/root.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isloading = false;
  bool tiping = false;
  String title = "提示";
  String content = "";
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Stack(children: [
      Container(
        width: width,
        height: height,
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
          Color.fromARGB(255, 248, 236, 236),
          Color.fromARGB(255, 231, 244, 255)
        ], begin: Alignment.bottomLeft, end: Alignment.topRight)),
      ),
      Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(" - 登陆 - ",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            RTextField(
                ispassword: false,
                controller: usernameController,
                label: "用户名",
                width: 280,
                height: 65),
            RTextField(
                ispassword: true,
                controller: passwordController,
                label: "密码",
                width: 280,
                height: 65),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              InkWell(
                  onTap: () {
                    if (usernameController.text.isEmpty ||
                        passwordController.text.isEmpty) {
                      setState(() {
                        tiping = true;
                        title = "提示";
                        content = "所有选项为必填项";
                      });
                    } else {
                      Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Root()));
                      // setState(() {
                      //   isloading = true;
                      // });
                      // loginUser(
                      //         usernameController.text, passwordController.text)
                      //     .then((b) {
                      //   if (b != "登陆成功") {
                      //     setState(() {
                      //       isloading = false;
                      //       tiping = true;
                      //       title = "提示";
                      //       content = b;
                      //     });
                      //   } else {
                      //     Navigator.pushReplacement(
                      //         context,
                      //         MaterialPageRoute(
                      //             builder: (context) => const MyHomePage()));
                      //   }
                      // });
                    }
                  },
                  child: Container(
                      width: 190,
                      height: 40,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(12)),
                      child: Center(
                          child: isloading
                              ? const SizedBox(
                                  width: 25,
                                  height: 25,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  "登  陆",
                                  style: TextStyle(color: Colors.white),
                                )))),
              const SizedBox(width: 10),
              InkWell(
                  onTap: () async {
                    usernameController.text = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Register()),
                        ) ??
                        usernameController.text;
                  },
                  child: Container(
                      width: 80,
                      height: 40,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(12)),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "  注册",
                            style: TextStyle(color: Colors.white, height: 1),
                          ),
                          Icon(Icons.arrow_forward_ios,
                              size: 12, color: Colors.white)
                        ],
                      )))
            ]),
          ]),
      tiping
          ? Container(
              color: Colors.black38,
              child: Center(
                  child: Container(
                      width: 300,
                      height: 150,
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(13)),
                      child: Column(children: [
                        Text(title,
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 10),
                        Expanded(
                            child: Text(content,
                                style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold))),
                        Container(width: 290, height: 1, color: Colors.black38),
                        InkWell(
                            onTap: () {
                              setState(() {
                                tiping = false;
                              });
                            },
                            child: const SizedBox(
                                height: 30, child: Center(child: Text("确定"))))
                      ]))))
          : Container()
    ]));
  }
}


class RTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final double width;
  final double height;
  final bool ispassword;
  const RTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.width,
    required this.height,
    required this.ispassword,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: width,
        height: height,
        child: TextField(
          obscureText: ispassword,
          obscuringCharacter: "●",
            controller: controller,
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              labelText: label,
            )));
  }
}