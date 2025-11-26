package com.muhibsoft.matounso.model;

import java.math.BigDecimal;

import com.muhibsoft.matounso.enums.Devise;

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
@Table(name = "serviceTarif")
@Getter
@Setter
public class ServiceTarif {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long idServiceTarif;

    @Column(name = "codeTarif", unique = true)
    private String codeTarif;
    @Column(name = "libelle", nullable = false)
    private String libelle;
    @Column(name = "prixUnitaire", nullable = false, precision = 12, scale = 2)
    private BigDecimal prixUnitaire;
    @Column(name = "devise", nullable = false)
    private Devise devise;
    @Column(name = "actif", nullable = false)
    private Boolean actif;
    @Column(name = "descriptionTarif")
    private String descriptionTarif;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "idService", nullable = false)
    private Service service;
}
