import 'package:borrows/src/commons/string_const.dart';
import 'package:borrows/src/ui/components/drawer.dart';
import 'package:borrows/src/ui/components/popupMenuTIle.dart';
import 'package:borrows/src/ui/components/title.dart';
import 'package:borrows/src/ui/screens/about/about.dart';
import 'package:borrows/src/utils/string_util.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _addEntry() {
    // open add entry adaptable dialog
  }
  @override
  Widget build(BuildContext context) {
    final Brightness brightness = Theme.of(context).brightness;
    final bool isDark = brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: DrawerButton(),
        title: ApplicationTitle(),
        actions: <Widget>[
          PopupMenuButton(
              color: isDark ? Colors.grey.shade800 : Colors.white,
              itemBuilder: (context) {
                return <PopupMenuEntry>[
                  PopupMenuTile(
                    onTap: () {},
                    icon: Icon(EvaIcons.options2),
                    label: StringUtils.toFirstLetterUppercase(Strings.settings),
                  ),
                  PopupMenuTile(
                    onTap: () {
                      showMyAboutDialog(
                        context: context,
                        applicationIcon: ApplicationTitle(),
                        applicationLegalese: Strings.applicationLegalese,
                        applicationVersion: Strings.applicationVersion,
                      );
                    },
                    icon: Icon(EvaIcons.questionMark),
                    label: StringUtils.toFirstLetterUppercase(Strings.aboutUs),
                  ),
                ];
              }),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addEntry,
        tooltip: 'add entry',
        child: Icon(Icons.add),
        foregroundColor: isDark ? Colors.black : Colors.white,
        backgroundColor: isDark ? Theme.of(context).accentColor : Colors.black,
      ),
      // TODO: fix drawer theme
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            // Head
          ],
        ),
      ),
    );
  }
}
