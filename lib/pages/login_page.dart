import 'dart:convert';

import 'package:capd/utilities/myconfigs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController ctrlTelephone = TextEditingController();
  bool isLogin = false;

  /// ตรวจสอบการเคย Login แล้วหรือไม่
  Future getLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var isLogin = prefs.get('isLogin');

    if (isLogin == 'ok') {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    }
  }

  /// ตรวจสอบเบอร์โทรศัพท์ กับฐานข้อมูล
  Future doLogin({required String telephone}) async {
    String apiCheckAuthen = '${MyConfigs.domain}/login.php?u=$telephone';
    final response = await http.post(Uri.parse(apiCheckAuthen));
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      // print('##### Data : $jsonResponse');
      try {
        String resTelephone = jsonResponse['data'][0]['telephone'];
        if (resTelephone == telephone) {
          print('##### Login Success');
          // เก็บค่าที่ได้จากฐานข้อมูลลง File
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('isLogin', 'ok');
          prefs.setString('telephone', resTelephone);
          Fluttertoast.showToast(
            msg: "เข้าสู่ระบบสำเร็จ !!!",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP_RIGHT,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        }
      } catch (e) {
        print('### Error message : $e');
        final snackBar = SnackBar(
          content: Text(
            'เกิดข้อผิดพลาด : ไม่พบข้อมูลในระบบ',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontFamily: 'Krungthai',
            ),
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).requestFocus(
          FocusNode(),
        ),
        child: Stack(fit: StackFit.expand, children: [
          Container(
            color: Colors.cyan[700],
          ),
          ListView(
            children: [
              const SizedBox(
                height: 20.0,
              ),
              Center(
                child: Center(
                  child: Image(
                    image: MyConfigs.logoImage,
                    width: size * 0.65,
                  ),
                ),
              ),
              Column(
                children: [
                  Text(
                    MyConfigs.appNameEN,
                    style: const TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    MyConfigs.appNameTH,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  const Text(
                    'Version 1.0 | โรงพยาบาลบ้านหมี่',
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber,
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Form(
                      child: Column(
                    children: [
                      SizedBox(
                        width: size * 0.8,
                        child: TextField(
                          controller: ctrlTelephone,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintStyle: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Krungthai',
                              backgroundColor: Colors.white,
                            ),
                            hintText: 'ระบุหมายเลขโทรศัพท์',
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                                borderRadius: BorderRadius.circular(20.0)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                                borderRadius: BorderRadius.circular(20.0)),
                            prefixIcon: Icon(
                              Icons.mobile_friendly,
                              color: MyConfigs.dark,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      SizedBox(
                        width: size * 0.5,
                        height: 50.0,
                        child: ElevatedButton(
                          onPressed: () {
                            if (ctrlTelephone.text.isEmpty) return;
                            doLogin(telephone: ctrlTelephone.text);
                          },
                          child: const Text(
                            'เข้าใช้งาน',
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Krungthai',
                              letterSpacing: 0.6,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ))
                ],
              ),
            ],
          )
        ]),
      ),
    );
  }
}
