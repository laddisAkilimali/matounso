package com.muhibsoft.matounso.model;

import java.time.LocalDate;
import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.MapsId;
import jakarta.persistence.OneToOne;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Entity
@Table(name = "mot_De_Passe")
public class MotDePasse {

    @Id
    @Column(name = "id_user")
    private Long idUser;
    @Column(name = "motdepasse")
    private String motDePasse;
    @Column(name = "datecreation", insertable = false)
    private LocalDateTime dateCreation;
    @Column(name = "dateexpiration")
    private LocalDate dateExpiration;
    @Column(name = "datemodification")
    private LocalDateTime dateModification;

    @OneToOne(fetch = FetchType.LAZY)
    @MapsId
    @JoinColumn(name = "id_user")
    private User user;
}