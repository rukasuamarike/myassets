import 'package:flutter/material.dart';
import 'package:myassets/jsonlookdata.dart';
import 'package:myassets/views/accountview.dart';
import 'package:myassets/jsondata.dart';
import 'package:myassets/views/addaccount.dart';
import 'package:myassets/views/addbucket.dart';
import 'package:myassets/views/addview.dart';
import 'package:myassets/views/bucketview.dart';
import 'package:myassets/views/subview.dart';
import 'models/account.dart';
import 'dart:io';
import 'package:http/http.dart';
import 'dart:async';

import 'package:path_provider/path_provider.dart';

import 'package:flutter/foundation.dart';

Accounts a = Accounts(jsondata);
//Subtotals sub = Subtotals.fromJson(k);
void main() => runApp(CoolApp(data: ""));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 's',
      home: Scaffold(
        appBar: AppBar(
          title: Text("hi"),
        ),
      ),
    );
  }
}

class ClientApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Node server demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(title: Text('Flutter Client')),
        body: BodyWidget(),
      ),
    );
  }
}

class BodyWidget extends StatefulWidget {
  @override
  BodyWidgetState createState() {
    return new BodyWidgetState();
  }
}

class BodyWidgetState extends State<BodyWidget> {
  String serverResponse = 'Server response';
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Align(
        alignment: Alignment.topCenter,
        child: SizedBox(
          width: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // ignore: deprecated_member_use
              RaisedButton(
                child: Text('Send request to server'),
                onPressed: () {
                  _makeGetRequest();
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(serverResponse),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Uri _localhost() {
    // if (Platform.isAndroid)
    //   return Uri.http('10.0.2.2:3000', "");
    // else // for iOS simulator
    return Uri.http('192.168.1.121:3000', "");
  }

  _makeGetRequest() async {
    Response response = await get(_localhost());
    setState(() {
      serverResponse = response.body;
    });
  }
}

class CoolApp extends StatelessWidget {
  final String? data;
  CoolApp({Key? key, @required this.data}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Reading and Writing to Storage",
      routes: {
        '/': (context) => First(),
        DataStore.routeName: (context) => DataStore(),
        AccountView.routeName: (context) => AccountView(),
        BucketView.routeName: (context) => BucketView(),
        SubtotalView.routeName: (context) => SubtotalView(),
        FormView.routeName: (context) => FormView(),
        FormViewa.routeName: (context) => FormViewa(),
        FormViewb.routeName: (context) => FormViewb(),
      },
      initialRoute: '/',
    );
  }
}

class First extends StatelessWidget {
  const First({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('created by Lucas Amlicke'),
        ),
        body: Container(
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, DataStore.routeName,
                  arguments: Home(storage: Storage(), data: fillerdata));
            },
            child: Icon(Icons.ac_unit),
          ),
        ));
  }
}

class DataStore extends StatelessWidget {
  static const routeName = '/store';

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Home;
    return Scaffold(
        appBar: AppBar(
          title: Text('Home Screen main'),
        ),
        body: Home(
          storage: args.storage,
          data: args.data,
        ));
  }
}

class Home extends StatefulWidget {
  final Storage? storage;
  final String? data;

  Home({Key? key, @required this.storage, @required this.data})
      : super(key: key);

  @override
  HomeState createState() => HomeState(data: data);
}

class HomeState extends State<Home> {
  String? data;
  TextEditingController controller = TextEditingController();

  HomeState({Key? key, @required this.data});
  @override
  void initState() {
    super.initState();
    widget.storage!.readData().then((String value) {
      setState(() {
        if (data != "") {
          print("newdata");

          writeData(data!);
          Navigator.pushNamed(
            context,
            AccountView.routeName,
            arguments: AccView(
              accounts: Accounts(data!),
            ),
          );
        } else {
          print(value);
          data = value;
          //writeData(jsondata);
        }
        if (value == "error" || value == null) {
          writeData(jsondata);
        }
      });
    });
  }

  Future<File> writeData(String k) async {
    setState(() {
      data = k;
    });

    return widget.storage!.writeData(data!);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // A button that navigates to a named route.
          // The named route extracts the arguments
          // by itself.
          ElevatedButton(
            onPressed: () {
              print(data);
              Navigator.pushNamed(
                context,
                AccountView.routeName,
                arguments: AccView(
                  accounts: Accounts(data!),
                ),
              );
            },
            child: Text('open accview'),
          ),
        ],
      ),
    );
  }
}

class Storage {
  Future<String> get localPath async {
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  Future<File> get localFile async {
    final path = await localPath;
    print('write to file: $path/db.txt');
    return File('$path/db.txt');
  }

  Future<String> readData() async {
    try {
      final file = await localFile;
      String body = await file.readAsString();

      return body;
    } catch (e) {
      return "error"; //e.toString();
    }
  }

  Future<File> writeData(String data) async {
    final file = await localFile;
    return file.writeAsString("${data}");
  }
}

class HomeScreen extends StatelessWidget {
  final String json;
  HomeScreen({Key? key, required this.json});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // A button that navigates to a named route.
            // The named route extracts the arguments
            // by itself.
            ElevatedButton(
              onPressed: () {
                print(json);
                Navigator.pushNamed(
                  context,
                  AccountView.routeName,
                  arguments: AccView(
                    accounts: Accounts(json),
                  ),
                );
              },
              child: Text('open accview'),
            ),
          ],
        ),
      ),
    );
  }
}
