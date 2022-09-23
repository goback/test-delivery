import 'package:flutter/material.dart';
import 'package:prac/common/layout/default_layout.dart';

class RootTab extends StatelessWidget {
  const RootTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      body: Container(
        alignment: Alignment.center,
        child: Text('RootTab'),
      ),
    );
  }
}
