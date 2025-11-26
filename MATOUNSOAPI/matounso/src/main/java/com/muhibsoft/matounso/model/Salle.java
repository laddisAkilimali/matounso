package com.muhibsoft.matounso.model;

import java.time.LocalDateTime;

import com.muhibsoft.matounso.enums.SexeSalle;
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
@Table(name = "salle")
@Getter
@Setter
public class Salle {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_salle")
    private Long idSalle;

    @Column(name = "codeSalle")
    private String codeSalle;
    @Column(name = "nomSalle")
    private String nomSalle;
    @Column(name = "sexeSalle")
    private SexeSalle sexeSalle;
    @Column(name = "capacite")
    private Byte capacite;
    @Column(name = "localisation")
    private String localisation;
    @Column(name = "actif")
    private Boolean actif;
    @Column(name = "dateCreation", insertable = false)
    private LocalDateTime dateCreation;
    @Column(name = "dateModification", insertable = false)
    private LocalDateTime dateModification;

    @ManyToOne
    @JoinColumn(name = "service_id")
    private Service service;
    @ManyToOne
    @JoinColumn(name = "createur_id")
    private User createur;
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "statut_id")
    private Statut statut;
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "typesalle_id")
    private TypeSalle typeSalle;
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "categoriesalle_id")
    private CategorieSalle categorieSalle;
}
