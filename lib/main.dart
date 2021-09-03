import 'package:flutter/material.dart';
import 'package:stand_by/Password/passlock_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'HomePage/home.dart';


void main() async {
  runApp(MyStatefulWidget());
  // await FolderPreferences.init();
}

/// This is the main application widget.
// class MyApp extends StatelessWidget {
//   // final String? value;
//   // const MyApp({Key? key, this.value}) : super(key: key);
//   static const String _title = 'Flutter Code Sample';

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: _title,
//       home: Scaffold(
//         body: Center(
//           child: MyStatefulWidget(),
//         ),
//       ),
//     );
//   }
// }

// double _volume = 0.0;
bool setPassword = false;

/// This is the stateful widget that the main application instantiates.
class MyStatefulWidget extends StatefulWidget {
  // final String? text;
  // const MyStatefulWidget({Key? key, this.text}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int index = 0;
  bool addButton = false;
  bool? _isLoading;
  var nameController = TextEditingController();
  // List<String> folderNames = ['university'];

  _getGotPass() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setPassword = prefs.getBool("hasPass")!;
    return setPassword;
  }

  // @override
  // void initState() {
  //   super.initState();
  //   setState(() {
  //     _isLoading = true;
  //   });
  //   // setPassword = await _getGotPass();
  //   _getGotPass();

  //   setState(() {
  //     _isLoading = false;
  //   });
  // }

  void appearTextField() {
    setState(() {
      addButton = true;
    });
  }

  void dissAppearTextField() {
    setState(() {
      addButton = false;
    });
  }

  String? name;
  List<String> folderNames = [];
  int? item; 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //future builder is needed for getting the result of getGotPassword result in bool which is in type Future<bool> and decide
      //the navigation based on setPassword
      home: FutureBuilder(
          future: _getGotPass(),
          builder: (context, snapshot) {
            print(snapshot);
            if (snapshot.hasData & (snapshot.data == true)) {
              return PassLockScreen();
            }
            return Home();
          }),
      // initialRoute: '/',
      
    );
  }
}
