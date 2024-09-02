import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'custom_weekend_as.dart';


class AvailableTimeSelectionScreen extends StatefulWidget {
  final String nickname;

  AvailableTimeSelectionScreen({required this.nickname});

  @override
  _AvailableTimeSelectionScreenState createState() => _AvailableTimeSelectionScreenState();
}

class _AvailableTimeSelectionScreenState extends State<AvailableTimeSelectionScreen> {
  bool morningSelected = false;
  bool afternoonSelected = false;
  bool eveningSelected = false;

  void _submitData() async {
    await FirebaseFirestore.instance.collection('consumers').doc(widget.nickname).update({
      'morning_as': morningSelected,
      'afternoon_as': afternoonSelected,
      'evening_as': eveningSelected,
      'timestamp': FieldValue.serverTimestamp(),
    });

    // 성공적으로 저장 후 화면 전환 등
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => WeekendAsPreferenceScreen(nickname: widget.nickname)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: Center(
          child: Text(
            '희망 시간 선택',
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
                      morningSelected = !morningSelected;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: morningSelected ? Colors.blue : Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                      color: morningSelected ? Colors.blue.withOpacity(0.2) : Colors.transparent,
                    ),
                    padding: EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.wb_sunny,
                          color: morningSelected ? Colors.yellow : Colors.grey,
                          size: 50,
                        ),
                        SizedBox(width: 16),
                        Text(
                          '12시 이전',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: morningSelected ? Colors.yellow : Colors.grey,
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
                      afternoonSelected = !afternoonSelected;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: afternoonSelected ? Colors.blue : Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                      color: afternoonSelected ? Colors.blue.withOpacity(0.2) : Colors.transparent,
                    ),
                    padding: EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.wb_sunny,
                          color: afternoonSelected ? Colors.orange : Colors.grey,
                          size: 50,
                        ),
                        SizedBox(width: 16),
                        Text(
                          '12시~18시',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: afternoonSelected ? Colors.orange : Colors.grey,
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
                      eveningSelected = !eveningSelected;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: eveningSelected ? Colors.blue : Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                      color: eveningSelected ? Colors.blue.withOpacity(0.2) : Colors.transparent,
                    ),
                    padding: EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.nights_stay,
                          color: eveningSelected ? Colors.blue : Colors.grey,
                          size: 50,
                        ),
                        SizedBox(width: 16),
                        Text(
                          '18시 이후',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: eveningSelected ? Colors.blue : Colors.grey,
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