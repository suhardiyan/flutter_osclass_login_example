import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loginflutter/AdminPage.dart';
import 'package:loginflutter/MemberPage.dart';
import 'package:loginflutter/RegisterPage.dart';

void main() => runApp(new MyApp());

String username='';
bool login_state;
int user_id;

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login PHP My Admin',     
      home: new MyHomePage(),
      routes: <String,WidgetBuilder>{
        '/AdminPage': (BuildContext context)=> new AdminPage(username: username,),
        '/MemberPage': (BuildContext context)=> new MemberPage(username: username,),
        '/MyHomePage': (BuildContext context)=> new MyHomePage(),
        '/RegisterPage': (BuildContext context)=> new RegisterPage()
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

TextEditingController user=new TextEditingController();
TextEditingController pass=new TextEditingController();

String msg='';

Future<List> _login() async {

  var url = 'http://10.0.2.2/osclass_api/api/login.php';
  
  var data = json.encode({
    'username': user.text,
    'password': pass.text
  });

  var headers = {
    'Content-type' : 'application/json',
    'Accept': 'application/json',
  };

  final response = await http.post(url, body: data, headers: headers);

  var datauser = json.decode(response.body);
  print(response.statusCode);

  if (response.statusCode == 401) {
    setState(() {
          msg="Login Fail";
        });
  } else {
    // if (datauser[0]['level']=='admin') {
    Navigator.pushReplacementNamed(context, '/AdminPage');
    // } else if(datauser[0]['level']=='member') {
    //   Navigator.pushReplacementNamed(context, '/MemberPage');
    // }

    setState(() {
          username = user.text;
          login_state = true;
          user_id= datauser['data']['user_id'];
        });

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
      title: new Text("Login"),
      centerTitle: true,
    );
  }

  Widget _buildTextFields() {
    return new Container(
      child: new Column(
        children: <Widget>[
          new Container(
            child: new TextField(
              controller: user,
              decoration: new InputDecoration(
                labelText: 'Email'
              ),
            ),
          ),
          new Container(
            child: new TextField(
              controller: pass,
              decoration: new InputDecoration(
                labelText: 'Password'
              ),
              obscureText: true,
            ),
          )
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
              child: new Text('Login'),
              onPressed: (){
                _login();
              },
            ),
            new RaisedButton(
              child: new Text('Register'),
              onPressed: (){
                Navigator.pushNamed(context, "/RegisterPage");
              },
            ),
          ],
        ),
      )
    );
  }
}