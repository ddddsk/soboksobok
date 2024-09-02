import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'owner_copy_amount.dart';

class HighSpeedPrintSelectionScreen extends StatefulWidget {
  final String nickname;

  HighSpeedPrintSelectionScreen({required this.nickname});

  @override
  _HighSpeedPrintSelectionScreenState createState() => _HighSpeedPrintSelectionScreenState();
}

class _HighSpeedPrintSelectionScreenState extends State<HighSpeedPrintSelectionScreen> {
  bool highSpeedPrintRequired = false;

  void _submitData() async {
    await FirebaseFirestore.instance.collection('owners').doc(widget.nickname).update({
      'high_speed_print_required': highSpeedPrintRequired,
      'timestamp': FieldValue.serverTimestamp(),
    });

    // 성공적으로 저장 후 화면 전환 등
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UsualCopyAmountSelectionScreen(nickname: widget.nickname)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: Center(
          child: Text(
            '고속기 제공 가능 여부 선택',
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
                      highSpeedPrintRequired = !highSpeedPrintRequired;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: highSpeedPrintRequired ? Colors.blue : Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                      color: highSpeedPrintRequired ? Colors.blue.withOpacity(0.2) : Colors.transparent,
                    ),
                    padding: EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.speed,
                          color: highSpeedPrintRequired ? Colors.blue : Colors.grey,
                          size: 50,
                        ),
                        SizedBox(width: 16),
                        Text(
                          '고속기 제공 가능',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: highSpeedPrintRequired ? Colors.blue : Colors.grey,
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
                      highSpeedPrintRequired = !highSpeedPrintRequired;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: !highSpeedPrintRequired ? Colors.blue : Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                      color: !highSpeedPrintRequired ? Colors.blue.withOpacity(0.2) : Colors.transparent,
                    ),
                    padding: EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.not_interested,
                          color: !highSpeedPrintRequired ? Colors.red : Colors.grey,
                          size: 50,
                        ),
                        SizedBox(width: 16),
                        Text(
                          '고속기 제공 불가능',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: !highSpeedPrintRequired ? Colors.red : Colors.grey,
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