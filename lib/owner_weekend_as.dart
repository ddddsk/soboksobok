import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'owner_introduction.dart';

class WeekendAsPreferenceScreen extends StatefulWidget {
  final String nickname;

  WeekendAsPreferenceScreen({required this.nickname});

  @override
  _WeekendAsPreferenceScreenState createState() => _WeekendAsPreferenceScreenState();
}

class _WeekendAsPreferenceScreenState extends State<WeekendAsPreferenceScreen> {
  bool weekendAsPreferred = false;
  bool weekendAsNotPreferred = false;

  void _submitData() async {
    await FirebaseFirestore.instance.collection('owners').doc(widget.nickname).update({
      'weekend_as_preferred': weekendAsPreferred,
      'timestamp': FieldValue.serverTimestamp(),
    });

    // 성공적으로 저장 후 화면 전환 등
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => OwnerProfileScreen(nickname: widget.nickname)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: Center(
          child: Text(
            '주말/공휴일 AS 가능 여부',
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
                      weekendAsPreferred = true;
                      weekendAsNotPreferred = false;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: weekendAsPreferred ? Colors.blue : Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                      color: weekendAsPreferred ? Colors.blue.withOpacity(0.2) : Colors.transparent,
                    ),
                    padding: EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.weekend,
                          color: weekendAsPreferred ? Colors.blue : Colors.grey,
                          size: 50,
                        ),
                        SizedBox(width: 16),
                        Text(
                          '가능해요',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: weekendAsPreferred ? Colors.blue : Colors.grey,
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
                      weekendAsNotPreferred = true;
                      weekendAsPreferred = false;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: weekendAsNotPreferred ? Colors.blue : Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                      color: weekendAsNotPreferred ? Colors.blue.withOpacity(0.2) : Colors.transparent,
                    ),
                    padding: EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.do_not_disturb,
                          color: weekendAsNotPreferred ? Colors.red : Colors.grey,
                          size: 50,
                        ),
                        SizedBox(width: 16),
                        Text(
                          '힘들어요',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: weekendAsNotPreferred ? Colors.red : Colors.grey,
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