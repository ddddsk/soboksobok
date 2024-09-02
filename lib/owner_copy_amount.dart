import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'owner_as_time.dart';

class UsualCopyAmountSelectionScreen extends StatefulWidget {
  final String nickname;

  UsualCopyAmountSelectionScreen({required this.nickname});

  @override
  _UsualCopyAmountSelectionScreenState createState() => _UsualCopyAmountSelectionScreenState();
}

class _UsualCopyAmountSelectionScreenState extends State<UsualCopyAmountSelectionScreen> {
  bool isHigh = false;
  bool isMedium = false;
  bool isLow = false;

  void _submitData() async {
    await FirebaseFirestore.instance.collection('owners').doc(widget.nickname).update({
      'usual_copy_amount_high': isHigh ? '많다' : '',
      'usual_copy_amount_medium': isMedium ? '보통' : '',
      'usual_copy_amount_low': isLow ? '적다' : '',
      'timestamp': FieldValue.serverTimestamp(),
    });

    // 성공적으로 저장 후 화면 전환 등
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AvailableTimeSelectionScreen(nickname: widget.nickname)),
    );
  }

  void _toggleHigh() {
    setState(() {
      isHigh = !isHigh;
    });
  }

  void _toggleMedium() {
    setState(() {
      isMedium = !isMedium;
    });
  }

  void _toggleLow() {
    setState(() {
      isLow = !isLow;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: Center(
          child: Text(
            '복사기 사용량 제공 선택',
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
                  onTap: _toggleHigh,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: isHigh ? Colors.blue : Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                      color: isHigh ? Colors.blue.withOpacity(0.2) : Colors.transparent,
                    ),
                    padding: EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.copy,
                          color: isHigh ? Colors.blue : Colors.grey,
                          size: 50,
                        ),
                        SizedBox(width: 16),
                        Text(
                          '많다',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: isHigh ? Colors.blue : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: _toggleMedium,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: isMedium ? Colors.blue : Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                      color: isMedium ? Colors.blue.withOpacity(0.2) : Colors.transparent,
                    ),
                    padding: EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.copy,
                          color: isMedium ? Colors.orange : Colors.grey,
                          size: 50,
                        ),
                        SizedBox(width: 16),
                        Text(
                          '보통',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: isMedium ? Colors.orange : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: _toggleLow,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: isLow ? Colors.blue : Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                      color: isLow ? Colors.blue.withOpacity(0.2) : Colors.transparent,
                    ),
                    padding: EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.copy,
                          color: isLow ? Colors.green : Colors.grey,
                          size: 50,
                        ),
                        SizedBox(width: 16),
                        Text(
                          '적다',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: isLow ? Colors.green : Colors.grey,
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