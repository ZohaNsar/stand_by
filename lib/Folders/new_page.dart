import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:open_file/open_file.dart';

class Files extends StatefulWidget {
  final String name;
  String? newName;
  Files(this.name, [this.newName]);

  @override
  _FilesState createState() => _FilesState(name, newName);
}

class _FilesState extends State<Files> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String? _fileName;
  List<PlatformFile>? _paths;
  String? _directoryPath;
  // String? _extension;
  bool _loadingPath = false;
  bool _multiPick = true;
  FileType _pickingType = FileType.custom;
  TextEditingController _controller = TextEditingController();
  List<String> paths = [];
  List<String> names = [];
  List<String> extensions = [];
  bool? _isLoading;
  String? newName = "";
  String name;

  _FilesState(this.name, [this.newName]);

  void _openFileExplorer() async {
    setState(() => _loadingPath = true);
    try {
      _directoryPath = null;
      _paths = (await FilePicker.platform.pickFiles(
        type: _pickingType,
        allowMultiple: _multiPick,
        onFileLoading: (FilePickerStatus status) => print(status),
        allowedExtensions: ['jpg', 'pdf', 'docx', 'mp3', 'mp4', 'txt', 'zip'],
      ))
          ?.files;
      if (_paths != null) {
        for (var i = 0; i < _paths!.length; i++) {
          PlatformFile file = _paths![i];
          paths.add(file.path);
          names.add(file.name.toString());
          extensions.add(file.extension!);
        }
        _saveList(paths, names, extensions);
      }
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    } catch (ex) {
      print(ex);
    }
    if (!mounted) return;
    setState(() {
      _loadingPath = false;
      _fileName =
          _paths != null ? _paths!.map((e) => e.name).toString() : '...';
    });
  }

  _saveList(paths, names, extensions) async {
    // print("this is the saved paths : ${paths}");
    print("this is the saved names : $names");
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setStringList("${name}_paths", paths);
    prefs.setStringList("${name}_names", names);
    prefs.setStringList("${name}_ext", extensions);
    return true;
  }

  _getSavedList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getStringList("${name}_paths") != null)
      paths = prefs.getStringList("${name}_paths")!;
    if (prefs.getStringList("${name}_names") != null)
      names = prefs.getStringList("${name}_names")!;
    if (prefs.getStringList("${name}_ext") != null)
      extensions = prefs.getStringList("${name}_ext")!;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _isLoading = true;
    });
    _getSavedList();
    setState(() {});
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.deepOrange[50],
        key: _scaffoldKey,
        appBar: AppBar(
          actions: [
            PopupMenuButton(
              icon: Icon(Icons.more_vert),
              onSelected: (String result) {
                switch (result) {
                  case 'Delete':
                    showAlertBeforeFileDeletion();
                    break;
                  case 'Rename':
                    renameFolder();
                    break;
                  default:
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'Delete',
                  child: Text('Delete'),
                ),
                const PopupMenuItem<String>(
                  value: 'Rename',
                  child: Text('Rename'),
                ),
              ],
            ),
          ],
          title: Text(name),
          backgroundColor: Colors.purple[800],
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, name),
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                    top: 20.0,
                    bottom: 20.0,
                  ),
                  child: Column(
                    children: <Widget>[
                      IconButton(
                          icon: Icon(
                            Icons.add,
                            size: 40,
                          ),
                          onPressed: () => _openFileExplorer())
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                SingleChildScrollView(
                  child: Builder(
                    builder: (BuildContext context) => _loadingPath
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: const CircularProgressIndicator(),
                          )
                        : paths.isNotEmpty
                            ? Container(
                                // padding: const EdgeInsets.only(bottom: 10.0),
                                height: MediaQuery.of(context).size.height * 2,
                                child: Scrollbar(
                                    child: Wrap(
                                  children: List<Widget>.generate(
                                      paths.length,
                                      (i) => ListTile(
                                          title: Text(names[i]),
                                          leading: extensions[i] == 'pdf'
                                              ? Icon(
                                                  Icons.picture_as_pdf,
                                                  size: 40,
                                                  color: Colors.purple[800],
                                                )
                                              : extensions[i] == 'jpg'
                                                  ? Icon(
                                                      Icons.image,
                                                      size: 40,
                                                      color: Colors.amber[500],
                                                    )
                                                  : extensions[i] == 'docx'
                                                      ? Icon(
                                                          Icons.description,
                                                          size: 40,
                                                          color: Colors.cyan,
                                                        )
                                                      : extensions[i] == 'mp3'
                                                          ? Icon(
                                                              Icons.mic,
                                                              size: 40,
                                                              color:
                                                                  Colors.pink,
                                                            )
                                                          : extensions[i] ==
                                                                  'zip'
                                                              ? Icon(
                                                                  Icons.source,
                                                                  size: 40,
                                                                  color: Colors
                                                                          .blue[
                                                                      600])
                                                              : Icon(
                                                                  Icons.movie,
                                                                  size: 40,
                                                                ),
                                          onTap: () async {
                                            print("hye");
                                            var _result =
                                                await OpenFile.open(paths[i]);
                                          },
                                          trailing: IconButton(
                                            color: Colors.grey,
                                            icon: Icon(
                                              Icons.delete,
                                            ),
                                            onPressed: () {
                                              showAlertBeforeFileDeletion(i);
                                            },
                                          ))),
                                )),
                              )
                            : const SizedBox(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  showDropDownMenu() {
    String dropdownValue = 'one';
    DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? newValue) {
        setState(() {
          dropdownValue = newValue!;
        });
      },
      items: <String>['One', 'Two', 'Free', 'Four']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  showAlertBeforeFileDeletion([i]) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Delete'),
        content: const Text('Are you sure you want to delete ?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              i != null ? alertForFileDeletion(i) : alertForFolderDeletion();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  alertForFileDeletion(i) {
    names.removeAt(i);
    paths.removeAt(i);
    extensions.removeAt(i);
    _saveList(paths, names, extensions);
    Navigator.pop(context, 'OK');
    setState(() {});
  }

  void alertForFolderDeletion() {
    deleteFolder();
  }

  void deleteFolder() {
    paths.clear();
    names.clear();
    extensions.clear();
    _saveList(paths, names, extensions);
    setState(() {});
    Navigator.pop(
      context,
    );
    //get back to the home page
    Navigator.pop(context, 'Delete');
  }

  final newFolderNameController = TextEditingController();

  void renameFolder() {
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
            child: Center(
                child: Text(
              'Rename',
              style: TextStyle(color: Colors.white),
            ))),
        titlePadding: EdgeInsets.all(0),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                child: TextField(
              textAlign: TextAlign.center,
              controller: newFolderNameController,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'enter new folder name',
                  hintStyle: TextStyle(color: Colors.purple[800])),
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
                name = newFolderNameController.text;
                _saveList(paths, names, extensions);
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
}
