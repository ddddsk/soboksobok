import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'owner_home.dart';  // 업로드 후 홈 화면으로 이동한다고 가정

class OwnerProfileScreen extends StatefulWidget {
  final String nickname;

  OwnerProfileScreen({required this.nickname});

  @override
  _OwnerProfileScreenState createState() => _OwnerProfileScreenState();
}

class _OwnerProfileScreenState extends State<OwnerProfileScreen> {
  final _introController = TextEditingController();
  final _phoneController = TextEditingController();
  File? _profileImage;
  File? _businessLicenseImage;
  bool _isUploading = false;
  final picker = ImagePicker();

  Future _pickImage(bool isProfile) async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        if (isProfile) {
          _profileImage = File(pickedFile.path);
        } else {
          _businessLicenseImage = File(pickedFile.path);
        }
      } else {
        print('No image selected.');
      }
    });
  }

  Future _uploadData() async {
    if (_introController.text.isEmpty || _phoneController.text.isEmpty || _profileImage == null || _businessLicenseImage == null) {
      // 필수 항목이 채워지지 않은 경우 처리
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      // 프로필 이미지 업로드
      String profileFileName = Path.basename(_profileImage!.path);
      Reference profileStorageRef = FirebaseStorage.instance.ref().child('profile_images/$profileFileName');
      UploadTask profileUploadTask = profileStorageRef.putFile(_profileImage!);
      TaskSnapshot profileTaskSnapshot = await profileUploadTask;
      String profileImageUrl = await profileTaskSnapshot.ref.getDownloadURL();

      // 사업자 등록증 이미지 업로드
      String licenseFileName = Path.basename(_businessLicenseImage!.path);
      Reference licenseStorageRef = FirebaseStorage.instance.ref().child('business_licenses/$licenseFileName');
      UploadTask licenseUploadTask = licenseStorageRef.putFile(_businessLicenseImage!);
      TaskSnapshot licenseTaskSnapshot = await licenseUploadTask;
      String licenseImageUrl = await licenseTaskSnapshot.ref.getDownloadURL();

      await FirebaseFirestore.instance.collection('owners').doc(widget.nickname).update({
        'intro': _introController.text,
        'phone': _phoneController.text,
        'profile_image': profileImageUrl,
        'business_license_image': licenseImageUrl,
        'timestamp': FieldValue.serverTimestamp(),
      });

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => owner_home()),  // 업로드 후 홈 화면으로 이동
      );
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: Align(
          alignment: Alignment(-0.2, 0),  // 중앙에서 약간 왼쪽으로 이동
          child: Text(
            '프로필 설정',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 25,
              height: 2,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _introController,
                maxLength: 50,
                maxLines: 3,  // 텍스트 필드를 텍스트 박스로 변환
                decoration: InputDecoration(
                  labelText: '소개 멘트',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: '전화번호',
                  hintText: '고객님들과 컨택 시에 사용하실 전화번호를 입력해주세요',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () => _pickImage(true),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.transparent,
                  ),
                  height: 200,
                  width: 200,
                  child: _profileImage == null
                      ? Icon(Icons.add_a_photo, size: 50, color: Colors.grey)
                      : Image.file(_profileImage!, fit: BoxFit.cover),
                ),
              ),
              SizedBox(height: 20),
              Text(
                '프로필 사진을 업로드 해주세요!',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              GestureDetector(
                onTap: () => _pickImage(false),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.transparent,
                  ),
                  height: 200,
                  width: 200,
                  child: _businessLicenseImage == null
                      ? Icon(Icons.add_photo_alternate, size: 50, color: Colors.grey)
                      : Image.file(_businessLicenseImage!, fit: BoxFit.cover),
                ),
              ),
              SizedBox(height: 20),
              Text(
                '사업자 등록증 승인이 완료되면 고객들과 컨택이 가능합니다!',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isUploading ? null : _uploadData,
                child: _isUploading ? CircularProgressIndicator() : Text('가입하기', style: Theme.of(context).textTheme.labelLarge),
                style: ElevatedButton.styleFrom(
                  elevation: 10,
                  shadowColor: Colors.black,
                  backgroundColor: Colors.lightBlue[200],
                  padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}