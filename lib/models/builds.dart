import 'SliverMulti.dart';
import 'package:flutter/material.dart';
import 'account.dart';

SliverMultilineAppBar buildBucketAppBar(Account a) {
  SliverMultilineAppBar bar = SliverMultilineAppBar(
    title: '${(a.name ?? 'default')} \$${(a.value ?? 0.1)} USD',
    leading: IconButton(
        onPressed: () => print('backButton'),
        icon: Icon(
          Icons.arrow_back_ios,
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
  );
  return bar;
}
