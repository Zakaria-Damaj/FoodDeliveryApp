import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'login_page.dart';

const String _baseURL = 'https://zakdeliveryapp.000webhostapp.com';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController cusername = TextEditingController();
  TextEditingController cname = TextEditingController();
  TextEditingController cpassword = TextEditingController();

  void update(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 40),
          height: MediaQuery.of(context).size.height - 50,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(
                    "Sign up",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Create an account, It's free",
                    style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  makeInput(label: "Username", controller: cusername),
                  makeInput(label: "Name", controller: cname),
                  makeInput(label: "Password", controller: cpassword, obscureText: true),
                  makeInput(label: "Confirm Password", obscureText: true),
                ],
              ),
              Container(
                padding: EdgeInsets.only(top: 20),
                child: ElevatedButton(
                  onPressed: () {
                    signupUser(
                      update,
                      cusername.text,
                      cname.text,
                      cpassword.text,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.greenAccent,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: Center(
                      child: Text(
                        "Sign up",
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Already have an account?"),
                  Text(
                    " Login",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget makeInput({label, controller, obscureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black87),
        ),
        SizedBox(height: 5),
        TextField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
            border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }



  void signupUser(Function(String text) update, String username, String name, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseURL/signup.php'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: convert.jsonEncode(<String, String>{
          'username': username,
          'name': name,
          'password': password,
          'key': 'your_key',
        }),
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        update(response.body);

        if (response.body == 'Signup successful') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        }
      }
    } catch (e) {
      update(e.toString());
    }
  }
}
