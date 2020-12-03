import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:pradipassignment/models/user.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Home Page')),
        body: DropDown(),
      ),
    );
  }
}

class DropDown extends StatefulWidget {
  @override
  DropDownWidget createState() => DropDownWidget();
}

class DropDownWidget extends State {

  // Default Drop Down Item.
  String dropdownValue = 'Team A';

  // To show Selected Item in Text.
  String holder = '' ;

  List <String> actorsName = [
    'Team A',
    'Team B',
  ] ;
  List<User> listModel = [];
  var loading = false;

  Future<Null> getData() async{
    setState(() {
      loading = true;
    });

    final responseData = await http.get("https://jsonplaceholder.typicode.com/users");

    if(responseData.statusCode == 200){
      final data = jsonDecode(responseData.body);
      print(data);
      setState(() {
        for(Map i in data){
          listModel.add(User.fromJson(i));
        }
        loading = false;
      });
    }
  }

  //Panggil Data / Call Data
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }


  void getDropDownItem(){

    setState(() {
      holder = dropdownValue ;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child :
        Column(children: <Widget>[

          DropdownButton<String>(
            value: dropdownValue,
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 24,
            elevation: 16,
            style: TextStyle(color: Colors.red, fontSize: 18),
            underline: Container(
              height: 2,
              color: Colors.deepPurpleAccent,
            ),
            onChanged: (String data) {
              setState(() {
                dropdownValue = data;
              });
            },
            items: actorsName.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),

          Padding(
              padding: EdgeInsets.only(top: 30, bottom: 30),
              child :
              //Printing Item on Text Widget
              Text('Selected Item = ' + '$holder',
                  style: TextStyle
                    (fontSize: 22,
                      color: Colors.black))),

          RaisedButton(
            child: Text('Click Here To Get Selected Item From Drop Down'),
            onPressed: getDropDownItem,
            color: Colors.green,
            textColor: Colors.white,
            padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
          ),

        ]),
      ),
    );
  }
}