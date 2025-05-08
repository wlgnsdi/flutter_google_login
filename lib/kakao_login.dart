import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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

      var provider = OAuthProvider(dotenv.get('KAKAO_OIDC_ID'));
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
      debugPrint('카카오계정으로 로그인 실패 $error');
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
                TextButton(
                    onPressed: _kakaoLogin,
                    child: Text('카카오 로그인',
                        style: TextStyle(fontSize: 30, color: Colors.white)))
              ])
            : Column(
                children: [
                  Text('카카오 유저 정보 : $name'),
                  TextButton(
                      onPressed: _signOut,
                      child: Text(
                        '카카오 로그아웃',
                        style: TextStyle(fontSize: 20),
                      )),
                ],
              ));
  }
}
