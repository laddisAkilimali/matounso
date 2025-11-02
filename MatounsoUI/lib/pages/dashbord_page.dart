import 'package:flutter/material.dart';
import 'package:meditrackui/pages/drawer_page.dart';

class MyDashboardPage extends StatefulWidget {
  final String userName;
  final String userRole;
  final List<String> userPermissions;

  const MyDashboardPage({
    super.key,
    required this.userName,
    required this.userRole,
    required this.userPermissions,
  });

  @override
  State<MyDashboardPage> createState() => _MyDashboardPageState();
}

class _MyDashboardPageState extends State<MyDashboardPage> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  void _navigateTo(Widget page) {
    // remplace la page courante dans le Navigator interne
    _navigatorKey.currentState!.pushReplacement(
      MaterialPageRoute(builder: (context) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          AppDrawer(
            userName: widget.userName,
            userRole: widget.userRole,
            userPermissions: widget.userPermissions,
            /*
             cette fonction _navigateTo(page) sera appeler dans AppDrawer
             quand on aura definir ce patrametre de pageCharge
            */
            pageCharge: (page) => _navigateTo(page),
          ),
          Expanded(
            child: Navigator(
              key: _navigatorKey,
              onGenerateRoute: (settings) {
                return MaterialPageRoute(
                  builder: (context) =>
                      Center(child: Text("Bienvenue sur le tableau de bord")),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
