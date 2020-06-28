import 'package:borrows/src/commons/string_const.dart';
import 'package:borrows/src/ui/components/drawer.dart';
import 'package:borrows/src/ui/components/text/icon.dart';
import 'package:borrows/src/ui/components/text/text.dart';
import 'package:borrows/src/utils/string_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icofont_flutter/icofont_flutter.dart';

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
    final String title =
        StringUtils.toFirstLetterUppercase(Strings.applicationTitle);
    final Brightness brightness = Theme.of(context).brightness;
    final bool isDark = brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: DrawerButton(),
        title: Text(
          title,
          style: GoogleFonts.bitter(fontSize: 20),
        ),
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
            ListTile(
              leading: IconBuilder(
                context,
                IcoFontIcons.settings,
                IconType.drawerIcon,
              ),
              title: TextBuilder(
                context,
                StringUtils.toFirstLetterUppercase(Strings.settings),
                TextType.drawerText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
