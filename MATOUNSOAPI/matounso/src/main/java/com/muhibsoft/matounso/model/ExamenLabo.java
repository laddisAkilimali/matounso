package com.muhibsoft.matounso.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

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
@Table(name = "examenlabo")
@Getter
@Setter
public class ExamenLabo {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_examenlabo")
    private Long idExamenLabo;

    @Column(name = "codeechantillon")
    private String codeEchantillon;
    @Column(name = "typeechantillon")
    private String typeEchantillon;
    @Column(name = "dateprelevement")
    private LocalDateTime datePrelevement;
    @Column(name = "dateresultat")
    private LocalDateTime dateResultat;
    @Column(name = "resultattexte")
    private String resultatTexte;
    @Column(name = "valeurnumerique", precision = 10, scale = 2)
    private BigDecimal valeurNumerique;
    @Column(name = "unite")
    private String unite;
    @Column(name = "referencemin", precision = 10, scale = 2)
    private BigDecimal referenceMin;
    @Column(name = "referencemax", precision = 10, scale = 2)
    private BigDecimal referenceMax;
    @Column(name = "commentaire")
    private String commentaire;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "demandeexmen_id", unique = true)
    private DemandeExamen demandeExamen;
    @ManyToOne
    @JoinColumn(name = "technicienlabo_id")
    private User technicienLabo;
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "statut_id")
    private Statut statut;
}
