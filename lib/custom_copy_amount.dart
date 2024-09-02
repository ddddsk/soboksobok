import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'custom_as_time.dart';

class UsualCopyAmountSelectionScreen extends StatefulWidget {
  final String nickname;

  UsualCopyAmountSelectionScreen({required this.nickname});

  @override
  _UsualCopyAmountSelectionScreenState createState() => _UsualCopyAmountSelectionScreenState();
}

class _UsualCopyAmountSelectionScreenState extends State<UsualCopyAmountSelectionScreen> {
  String selectedAmount = '';

  void _submitData() async {
    if (selectedAmount.isEmpty) {
      // 선택되지 않은 경우 처리
      return;
    }

    await FirebaseFirestore.instance.collection('consumers').doc(widget.nickname).update({
      'usual_copy_amount': selectedAmount,
      'timestamp': FieldValue.serverTimestamp(),
    });

    // 성공적으로 저장 후 화면 전환 등
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AvailableTimeSelectionScreen(nickname: widget.nickname)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: Center(
          child: Text(
            '평소 복사기 사용량 선택',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 25,
              height: 2,
            ),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedAmount = '많다';
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: selectedAmount == '많다' ? Colors.blue : Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                      color: selectedAmount == '많다' ? Colors.blue.withOpacity(0.2) : Colors.transparent,
                    ),
                    padding: EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.copy,
                          color: selectedAmount == '많다' ? Colors.blue : Colors.grey,
                          size: 50,
                        ),
                        SizedBox(width: 16),
                        Text(
                          '많다',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: selectedAmount == '많다' ? Colors.blue : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedAmount = '보통';
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: selectedAmount == '보통' ? Colors.blue : Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                      color: selectedAmount == '보통' ? Colors.blue.withOpacity(0.2) : Colors.transparent,
                    ),
                    padding: EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.copy,
                          color: selectedAmount == '보통' ? Colors.orange : Colors.grey,
                          size: 50,
                        ),
                        SizedBox(width: 16),
                        Text(
                          '중간',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: selectedAmount == '보통' ? Colors.orange : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedAmount = '적다';
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: selectedAmount == '적다' ? Colors.blue : Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                      color: selectedAmount == '적다' ? Colors.blue.withOpacity(0.2) : Colors.transparent,
                    ),
                    padding: EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.copy,
                          color: selectedAmount == '적다' ? Colors.green : Colors.grey,
                          size: 50,
                        ),
                        SizedBox(width: 16),
                        Text(
                          '적다',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: selectedAmount == '적다' ? Colors.green : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(40.0),
            child: ElevatedButton(
              onPressed: _submitData,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[20],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: Colors.white),
                ),
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                textStyle: TextStyle(fontSize: 18),
                elevation: 10,
                shadowColor: Colors.black,
              ),
              child: Text('선택 완료'),
            ),
          ),
        ],
      ),
    );
  }
}