import 'package:flutter/material.dart';
import 'package:projectlavage/models/abonnement.dart';
import 'package:projectlavage/screens/signin_screen.dart'; // Assurez-vous que vous importez la page de connexion
import 'package:projectlavage/services/auth_service.dart';


import 'AbonnementPage.dart';
import 'AddAbonnementPage.dart';
import 'AddServicePage.dart';
import '../models/service.dart';
import 'ServicePage.dart';
import 'UpdateAbonnementPage.dart';
import 'UpdateServicePage.dart';
import '../models/abonnement.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AdminScreen(),
      routes: {
        '/AddServicePage': (context) => AddServicePage(),
        '/ServicePage': (context) => ServicePage(),
        '/UpdateServicePage': (context) => UpdateServicePage(service: ModalRoute.of(context)!.settings.arguments as Service),
        '/AddAbonnementPage': (context) => AddAbonnementPage(),
        '/UpdateAbonnementPage': (context) => UpdateAbonnementPage(abonnement: ModalRoute.of(context)!.settings.arguments as Abonnement),
        '/AbonnementPage': (context) => AbonnementPage()



      },
    );
  }
}

class AdminScreen extends StatefulWidget {
  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  int _selectedPageIndex = 0;

  // Instance du service AuthService
  final AuthService authService = AuthService();

  final List<Widget> _pages = [
    Center(child: Text('Accueil')),
    ServicePage (),
    Center(child: Text('Services')),
    Center(child: Text('Equipe')),
    Center(child: Text('Promotion')),
    Center(child: Text('Abonnements')),
    Center(child: Text('Réservations')),
    Center(child: Text('FAQ')),
  ];

  void _onSelectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: Colors.black),  // Hamburger icon (3 horizontal lines)
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: Sidebar(authService: authService, onSelectPage: _onSelectPage),
      body: _pages[_selectedPageIndex],
    );
  }
}

class Sidebar extends StatelessWidget {
  final AuthService authService;
  final Function(int) onSelectPage;

  Sidebar({required this.authService, required this.onSelectPage});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.cyan[50],
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.cyan[300],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Admin',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Welcome to Admin Dashboard',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            _buildDrawerItem(context, 'assets/images/home.png', 'Accueil', 0),
            _buildDrawerItem(
                context, 'assets/images/services.png', 'Services', 1),
            _buildDrawerItem(context, 'assets/images/team.png', 'Equipe', 2),
            _buildDrawerItem(
                context, 'assets/images/promotion.png', 'Promotion', 3),
            _buildDrawerItem(
                context, 'assets/images/subscriptions.png', 'Abonnements', 4),
            _buildDrawerItem(
                context, 'assets/images/reservations.png', 'Réservations', 5),
            _buildDrawerItem(context, 'assets/images/faq.png', 'FAQ', 6),
            _buildDrawerItem(
                context, 'assets/images/logout.png', 'Se déconnecter', 7),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, String iconPath, String title,
      int index) {
    return ListTile(
      leading: Image.asset(
        iconPath,
        width: 30,
        height: 30,
      ),
      title: Text(
        title,
        style: TextStyle(fontSize: 16),
      ),
      onTap: () async {
        if (index == 7) {
          // Déconnexion si 'Se déconnecter' est sélectionné
          await authService.signOut();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => SignInScreen()), // Page de connexion
          );
        } else if (index == 1) {
          // Si 'Services' est sélectionné, naviguer vers AddServicePage
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ServicePage()),
          );
        } else if (index == 4) {
          // Si index est 4, naviguer vers TargetPage
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AbonnementPage()), // Remplacez TargetPage par votre page
          );
        } else {
          Navigator.pop(context); // Ferme le drawer
          onSelectPage(index);
        }

      },
    );
  }
}
