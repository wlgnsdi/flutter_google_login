// ignore_for_file: avoid_print, library_private_types_in_public_api

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PhoneAuthScreen extends StatefulWidget {
  const PhoneAuthScreen({super.key});

  @override
  _PhoneAuthScreenState createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  String _verificationId = "";

  Future<void> _sendOtp() async {
    await _auth.verifyPhoneNumber(
      phoneNumber: _phoneController.text,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // 자동 인증 (Android에서만 지원)
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        print("인증 실패 : ${e.message}");
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          _verificationId = verificationId;
        });
        print("문자 코드 전송 ${_phoneController.text}");
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        print("코드 인증 만료");
      },
    );
  }

  Future<void> _verifyOtp() async {
    final credential = PhoneAuthProvider.credential(
      verificationId: _verificationId,
      smsCode: _otpController.text,
    );

    try {
      await _auth.signInWithCredential(credential);
      print("로그인 성공");
    } catch (e) {
      print("OTP 코드 에러 : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("전화번호 인증")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: "전화 번호"),
              keyboardType: TextInputType.phone,
            ),
            ElevatedButton(
              onPressed: _sendOtp,
              child: Text("문자 인증 요청"),
            ),
            TextField(
              controller: _otpController,
              decoration: InputDecoration(labelText: "문자 인증 번호"),
              keyboardType: TextInputType.number,
            ),
            ElevatedButton(
              onPressed: _verifyOtp,
              child: Text("인증 처리"),
            ),
          ],
        ),
      ),
    );
  }
}
