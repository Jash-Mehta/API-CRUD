import 'package:apipratice/screens/cart.dart';
import 'package:apipratice/screens/display_data.dart';
import 'package:apipratice/screens/fav_list.dart';
import 'package:apipratice/screens/yourbook.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DashDrawer extends StatelessWidget {
  const DashDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
      children: [
        const DrawerHeader(
            child: CircleAvatar(
          radius: 60,
        )),
        const ListTile(
          leading: Icon(
            CupertinoIcons.cloud_upload,
            size: 30,
            color: Colors.blue,
          ),
          title: Text(
            "Posting Data",
            style: TextStyle(fontSize: 20.0),
          ),
        ),
        ListTile(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const DisplayData()));
          },
          leading: const Icon(
            CupertinoIcons.cloud_download,
            size: 30,
            color: Colors.blue,
          ),
          title: const Text(
            "Fetching Data",
            style: TextStyle(fontSize: 20.0),
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => const FavList()));
          },
          child: const ListTile(
            leading: Icon(
              CupertinoIcons.heart,
              size: 30,
              color: Colors.blue,
            ),
            title: Text(
              "Favorite List",
              style: TextStyle(fontSize: 20.0),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => const Carts()));
          },
          child: const ListTile(
            leading: Icon(
              CupertinoIcons.cart,
              size: 30,
              color: Colors.blue,
            ),
            title: Text(
              "Cart",
              style: TextStyle(fontSize: 20.0),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => const Yourbook()));
          },
          child: const ListTile(
            leading: Icon(
              CupertinoIcons.book,
              size: 30,
              color: Colors.blue,
            ),
            title: Text(
              "Your Book's",
              style: TextStyle(fontSize: 20.0),
            ),
          ),
        ),
      ],
    ));
  }
}
