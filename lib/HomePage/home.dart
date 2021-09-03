import 'package:flutter/material.dart';
import 'package:stand_by/Password/set_password.dart';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

import '../Search/searchBar.dart';
import '../Folders/new_page.dart';
import '../Password/set_password.dart';
import '../Password/change_password.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(body: new Home()),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int index = 0;
  bool addButton = false;
  bool? _isLoading;
  var nameController = TextEditingController();
  List<String> folderNames = ['university'];
  String searchResult = '';
  bool searchResultExist = false;
  bool isSwitched = false;
  bool setPassword = false;
  int? item;
  bool state = false;
  double posx = 100.0;
  double posy = 100.0;

  _saveList(list) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setStringList("key", list);

    return true;
  }

  _saveSwitchState(state) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("colorSwitch", state);
    return true;
  }

  _getSavedList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getStringList("key") != null)
      folderNames = prefs.getStringList("key")!;
    setState(() {});
  }

  _getSwitchState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isSwitched = prefs.getBool("colorSwitch")!;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    setState(() {});

    _getSavedList();
    _getGotPass();
    _getSwitchState();

    setState(() {});
  }

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

  _getGotPass() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setPassword = prefs.getBool("hasPass")!;
    print(setPassword);
    // return setPassword;
  }

  void floatingAddButtonAddFolder() {
    showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                title: Container(
                    decoration: BoxDecoration(
                        color: Colors.purple[600],
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20))),
                    height: 60,
                    width: 350,
                    // color: Colors.purple[100],
                    child: Center(
                        child: Text("Create new folder",
                            style: TextStyle(color: Colors.white)))),
                titlePadding: EdgeInsets.all(0),
                content: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                          child: TextField(
                              textAlign: TextAlign.center,
                              controller: nameController,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Enter new folder's name",
                                  hintStyle:
                                      TextStyle(color: Colors.purple[800]))))
                    ]),
                actions: [
                  SizedBox(
                      width: 350,
                      child: Center(
                          child: TextButton(
                              style: ButtonStyle(
                                  // backgroundColor: MaterialStateProperty.all(Colors.purple),
                                  ),
                              child: Text(
                                "Ok",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.purple),
                              ),
                              onPressed: () {
                                folderNames += [nameController.text];
                                _saveList(folderNames);
                                nameController.clear();
                                Navigator.pop(context);
                                setState(() {});
                              })))
                ]));
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => Scaffold(
        appBar: AppBar(
            centerTitle: true,
            title: Text(
              "Standby",
              style: TextStyle(color: Colors.purple[800], fontSize: 25),
            ),
            iconTheme: IconThemeData(color: Colors.purple[800]),
            backgroundColor: Colors.transparent,
            elevation: 0),
        backgroundColor: Colors.deepOrange[50],
        body: GestureDetector(
          onTapDown: (TapDownDetails details) => onTapDown(context, details),
          child: Center(
            child: Stack(children: <Widget>[
              // SearchBar(),

              Positioned(
                top: 40,
                right: 15,
                left: 15,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      border: Border.all(
                          color: Colors.purple,
                          width: 2,
                          style: BorderStyle.solid)),
                  // color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          controller: searchController,
                          cursorColor: Colors.black,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.go,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 15),
                              hintText: "Search..."),
                        ),
                      ),
                      TextButton(
                          onPressed: () {
                            searchResultExist =
                                searchForTerm(searchController.text);
                            if (searchResultExist) {
                              item = whichItem(searchController.text);
                              searchController.clear();

                              //dismiss the onscreen keyboard
                              FocusScope.of(context).unfocus();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SearchResult(
                                            folderName: folderNames[item!],
                                            item: item,
                                          )));
                            }
                          },
                          child: Icon(
                            Icons.search,
                            color: Colors.purple[800],
                          ))
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 130,
                left: 20,
                right: 0,
                bottom: 100,
                child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Wrap(
                        spacing: 2,
                        children: List<Widget>.generate(
                            folderNames.length,
                            (i) => Column(children: [
                                  TextButton(
                                    onPressed: null,
                                    onLongPress: () =>
                                        _showPopupMenu(context, i),
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.folder,
                                        color: isSwitched
                                            ? Colors.primaries[Random().nextInt(
                                                Colors.primaries.length)]
                                            : Colors.cyan[300],
                                      ),
                                      iconSize: 90,
                                      onPressed: () =>
                                          navigateToFolderAndWaitForAction(
                                              context, i),
                                    ),
                                  ),
                                  Text(folderNames[i]),
                                ])).toList())),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Visibility(
                    visible: addButton,
                    child: Theme(
                      data: new ThemeData(
                          primaryColor: Colors.purple[400],
                          backgroundColor: Colors.pink),
                      child: TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          fillColor: Colors.pink[100],
                          filled: true,
                          suffixIcon: IconButton(
                            onPressed: () {
                              // addToFolders(nameController.text);
                              nameController.clear();
                              dissAppearTextField();
                            },
                            icon: Icon(Icons.check),
                          ),
                          border: OutlineInputBorder(),
                          hintText: "enter new name",
                        ),
                      ),
                    )),
              )
            ]),
          ),
        ),
        drawer: Drawer(
            child: Container(
          color: Colors.deepOrange[50],
          child: ListView(
            children: [
              DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.purple[800],
                  ),
                  child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Settings",
                        style: TextStyle(fontSize: 30, color: Colors.white),
                      ))),
              Container(
                  // color: Colors.purple[100],
                  child: Column(children: [
                SizedBox(
                  height: 20,
                ),
                ListTile(
                  title: Text("Pass Lock",
                      style: TextStyle(
                        fontSize: 17,
                      )),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              setPassword ? ChangePassWord() : SetPassWord(),
                          // ChangePassWord(),
                        ));
                    _getGotPass();
                  },
                  leading: Icon(Icons.lock, color: Colors.purple[800]),
                ),
                SizedBox(
                  height: 20,
                ),
                ListTile(
                    leading: Icon(Icons.palette_outlined, color: Colors.purple),
                    title: Text("Random Folder Colors",
                        style: TextStyle(fontSize: 17)),
                    trailing: Switch(
                      value: isSwitched,
                      onChanged: (value) {
                        setState(() {
                          isSwitched = value;
                          _saveSwitchState(isSwitched);
                          print(isSwitched);
                        });
                        //to change colors right after switch on/off
                        setState(() {});
                      },
                      activeTrackColor: Colors.purple[400],
                      activeColor: Colors.purple[800],
                    )),
              ]))
            ],
          ),
        )),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Builder(
          builder: (context) => FloatingActionButton(
            child: Icon(
              Icons.add,
              size: 40,
            ),
            focusColor: Colors.purple[100],
            backgroundColor: Colors.purple[600],
            onPressed: () {
              floatingAddButtonAddFolder();
            },
          ),
        ),
      ),
    );
  }

  void onTapDown(BuildContext context, TapDownDetails details) {
    print('${details.globalPosition}');
    final RenderBox box = context.findRenderObject() as RenderBox;
    final Offset localOffset = box.globalToLocal(details.globalPosition);
    setState(() {
      posx = localOffset.dx;
      posy = localOffset.dy;
    });
  }

  void deleteFolder(String name) {
    folderNames.remove(name);
    _saveList(folderNames);
    setState(() {});
  }

  void renameFolder(resultForThename, i) {
    print("$resultForThename");
    folderNames[i] = resultForThename;
    setState(() {});
  }

  navigateToFolderAndWaitForAction(BuildContext context, i) async {
    final resultForTheFile = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Files(folderNames[i])),
    );
    // final resultForTheFile = await Navigator.pushNamed(context, '/folder',);
    print('$resultForTheFile');
    if (resultForTheFile == 'Delete') {
      deleteFolder(folderNames[i]);
    } else {
      renameFolder(resultForTheFile, i);
    }
  }

  _showPopupMenu(context, i) {
    showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(0.0, posy, posx,
          0.0), //position where you want to show the menu on screen

      items: [
        PopupMenuItem<String>(child: const Text('Delete'), value: 'delete'),
        PopupMenuItem<String>(child: const Text('Rename'), value: 'rename'),
      ],
      elevation: 8.0,
    ).then<void>((String? itemSelected) {
      if (itemSelected == null) return;

      if (itemSelected == "delete") {
        showAlertBeforeFolderDeletion(i);
      } else if (itemSelected == "rename") {
        renameFolderOnLongPress(i);
      }
    });
  }

  showAlertBeforeFolderDeletion(i) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Delete'),
        content: const Text('Are you sure you want to delete ?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context, 'Cancel');
              setState(() {});
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              deleteFolderOnLongPress(i);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  _showDeleteSnackBar(String message, i, deletedFolderName) {
    final snackBar = SnackBar(
      content: Text(message),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          restoreFolderWithUndoAfterDeletion(i, deletedFolderName);
        },
      ),
    );

    // Find the ScaffoldMessenger in the widget tree
    // and use it to show a SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  _showRestoreSnackBar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  restoreFolderWithUndoAfterDeletion(i, deletedFolderName) {
    String msg = "Folder ${deletedFolderName} is now successfully restored";
    folderNames.insert(i, deletedFolderName);
    _showRestoreSnackBar(msg);
    _saveList(folderNames);
    setState(() {});
  }

  void deleteFolderOnLongPress(i) {
    String msg = "Folder ${folderNames[i]} is now successfully deleted";
    String deletedFolderName = folderNames[i];
    _showDeleteSnackBar(msg, i, deletedFolderName);
    folderNames.removeAt(i);
    print("heeeeeeeeeereeeee$posx, $posy");
    _saveList(folderNames);
    Navigator.pop(context);
    setState(() {});
  }

  final newFolderNameController = TextEditingController();

  void renameFolderOnLongPress(i) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Center(child: Text('Rename')),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                child: TextField(
              controller: newFolderNameController,
              decoration: InputDecoration(
                  border: InputBorder.none, hintText: 'enter new name'),
            ))
          ],
        ),
        actions: <Widget>[
          SizedBox(
            width: 350,
            child: Center(
                child: TextButton(
              child: Text('Ok'),
              onPressed: () {
                folderNames[i] = newFolderNameController.text;
                _saveList(folderNames);
                newFolderNameController.clear();
                Navigator.pop(context);
                setState(() {});
              },
            )),
          )
        ],
      ),
    );
  }

  bool searchForTerm(String term) {
    print(folderNames);
    if (folderNames.contains(term)) {
      searchResult = term;
      return true;
    }
    searchResult = '';
    return false;
  }

  whichItem(String term) {
    item = folderNames.indexOf(term);
    return item;
  }
}
