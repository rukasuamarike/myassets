import 'package:flutter/material.dart';
import 'package:myassets/main.dart';
import '../models/SliverMulti.dart';
import 'addview.dart';
import '../models/account.dart';

class SubtotalView extends StatelessWidget {
  static const routeName = '/subtotals';

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as SubView;
    void _doForm(BuildContext context) async {
      // Navigator.push returns a Future that completes after calling
      // Navigator.pop on the Selection Screen.
      final result = await Navigator.pushNamed(context, FormView.routeName,
          arguments: SubForm(
              accounts: args.accs, loc: '${args.acc.name},${args.cat.name}'));
      print("result");
      print(result);
      Navigator.pushNamed(context, DataStore.routeName,
          arguments: Home(storage: Storage(), data: "$result"));
      //Navigator.pushNamed(context, DataStore.routeName,arguments: Home(storage: Storage(), data: result))
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(args.cat.name!),
      ),
      resizeToAvoidBottomInset: false,
      body: SubView(accs: args.accs, acc: args.acc, cat: args.cat),
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

class SubView extends StatefulWidget {
  final Subtotals cat;
  final Account acc;
  final Accounts accs;
  SubView({
    Key? key,
    required this.accs,
    required this.acc,
    required this.cat,
  }) : super(key: key);

  @override
  _SubViewState createState() => _SubViewState();
}

class _SubViewState extends State<SubView> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverMultilineAppBar(
          title: '\$${(widget.cat.value ?? 0.1)} USD',
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
        SliverGrid.count(
          crossAxisCount: 1,
          childAspectRatio: 9.0 / 3.0,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          children: List.generate(
            widget.cat.subtotals!.length,
            (int index) => Card(
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(widget.cat.subtotals![index].name ?? 'default'),
                        SizedBox(height: 8.0),
                        Text(
                            'value: \$${(widget.cat.subtotals![index].value ?? 0.1).toString()} USD'),
                        SizedBox(height: 16.0),
                        Text(
                            '${widget.cat.subtotals![index].shares} shares @\$${widget.cat.subtotals![index].pricePer}USD'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
