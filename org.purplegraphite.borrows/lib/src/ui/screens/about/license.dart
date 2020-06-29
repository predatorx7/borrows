import 'package:borrows/src/ui/components/version.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:borrows/src/commons/string_const.dart';
import 'package:borrows/src/ui/components/loading.dart';

void showMyLicensePage({
  @required BuildContext context,
  String applicationName,
  String applicationVersion,
  Widget applicationIcon,
  String applicationLegalese,
  bool useRootNavigator = false,
}) {
  assert(context != null);
  assert(useRootNavigator != null);
  Navigator.of(context, rootNavigator: useRootNavigator)
      .push(MaterialPageRoute<void>(
    builder: (BuildContext context) => LicensePage(
      applicationName: applicationName,
      applicationVersion: applicationVersion,
      applicationIcon: applicationIcon,
      applicationLegalese: applicationLegalese,
    ),
  ));
}

class _LicenseSubPage extends StatelessWidget {
  final String title;
  final List<Widget> legalese;

  const _LicenseSubPage({Key key, this.title, this.legalese}) : super(key: key);
  static Widget navigator(BuildContext context,
      {final String title, final List<Widget> legalese}) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          color: Colors.green,
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => _LicenseSubPage(
              title: title,
              legalese: legalese,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color textColor = isDark ? Colors.white : Colors.black;
    return Scaffold(
      backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
      appBar: AppBar(
        leading: CloseButton(),
        title: Text(
          title,
          style: TextStyle(
            color: Colors.green,
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(8),
        children: legalese,
      ),
    );
  }
}

class LicensePage extends StatefulWidget {
  /// Creates a page that shows licenses for software used by the application.
  ///
  /// The arguments are all optional. The application name, if omitted, will be
  /// derived from the nearest [Title] widget. The version and legalese values
  /// default to the empty string.
  ///
  /// The licenses shown on the [LicensePage] are those returned by the
  /// [LicenseRegistry] API, which can be used to add more licenses to the list.
  const LicensePage({
    Key key,
    this.applicationName,
    this.applicationVersion,
    this.applicationIcon,
    this.applicationLegalese,
  }) : super(key: key);

  /// The name of the application.
  ///
  /// Defaults to the value of [Title.title], if a [Title] widget can be found.
  /// Otherwise, defaults to [Platform.resolvedExecutable].
  final String applicationName;

  /// The version of this build of the application.
  ///
  /// This string is shown under the application name.
  ///
  /// Defaults to the empty string.
  final String applicationVersion;

  /// The icon to show below the application name.
  ///
  /// By default no icon is shown.
  ///
  /// Typically this will be an [ImageIcon] widget. It should honor the
  /// [IconTheme]'s [IconThemeData.size].
  final Widget applicationIcon;

  /// A string to show in small print.
  ///
  /// Typically this is a copyright notice.
  ///
  /// Defaults to the empty string.
  final String applicationLegalese;

  @override
  _LicensePageState createState() => _LicensePageState();
}

class _LicensePageState extends State<LicensePage> {
  @override
  void initState() {
    super.initState();
    _initLicenses();
  }

  final Map<String, Widget> _licenses = <String, Widget>{};
  bool _loaded = false;

  Future<void> _initLicenses() async {
    await for (final LicenseEntry license in LicenseRegistry.licenses) {
      if (!mounted) {
        return;
      }
      final List<LicenseParagraph> paragraphs =
          await SchedulerBinding.instance.scheduleTask<List<LicenseParagraph>>(
        license.paragraphs.toList,
        Priority.animation,
        debugLabel: 'License',
      );
      if (!mounted) {
        return;
      }
      final String title = license.packages.join(', ');
      final List<Widget> legalese = [];
      for (final LicenseParagraph paragraph in paragraphs) {
        if (paragraph.indent == LicenseParagraph.centeredIndent) {
          legalese.add(Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Text(
              paragraph.text,
              style: const TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ));
        } else {
          assert(paragraph.indent >= 0);
          legalese.add(Padding(
            padding: EdgeInsetsDirectional.only(
                top: 8.0, start: 16.0 * paragraph.indent),
            child: Text(
              paragraph.text,
              textAlign: TextAlign.justify,
            ),
          ));
        }
      }
      final ListTile child = _LicenseSubPage.navigator(
        context,
        title: title,
        legalese: legalese,
      );
      setState(() {
        _licenses[title] = child;
      });
    }
    setState(() {
      _loaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final String name = widget.applicationName;
    final String version = widget.applicationVersion;
    final Widget icon = widget.applicationIcon;
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color textColor = isDark ? Colors.white : Colors.black;
    return Scaffold(
      backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: Icon(EvaIcons.arrowIosBack),
        ),
        title: Text(localizations.licensesPageTitle),
      ),
      // All of the licenses page text is English. We don't want localized text
      // or text direction.
      body: Localizations.override(
        locale: const Locale('en', 'US'),
        context: context,
        child: DefaultTextStyle(
          style: Theme.of(context).textTheme.caption.apply(color: textColor),
          child: SafeArea(
            bottom: false,
            child: Scrollbar(
              child: ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
                children: <Widget>[
                  // App title, probably null.
                  if (name != null)
                    Text(
                      name,
                      style: Theme.of(context).textTheme.headline5,
                      textAlign: TextAlign.center,
                    ),
                  // App icon
                  if (icon != null)
                    Center(
                      child: IconTheme(
                          data: Theme.of(context).iconTheme, child: icon),
                    ),
                  Version(
                    version: version,
                  ),
                  SizedBox(height: 9.0),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Divider(
                      height: 10,
                      color: isDark ? Colors.white : Colors.green,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Application License',
                      style: Theme.of(context).textTheme.headline6.apply(
                            color: textColor,
                          ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 9.0),
                    child: Text(
                      Strings.applicationLegalese ?? '',
                      style: Theme.of(context)
                          .textTheme
                          .caption
                          .apply(color: textColor),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  ..._licenses.values,
                  if (!_loaded)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24.0),
                      child: Center(
                        child: CircularLoading(
                          useScaffold: false,
                          useWhiteBackground: false,
                        ),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 9, top: 24),
                    child: Text(
                      'Powered by Flutter',
                      style: Theme.of(context)
                          .textTheme
                          .caption
                          .apply(color: textColor),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  FlutterLogo(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
