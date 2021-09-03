import 'package:flutter/material.dart';
import 'package:stand_by/Folders/new_page.dart';


class SearchResult extends StatefulWidget {
  String? folderName;
  int? item;
  SearchResult({Key? key, @required this.folderName, this.item})
      : super(key: key);

  @override
  _SearchResultState createState() => _SearchResultState(folderName!, item);
}

class _SearchResultState extends State<SearchResult> {
  TextEditingController searchController = TextEditingController();
  String folderName;
  int? item;

  _SearchResultState(this.folderName, this.item);

  @override
  Widget build(BuildContext context) { 
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.deepOrange[50],
        body: Stack(
          children: [
            // SizedBox(height: 50,),
            Positioned(
              top: 40,
              left: 10,
              right: 5,
              // top: 10,
              child: Container(
                width: 400,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    border: Border.all(
                        color: Colors.purple,
                        width: 2,
                        style: BorderStyle.solid)),
                child: Row(
                  children: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.purple[800],
                        )),
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
                            hintText: folderName),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              top: 200,
              left: 20,
              // right: 5,
                child: Column(
              children: [
                IconButton(icon: Icon(Icons.folder, color: Colors.purple,),
                iconSize: 80,
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Files(folderName)))) ,
                Text(folderName),
              ],
            ))
            
          ],
        ),
      ),
    );
  }
}
