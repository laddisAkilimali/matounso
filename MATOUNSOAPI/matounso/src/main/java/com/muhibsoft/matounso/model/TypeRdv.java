package com.muhibsoft.matounso.model;

import java.time.LocalDateTime;

import org.hibernate.annotations.ManyToAny;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.Setter;

@Entity
@Table(name = "priorite")
@Getter
@Setter
public class TypeRdv {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_typerdv")
    private Long idTypeRdv;

    @Column(name = "libelle")
    private String libelle;
    @Column(name = "actif")
    private Boolean actif;
    @Column(name = "datecreation")
    private LocalDateTime dateCreation;
    @Column(name = "datemodification")
    private LocalDateTime dateModification;

    @ManyToAny(fetch = FetchType.LAZY)
    @JoinColumn(name = "createur")
    private User createur;
}
