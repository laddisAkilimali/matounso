package com.muhibsoft.matounso.model;

import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.Setter;

@Entity
@Table(name = "statut")
@Getter
@Setter
public class Statut {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_statut")
    private Long idStatut;

    @Column(name = "libellestatut", unique = true, nullable = false)
    private String libelleStatut;
    @Column(name = "descriptionstatut")
    private String descriptionStatut;
    @Column(name = "actif", nullable = false)
    private Boolean actif;
    @Column(name = "datecreation", insertable = false, updatable = false)
    private LocalDateTime dateCreation;
    @Column(name = "datemodification", insertable = false)
    private LocalDateTime dateModification;
}
