class Item {
  int _id;
  String _name;
  String _description;
  String _importance;
  String _date;

  Item(this._name, this._description, this._importance, this._date);
  Item.withId(this._id, this._name, this._description, this._importance, this._date);

  int get id => _id;
  String get name => _name;
  String get description => _description;
  String get importance => _importance;
  String get date => _date;

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["name"] = _name;
    map["description"] = _description;
    map["importance"] = _importance;
    map["date"] = _date;
    if (_id != null) {
      map["id"] = _id;
    }
    return map;
  }

  Item.formObject(dynamic o) {
    this._id = o["id"];
    this._name = o["name"];
    this._description = o["description"];
    this._importance = o["importance"];
    this._date = o["date"];
  }
}
