import 'package:flutter/material.dart';
import 'models/models.dart';
import 'services/api_service.dart';
import 'screens/avis_screen.dart';

void main() {
  runApp(const BoutiqueApp());
}

class BoutiqueApp extends StatelessWidget {
  const BoutiqueApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Boutique',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Home Screen — Catégories + Produits
// ─────────────────────────────────────────────────────────────────────────────

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Categorie? _selectedCategorie;
  late Future<List<Categorie>> _categoriesFuture;

  @override
  void initState() {
    super.initState();
    _categoriesFuture = ApiService.getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🛍️ Boutique'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // ── Catégorie Dropdown ──────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Colors.indigo.shade50,
            child: FutureBuilder<List<Categorie>>(
              future: _categoriesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Text('Erreur: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red));
                }
                final categories = snapshot.data ?? [];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Filtrer par catégorie',
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.indigo)),
                    const SizedBox(height: 6),
                    DropdownButton<Categorie>(
                      isExpanded: true,
                      hint: const Text('Toutes les catégories'),
                      value: _selectedCategorie,
                      items: [
                        const DropdownMenuItem<Categorie>(
                          value: null,
                          child: Text('Toutes les catégories'),
                        ),
                        ...categories.map((cat) => DropdownMenuItem(
                              value: cat,
                              child: Text(cat.nom),
                            )),
                      ],
                      onChanged: (cat) =>
                          setState(() => _selectedCategorie = cat),
                    ),
                  ],
                );
              },
            ),
          ),

          // ── Products List ──────────────────────────────────────────────
          Expanded(
            child: FutureBuilder<List<Produit>>(
              future: ApiService.getProduits(
                  categorieId: _selectedCategorie?.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.wifi_off,
                            size: 64, color: Colors.grey),
                        const SizedBox(height: 12),
                        Text('Erreur de connexion\n${snapshot.error}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.grey)),
                      ],
                    ),
                  );
                }
                final produits = snapshot.data ?? [];
                if (produits.isEmpty) {
                  return const Center(
                    child: Text('Aucun produit trouvé',
                        style: TextStyle(color: Colors.grey)),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: produits.length,
                  itemBuilder: (context, index) {
                    final produit = produits[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => AvisScreen(produit: produit)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              // Product icon
                              Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  color: Colors.indigo.shade100,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(Icons.shopping_bag,
                                    color: Colors.indigo.shade600, size: 28),
                              ),
                              const SizedBox(width: 14),
                              // Product info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(produit.nom,
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600)),
                                    const SizedBox(height: 4),
                                    Text(produit.categorie.nom,
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.indigo.shade400)),
                                    const SizedBox(height: 4),
                                    Text('Stock: ${produit.stock}',
                                        style: const TextStyle(
                                            fontSize: 12, color: Colors.grey)),
                                  ],
                                ),
                              ),
                              // Price
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '${produit.prix.toStringAsFixed(2)} €',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.indigo.shade700),
                                  ),
                                  const SizedBox(height: 4),
                                  const Icon(Icons.chevron_right,
                                      color: Colors.grey),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
