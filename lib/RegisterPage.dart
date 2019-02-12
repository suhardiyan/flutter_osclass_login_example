import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new RegisterScreenState();
  }
}

class RegisterScreenState extends State<RegisterPage> {

  TextEditingController name=new TextEditingController();
  TextEditingController username=new TextEditingController();
  TextEditingController password=new TextEditingController();
  TextEditingController email=new TextEditingController();
  TextEditingController website=new TextEditingController();
  TextEditingController phone=new TextEditingController();
  TextEditingController country=new TextEditingController();

  String msg='';

  Future<List> _register() async {

    var url = 'http://10.0.2.2/osclass_api/api/register.php';
    
    var data = json.encode({
      'name': name.text,
      'username': username.text,
      'password': password.text,
      'email': email.text,
      'website': website.text,
      'phone': phone.text,
      'country': country.text
    });

    var headers = {
      'Content-type' : 'application/json',
      'Accept': 'application/json',
    };

    final response = await http.post(url, body: data, headers: headers);

    var datauser = json.decode(response.body);

    if (response.statusCode == 401) {
      setState(() {
            msg="Register Fail";
          });
    } else {
      // if (datauser[0]['level']=='admin') {
      Navigator.pushReplacementNamed(context, '/MyHomePage');
      // } else if(datauser[0]['level']=='member') {
      //   Navigator.pushReplacementNamed(context, '/MemberPage');
      // }

      // setState(() {
      //       username = email.text;
      //       login_state = true;
      //       user_id= datauser['data']['user_id'];
      //     });

    }

    return datauser;
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: _buildBar(context),
      body: new Container(
        padding: EdgeInsets.all(16.0),
        child: new Column(
          children: <Widget>[
            _buildTextFields(),
            _buildButtons(),
            Text(msg,style: TextStyle(fontSize: 20.0,color: Colors.red),),
          ],
        ),
      ),
    );
  }

  Widget _buildBar(BuildContext context) {
    return new AppBar(
      title: new Text("Register"),
      centerTitle: true,
    );
  }

  Widget _buildTextFields() {
    return new Container(
      child: new Column(
        children: <Widget>[
          new Container(
            child: new TextField(
              controller: name,
              decoration: new InputDecoration(
                labelText: 'Name'
              ),
            ),
          ),
          new Container(
            child: new TextField(
              controller: username,
              decoration: new InputDecoration(
                labelText: 'Username'
              ),
            ),
          ),
          new Container(
            child: new TextField(
              controller: password,
              decoration: new InputDecoration(
                labelText: 'Password'
              ),
              obscureText: true,
            ),
          ),
          new Container(
            child: new TextField(
              controller: email,
              decoration: new InputDecoration(
                labelText: 'Email'
              ),
            ),
          ),
          new Container(
            child: new TextField(
              controller: website,
              decoration: new InputDecoration(
                labelText: 'Website'
              ),
            ),
          ),
          new Container(
            child: new TextField(
              controller: phone,
              decoration: new InputDecoration(
                labelText: 'Phone'
              ),
            ),
          ),
          new Container(
            child: new TextField(
              controller: country,
              decoration: new InputDecoration(
                labelText: 'Country'
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtons() {
    return new Container(
      child: Center(
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            new RaisedButton(
              child: new Text('Submit'),
              onPressed: (){
                _register();
              },
            ),
          ],
        ),
      )
    );
  }
}