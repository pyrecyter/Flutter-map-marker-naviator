import 'package:flutter/material.dart';

class DrawerItem {
  String title;
  IconData icon;
  DrawerItem(this.title, this.icon);
}

class DrawerMenu extends StatefulWidget {
  final drawerItems = [
    new DrawerItem("Map", Icons.home),
    new DrawerItem("Option1", Icons.credit_card),
    //add here 1st
  ];

  @override
  State<StatefulWidget> createState() {
    return new MenuState();
  }
}

class MenuState extends State<DrawerMenu> {
  int _selectedDrawerIndex = 0;

  _getDrawerItemWidget(int pos) {
  }
 PageController _controller = new PageController(initialPage: 1, viewportFraction: 1.0);
  _onSelectItem(int index) {
    setState(() => _selectedDrawerIndex = index);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    var drawerOptions = <Widget>[];
    for (var i = 0; i < widget.drawerItems.length; i++) {
      var d = widget.drawerItems[i];
      drawerOptions.add(new ListTile(
        leading: new Icon(d.icon),
        title: new Text(d.title),
        selected: i == _selectedDrawerIndex,
        onTap: () => _onSelectItem(i),
      ));
    }

    return new  Drawer(
        child: new Column(
          children: <Widget>[
            new DrawerHeader(
              child: null,
              decoration: new BoxDecoration(
                color: Colors.blueAccent,
              ),
            ),
            new Column(children: drawerOptions)
          ],
        ),
      );
  }
}
