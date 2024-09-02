import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class owner_home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('사업자 홈 화면'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, '/auth');
            },
          ),
        ],
      ),
      body: Center(
        child: Text(
          '사업자님, 환영합니다!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}