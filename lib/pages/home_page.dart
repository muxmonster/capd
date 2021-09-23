import 'package:capd/utilities/myconfigs.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            splashRadius: 2.0,
            onPressed: () {},
            icon: const Icon(
              Icons.exit_to_app,
              color: Colors.red,
            ),
          ),
        ],
        backgroundColor: MyConfigs.darker,
        title: const Text(
          'หน้าหลัก',
          style: TextStyle(
              fontFamily: 'Krungthai',
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 0.6),
        ),
      ),
      body: Text('data'),
    );
  }
}
