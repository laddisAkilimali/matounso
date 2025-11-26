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
@Table(name = "preconsultation")
@Getter
@Setter
public class Preconsultation {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_preconsultation")
    private Long idPreconsultation;

    @Column(name = "datePreconsultation")
    private LocalDateTime datePreconsultation;
    @Column(name = "motifVisite")
    private String motifVisite;
    @Column(name = "poids", precision = 5, scale = 2)
    private BigDecimal poids;
    @Column(name = "taille")
    private Short taille;
    @Column(name = "temperature", precision = 4, scale = 1)
    private BigDecimal temperature;
    @Column(name = "tensionsystolique")
    private Byte tensionSystolique;
    @Column(name = "tensiondiastolique")
    private Byte tensionDiastolique;
    @Column(name = "frequencecardiaque")
    private Byte frequenceCardiaque;
    @Column(name = "frequencerespiratoire")
    private Byte frequenceRespiratoire;
    @Column(name = "saturationo2")
    private Byte saturationO2;
    @Column(name = "glycemiecapillaire", precision = 5, scale = 2)
    private BigDecimal glycemieCapillaire;
    @Column(name = "commentaire")
    private String commentaire;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "episodeSoin_id", unique = true)
    private EpisodeSoin episodeSoin;
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "preconsultant_id")
    private User preconsultant;
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "serviceDestination_id")
    private Service serviceDestination;

}
