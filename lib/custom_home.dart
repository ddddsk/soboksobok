import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';

class CustomHome extends StatefulWidget {
  final String nickname;

  CustomHome({required this.nickname});

  @override
  _CustomHomeState createState() => _CustomHomeState();
}

class _CustomHomeState extends State<CustomHome> {
  List<Map<String, dynamic>> _owners = [];
  int _currentIndex = 0;
  final TextEditingController _afternoonAsController = TextEditingController();
  final TextEditingController _morningAsController = TextEditingController();
  final TextEditingController _eveningAsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchOwners();
  }

  Future<void> _fetchOwners() async {
    try {
      DocumentSnapshot consumerDoc = await FirebaseFirestore.instance.collection('consumers').doc(widget.nickname).get();
      Map<String, dynamic> consumerData = consumerDoc.data() as Map<String, dynamic>;

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('owners').where('certificate', isEqualTo: true).get();
      List<Map<String, dynamic>> owners = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        data['profile_image'] = data['profile_image'] ?? 'default_profile_image_url';  // 기본 프로필 이미지 URL 설정
        return data;
      }).toList();

      owners.sort((a, b) => _calculateMatchScore(b, consumerData).compareTo(_calculateMatchScore(a, consumerData)));

      setState(() {
        _owners = owners;
      });
    } catch (e) {
      print('오류가 발생했습니다. $e');
    }
  }

  int _calculateMatchScore(Map<String, dynamic> owner, Map<String, dynamic> consumer) {
    int score = 0;
    if (owner['afternoon_as'] == consumer['afternoon_as']) score++;
    if (owner['black_and_white_printer_selected'] == consumer['black_and_white_printer_selected']) score++;
    if (owner['color_printer_selected'] == consumer['color_printer_selected']) score++;
    if (owner['evening_as'] == consumer['evening_as']) score++;
    if (owner['high_speed_print_required'] == consumer['high_speed_print_required']) score++;
    if (owner['location'] == consumer['location']) score += 2;
    if (owner['morning_as'] == consumer['morning_as']) score++;
    if (owner['scan_required'] == consumer['scan_required']) score++;
    if (owner['usual_copy_amount_high'] == consumer['usual_copy_amount_high']) score++;
    if (owner['usual_copy_amount_low'] == consumer['usual_copy_amount_low']) score++;
    if (owner['usual_copy_amount_medium'] == consumer['usual_copy_amount_medium']) score++;
    if (owner['weekend_as_preferred'] == consumer['weekend_as_preferred']) score++;
    return score;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: Center(
          child: Text('소복소복'),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('앱을 종료하시겠습니까?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('취소'),
                    ),
                    TextButton(
                      onPressed: () => SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
                      child: Text('확인'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _owners.isEmpty
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
              itemCount: (_currentIndex + 5 <= _owners.length) ? 5 : _owners.length - _currentIndex,
              itemBuilder: (context, index) {
                if (_currentIndex + index >= _owners.length) {
                  return null;
                }
                Map<String, dynamic> owner = _owners[_currentIndex + index];
                return _buildOwnerCard(owner);
              },
            ),
          ),
          Divider(),
          BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.delete),
                label: '회원 탈퇴',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.edit),
                label: '정보 수정',
              ),
            ],
            onTap: (index) {
              if (index == 0) {
                _showDeleteConfirmationDialog();
              } else if (index == 1) {
                _showEditProfileModal();
              }
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _currentIndex += 5;
            if (_currentIndex >= _owners.length) {
              _currentIndex = 0;
            }
          });
        },
        child: Icon(Icons.refresh),
      ),
    );
  }

  Widget _buildOwnerCard(Map<String, dynamic> owner) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            FutureBuilder(
              future: FirebaseStorage.instance.ref(owner['profile_image']).getDownloadURL(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    return Image.network(snapshot.data as String, width: 50, height: 50);
                  } else {
                    return Icon(Icons.error, color: Colors.red);
                  }
                }
                return CircularProgressIndicator();
              },
            ),
            SizedBox(width: 8.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(owner['intro'], style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text(owner['location'], style: TextStyle(fontSize: 14)),
                  ElevatedButton(
                    onPressed: () {
                      _showOwnerDetails(owner);
                    },
                    child: Text('자세한 정보 확인'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showOwnerDetails(Map<String, dynamic> owner) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('사업소명: ${owner['office_name']}'),
              Text('위치: ${owner['location']}'),
              Text('닉네임: ${owner['nickname']}'),
              Text('블랙/화이트 프린터: ${owner['black_and_white_printer_selected']}'),
              Text('컬러 프린터: ${owner['color_printer_selected']}'),
              Text('고속 프린트: ${owner['high_speed_print_required']}'),
              Text('스캔 필요: ${owner['scan_required']}'),
              Text('복사량 (많다): ${owner['usual_copy_amount_high']}'),
              Text('복사량 (보통): ${owner['usual_copy_amount_medium']}'),
              Text('복사량 (적다): ${owner['usual_copy_amount_low']}'),
              Text('주말 AS 가능 여부: ${owner['weekend_as_preferred']}'),
              SizedBox(height: 16),
              Text(
                '이 업체와 컨택 해보시겠습니까?',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                '확인을 누르시면 전화번호가 사업자에게 전송되어 연락이 올 수 있습니다.',
                style: TextStyle(fontSize: 12),
              ),
              ElevatedButton(
                onPressed: () {
                  _contactOwner(owner);
                },
                child: Text('확인'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _contactOwner(Map<String, dynamic> owner) async {
    DocumentSnapshot consumerDoc = await FirebaseFirestore.instance.collection('consumers').doc(widget.nickname).get();
    Map<String, dynamic> consumerData = consumerDoc.data() as Map<String, dynamic>;

    await FirebaseFirestore.instance.collection('contact_requests').add({
      'owner_nickname': owner['nickname'],
      'consumer_nickname': consumerData['nickname'],
      'consumer_phone': consumerData['phoneNumber'],
      'timestamp': FieldValue.serverTimestamp(),
    });

    Navigator.pop(context);
  }

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('정말로 회원 탈퇴하시겠습니까?'),
        content: Text('모든 정보가 삭제됩니다'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('취소'),
          ),
          TextButton(
            onPressed: () async {
              await FirebaseFirestore.instance.collection('consumers').doc(widget.nickname).delete();
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: Text('확인'),
          ),
        ],
      ),
    );
  }

  void _showEditProfileModal() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('정보 수정', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                TextField(
                  controller: _morningAsController,
                  decoration: InputDecoration(labelText: 'AS 시간(12시 이전)'),
                ),
                TextField(
                  controller: _afternoonAsController,
                  decoration: InputDecoration(labelText: 'AS 시간(12시~18시)'),
                ),
                TextField(
                  controller: _eveningAsController,
                  decoration: InputDecoration(labelText: 'AS 시간(18시 이후)'),
                ),
                CheckboxListTile(
                  title: Text('흑백 여부'),
                  value: _blackAndWhitePrinterSelected,
                  onChanged: (bool? value) {
                    setState(() {
                      _blackAndWhitePrinterSelected = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text('컬러 여부'),
                  value: _colorPrinterSelected,
                  onChanged: (bool? value) {
                    setState(() {
                      _colorPrinterSelected = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text('스캔 여부'),
                  value: _scanRequired,
                  onChanged: (bool? value) {
                    setState(() {
                      _scanRequired = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text('고속기 여부'),
                  value: _highSpeedPrintRequired,
                  onChanged: (bool? value) {
                    setState(() {
                      _highSpeedPrintRequired = value!;
                    });
                  },
                ),
                Text('복사량'),
                Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        title: const Text('많다'),
                        leading: Radio<String>(
                          value: 'high',
                          groupValue: _usualCopyAmount,
                          onChanged: (String? value) {
                            setState(() {
                              _usualCopyAmount = value!;
                            });
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListTile(
                        title: const Text('보통'),
                        leading: Radio<String>(
                          value: 'medium',
                          groupValue: _usualCopyAmount,
                          onChanged: (String? value) {
                            setState(() {
                              _usualCopyAmount = value!;
                            });
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListTile(
                        title: const Text('적다'),
                        leading: Radio<String>(
                          value: 'low',
                          groupValue: _usualCopyAmount,
                          onChanged: (String? value) {
                            setState(() {
                              _usualCopyAmount = value!;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                CheckboxListTile(
                  title: Text('공휴일 AS 여부'),
                  value: _weekendAsPreferred,
                  onChanged: (bool? value) {
                    setState(() {
                      _weekendAsPreferred = value!;
                    });
                  },
                ),
                ElevatedButton(
                  onPressed: _saveProfileChanges,
                  child: Text('저장'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  bool _blackAndWhitePrinterSelected = false;
  bool _colorPrinterSelected = false;
  bool _scanRequired = false;
  bool _highSpeedPrintRequired = false;
  String _usualCopyAmount = 'medium';
  bool _weekendAsPreferred = false;

  void _saveProfileChanges() async {
    await FirebaseFirestore.instance.collection('consumers').doc(widget.nickname).update({
      'morning_as': _morningAsController.text,
      'afternoon_as': _afternoonAsController.text,
      'evening_as': _eveningAsController.text,
      'black_and_white_printer_selected': _blackAndWhitePrinterSelected,
      'color_printer_selected': _colorPrinterSelected,
      'scan_required': _scanRequired,
      'high_speed_print_required': _highSpeedPrintRequired,
      'usual_copy_amount_high': _usualCopyAmount == 'high',
      'usual_copy_amount_medium': _usualCopyAmount == 'medium',
      'usual_copy_amount_low': _usualCopyAmount == 'low',
      'weekend_as_preferred': _weekendAsPreferred,
    });

    Navigator.pop(context);
  }
}
