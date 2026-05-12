package com.boutique.produits.controller;

import com.boutique.produits.entity.Produit;
import com.boutique.produits.service.ProduitService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/produits")
@Tag(name = "Produits", description = "API de gestion des produits")
public class ProduitController {

    private final ProduitService produitService;

    public ProduitController(ProduitService produitService) {
        this.produitService = produitService;
    }

    @GetMapping
    @Operation(summary = "Liste tous les produits ou filtre par catégorie")
    public ResponseEntity<List<Produit>> findAll(
            @RequestParam(required = false) Long categorieId) {
        if (categorieId != null) {
            return ResponseEntity.ok(produitService.findByCategorieId(categorieId));
        }
        return ResponseEntity.ok(produitService.findAll());
    }

    @GetMapping("/{id}")
    @Operation(summary = "Détail d'un produit")
    public ResponseEntity<Produit> findById(@PathVariable Long id) {
        return ResponseEntity.ok(produitService.findById(id));
    }

    @PostMapping
    @Operation(summary = "Créer un nouveau produit")
    public ResponseEntity<Produit> create(@RequestBody Produit produit) {
        return ResponseEntity.status(HttpStatus.CREATED).body(produitService.save(produit));
    }
}