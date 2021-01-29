import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WebService {
  Future<dynamic> searchUser(String username) async {
      final String apiUrl = "https://api.github.com/users/${username}";
      var result = await http.get(apiUrl);
      return json.decode(result.body);
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController usernameController;
  WebService service = WebService();
  bool isLoading = false;
  String image = "https://image.flaticon.com/icons/png/512/25/25231.png";
  String bio="";
  @override
  void initState() {
    usernameController = TextEditingController();
    super.initState();
  }
@override
  void dispose() {
    usernameController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          child: Column(
            children:[
              Text("Github API"),
              if (isLoading)
                LinearProgressIndicator(
                  backgroundColor: Colors.white,
                  valueColor:AlwaysStoppedAnimation<Color>(Colors.black),
                )
            ],
          ),
        ),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Container(
            margin: EdgeInsets.all(30),
            child: ListView(
              children:[ Column(
                children: [
                  Container(
                    margin: EdgeInsets.all(30),
                    child: Image.network(
                      this.image,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    child: Text(this.bio),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: TextField(
                      style: TextStyle(
                          color: Colors.black
                      ),
                      controller: usernameController,
                      decoration: InputDecoration(
                        labelText: "Enter your github user",
                        enabledBorder:  OutlineInputBorder(
                          borderRadius:  BorderRadius.circular(25.0),
                          borderSide:  BorderSide(color: Colors.black ),
                        ),
                        focusedBorder:  OutlineInputBorder(
                          borderRadius:  BorderRadius.circular(25.0),
                          borderSide:  BorderSide(color: Colors.black ),
                        ),
                        labelStyle: TextStyle(
                            color: Colors.black
                        ),

                      ),

                    ),
                  ),

                  FlatButton(onPressed: searchProfile
                    , child: Text("Search",style: TextStyle(
                    color: Colors.black
                  ),))
                ],
              ),]
            ),
          )
      ),
    );
  }

  searchProfile() async {
    setLoading();
    var user = await this.service.searchUser(this.usernameController.text);
    if (user['message'] != "Not Found"){
      print(user['login']);
      setState(() {
        image = user['avatar_url'];
        bio = user['bio'] != null ? user['bio'] : "Sin bio :(";
      });
    }
    setLoading();
  }
  setLoading(){
    setState(() {
      isLoading = !this.isLoading;
    });
  }
}

