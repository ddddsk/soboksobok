import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'custom_home.dart';

class ConsumerPhoneNumberScreen extends StatefulWidget {
  final String nickname;

  ConsumerPhoneNumberScreen({required this.nickname});

  @override
  _ConsumerPhoneNumberScreenState createState() => _ConsumerPhoneNumberScreenState();
}

class _ConsumerPhoneNumberScreenState extends State<ConsumerPhoneNumberScreen> {
  final TextEditingController _phoneController = TextEditingController();
  bool _isButtonEnabled = false;

  void _savePhoneNumber() async {
    String phoneNumber = _phoneController.text.trim();

    if (phoneNumber.isNotEmpty && phoneNumber.length == 11) {
      await FirebaseFirestore.instance.collection('consumers').doc(widget.nickname).set({
        'phoneNumber': phoneNumber,
      }, SetOptions(merge: true));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('전화번호가 저장되었습니다.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('전화번호를 입력하세요.')),
      );
    }
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CustomHome(nickname: widget.nickname)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('연락처'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "마지막으로 연락처를 입력해주세요. 컨택이 되면 이 번호로 사업자에게 연락이 옵니다",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
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
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isButtonEnabled ? _savePhoneNumber : null,
              child: Text('가입완료'),
            ),
          ],
        ),
      ),
    );
  }
}