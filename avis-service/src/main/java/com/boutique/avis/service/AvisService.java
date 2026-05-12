package com.boutique.avis.service;

import com.boutique.avis.client.ProduitClient;
import com.boutique.avis.entity.Avis;
import com.boutique.avis.exception.ResourceNotFoundException;
import com.boutique.avis.repository.AvisRepository;
import feign.FeignException;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class AvisService {

    private final AvisRepository avisRepository;
    private final ProduitClient produitClient;

    public AvisService(AvisRepository avisRepository, ProduitClient produitClient) {
        this.avisRepository = avisRepository;
        this.produitClient = produitClient;
    }

    public List<Avis> findByProduitId(Long produitId) {
        verifyProduitExists(produitId);
        return avisRepository.findByProduitId(produitId);
    }

    public Avis save(Avis avis) {
        verifyProduitExists(avis.getProduitId());
        return avisRepository.save(avis);
    }

    private void verifyProduitExists(Long produitId) {
        try {
            var response = produitClient.getProduitById(produitId);
            if (!response.getStatusCode().is2xxSuccessful()) {
                throw new ResourceNotFoundException("Produit introuvable avec l'id: " + produitId);
            }
        } catch (FeignException.NotFound e) {
            throw new ResourceNotFoundException("Produit introuvable avec l'id: " + produitId);
        }
    }
}