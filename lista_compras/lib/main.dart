import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List _buyList = [];
  Map<String, dynamic> _lastRemoved;
  int _lastRemovedPos;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _readData().then((data) {
      setState(() {
        _buyList = json.decode(data);
      });
    });
  }

  Future<Null> _refresh() async {
     await Future.delayed(Duration(seconds: 1));
     setState(() {
       _buyList.sort((a,b){
         if(a["ok"] && !b["ok"]) return 1;
         else if(!a["ok"] && b["ok"]) return -1;
         else return 0;
       });
       _saveData();
     });
    return null;
  }

  final itemBuyController = TextEditingController();
  void _addBuyItem() {
    setState(() {
      Map<String, dynamic> newBuyItem = Map();
      newBuyItem["title"] = itemBuyController.text;
      itemBuyController.text = "";
      newBuyItem["ok"] = false;
      _buyList.add(newBuyItem);
      _saveData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Lista de Compras",
          style: TextStyle(color: Colors.red),
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(17.0, 3.0, 7.0, 3.0),
            child: Row(
              children: <Widget>[
                Expanded(
                    child: TextField(
                  decoration: InputDecoration(
                    labelText: "Novo item",
                    hoverColor: Colors.red,
                    labelStyle: TextStyle(color: Colors.black),
                    focusColor: Colors.black,
                    fillColor: Colors.red,
                  ),
                  cursorColor: Colors.red,
                  controller: itemBuyController,
                )),
                RaisedButton(
                  color: Colors.black,
                  child: Text("Add"),
                  textColor: Colors.redAccent,
                  onPressed: _addBuyItem,
                )
              ],
            ),
          ),
          Expanded(

            child: RefreshIndicator(onRefresh: _refresh,
            child: ListView.builder(
              padding: EdgeInsets.only(top: 10),
              itemCount: _buyList.length,
              itemBuilder: buildItem,
            ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildItem(context, index) {
    return Dismissible(
      key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
      background: Container(
        color: Colors.red,
        child: Align(
          alignment: Alignment(-0.9, 0.0),
          child: Icon(
            Icons.delete,
            color: Colors.black,
          ),
        ),
      ),
      direction: DismissDirection.startToEnd,
      child: CheckboxListTile(
        title: Text(_buyList[index]["title"]),
        value: _buyList[index]["ok"],
        activeColor: Colors.black,
        checkColor: Colors.red,
        secondary: CircleAvatar(
          backgroundColor: Colors.black,
          child: Icon(
            _buyList[index]["ok"] ? Icons.check : Icons.error,
            color: Colors.red,
          ),
        ),
        onChanged: (check) {
          setState(() {
            _buyList[index]["ok"] = check;
            _saveData();
          });
        },
      ),
      onDismissed:(direction){
        setState(() {
          _lastRemoved  = Map.from(_buyList[index]);
          _lastRemovedPos = index;
          _buyList.removeAt(index);
          _saveData();
          final snackBar = SnackBar(
            content: Text("Tarefa, ${_lastRemoved["title"]} removido com sucesso."),
            action: SnackBarAction(label: "Desfazer", onPressed: (){
            setState(() {
              _buyList.insert(_lastRemovedPos, _lastRemoved);
              _saveData();
            });
            }),
            duration: Duration(seconds: 3),
          );
          Scaffold.of(context).showSnackBar(snackBar);
        });
      },
    );
  }

  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();

    return File("${directory.path}/data.json");
  }

  Future<File> _saveData() async {
    String data = json.encode(_buyList);
    final file = await _getFile();
    return file.writeAsString(data);
  }

  Future<String> _readData() async {
    try {
      final file = await _getFile();
      print(file);
      return file.readAsString();
    } catch (ex) {
      return null;
    }
  }
}
