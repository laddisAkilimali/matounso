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
@Table(name = "parametretype")
@Getter
@Setter
public class ParametreType {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_parametretype")
    private Long idParametreType;

    @Column(name = "codeparametre", unique = true)
    private String codeParametre;
    @Column(name = "libelle")
    private String libelle;
    @Column(name = "unite")
    private String unite;
    @Column(name = "valeurminnormale", precision = 10, scale = 2)
    private BigDecimal valeurMinNormale;
    @Column(name = "valeurmaxnormale", precision = 10, scale = 2)
    private BigDecimal valeurMaxNormale;
    @Column(name = "actif")
    private Boolean actif;
    @Column(name = "datecreation")
    private LocalDateTime dateCreation;
    @Column(name = "datemodification")
    private LocalDateTime dateModification;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "createur_id")
    private User createur;
}
