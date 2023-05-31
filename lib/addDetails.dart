import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddDetailsScreen extends StatefulWidget {
  @override
  _AddDetailsScreenState createState() => _AddDetailsScreenState();
}

class _AddDetailsScreenState extends State<AddDetailsScreen> {
  TextEditingController _mobileNumberController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _ageController = TextEditingController();

  void _saveDetails() {
    String mobileNumber = _mobileNumberController.text;
    String name = _nameController.text;
    int age = int.tryParse(_ageController.text) ?? 0;

    Map<String, dynamic> userDetails = {
      'mobileNumber': mobileNumber,
      'name': name,
      'age': age,
      'isLiked': false,
    };

    saveMobileNumberAndName(userDetails).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Details added successfully!'),
        ),
      );
    });

    _mobileNumberController.clear();
    _nameController.clear();
    _ageController.clear();
  }

  Future<void> saveMobileNumberAndName(Map<String, dynamic> userDetails) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? encodedList = prefs.getStringList('mobileNumberList');
    List<Map<String, dynamic>> list =
        encodedList?.map((item) => Map<String, dynamic>.from(json.decode(item))).toList() ?? [];
    list.add(userDetails);
    List<String> encodedUpdatedList = list.map((item) => json.encode(item)).toList();
    await prefs.setStringList('mobileNumberList', encodedUpdatedList);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mobile Number:',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextFormField(
            controller: _mobileNumberController,
            keyboardType: TextInputType.phone,
          ),
          SizedBox(height: 16.0),
          Text(
            'Name:',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextFormField(
            controller: _nameController,
          ),
          SizedBox(height: 16.0),
          Text(
            'Age:',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextFormField(
            controller: _ageController,
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: _saveDetails,
            child: Text('Save'),
          ),
        ],
      ),
    );
  }
}
