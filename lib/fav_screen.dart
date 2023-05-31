import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Map<String, dynamic>> favoriteDetailsList = [];

  @override
  void initState() {
    super.initState();
    getFavoriteDetailsList().then((list) {
      setState(() {
        favoriteDetailsList = list;
      });
    });
  }

  Future<List<Map<String, dynamic>>> getFavoriteDetailsList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? encodedList = prefs.getStringList('favoriteDetailsList');
    List<Map<String, dynamic>> list = encodedList
            ?.map((item) => Map<String, dynamic>.from(json.decode(item)))
            .toList() ??
        [];
    return list;
  }

  Future<void> _removeFromFavorites(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? encodedList = prefs.getStringList('favoriteDetailsList');
    List<Map<String, dynamic>> list = encodedList
            ?.map((item) => Map<String, dynamic>.from(json.decode(item)))
            .toList() ??
        [];

    list.removeAt(index);

    List<String> encodedUpdatedList =
        list.map((item) => json.encode(item)).toList();
    await prefs.setStringList('favoriteDetailsList', encodedUpdatedList);

    setState(() {
      favoriteDetailsList = list;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: favoriteDetailsList.length,
      itemBuilder: (context, index) {
        return Dismissible(
          key: UniqueKey(),
          onDismissed: (direction) {
            _removeFromFavorites(index);
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
            title: Text(
                'Mobile Number: ${favoriteDetailsList[index]['mobileNumber']}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Name: ${favoriteDetailsList[index]['name']}'),
                Text('Age: ${favoriteDetailsList[index]['age']}'),
              ],
            ),
          ),
        );
      },
    );
  }
}
