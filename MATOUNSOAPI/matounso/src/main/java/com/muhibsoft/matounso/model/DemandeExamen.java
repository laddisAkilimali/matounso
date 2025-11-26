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
@Table(name = "demandeexamen")
@Getter
@Setter
public class DemandeExamen {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_demandeexamen")
    private Long idDemandeExamen;

    @Column(name = "dateDemande")
    private LocalDateTime dateDemande;
    @Column(name = "commentaire")
    private String commentaire;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "consultation_id")
    private Consultation consultation;
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "actemedical_id", unique = true)
    private ActeMedical acteMedical;
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "serviceexamination_id")
    private Service serviceExamination;
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "statut_id")
    private Statut statut;
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "priorite_id")
    private Priorite priorite;

}
