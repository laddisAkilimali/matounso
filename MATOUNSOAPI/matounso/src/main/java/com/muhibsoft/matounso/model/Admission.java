package com.muhibsoft.matounso.model;

import java.time.LocalDate;
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
@Table(name = "admission")
@Getter
@Setter
public class Admission {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_admission")
    private Long idAdmission;

    @Column(name = "dateadmission")
    private LocalDateTime dateAdmission;
    @Column(name = "datesortieprevue")
    private LocalDate dateSortiePrevue;
    @Column(name = "datesortiereelle")
    private LocalDate dateSortieReelle;
    @Column(name = "commentaire")
    private String commentaire;
    @Column(name = "motifadmission")
    private String motifAdmission;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "episodesoin_id", unique = true)
    private EpisodeSoin episodeSoin;
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "patient_id")
    private Patient patient;
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "lit_id")
    private Lit lit;
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "serviceAdmision_id")
    private Service serviceAdmission;
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "medecinResponsable_id")
    private User medecinResponsable;
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "statut_id")
    private Statut statut;
}
