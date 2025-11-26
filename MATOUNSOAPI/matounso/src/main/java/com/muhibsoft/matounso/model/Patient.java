package com.muhibsoft.matounso.model;

import java.time.LocalDate;
import java.time.LocalDateTime;

import com.muhibsoft.matounso.enums.GroupeSanguin;
import com.muhibsoft.matounso.enums.Sexe;
import com.muhibsoft.matounso.enums.StatutEnum;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
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
@Table(name = "patient")
@Getter
@Setter
public class Patient {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_patient")
    private Long idPatient;

    @Column(name = "codepatient")
    private String codePatient;
    @Column(name = "nom")
    private String nom;
    @Column(name = "postnom")
    private String postNom;
    @Column(name = "prenom")
    private String preNom;

    @Column(name = "sexe")
    @Enumerated(EnumType.STRING)
    private Sexe sexe;

    @Column(name = "datenaissance")
    private LocalDate dateNaissance;
    @Column(name = "telephone")
    private String Telephone;
    @Column(name = "dateenregistrement", insertable = false)
    private LocalDateTime dateEnregistrement;

    @Column(name = "etatcivil")
    @Enumerated(EnumType.STRING)
    private StatutEnum etatCivil;
    @Column(name = "groupesanguin")
    @Enumerated(EnumType.STRING)
    private GroupeSanguin groupeSanguin;
    @Column(name = "rhesus")
    @Enumerated(EnumType.STRING)
    private GroupeSanguin rhesus;

    @Column(name = "profession")
    private String profession;
    @Column(name = "email")
    private String email;

    @ManyToOne(cascade = { CascadeType.PERSIST, CascadeType.MERGE, CascadeType.REFRESH }, fetch = FetchType.LAZY)
    @JoinColumn(name = "id_adresse")
    private Adresse adresse;

    @ManyToOne(cascade = { CascadeType.REFRESH }, fetch = FetchType.LAZY)
    @JoinColumn(name = "createur_id")
    private User createur;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "statut_id")
    private Statut statut;

}
