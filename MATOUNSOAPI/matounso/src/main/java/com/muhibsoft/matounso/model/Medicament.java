package com.muhibsoft.matounso.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.Setter;

@Entity
@Table(name = "medicament")
@Getter
@Setter
public class Medicament {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_medicament")
    private Long idMedicament;

    @Column(name = "nommedicament", nullable = false)
    private String nomMedicament;
    @Column(name = "forme")
    private String forme;
    @Column(name = "dosage", nullable = false)
    private String dosage;
    @Column(name = "presentation")
    private String presentation;
    @Column(name = "descriptionmedicament")
    private String descriptionMedicament;
    @Column(name = "actif", nullable = false)
    private Boolean actif;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "pharmacie_id", nullable = false)
    private Pharmacie pharmacie;
}
