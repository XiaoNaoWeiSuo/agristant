import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool isloading = false;
  bool tiping = false;
  String title = "提示";
  String content = "";

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
            const Text(" - 注册 - ",
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
            RTextField(
                ispassword: true,
                controller: confirmPasswordController,
                label: "确认密码",
                width: 280,
                height: 65),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              InkWell(
                  onTap: () {
                    if (usernameController.text.isEmpty ||
                        passwordController.text.isEmpty ||
                        confirmPasswordController.text.isEmpty) {
                      setState(() {
                        tiping = true;
                        title = "提示";
                        content = "所有选项为必填项";
                      });
                    } else {
                      Navigator.pop(context, usernameController.text);
                      // setState(() {
                      //   isloading = true;
                      // });
                      // setState(() {
                      //   isloading = false;
                      //   tiping = true;
                      //   title = "提示";
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
                                  "注  册",
                                  style: TextStyle(color: Colors.white),
                                )))),
              const SizedBox(width: 10),
              InkWell(
                  onTap: () {
                    Navigator.pop(context);
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
                            Icon(Icons.arrow_back_ios_new,
                                size: 12, color: Colors.white),
                            Text("登陆  ",
                                style:
                                    TextStyle(color: Colors.white, height: 1))
                          ])))
            ])
          ]),
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
