package com.boutique.produits.controller;

import com.boutique.produits.entity.Categorie;
import com.boutique.produits.service.CategorieService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/categories")
@RequiredArgsConstructor
@Tag(name = "Catégories", description = "API de gestion des catégories")
public class CategorieController {

    private final CategorieService categorieService;

    @GetMapping
    @Operation(summary = "Liste toutes les catégories")
    public ResponseEntity<List<Categorie>> findAll() {
        return ResponseEntity.ok(categorieService.findAll());
    }

    @GetMapping("/{id}")
    @Operation(summary = "Détail d'une catégorie")
    public ResponseEntity<Categorie> findById(@PathVariable Long id) {
        return ResponseEntity.ok(categorieService.findById(id));
    }
}
