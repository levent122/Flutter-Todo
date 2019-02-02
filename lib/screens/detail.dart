import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:todo/db/dbHelper.dart';
import 'package:todo/models/item.dart';
import 'package:todo/screens/home.dart';

class DetailScreen extends StatefulWidget {
  final data;

  DetailScreen({Key key, this.data}) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final _formKey = new GlobalKey<FormState>();
  final TextEditingController _titleEditingController =
      new TextEditingController();
  final TextEditingController _descriptionEditingController =
      new TextEditingController();

  String _value;
  List<String> _values = new List<String>();

  @override
  void initState() {
    super.initState();
    _values.addAll(["Low", "High"]);
    _titleEditingController.text = widget.data.name;
    _descriptionEditingController.text = widget.data.description;
    switch (widget.data.importance) {
      case "High":
        _value = _values.elementAt(1);
        break;
      case "Low":
        _value = _values.elementAt(0);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text(widget.data.name)),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: _alert,
            )
          ],
        ),
        body: ListView(
          children: <Widget>[
            Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding:
                          EdgeInsets.only(top: 50.0, left: 40.0, right: 40.0),
                      child: TextFormField(
                        controller: _titleEditingController,
                        decoration: InputDecoration(
                            labelText: "Item Title",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                        validator: (value) {
                          if (value.isEmpty) {
                            return "This field is required!";
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: 30.0, left: 40.0, right: 40.0, bottom: 30.0),
                      child: TextFormField(
                        controller: _descriptionEditingController,
                        decoration: InputDecoration(
                            labelText: "Item Description",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                        maxLines: 5,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "This field is required!";
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 30.0, right: 30.0, bottom: 30.0),
                      child: ListTile(
                        title: DropdownButton(
                          value: _value,
                          items: _values.map((String value) {
                            return new DropdownMenuItem(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String value) {
                            setState(() => _value = value);
                          },
                        ),
                      ),
                    ),
                    Center(
                      child: RaisedButton(
                        child: Text(
                          "Update",
                          style: TextStyle(color: Colors.white, fontSize: 17.0),
                        ),
                        onPressed: update,
                        color: Colors.indigo,
                      ),
                    )
                  ],
                )),
          ],
        ));
  }

  void remove() {
    DbHelper dbHelper = new DbHelper();
    dbHelper.delete(widget.data.id);
    setState(() => items);
    Navigator.pop(context);
    Navigator.pop(context);
    Fluttertoast.showToast(msg: "${widget.data.name} item deleted");
  }

  void update() {
    if (_formKey.currentState.validate()) {
      DbHelper dbHelper = new DbHelper();
      Item x = new Item.withId(widget.data.id, _titleEditingController.text,
          _descriptionEditingController.text, _value, widget.data.date);
      dbHelper.update(x);
      items.add(x);
      Navigator.pop(context);
    }
  }

  void _alert() {
    var alert = new AlertDialog(
      content: Text("Do you want to delete this item"),
      actions: <Widget>[
        new FlatButton(
          child: Text("Delete"),
          onPressed: remove,
        ),
        new FlatButton(
            child: Text("Cancel"), onPressed: () => Navigator.pop(context)),
      ],
    );
    showDialog(
        context: context,
        builder: (_) {
          return alert;
        });
  }
}
