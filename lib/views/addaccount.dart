import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/account.dart';

class FormViewb extends StatelessWidget {
  static const routeName = '/formb';

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as AccForm;
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Formb"),
        leading: Text("press send to go back"),
      ),
      body: AccForm(accounts: args.accounts, loc: args.loc),
    );
  }
}

// ignore: must_be_immutable
class AccForm extends StatefulWidget {
  final Accounts accounts;
  final String loc;

  AccForm({Key? key, required this.accounts, required this.loc})
      : super(key: key);

  List<Subtotals>? bucks = List.generate(
      1,
      (index) => Subtotals.fromForm(
          name: "fill",
          subtotals: List.generate(
              1,
              (index) => Subtotal.fromForm(
                  shares: 0,
                  value: 0.0,
                  name: "fill",
                  pricePer: 0.0,
                  loc: "dummy,fill")),
          value: 0.0));

  double? _value;
  String? _name;

  IconData submit = Icons.send_outlined;
  @override
  _AccFormState createState() => _AccFormState();
}

class _AccFormState extends State<AccForm> {
  Container _buildtext(
      String hint, Function(String val) funct, TextInputType t) {
    return Container(
        child: TextField(
      autofocus: false,
      cursorHeight: 10.0,
      expands: false,
      keyboardType: t,
      minLines: 1,
      maxLines: 2,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          border: OutlineInputBorder(),
          hintText: hint,
          filled: true,
          fillColor: Colors.grey[200]),
      onChanged: funct,
    ));
  }

  @override
  Widget build(BuildContext context) {
    Accounts newAcc = widget.accounts;
    //final halfMediaWidth = MediaQuery.of(context).size.width / 1.5;

    return ListView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      clipBehavior: Clip.hardEdge,
      itemExtent: 50.0,
      children: <Widget>[
        _buildtext('Account Name', (val) {
          widget._name = val;
        }, TextInputType.name),

        _buildtext('value', (val) {
          if (val.isNotEmpty) {
            widget._value = double.parse(val.toString());
          }
        }, TextInputType.numberWithOptions(decimal: true)),

        // ignore: deprecated_member_use
        IconButton(
          color: Colors.blueAccent,
          icon: Icon(widget.submit),
          onPressed: () {
            setState(() {
              widget.submit = Icons.check;
              if (widget._value != null && widget._name != null) {
                if (widget._value.toString().indexOf('.') == -1) {
                  widget._value = double.parse("${widget._value}.0");
                }
                newAcc.insertaccount(
                    Account.fromForm(
                        name: widget._name,
                        buckets: widget.bucks,
                        value: widget._value,
                        loc: widget.loc),
                    widget.loc);
              } else {
                newAcc.insertaccount(
                    Account.fromForm(
                        name: widget._name,
                        buckets: widget.bucks,
                        value: 0.0,
                        loc: widget.loc),
                    widget.loc);
              }
              //print(widget.accounts.toJson());
              Navigator.pop(context, newAcc.toJson());
            });
            //print(jsondata);
          },
        ),
      ],
    );
  }
}
