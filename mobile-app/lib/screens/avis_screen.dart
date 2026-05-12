import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/api_service.dart';

class AvisScreen extends StatefulWidget {
  final Produit produit;
  const AvisScreen({super.key, required this.produit});

  @override
  State<AvisScreen> createState() => _AvisScreenState();
}

class _AvisScreenState extends State<AvisScreen> {
  final _auteurController = TextEditingController();
  final _commentaireController = TextEditingController();
  int _selectedNote = 5;
  bool _submitting = false;

  Future<void> _submitAvis(VoidCallback refresh) async {
    if (_auteurController.text.isEmpty || _commentaireController.text.isEmpty) return;
    setState(() => _submitting = true);
    try {
      await ApiService.submitAvis(Avis(
        id: 0,
        produitId: widget.produit.id,
        auteur: _auteurController.text,
        commentaire: _commentaireController.text,
        note: _selectedNote,
      ));
      _auteurController.clear();
      _commentaireController.clear();
      setState(() => _selectedNote = 5);
      refresh();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Avis soumis avec succès !')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Avis — ${widget.produit.nom}'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Product summary card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.indigo.shade50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.produit.nom,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('${widget.produit.prix.toStringAsFixed(2)} €',
                    style: TextStyle(fontSize: 16, color: Colors.indigo.shade700)),
                Text('Stock: ${widget.produit.stock}',
                    style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          Expanded(
            child: StatefulBuilder(
              builder: (context, setInnerState) {
                return FutureBuilder<List<Avis>>(
                  future: ApiService.getAvis(widget.produit.id),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Erreur: ${snapshot.error}'));
                    }
                    final avisList = snapshot.data ?? [];
                    return ListView(
                      padding: const EdgeInsets.all(12),
                      children: [
                        // Submit form
                        Card(
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Laisser un avis',
                                    style: TextStyle(
                                        fontSize: 16, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 12),
                                TextField(
                                  controller: _auteurController,
                                  decoration: const InputDecoration(
                                    labelText: 'Votre nom',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextField(
                                  controller: _commentaireController,
                                  maxLines: 3,
                                  decoration: const InputDecoration(
                                    labelText: 'Commentaire',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Text('Note: '),
                                    DropdownButton<int>(
                                      value: _selectedNote,
                                      items: List.generate(5, (i) => i + 1)
                                          .map((n) => DropdownMenuItem(
                                                value: n,
                                                child: Row(children: [
                                                  const Icon(Icons.star,
                                                      color: Colors.amber, size: 18),
                                                  Text(' $n'),
                                                ]),
                                              ))
                                          .toList(),
                                      onChanged: (val) =>
                                          setState(() => _selectedNote = val!),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.indigo),
                                    onPressed: _submitting
                                        ? null
                                        : () => _submitAvis(
                                            () => setInnerState(() {})),
                                    child: _submitting
                                        ? const SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                                color: Colors.white, strokeWidth: 2))
                                        : const Text('Soumettre',
                                            style: TextStyle(color: Colors.white)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text('${avisList.length} avis',
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 8),
                        ...avisList.map((avis) => Card(
                              margin: const EdgeInsets.only(bottom: 8),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.indigo.shade100,
                                  child: Text(avis.auteur[0].toUpperCase(),
                                      style: TextStyle(color: Colors.indigo.shade700)),
                                ),
                                title: Row(
                                  children: [
                                    Text(avis.auteur,
                                        style: const TextStyle(fontWeight: FontWeight.w600)),
                                    const Spacer(),
                                    Row(
                                      children: List.generate(
                                          5,
                                          (i) => Icon(Icons.star,
                                              size: 14,
                                              color: i < avis.note
                                                  ? Colors.amber
                                                  : Colors.grey.shade300)),
                                    ),
                                  ],
                                ),
                                subtitle: Text(avis.commentaire),
                              ),
                            )),
                      ],
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
