package com.muhibsoft.matounso.model;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import com.muhibsoft.matounso.enums.Sexe;

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
import jakarta.persistence.OneToMany;
import jakarta.persistence.OneToOne;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Entity
@Table(name = "user")
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_user")
    private Long idUser;
    @Column(name = "nom")
    private String nom;
    @Column(name = "postnom")
    private String postNom;
    @Column(name = "prenom")
    private String preNom;

    @Enumerated(EnumType.STRING)
    private Sexe sexe;

    @Column(name = "datenaissance")
    private LocalDate dateNaissance;
    @Column(name = "lieunaissance")
    private String lieuNaissance;
    @Column(name = "nationalite")
    private String nationalite;
    @Column(name = "datecreation", insertable = false)
    private LocalDateTime dateCreation;
    @Column(name = "datemodification")
    private LocalDateTime dateModification;

    @OneToOne(mappedBy = "user", fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    private Coordonnee coordonnee;

    @OneToOne(mappedBy = "user", fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    private MotDePasse motDePasse;

    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    private Set<UserRole> userRoles = new HashSet<>();

    @ManyToOne(cascade = { CascadeType.PERSIST, CascadeType.MERGE, CascadeType.REFRESH }, fetch = FetchType.LAZY)
    @JoinColumn(name = "id_adresse")
    private Adresse adresse;
}
