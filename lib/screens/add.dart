import 'package:flutter/material.dart';
import 'package:todo/db/dbHelper.dart';
import 'package:todo/models/item.dart';
import 'package:todo/screens/home.dart';

class AddScreen extends StatefulWidget {
  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
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
    _value = _values.elementAt(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text("Add New Item"),
          ),
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
                        decoration: InputDecoration(hintText: "Item Title"),
                        autofocus: true,
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
                        decoration:
                            InputDecoration(hintText: "Item Description"),
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
                          "Save",
                          style: TextStyle(color: Colors.white, fontSize: 17.0),
                        ),
                        onPressed: save,
                        color: Colors.indigo,
                      ),
                    )
                  ],
                )),
          ],
        ));
  }

  void save() {
    if (_formKey.currentState.validate()) {
      DbHelper dbHelper = new DbHelper();
      Item x = new Item(
          _titleEditingController.text,
          _descriptionEditingController.text,
          _value,
          DateTime.now().toIso8601String());
      dbHelper.insert(x);
      items.add(x);
      Navigator.pop(context);
    }
  }
}
