import 'dart:async';

import 'package:flutter/material.dart';
import 'package:myassets/main.dart';
import 'package:myassets/views/addaccount.dart';
import 'package:myassets/views/bucketview.dart';
import '../models/SliverMulti.dart';
import '../models/account.dart';

class AccountView extends StatelessWidget {
  static const routeName = '/accounts';

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as AccView;
    void _doForm(BuildContext context) async {
      // Navigator.push returns a Future that completes after calling
      // Navigator.pop on the Selection Screen.
      final result = await Navigator.pushNamed(context, FormViewb.routeName,
          arguments: AccForm(accounts: args.accounts, loc: ''));
      print("result");
      print(result);
      Navigator.pushNamed(context, DataStore.routeName,
          arguments: Home(storage: Storage(), data: "$result"));
      //Navigator.pushNamed(context, DataStore.routeName,arguments: Home(storage: Storage(), data: result))
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Accounts'),
      ),
      resizeToAvoidBottomInset: false,
      body: AccView(accounts: args.accounts),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.check_box_outline_blank),
            label: 'filler',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'add new',
          )
        ],
        onTap: (value) {
          _doForm(context);
        },
      ),
    );
  }
}

class AccView extends StatefulWidget {
  final Accounts accounts;
  AccView({Key? key, required this.accounts}) : super(key: key);
  @override
  _AccViewState createState() => _AccViewState();
}

class _AccViewState extends State<AccView> {
  bool selected = false;
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverMultilineAppBar(
          title: '\$${(widget.accounts.value ?? 0.1)} USD',
          leading: IconButton(
              onPressed: () => print('box?'),
              icon: Icon(
                Icons.account_box,
                semanticLabel: 'menu',
              )),
          actions: <Widget>[
            IconButton(
                onPressed: () => print('searchbutton'),
                icon: Icon(
                  Icons.search,
                  semanticLabel: 'search',
                )),
            IconButton(
                onPressed: () => print('Filter button'),
                icon: Icon(
                  Icons.tune,
                  semanticLabel: 'filter',
                ))
          ],
        ),
        SliverGrid(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 500.0,
            mainAxisSpacing: 8.0,
            crossAxisSpacing: 8.0,
            childAspectRatio: 9.0 / 3.0,
          ),
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return Container(
                  alignment: Alignment.center,
                  color: Colors.teal[100 * (index % 9)],
                  child: GestureDetector(
                      onHorizontalDragUpdate: (details) {
                        // Note: Sensitivity is integer used when you don't want to mess up vertical drag
                        int sensitivity = 8;
                        if (details.delta.dx > sensitivity) {
                          setState(() {
                            selected = false;
                          });

                          print("l");
                        } else if (details.delta.dx < -sensitivity) {
                          setState(() {
                            selected = true;
                          });

                          print("r");
                        }
                      },
                      onTap: () {
                        print("tapp");
                        print(widget.accounts.subCat!.length);
                        Navigator.pushNamed(
                          context,
                          BucketView.routeName,
                          arguments: Bucketview(
                              acc: widget.accounts.subCat![index],
                              accs: widget.accounts),
                        );
                      },
                      child: Stack(children: [
                        GestureDetector(
                            onTap: () => {
                                  widget.accounts.removeaccount(widget.accounts,
                                      "${widget.accounts.subCat![index].name},")
                                },
                            child: AnimatedContainer(
                                alignment: selected
                                    ? Alignment.centerLeft
                                    : Alignment.center,
                                duration: const Duration(seconds: 1),
                                width: selected ? 400.0 : 500.0,
                                child: Card(
                                    clipBehavior: Clip.antiAlias,
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  16.0, 12.0, 16.0, 8.0),
                                              child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                        'delete ${widget.accounts.subCat![index].name}?'),
                                                  ])),
                                        ])))),
                        AnimatedContainer(
                          alignment: selected
                              ? Alignment.centerLeft
                              : Alignment.center,
                          duration: const Duration(seconds: 1),
                          width: selected ? 400.0 : 500.0,
                          child: Card(
                            clipBehavior: Clip.antiAlias,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.fromLTRB(
                                      16.0, 12.0, 16.0, 8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                          widget.accounts.subCat![index].name ??
                                              'default'),
                                      SizedBox(height: 8.0),
                                      Text(
                                          'value: \$${(widget.accounts.subCat![index].value ?? 0.1).toString()} USD'),
                                      SizedBox(height: 16.0),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ])));
            },
            childCount: widget.accounts.subCat!.length,
          ),
        ),
      ],
    );
  }
}
