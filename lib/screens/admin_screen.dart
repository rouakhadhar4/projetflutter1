import 'package:flutter/material.dart';
import 'package:projectlavage/models/abonnement.dart';
import 'package:projectlavage/screens/signin_screen.dart'; // Assurez-vous que vous importez la page de connexion
import 'package:projectlavage/services/auth_service.dart';


import '../models/user.dart';
import 'AbonnementPage.dart';
import 'AddAbonnementPage.dart';
import 'AddEquipeScreen.dart';
import 'AddServicePage.dart';
import '../models/service.dart';




import 'EditProfilePageAdmin.dart';
import 'EditProfilePageTechnicien.dart';
import 'ListeAvisPage.dart';
import 'ServicePage.dart';
import 'UpdateAbonnementPage.dart';
import 'UpdateServicePage.dart';

import 'EquipeListScreen.dart';
import 'editEquipeScreen.dart';
import 'ListeUsers.dart';

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
        '/AbonnementPage': (context) => AbonnementPage(),
        '/AddEquipeScreen': (context) => AddEquipeScreen(),
        '/EditEquipeScreen': (context) => EditEquipeScreen(user: ModalRoute.of(context)!.settings.arguments as User ),
        '/EquipeListScreen': (context) => EquipeListScreen(),
        '/EditProfilePageAdmin': (context) => EditProfilePageAdmin(),
        '/ListeUsers': (context) => ListeUsers(),
        '/ListeAvisPage': (context) => ListeAvisPage()




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
            _buildDrawerItem(context, 'assets/images/user.png', 'Utilisateurs', 3),
            _buildDrawerItem(context, 'assets/images/avis-client.png', 'Avis', 4),
            _buildDrawerItem(
                context, 'assets/images/promotion.png', 'Promotion', 5),
            _buildDrawerItem(
                context, 'assets/images/subscriptions.png', 'Abonnements', 6),
            _buildDrawerItem(
                context, 'assets/images/reservations.png', 'Réservations', 7),
            _buildDrawerItem(context, 'assets/images/faq.png', 'FAQ', 8),

            _buildDrawerItem(
                context, 'assets/images/profile.png', 'Profile', 9),
            _buildDrawerItem(
                context, 'assets/images/logout.png', 'Se déconnecter', 10),
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
          if (index == 10) {
            // Déconnexion si 'Se déconnecter' est sélectionné
            await authService.signOut();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => SignInScreen()), // Page de connexion
            );
          } else if (index == 1) {
            // Si 'Services' est sélectionné, naviguer vers AddServicePage
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ServicePage()),
            );
          } else if (index == 6) {
            // Si index est 5, naviguer vers AbonnementPage
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AbonnementPage()),
            );
          } else if (index == 2) {
            // Si index est 2, naviguer vers EquipeListScreen
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EquipeListScreen()),
            );
          } else if (index == 9) {
            // Si index est 8, naviguer vers EditProfilePageAdmin
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EditProfilePageAdmin()),
            );
          } else if (index == 3) {
            // Si index est 3, naviguer vers ListeUsers
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ListeUsers()), // Remplace par la page souhaitée
            );
          } else if (index == 4) {
            // Nouvelle condition pour index == 4
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ListeAvisPage()), // Remplacez NouvellePage par la page appropriée
            );
          } else {
            // Si aucun des autres index ne correspond, fermer le drawer et sélectionner la page
            Navigator.pop(context);
            onSelectPage(index);
          }
        }


    );
  }
}
