import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'owner_blackwhite.dart';

class OwnerNickname extends StatefulWidget {
  @override
  State<OwnerNickname> createState() => _OwnerNicknameState();
}

class _OwnerNicknameState extends State<OwnerNickname> {
  final _nicknameController = TextEditingController();
  final _businessNameController = TextEditingController();
  String? _selectedLocation;
  bool _isButtonEnabled = false;

  final List<String> _locations = [
    '서울특별시', '인천광역시', '수원시', '성남시', '의정부시', '안양시', '부천시', '광명시', '평택시',
    '동두천시', '안산시', '고양시', '과천시', '구리시', '남양주시', '오산시', '시흥시',
    '군포시', '의왕시', '하남시', '용인시', '파주시', '이천시', '안성시', '김포시',
    '화성시', '광주시', '양주시', '포천시', '여주시', '연천군', '가평군', '양평군'

  ];

  void _submitData() async {
    final nickname = _nicknameController.text;
    final officeName = _businessNameController.text;
    final location = _selectedLocation;

    if (nickname.isEmpty || nickname.length > 8 || officeName.isEmpty || officeName.length > 14 || location == null) {
      // 입력 유효성 검사
      return;
    }

    await FirebaseFirestore.instance.collection('owners').doc(nickname).set({
      'office_name': officeName,
      'location': location,
      'timestamp': FieldValue.serverTimestamp(),
    });

    // 성공적으로 저장 후 화면 전환 등
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BlackWhiteSelectionScreen(nickname: nickname)),
    );
  }

  void _updateButtonState() {
    final nickname = _nicknameController.text;
    final officeName = _businessNameController.text;

    setState(() {
      _isButtonEnabled = nickname.isNotEmpty &&
          nickname.length <= 8 &&
          officeName.isNotEmpty &&
          officeName.length <= 14 &&
          _selectedLocation != null;
    });
  }

  @override
  void initState() {
    super.initState();

    _nicknameController.addListener(_updateButtonState);
    _businessNameController.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    _nicknameController.removeListener(_updateButtonState);
    _businessNameController.removeListener(_updateButtonState);
    _nicknameController.dispose();
    _businessNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: Text('소비자 회원가입', style: Theme.of(context).textTheme.headlineLarge),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _nicknameController,
              maxLength: 8,
              decoration: InputDecoration(labelText: '닉네임'),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              autofillHints: [AutofillHints.username],
            ),
            TextField(
              controller: _businessNameController,
              maxLength: 14,
              decoration: InputDecoration(labelText: '사업소명'),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              autofillHints: [AutofillHints.organizationName],
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: '사업소 위치'),
              value: _selectedLocation,
              onChanged: (newValue) {
                setState(() {
                  _selectedLocation = newValue;
                });
                _updateButtonState();
              },
              items: _locations.map((location) {
                return DropdownMenuItem(
                  value: location,
                  child: Text(location),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isButtonEnabled ? _submitData : null,
              child: Text('확인', style: Theme.of(context).textTheme.labelLarge),
              style: ElevatedButton.styleFrom(
                elevation: 10,
                shadowColor: Colors.black,
                backgroundColor: _isButtonEnabled ? Colors.lightBlue[200] : Colors.grey,
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
