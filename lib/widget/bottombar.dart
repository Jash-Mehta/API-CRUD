import 'package:apipratice/model/admin_model.dart';
import 'package:apipratice/screens/TestingMongo.dart';
import 'package:apipratice/screens/cart.dart';
import 'package:apipratice/screens/display_data.dart';
import 'package:apipratice/screens/fav_list.dart';
import 'package:apipratice/screens/yourbook.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BottomBar extends StatefulWidget {
  BottomBar({Key? key}) : super(key: key);

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = <Widget>[
    const TestingMongoDB(),
    const DisplayData(),
    const FavList(),
    const Carts(),
    const Yourbook()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
      bottomNavigationBar: BottomNavigationBar(
          elevation: 0,
          selectedItemColor: Colors.pink[200],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "DashBoard"),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: "Explore"),
            BottomNavigationBarItem(
                icon: Icon(Icons.favorite), label: "Favorite"),
            BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.cart), label: "Cart"),
            BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.book), label: "Book's")
          ]),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
