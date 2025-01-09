import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class NaverLoginPage extends StatefulWidget {
  const NaverLoginPage({super.key});

  @override
  State<NaverLoginPage> createState() => _NaverLoginPageState();
}

class _NaverLoginPageState extends State<NaverLoginPage> {
  String name = '';

  Future<UserCredential> signInWithNaver() async {
    final clientState = Uuid().v4();
    final url = Uri.https('nid.naver.com', '/oauth2.0/authorize', {
      'response_type': 'code',
      'client_id': '',
      'redirect_uri': '',
      'state': clientState,
    });

    final result = await FlutterWebAuth2.authenticate(
        url: url.toString(), callbackUrlScheme: "webauthcallback");
    final body = Uri.parse(result).queryParameters;

    final tokenUrl = Uri.https('nid.naver.com', '/oauth2.0/token', {
      'grant_type': 'authorization_code',
      'client_id': '',
      'client_secret': '',
      'code': body["code"],
      'state': clientState,
    });
    var responseTokens = await http.post(tokenUrl);
    Map<String, dynamic> bodys = json.decode(responseTokens.body);

    var response = await http
        .post(Uri.parse(''), body: {"accessToken": bodys['access_token']});

    return FirebaseAuth.instance.signInWithCustomToken(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          TextButton(
            onPressed: () async {
              UserCredential userCredential = await signInWithNaver();
              setState(() {
                name = userCredential.user?.displayName ?? "";
              });
            },
            child: Text('Naver Login'),
          ),
          TextButton(
              onPressed: () async {
                await FlutterNaverLogin.logOut();
                setState(() {
                  name = '';
                });
              },
              child: Text('Naver Logout')),
          Text(name, style: TextStyle(fontSize: 20, color: Colors.white)),
        ],
      ),
    );
  }
}
