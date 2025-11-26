package com.muhibsoft.matounso.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.Setter;

@Entity
@Table(name = "parametreobserve")
@Getter
@Setter
public class ParametreObserve {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_parametreobserve")
    private Long idParametreObserve;

    @Column(name = "dateobservation")
    private LocalDateTime dateObservation;
    @Column(name = "valeurnumerique", precision = 10, scale = 2)
    private BigDecimal valeurNumerique;
    @Column(name = "valeurtexte")
    private String valeurTexte;
    @Column(name = "remarque")
    private String remarque;
    @Column(name = "datecreation", insertable = false, updatable = false)
    private LocalDateTime dateCreation;
    @Column(name = "datemodification", insertable = false)
    private LocalDateTime dateModification;

    @ManyToOne(fetch = FetchType.LAZY)
    @Column(name = "parametreType_id")
    private ParametreType parametreType;
    @ManyToOne(fetch = FetchType.LAZY)
    @Column(name = "patient_id")
    private Patient patient;
    @ManyToOne(fetch = FetchType.LAZY)
    @Column(name = "soingant_id")
    private User soingant;
    @ManyToOne(fetch = FetchType.LAZY)
    @Column(name = "niveaualerte_id")
    private NiveauAlerte niveauAlerte;
}
