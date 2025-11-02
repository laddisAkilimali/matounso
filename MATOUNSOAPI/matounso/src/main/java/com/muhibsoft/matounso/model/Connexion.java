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

@Getter
@Setter
@Entity
@Table(name = "connexion")
public class Connexion {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_Connexion")
    private Long idConnexion;
    @Column(name = "email")
    private String email;
    @Column(name = "nombretentative")
    private int nombreTentative;
    @Column(name = "datedernieretentative")
    private LocalDateTime dateDerniereTentative;
    @Column(name = "tempsbloquage")
    private LocalDateTime tempsBloquage;
}
