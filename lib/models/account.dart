import 'dart:convert' show jsonDecode;
import 'package:myassets/jsondata.dart';

void main() {
  final Accounts test = Accounts(jsondata);

  //print("jj" + test.toJson());
  final sbt =
      new Subtotal.fromForm(name: "NewCorp", pricePer: 0.69, shares: 144);
  test.insertsubtotal(sbt, "ubs15,equities");
  //print(test.toJson());
}

Subtotals? findBucket(Accounts accs, String loc) {
  // gets equities, hedgefund, etc. category by string
  // loc = (account name, subcategory name)
  var address = loc.split(',');
  Account a = getAccount(accs, address[0])!;
  Subtotals res = getSubs(a.buckets, address[1])!;

  return res;
}

Account? findAccount(Accounts accs, String loc) {
  // gets equities, hedgefund, etc. category by string
  // loc = (account name, subcategory name)
  var address = loc.split(',');
  Account res = getAccount(accs, address[0])!;
  return res;
}

Subtotals? getSubs(List<Subtotals>? subs, String name) {
  for (Subtotals category in subs!) {
    if (category.name == name) {
      return category;
    }
  }
  return null;
}

Account? getAccount(Accounts accs, String name) {
  for (Account a in accs.subCat!) {
    if (a.name == name) {
      return a;
    }
  }
  return null;
}

class Accounts {
  //String result;
  List<Account>? subCat; //list of accounts
  double? value;
  Accounts(String jsonStr) {
    final _map = jsonDecode(jsonStr);

    //this.result = _map['result'];

    this.value = double.parse(_map['value'].toString());
    this.subCat = [];
    var k = _map['accounts'];
    //print(k[0].toString());
    for (var i = 0; i < (k.length); i++) {
      print(k[i]);
      subCat!.add(new Account(k[i]));
    }
  }
  void insertsubtotal(Subtotal sub, String loc) {
    //account, category
    findBucket(this, loc)!.subtotals!.add(sub);
    //print(this.toJson());
  }

  void removeaccount(Accounts a, String loc) {
    var ac = findAccount(a, loc);
  }

  void insertbucket(Subtotals buck, String loc) {
    findAccount(this, loc)!.buckets!.add(buck);
  }

  void insertaccount(Account nac, String loc) {
    this.subCat!.add(nac);
  }

  String toJson() {
    String first = '''{
      "value":$value,
      "accounts":[''';
    String second = "";
    if (this.subCat!.length == 0) {
      second = '''
        
      ]
    }
        ''';
      return first + second;
    }
    for (var i = 0; i < (this.subCat!.length); i++) {
      if (i == subCat!.length - 1) {
        second += '''
        ${this.subCat![i].toJson()}
      ]
    }
        ''';
        return first + second;
      } else {
        second += '''${this.subCat![i].toJson()},
        ''';
      }
    }

    return first + second;
  }
}

class Account {
  String? name;
  double? value;
  List<Subtotals>? buckets;
  String? loc;
  Accounts? accs; //account,bucket,position
  Account(Map<String, dynamic> jsonMap) {
    final map = jsonMap;

    this.name = map['name'];
    this.loc = this.name! + ",";
    print(map['value']);
    this.value = double.parse(map['value'].toString());
    this.buckets = [];
    var k = map['positions'];
    //print(k.length);

    for (var i = 0; i < (k.length); i++) {
      this.buckets!.add(new Subtotals(k[i], this.loc!));
    }
  }
  Account.fromForm({this.name, this.value, this.buckets, this.loc}) {
    //this.value = double.parse((this.shares! * this.pricePer!).toString());
  }
  String toJson() {
    String first = '''{
      "name":"$name",
      "value":$value,
      "positions":[
        ''';
    String second = "";
    if (this.buckets!.length == 0) {
      second = '''
        
      ]
    }
        ''';
      return first + second;
    }
    for (var i = 0; i < (this.buckets!.length); i++) {
      if (i == buckets!.length - 1) {
        second += '''${this.buckets![i].toJson()}
      ]
    }''';
        return first + second;
      } else {
        second += '''${this.buckets![i].toJson()},
        ''';
      }
    }

    return first + second;
  }
}

class Subtotals {
  //String result;
  String? name; // category name
  double? value;
  String? loc; //account,bucket,position
  List<Subtotal>? subtotals; //positions

  Subtotals(Map<String, dynamic> jsonMap, String a) {
    final _map = jsonMap;

    //print(_map);
    //this.result = _map['result'];
    this.name = _map['name'];
    this.loc = a + this.name! + ",";
    this.value = double.parse(_map['value'].toString());
    this.subtotals = [];
    var k = _map['positions'];

    if (k != null) {
      for (var i = 0; i < (k.length); i++) {
        this.subtotals!.add(new Subtotal(k[i], this.loc!));
      }
    }
  }
  Subtotals.fromForm({this.name, this.value, this.subtotals, this.loc}) {
    //this.value = double.parse((this.shares! * this.pricePer!).toString());
  }
  String toJson() {
    String first = '''{
      "name":"$name",
      "value":$value,
      "positions":[
        ''';
    String second = "";
    if (this.subtotals!.length == 0) {
      second = '''
        
      ]
    }
        ''';
      return first + second;
    }
    for (var i = 0; i < (this.subtotals!.length); i++) {
      if (i == subtotals!.length - 1) {
        second += '''${this.subtotals![i].toJson()}
      ]
    }''';
        return first + second;
      } else {
        second += '''${this.subtotals![i].toJson()},
        ''';
      }
    }

    return first + second;
  }
}

class Subtotal {
  double? value, pricePer;
  String? name, loc;
  int? shares;
  int? id;

  Subtotal(Map<String, dynamic> jsonMap, String a) {
    this.value = double.parse(jsonMap['value'].toString());
    this.pricePer = jsonMap['pricePer'] ?? 0.0;
    this.name = jsonMap['name'];
    this.loc = a + this.name!;
    this.shares = jsonMap['shares'] ?? 0;
  }
  Subtotal.fromForm(
      {this.name, this.shares, this.pricePer, this.value, this.loc}) {
    //this.value = double.parse((this.shares! * this.pricePer!).toString());
  }
  String toJson() {
    return '''{
          "name": "$name",
          "value": $value,
          "pricePer": $pricePer,
          "shares": $shares
          }''';
  }
}
