import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/ServiceService.dart';
import '../models/service.dart';
import '../services/auth_service.dart';
import 'Footer.dart';
import 'ListeAvisScreen.dart';

class UserScreen extends StatefulWidget {
  final String username;
  const UserScreen({Key? key, required this.username}) : super(key: key);

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final AuthService authService = AuthService();
  final _serviceService = ServiceService();
  late Future<List<Service>> _services;
  List<Service> _allServices = [];
  List<Service> _filteredServices = [];
  final TextEditingController _searchController = TextEditingController();
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _services = _serviceService.getServices();
    _services.then((services) {
      setState(() {
        _allServices = services;
        _filteredServices = services;
      });
    });
    _searchController.addListener(_filterServices);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterServices);
    _searchController.dispose();
    super.dispose();
  }

  void _filterServices() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredServices = query.isEmpty
          ? _allServices
          : _allServices
              .where((service) => service.titre.toLowerCase().contains(query))
              .toList();
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/help');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Fond blanc
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Rechercher par service',
                  filled: true,
                  fillColor: Colors.white,
                  // Personnalisation de la bordure
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30), // Bordure arrondie
                    borderSide: BorderSide(
                      color: Colors.blueAccent, // Couleur de la bordure
                      width: 2, // Épaisseur de la bordure
                    ),
                  ),
                  // Bordure lorsqu'il est sélectionné
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(
                      color: Colors
                          .grey, // Couleur de la bordure quand sélectionnée
                      width: 2,
                    ),
                  ),
                  // Bordure lorsque le champ est vide
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(
                      color: Colors
                          .grey, // Couleur de la bordure quand non sélectionnée
                      width: 2,
                    ),
                  ),
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Les Services',
                style: GoogleFonts.rochester(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF00BCD0)),
              ),
              SizedBox(height: 16),
              _filteredServices.isEmpty
                  ? Center(child: Text('Aucun service trouvé'))
                  : GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12.0,
                        mainAxisSpacing: 12.0,
                        childAspectRatio: 0.8,
                        mainAxisExtent: 400, // Augmenter la hauteur
                      ),
                      itemCount: _filteredServices.length,
                      itemBuilder: (context, index) {
                        final service = _filteredServices[index];
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 6,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20)),
                                child: Image.memory(
                                  base64Decode(service.imageUrl),
                                  width: double.infinity,
                                  height: 200, // Image plus grande
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      service.titre,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Color(
                                            0xFF213E88), // Ajout de la couleur demandée
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      service.description,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600]),
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '${service.duree} ',
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          service.prix == service.prix.toInt()
                                              ? '${service.prix.toInt()} DT'
                                              : '${service.prix.toStringAsFixed(2)} DT',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Spacer(),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 7.0, vertical: 7.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () {},
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Color(0xFF00BCD0),
                                          foregroundColor: Colors.white,
                                          padding: EdgeInsets.symmetric(
                                              vertical: 14),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                        ),
                                        child: Text('Réserver',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    IconButton(
                                      icon: Icon(Icons.comment,
                                          color: Colors.blue, size: 30),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ListeAvisScreen(
                                                idService: service
                                                    .id), // Assurez-vous que service.id est défini
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
      bottomNavigationBar:
          Footer(currentIndex: _selectedIndex, onTap: _onItemTapped),
    );
  }
}
