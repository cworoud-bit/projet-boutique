import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/models.dart';

class ApiService {
  // Replace with your machine's IP when running on a physical device
  static const String baseUrl = 'http://10.0.2.2:8090'; // Android emulator → localhost

  // ─── Catégories ──────────────────────────────────────────────────────────

  static Future<List<Categorie>> getCategories() async {
    final response = await http.get(Uri.parse('$baseUrl/api/categories'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Categorie.fromJson(json)).toList();
    }
    throw Exception('Erreur lors du chargement des catégories');
  }

  // ─── Produits ─────────────────────────────────────────────────────────────

  static Future<List<Produit>> getProduits({int? categorieId}) async {
    final uri = categorieId != null
        ? Uri.parse('$baseUrl/api/produits?categorieId=$categorieId')
        : Uri.parse('$baseUrl/api/produits');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Produit.fromJson(json)).toList();
    }
    throw Exception('Erreur lors du chargement des produits');
  }

  // ─── Avis ─────────────────────────────────────────────────────────────────

  static Future<List<Avis>> getAvis(int produitId) async {
    final response = await http.get(Uri.parse('$baseUrl/api/avis/$produitId'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Avis.fromJson(json)).toList();
    }
    throw Exception('Erreur lors du chargement des avis');
  }

  static Future<void> submitAvis(Avis avis) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/avis'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'produitId': avis.produitId,
        'auteur': avis.auteur,
        'commentaire': avis.commentaire,
        'note': avis.note,
      }),
    );
    if (response.statusCode != 201) {
      throw Exception('Erreur lors de la soumission de l\'avis');
    }
  }
}
