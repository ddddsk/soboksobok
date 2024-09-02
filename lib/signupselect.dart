import 'package:flutter/material.dart';
import 'custom_notification.dart';
import 'owner_notification.dart';

class Signupselect extends StatelessWidget {
  void _selectUserType(BuildContext context, String userType) {
    if (userType == 'consumers') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => customServiceAgreement()),
      );
    } else if (userType == 'owners') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => TermsOfServiceAgreement()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: Text('소복소복', style: Theme.of(context).textTheme.headlineLarge),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white,
        height: double.infinity,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () => _selectUserType(context, 'consumers'),
                icon: Icon(Icons.person_add, color: Colors.black, size: 30),
                label: Text('소비자 회원가입', style: Theme.of(context).textTheme.labelLarge),
                style: ElevatedButton.styleFrom(
                  elevation: 10,
                  shadowColor: Colors.black,
                  backgroundColor: Colors.lightBlue[200],
                  padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 60.0),
                ),
              ),
              SizedBox(height: 50),
              ElevatedButton.icon(
                onPressed: () => _selectUserType(context, 'owners'),
                icon: Icon(Icons.business, color: Colors.black, size: 30),
                label: Text('사업자 회원가입', style: Theme.of(context).textTheme.labelLarge),
                style: ElevatedButton.styleFrom(
                  elevation: 10,
                  shadowColor: Colors.black,
                  backgroundColor: Colors.lightGreen[200],
                  padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 60.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}