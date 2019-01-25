import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {

  HomePage() : super(key: GlobalKey(debugLabel: "[home]"));

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Colors.transparent,
            title: ConstrainedBox(
              constraints: BoxConstraints.expand(height: 45, width: 300),
              child: Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(22.5))),
                elevation: 6,
              ),
            ),
          )
        ],
      ),
    );
  }
}