package com.boutique.produits.service;

import com.boutique.produits.entity.Categorie;
import com.boutique.produits.entity.Produit;
import com.boutique.produits.repository.CategorieRepository;
import com.boutique.produits.repository.ProduitRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ProduitService {

    private final ProduitRepository produitRepository;
    private final CategorieRepository categorieRepository;

    @Cacheable(value = "produits")
    public List<Produit> findAll() {
        return produitRepository.findAll();
    }

    @Cacheable(value = "produits", key = "'cat_' + #categorieId")
    public List<Produit> findByCategorieId(Long categorieId) {
        return produitRepository.findByCategorieId(categorieId);
    }

    public Produit findById(Long id) {
        return produitRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Produit introuvable avec l'id: " + id));
    }

    @CacheEvict(value = "produits", allEntries = true)
    public Produit save(Produit produit) {
        Categorie categorie = categorieRepository.findById(produit.getCategorie().getId())
                .orElseThrow(() -> new RuntimeException("Catégorie introuvable"));
        produit.setCategorie(categorie);
        return produitRepository.save(produit);
    }
}
