package com.boutique.avis.controller;

import com.boutique.avis.entity.Avis;
import com.boutique.avis.service.AvisService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/avis")
@Tag(name = "Avis", description = "API de gestion des avis produits")
public class AvisController {

    private final AvisService avisService;

    public AvisController(AvisService avisService) {
        this.avisService = avisService;
    }

    @GetMapping("/{produitId}")
    @Operation(summary = "Liste les avis d'un produit")
    public ResponseEntity<List<Avis>> findByProduitId(@PathVariable Long produitId) {
        return ResponseEntity.ok(avisService.findByProduitId(produitId));
    }

    @PostMapping
    @Operation(summary = "Soumettre un avis")
    public ResponseEntity<Avis> create(@RequestBody Avis avis) {
        return ResponseEntity.status(HttpStatus.CREATED).body(avisService.save(avis));
    }
}