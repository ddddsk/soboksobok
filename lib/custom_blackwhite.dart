import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'custom_scan.dart';

class BlackWhiteSelectionScreen extends StatefulWidget {
  final String nickname;

  BlackWhiteSelectionScreen({required this.nickname});

  @override
  _BlackWhiteSelectionScreenState createState() => _BlackWhiteSelectionScreenState();
}

class _BlackWhiteSelectionScreenState extends State<BlackWhiteSelectionScreen> {
  bool colorPrinterSelected = false;
  bool blackAndWhitePrinterSelected = false;

  void _submitData() async {
    await FirebaseFirestore.instance.collection('consumers').doc(widget.nickname).update({
      'color_printer_selected': colorPrinterSelected,
      'black_and_white_printer_selected': blackAndWhitePrinterSelected,
      'timestamp': FieldValue.serverTimestamp(),
    });

    // 성공적으로 저장 후 화면 전환 등
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ScanRequirementSelectionScreen(nickname: widget.nickname)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: Center(
          child: Text(
            '컬러/흑백 선택',
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
                      colorPrinterSelected = !colorPrinterSelected;
                      if (colorPrinterSelected) {
                        blackAndWhitePrinterSelected = false;
                      }
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: colorPrinterSelected ? Colors.blue : Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                      color: colorPrinterSelected ? Colors.blue.withOpacity(0.2) : Colors.transparent,
                    ),
                    padding: EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.print,
                          color: colorPrinterSelected ? Colors.pink : Colors.blue,
                          size: 50,
                        ),
                        SizedBox(width: 16),
                        Text(
                          '컬러 프린터 선택',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: colorPrinterSelected ? Colors.pink : Colors.blue,
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
                      blackAndWhitePrinterSelected = !blackAndWhitePrinterSelected;
                      if (blackAndWhitePrinterSelected) {
                        colorPrinterSelected = false;
                      }
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: blackAndWhitePrinterSelected ? Colors.blue : Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                      color: blackAndWhitePrinterSelected ? Colors.blue.withOpacity(0.2) : Colors.transparent,
                    ),
                    padding: EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.print,
                          color: blackAndWhitePrinterSelected ? Colors.grey : Colors.black,
                          size: 50,
                        ),
                        SizedBox(width: 30),
                        Text(
                          '흑백 프린터 선택',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: blackAndWhitePrinterSelected ? Colors.grey : Colors.black,
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