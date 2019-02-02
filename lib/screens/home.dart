import 'package:flutter/material.dart';
import 'package:todo/db/dbHelper.dart';
import 'package:todo/models/item.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:todo/screens/detail.dart';

List<Item> items;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DbHelper dbHelper = new DbHelper();

  void remove(String name, int id) {
    DbHelper dbHelper = new DbHelper();
    dbHelper.delete(id);
    setState(() => items);
    Fluttertoast.showToast(msg: "$name item deleted");
  }

  @override
  Widget build(BuildContext context) {
    if (items == null) {
      items = new List<Item>();
      getData();
    }
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("${items.length} Todo"),
        ),
      ),
      body: itemList(),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => Navigator.pushNamed(context, "/add")),
    );
  }

  ListView itemList() {
    getData();
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (BuildContext context, int index) {
        final item = items[index];
        var importance;
        switch (item.importance) {
          case "High":
            importance = Colors.redAccent;
            break;
          case "Medium":
            importance = Colors.yellow;
            break;
          case "Low":
            importance = Colors.green;
            break;
        }
        return Dismissible(
            key: Key(item.id.toString()),
            onDismissed: (direction) {
              remove(item.name, item.id);
              setState(() {
                items.removeAt(index);
              });
            },
            background: Card(
              color: Colors.redAccent,
              child: ListTile(
                leading: Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
              elevation: 3.0,
            ),
            child: Card(
              elevation: 3.0,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: importance,
                ),
                trailing: GestureDetector(
                  child: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DetailScreen(data: item)));
                    },
                    color: Colors.indigo,
                  ),
                ),
                title: Text(item.name),
                subtitle: Text(timeago.format(DateTime.parse(item.date))),
              ),
            ));
      },
    );
  }

  void getData() {
    var db = dbHelper.initalizeDb();
    db.then((result) {
      var itemFuture = dbHelper.select();
      itemFuture.then((data) {
        List<Item> itemData = new List<Item>();
        for (int i = 0; i < data.length; i++) {
          itemData.add(Item.formObject(data[i]));
        }
        setState(() {
          items = itemData;
        });
      });
    });
  }
}
