package com.muhibsoft.matounso.model;

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
@Table(name = "noteinfiemiere")
@Getter
@Setter
public class NoteInfiemiere {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_noteinfiemiere")
    private Long idNoteInfiemiere;

    @Column(name = "typenote")
    private String typeNote;
    @Column(name = "observation")
    private String observation;
    @Column(name = "actionprevue")
    private String actionPrevue;
    @Column(name = "niveaualerte")
    private String niveauAlerte;
    @Column(name = "visiblemedecin")
    private Boolean visibleMedecin;
    @Column(name = "datecreation", insertable = false)
    private LocalDateTime dateCreation;
    @Column(name = "datemodification", insertable = false)
    private LocalDateTime dateModification;

    @ManyToOne(fetch = FetchType.LAZY)
    @Column(name = "admission_id")
    private Admission admission;
    @ManyToOne(fetch = FetchType.LAZY)
    @Column(name = "infirmiere_id")
    private User infirmiere;
}
