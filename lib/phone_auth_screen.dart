import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'signupselect.dart';

class PhoneAuthScreen extends StatefulWidget {
  @override
  _PhoneAuthScreenState createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();

  String _verificationId = '';
  bool _isCodeSent = false;
  bool _isButtonEnabled = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  void _verifyPhoneNumber() async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: '+82' + _phoneController.text.trim().substring(1),
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
          if (mounted) {
            _navigateToSignupSelect();
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          if (e.code == 'invalid-phone-number') {
            print('유효하지 않은 전화번호입니다.');
          }
          print('인증 실패: ${e.message}');
        },
        codeSent: (String verificationId, int? resendToken) {
          if (mounted) {
            setState(() {
              _verificationId = verificationId;
              _isCodeSent = true;
            });
          }
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          if (mounted) {
            setState(() {
              _verificationId = verificationId;
            });
          }
        },
      );
    } catch (e) {
      print('전화번호 인증 실패: $e');
    }
  }

  void _signInWithPhoneNumber() async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: _codeController.text.trim(),
      );
      await _auth.signInWithCredential(credential);
      if (mounted) {
        _navigateToSignupSelect();
      }
    } catch (e) {
      print('로그인 실패: $e');
    }
  }

  void _navigateToSignupSelect() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => Signupselect(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('전화번호 인증')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: '전화번호',
                hintText: '010-1111-1111',
              ),
              keyboardType: TextInputType.phone,
              onChanged: (value) {
                setState(() {
                  _isButtonEnabled = value.trim().length == 11;
                });
              },
            ),
            if (_isCodeSent) ...[
              SizedBox(height: 16.0),
              TextField(
                controller: _codeController,
                decoration: InputDecoration(
                  labelText: '인증번호',
                  hintText: '인증번호 입력',
                ),
                keyboardType: TextInputType.number,
              ),
            ],
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _isButtonEnabled
                  ? _isCodeSent ? _signInWithPhoneNumber : _verifyPhoneNumber
                  : null,
              child: Text(_isCodeSent ? '인증번호 확인' : '인증번호 발송'),
            ),
          ],
        ),
      ),
    );
  }
}