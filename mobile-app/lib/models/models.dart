// lib/models/categorie.dart
class Categorie {
  final int id;
  final String nom;

  Categorie({required this.id, required this.nom});

  factory Categorie.fromJson(Map<String, dynamic> json) =>
      Categorie(id: json['id'], nom: json['nom']);
}

// lib/models/produit.dart
class Produit {
  final int id;
  final String nom;
  final double prix;
  final int stock;
  final Categorie categorie;

  Produit({
    required this.id,
    required this.nom,
    required this.prix,
    required this.stock,
    required this.categorie,
  });

  factory Produit.fromJson(Map<String, dynamic> json) => Produit(
        id: json['id'],
        nom: json['nom'],
        prix: (json['prix'] as num).toDouble(),
        stock: json['stock'],
        categorie: Categorie.fromJson(json['categorie']),
      );
}

// lib/models/avis.dart
class Avis {
  final int id;
  final int produitId;
  final String auteur;
  final String commentaire;
  final int note;

  Avis({
    required this.id,
    required this.produitId,
    required this.auteur,
    required this.commentaire,
    required this.note,
  });

  factory Avis.fromJson(Map<String, dynamic> json) => Avis(
        id: json['id'],
        produitId: json['produitId'],
        auteur: json['auteur'],
        commentaire: json['commentaire'],
        note: json['note'],
      );
}
