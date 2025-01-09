import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

class KakaoLogin extends StatefulWidget {
  const KakaoLogin({super.key});

  @override
  State<KakaoLogin> createState() => _KakaoLoginState();
}

class _KakaoLoginState extends State<KakaoLogin> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLogin = false;
  String name = '';

  void _kakaoLogin() async {
    try {
      OAuthToken token = await UserApi.instance.loginWithKakaoAccount();

      var provider = OAuthProvider('oidc.kakao_login'); // 제공업체 id
      var credential = provider.credential(
        idToken: token.idToken,
        accessToken: token.accessToken,
      );
      _auth.signInWithCredential(credential);

      var user = await UserApi.instance.me();

      if (context.mounted) {
        setState(() {
          name = user.kakaoAccount?.profile?.nickname ?? '';
          isLogin = true;
        });
      }
    } catch (error) {
      print('카카오계정으로 로그인 실패 $error');
    }
  }

  Future<void> _signOut() async {
    await UserApi.instance.logout();
    await _auth.signOut();

    setState(() {
      isLogin = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: !isLogin
            ? Column(children: [
                TextButton(onPressed: _kakaoLogin, child: Text('Kakao Login', style: TextStyle(fontSize: 30, color: Colors.white)))
              ])
            : Column(
                children: [
                  Text('Kakao User Info : ${name}'),
                  TextButton(onPressed: _signOut, child: Text('Kakao Logout', style: TextStyle(fontSize: 20),)),
                ],
              ));
  }
}
