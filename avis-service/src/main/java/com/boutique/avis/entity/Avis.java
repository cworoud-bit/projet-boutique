package com.boutique.avis.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import lombok.*;

@Entity
@Table(name = "avis")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Avis {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private Long produitId;

    @Column(nullable = false)
    private String auteur;

    @Column(nullable = false, length = 1000)
    private String commentaire;

    @Column(nullable = false)
    @Min(1) @Max(5)
    private int note;
}