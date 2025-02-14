class Service {
  final int id;
  final String titre;
  final String description;
  final double prix;
  final String duree;
  String? imageName;  // Image du service (peut être null)
  String imageUrl;    // URL de l'image (ne peut pas être null)

  Service({
    required this.id,
    required this.titre,
    required this.description,
    required this.prix,
    required this.duree,
    this.imageName,
    required this.imageUrl,
  });

  // Convertir en format JSON
  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'] ?? 0,  // Si 'id' est null, utiliser une valeur par défaut 0
      titre: json['titre'] ?? '',  // Assurer que titre n'est jamais null
      description: json['description'] ?? '',  // Assurer que description n'est jamais null
      prix: (json['prix'] ?? 0.0).toDouble(),  // Assurer que prix n'est jamais null
      duree: json['duree'] ?? '',  // Assurer que durée n'est jamais null
      imageName: json['imageName'],  // imageName peut être null
      imageUrl: json['image'] ?? '',  // imageUrl ne peut pas être null, sinon chaîne vide
    );
  }

  // Convertir en format JSON pour l'envoi à l'API
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titre': titre,
      'description': description,
      'prix': prix,
      'duree': duree,
      'imageName': imageName,  // imageName peut être null
      'image': imageUrl,  // imageUrl ne doit jamais être null
    };
  }
}
