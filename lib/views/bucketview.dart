import 'package:flutter/material.dart';

import 'package:myassets/views/subview.dart';

import '../main.dart';
import '../models/SliverMulti.dart';
import '../models/account.dart';
import 'addbucket.dart';

class BucketView extends StatelessWidget {
  static const routeName = '/buckets';

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Bucketview;
    void _doForm(BuildContext context) async {
      // Navigator.push returns a Future that completes after calling
      // Navigator.pop on the Selection Screen.
      final result = await Navigator.pushNamed(context, FormViewa.routeName,
          arguments: BukForm(accounts: args.accs, loc: '${args.acc.name},'));
      print("result");
      print(result);
      Navigator.pushNamed(context, DataStore.routeName,
          arguments: Home(storage: Storage(), data: "$result"));
      //Navigator.pushNamed(context, DataStore.routeName,arguments: Home(storage: Storage(), data: result))
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(args.acc.name!),
      ),
      body: Bucketview(acc: args.acc, accs: args.accs),
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

class Bucketview extends StatefulWidget {
  final Account acc;
  final Accounts accs;
  Bucketview({Key? key, required this.acc, required this.accs})
      : super(key: key);
  @override
  _BucketsState createState() => _BucketsState();
}

class _BucketsState extends State<Bucketview> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverMultilineAppBar(
          title: '\$${(widget.acc.value ?? 0.1)} USD',
          leading: IconButton(
              onPressed: () => print('box?'),
              icon: Icon(
                Icons.account_box,
                semanticLabel: 'menu',
              )),
          actions: <Widget>[
            IconButton(
                onPressed: () => print('search button'),
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
                  onTap: () {
                    print("tapp");
                    print(widget.acc.buckets![index].subtotals!.length);

                    Navigator.pushNamed(context, SubtotalView.routeName,
                        arguments: SubView(
                            accs: widget.accs,
                            acc: widget.acc,
                            cat: widget.acc.buckets![index]));
                  },
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                  widget.acc.buckets![index].name ?? 'default'),
                              SizedBox(height: 8.0),
                              Text(
                                  'value: \$${(widget.acc.buckets![index].value ?? 0.1).toString()} USD'),
                              SizedBox(height: 16.0),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            childCount: widget.acc.buckets!.length,
          ),
        ),
      ],
    );
  }
}
