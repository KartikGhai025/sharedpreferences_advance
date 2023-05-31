import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  List<Map<String, dynamic>> userDetailsList = [];
  List<Map<String, dynamic>> favoriteDetailsList = [];

  @override
  void initState() {
    super.initState();
    getMobileNumberAndNameList().then((list) {
      setState(() {
        userDetailsList = list;
      });
    });
    getFavoriteDetailsList().then((list) {
      setState(() {
        favoriteDetailsList = list;
      });
    });
  }

  Future<List<Map<String, dynamic>>> getMobileNumberAndNameList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? encodedList = prefs.getStringList('mobileNumberList');
    List<Map<String, dynamic>> list =
        encodedList?.map((item) => Map<String, dynamic>.from(json.decode(item))).toList() ?? [];
    return list;
  }

  Future<List<Map<String, dynamic>>> getFavoriteDetailsList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? encodedList = prefs.getStringList('favoriteDetailsList');
    List<Map<String, dynamic>> list =
        encodedList?.map((item) => Map<String, dynamic>.from(json.decode(item))).toList() ?? [];
    return list;
  }

  Future<void> _toggleLikeStatus(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? encodedList = prefs.getStringList('mobileNumberList');
    List<Map<String, dynamic>> list =
        encodedList?.map((item) => Map<String, dynamic>.from(json.decode(item))).toList() ?? [];

    Map<String, dynamic> userDetails = list[index];

    bool isLiked = userDetails['isLiked'] ?? false;
    userDetails['isLiked'] = !isLiked;

    List<String>? encodedFavoritesList = prefs.getStringList('favoriteDetailsList');
    List<Map<String, dynamic>> favoritesList =
        encodedFavoritesList?.map((item) => Map<String, dynamic>.from(json.decode(item))).toList() ?? [];

    if (userDetails['isLiked']) {
      favoritesList.add(userDetails);
    } else {
      favoritesList.removeWhere((item) => item['mobileNumber'] == userDetails['mobileNumber']);
    }

    List<String> encodedUpdatedList = list.map((item) => json.encode(item)).toList();
    await prefs.setStringList('mobileNumberList', encodedUpdatedList);

    List<String> encodedUpdatedFavoritesList = favoritesList.map((item) => json.encode(item)).toList();
    await prefs.setStringList('favoriteDetailsList', encodedUpdatedFavoritesList);

    setState(() {
      userDetailsList = list;
      favoriteDetailsList = favoritesList;
    });
  }

  Future<void> _deleteDetails(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? encodedList = prefs.getStringList('mobileNumberList');
    List<Map<String, dynamic>> list =
        encodedList?.map((item) => Map<String, dynamic>.from(json.decode(item))).toList() ?? [];

    list.removeAt(index);

    List<String> encodedUpdatedList = list.map((item) => json.encode(item)).toList();
    await prefs.setStringList('mobileNumberList', encodedUpdatedList);

    setState(() {
      userDetailsList = list;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: userDetailsList.length,
      itemBuilder: (context, index) {
        bool isLiked = userDetailsList[index]['isLiked'] ?? false;
        IconData iconData = isLiked ? Icons.favorite : Icons.favorite_border;
        Color iconColor = isLiked ? Colors.red : Colors.grey;

        return Dismissible(
          key: UniqueKey(),
          onDismissed: (direction) {
            _deleteDetails(index);
          },
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
          child: ListTile(
            title: Text('Mobile Number: ${userDetailsList[index]['mobileNumber']}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Name: ${userDetailsList[index]['name']}'),
                Text('Age: ${userDetailsList[index]['age']}'),
              ],
            ),
            trailing: IconButton(
              icon: Icon(iconData),
              color: iconColor,
              onPressed: () => _toggleLikeStatus(index),
            ),
          ),
        );
      },
    );
  }
}
