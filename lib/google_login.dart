import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleLogin extends StatefulWidget {
  const GoogleLogin({super.key});

  @override
  State<GoogleLogin> createState() => _GoogleLoginState();
}

class _GoogleLoginState extends State<GoogleLogin> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  bool isLogin = false;
  User? currentUser;

  Future<void> signInWithGoogle() async {
    try {
      // Google Sign-In 시작
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // 사용자가 로그인 취소
        return;
      }

      // Google 인증 정보 가져오기
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Firebase 에서 Google 사용자를 인증하기 위해서 GoogleAuthProvider.credential() 사용하여
      // Firebase 인증자격(AuthCredential) 생성
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // FirebaseAuth 로 생성된 Firebase 인증자격을 사용하여 계정을 생성하거나 로그인 진행
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      // 사용자가 신규 사용자인지 확인
      final bool isNewUser =
          userCredential.additionalUserInfo?.isNewUser ?? false;

      if (user != null) {
        if (isNewUser) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('환영합니다, 새로운 사용자 ${user.displayName}!')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('다시 오신 것을 환영합니다, ${user.displayName}!')),
          );
        }

        setState(() {
          currentUser = user;
          isLogin = true;
        });
      }
    } catch (e) {
      print('Google Sign-In Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('로그인에 실패했습니다. 다시 시도해주세요.')),
      );
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('로그아웃 되었습니다.')),
    );
    setState(() {
      currentUser = null;
      isLogin = false;
    });
  }

  void _checkExistingSession() {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // 사용자가 이미 로그인 상태인 경우
      setState(() {
        isLogin = true;
        currentUser = user;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _checkExistingSession();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Google Sign-In : ${currentUser?.displayName ?? ''}',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            !isLogin
                ? ElevatedButton(
                    onPressed: signInWithGoogle,
                    child: const Text('Google 로그인'),
                  )
                : ElevatedButton(
                    onPressed: signOut,
                    child: const Text('로그아웃'),
                  ),
          ],
        ),
      ),
    );
  }
}
