import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'phone_auth_screen.dart';
import 'custom_home.dart';
import 'owner_home.dart';
import 'custom_phonenumber.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AuthWrapper(),
      routes: {
        '/home': (context) => CustomHome(nickname: ''), // 초기값으로 빈 문자열
        '/auth': (context) => PhoneAuthScreen(),
        '/ownerhome': (context) => owner_home(),
        '/phone': (context) => ConsumerPhoneNumberScreen(nickname: ''), // 초기값으로 빈 문자열
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData) {
          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance.collection('users').doc(snapshot.data!.uid).get(),
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (userSnapshot.hasData && userSnapshot.data!.exists) {
                final userType = userSnapshot.data!['userType'];
                final consumerNickname = userSnapshot.data!['nickname'];  // Get consumerNickname here
                if (userType == 'consumers') {
                  return CustomHome(nickname: consumerNickname);
                } else if (userType == 'owners') {
                  return owner_home();
                }
              } else {
                return PhoneAuthScreen(); // 회원가입이 안되어 있는 경우
              }
              return PhoneAuthScreen(); // 기본적으로 회원가입 화면으로 이동
            },
          );
        }
        return PhoneAuthScreen(); // 로그인되지 않은 상태면 회원가입 화면으로 이동
      },
    );
  }
}
