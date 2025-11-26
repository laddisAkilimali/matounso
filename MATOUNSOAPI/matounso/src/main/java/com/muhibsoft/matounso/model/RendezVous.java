package com.muhibsoft.matounso.model;

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
@Table(name = "rendezvous")
@Getter
@Setter
public class RendezVous {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_rendezvous")
    private Long idRendezVous;

    @Column(name = "daterendezvous", nullable = false)
    private LocalDateTime dateHeure;
    @Column(name = "dureeRendezvous")
    private Short dureeRendezVous;
    @Column(name = "objet", nullable = false)
    private String objet;
    @Column(name = "commentaire")
    private String commentaire;
    @Column(name = "dateCreation", insertable = false)
    private LocalDateTime dateCreation;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "patient_id", nullable = false)
    private Patient patient;
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "planificateurrendezvous_id", nullable = false)
    private User planificateurRendezVous;
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "servicerendezvous_id", nullable = false)
    private Service serviceRendezVous;
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "statut_id", nullable = false)
    private Statut statut;
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "typerdv_id", nullable = false)
    private TypeRdv typeRdv;
}
