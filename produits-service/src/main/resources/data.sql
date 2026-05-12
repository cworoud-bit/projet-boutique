-- Catégories
INSERT INTO categorie (id, nom) VALUES (1, 'Électronique') ON CONFLICT DO NOTHING;
INSERT INTO categorie (id, nom) VALUES (2, 'Vêtements') ON CONFLICT DO NOTHING;
INSERT INTO categorie (id, nom) VALUES (3, 'Maison & Jardin') ON CONFLICT DO NOTHING;

-- Produits
INSERT INTO produit (id, nom, prix, stock, categorie_id) VALUES (1, 'Smartphone Samsung Galaxy S24', 899.99, 50, 1) ON CONFLICT DO NOTHING;
INSERT INTO produit (id, nom, prix, stock, categorie_id) VALUES (2, 'Laptop Dell XPS 15', 1499.99, 25, 1) ON CONFLICT DO NOTHING;
INSERT INTO produit (id, nom, prix, stock, categorie_id) VALUES (3, 'Veste en cuir noir', 199.99, 100, 2) ON CONFLICT DO NOTHING;
INSERT INTO produit (id, nom, prix, stock, categorie_id) VALUES (4, 'Jean slim bleu', 59.99, 200, 2) ON CONFLICT DO NOTHING;
INSERT INTO produit (id, nom, prix, stock, categorie_id) VALUES (5, 'Chaise de jardin aluminium', 89.99, 75, 3) ON CONFLICT DO NOTHING;
