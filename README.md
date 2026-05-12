# 🛍️ Projet Boutique — Architecture Microservices

Plateforme e-commerce basée sur une architecture microservices Spring Boot, avec une application mobile Flutter.

---

## 🏗️ Architecture

```
                        ┌─────────────────────────────────┐
                        │         API Gateway :8090        │
                        │     (Spring Cloud Gateway)       │
                        └───────────────┬─────────────────┘
                                        │
               ┌────────────────────────┼────────────────────────┐
               │                        │                        │
    ┌──────────▼──────────┐  ┌──────────▼──────────┐            │
    │  produits-service   │  │    avis-service      │            │
    │       :8091         │◄─┤       :8092          │            │
    │  Spring Boot + JPA  │  │  Spring Boot + JPA   │            │
    │  Redis Cache        │  │  OpenFeign Client    │            │
    └──────────┬──────────┘  └──────────┬──────────┘            │
               │                        │                        │
    ┌──────────▼──────────┐  ┌──────────▼──────────┐            │
    │   PostgreSQL        │  │   PostgreSQL         │            │
    │   produits_db       │  │   avis_db            │            │
    └─────────────────────┘  └─────────────────────┘            │
                                                                 │
    ┌─────────────────────┐   ┌────────────────────┐            │
    │    Redis :6379      │   │  Eureka Server      ├────────────┘
    │   (Cache L2)        │   │      :8761           │
    └─────────────────────┘   └────────────────────┘
```

---

## 📦 Services

| Service            | Port | Description                              |
|--------------------|------|------------------------------------------|
| `api-gateway`      | 8090 | Point d'entrée unique, routage           |
| `produits-service` | 8091 | CRUD produits & catégories + Redis cache |
| `avis-service`     | 8092 | Avis produits + validation Feign         |
| `eureka-server`    | 8761 | Service discovery                        |
| `postgres-produits`| 5433 | Base de données produits                 |
| `postgres-avis`    | 5434 | Base de données avis                     |
| `redis`            | 6379 | Cache Redis                              |

---

## 🚀 Démarrage rapide

### Prérequis
- Docker & Docker Compose
- Java 21 (pour développement local)
- Flutter SDK (pour l'app mobile)

### Lancer avec Docker Compose

```bash
# Cloner le dépôt
git clone https://github.com/<user>/projet-boutique.git
cd projet-boutique

# Construire et démarrer tous les services
docker-compose up --build

# En arrière-plan
docker-compose up --build -d
```

### Vérifier le statut

| URL                                          | Description              |
|----------------------------------------------|--------------------------|
| http://localhost:8761                        | Eureka Dashboard         |
| http://localhost:8091/swagger-ui.html        | Swagger produits-service |
| http://localhost:8092/swagger-ui.html        | Swagger avis-service     |
| http://localhost:8090/api/produits           | Via Gateway              |
| http://localhost:8090/api/categories         | Via Gateway              |
| http://localhost:8090/api/avis/{produitId}   | Via Gateway              |

---

## 📡 API Reference

### produits-service

| Méthode | URL                                    | Description                  |
|---------|----------------------------------------|------------------------------|
| GET     | `/api/produits`                        | Liste tous les produits       |
| GET     | `/api/produits?categorieId={id}`       | Filtre par catégorie          |
| GET     | `/api/produits/{id}`                   | Détail d'un produit           |
| POST    | `/api/produits`                        | Créer un produit              |
| GET     | `/api/categories`                      | Liste toutes les catégories   |
| GET     | `/api/categories/{id}`                 | Détail d'une catégorie        |

**Exemple POST /api/produits :**
```json
{
  "nom": "Casque Audio Sony",
  "prix": 149.99,
  "stock": 30,
  "categorie": { "id": 1 }
}
```

### avis-service

| Méthode | URL                    | Description              |
|---------|------------------------|--------------------------|
| GET     | `/api/avis/{produitId}`| Liste les avis d'un produit |
| POST    | `/api/avis`            | Soumettre un avis        |

**Exemple POST /api/avis :**
```json
{
  "produitId": 1,
  "auteur": "Jean Dupont",
  "commentaire": "Excellent produit, livraison rapide !",
  "note": 5
}
```

---

## 📱 Application Mobile (Flutter)

L'application Flutter se connecte exclusivement via l'API Gateway.

```bash
cd mobile-app
flutter pub get
flutter run
```

> ⚠️ Pour un émulateur Android, l'IP `10.0.2.2` pointe vers `localhost`.
> Pour un appareil physique, modifiez `baseUrl` dans `lib/services/api_service.dart`.

**Fonctionnalités :**
- Liste des catégories avec `DropdownButton`
- Produits filtrés par catégorie avec `FutureBuilder` + `ListView.builder`
- Détail produit avec avis (notes étoiles)
- Formulaire de soumission d'avis

---

## 🔧 Fonctionnalités techniques

### Cache Redis (produits-service)
- `@Cacheable("produits")` sur GET /api/produits — TTL 10 minutes
- `@CacheEvict(allEntries = true)` sur POST /api/produits

### Feign Client (avis-service)
- Vérifie l'existence du produit avant d'enregistrer un avis
- Retourne HTTP 404 si le produit est introuvable

### Service Discovery (Eureka)
- Tous les microservices s'enregistrent automatiquement
- L'API Gateway utilise `lb://service-name` pour le load balancing

---

## 🌿 Branches Git

| Branche    | Contenu                                              |
|------------|------------------------------------------------------|
| `version1` | Parties 1–4 : microservices + infrastructure + Docker |
| `version2` | Parties 5–6 : application mobile + tests             |

```bash
# Créer les branches
git checkout -b version1
git add .
git commit -m "feat: microservices Spring Boot + Docker Compose"
git push origin version1

git checkout -b version2
# Ajouter mobile-app + tests
git add mobile-app/
git commit -m "feat: application mobile Flutter"
git push origin version2
```

---

## 🗂️ Structure du projet

```
projet-boutique/
├── produits-service/          # Spring Boot — Produits & Catégories
│   ├── src/main/java/com/boutique/produits/
│   │   ├── controller/        # REST Controllers
│   │   ├── service/           # Business logic + Cache
│   │   ├── repository/        # Spring Data JPA
│   │   ├── entity/            # JPA Entities
│   │   └── config/            # Redis Cache Config
│   ├── src/main/resources/
│   │   ├── application.yml
│   │   └── data.sql           # Données initiales
│   ├── Dockerfile
│   └── pom.xml
├── avis-service/              # Spring Boot — Avis + Feign
│   ├── src/main/java/com/boutique/avis/
│   │   ├── controller/
│   │   ├── service/
│   │   ├── repository/
│   │   ├── entity/
│   │   ├── client/            # Feign Client
│   │   └── exception/         # Error handling
│   ├── Dockerfile
│   └── pom.xml
├── eureka-server/             # Spring Cloud Netflix Eureka
│   ├── Dockerfile
│   └── pom.xml
├── api-gateway/               # Spring Cloud Gateway
│   ├── Dockerfile
│   └── pom.xml
├── mobile-app/                # Flutter App
│   ├── lib/
│   │   ├── main.dart          # HomeScreen (catégories + produits)
│   │   ├── models/            # Modèles de données
│   │   ├── services/          # ApiService (HTTP)
│   │   └── screens/           # AvisScreen
│   └── pubspec.yaml
├── docker-compose.yml         # Orchestration complète
└── README.md
```

---

## 👨‍💻 Formateur

**Wahid Hamdi** — Test Pratique Architecture Microservices Spring Boot
