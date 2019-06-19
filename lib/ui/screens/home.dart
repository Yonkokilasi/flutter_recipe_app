import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double _iconSize = 20.0;

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 2.0,
          bottom: TabBar(
            labelColor: Theme.of(context).indicatorColor,
            tabs: [
              Tab(
                icon: Icon(Icons.restaurant, size: _iconSize),
              )
            ],
          ),
        ),
      ),
    );
  }
}
