import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/account.dart';

class FormView extends StatelessWidget {
  static const routeName = '/form';

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as SubForm;
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Form"),
        leading: Text("press send to go back"),
      ),
      body: SubForm(accounts: args.accounts, loc: args.loc),
    );
  }
}

// ignore: must_be_immutable
class SubForm extends StatefulWidget {
  final Accounts accounts;
  final String loc;

  SubForm({Key? key, required this.accounts, required this.loc})
      : super(key: key);
  Subtotal? inSub;
  double? _priceper;
  double? _value;
  int? _shares;
  String? _name;

  bool cShare = false;
  bool cPrice = false;
  IconData submit = Icons.send_outlined;
  @override
  _SubFormState createState() => _SubFormState();
}

class _SubFormState extends State<SubForm> {
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
        _buildtext('Fund Name', (val) {
          widget._name = val;
        }, TextInputType.name),

        _buildtext('Amount of Shares', (val) {
          if (val.isNotEmpty) {
            widget._shares = int.parse(val);
          }
          widget.cShare = true;
          if (widget.cPrice & widget.cShare) {
            widget._value =
                double.parse((widget._shares! * widget._priceper!).toString());
          }
        }, TextInputType.number),

        _buildtext('Price Per Share', (val) {
          if (val.isNotEmpty) {
            if (val.indexOf('.') == -1) {
              widget._priceper = double.parse("$val.0");
            } else {
              widget._priceper = double.parse(val.toString());
            }
          }
          widget.cPrice = true;
        }, TextInputType.numberWithOptions(decimal: true)),
        _buildtext(widget._value.toString(), (val) {
          if (val.isNotEmpty) {
            widget._value = double.parse(val.toString());
          }
          widget.cPrice = true;
        }, TextInputType.numberWithOptions(decimal: true)),

        // ignore: deprecated_member_use
        IconButton(
          color: Colors.blueAccent,
          icon: Icon(widget.submit),
          onPressed: () {
            setState(() {
              widget.submit = Icons.check;
              if (widget.cPrice & widget.cShare) {
                if (widget._value.toString().indexOf('.') == -1) {
                  widget._value = double.parse("${widget._value}.0");
                }
                newAcc.insertsubtotal(
                    Subtotal.fromForm(
                        name: widget._name,
                        pricePer: widget._priceper,
                        shares: widget._shares,
                        value: widget._value,
                        loc: widget.loc),
                    widget.loc);
              } else {
                if (widget.cShare == false) {
                  newAcc.insertsubtotal(
                      Subtotal.fromForm(
                          name: widget._name,
                          pricePer: widget._priceper,
                          shares: widget._shares,
                          value: widget._value,
                          loc: widget.loc),
                      widget.loc);
                }
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
