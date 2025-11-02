package com.muhibsoft.matounso.dto;

import java.time.LocalDate;
import java.util.List;

import com.muhibsoft.matounso.enums.Sexe;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Past;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
import lombok.Data;

@Data
public class ajoutPersonnelleRequest {

    // Informations personnelles
    @NotBlank(message = "le nom ne peut pas être vide")
    @Size(max = 50)
    private String nom;
    @NotBlank(message = "le postNom ne peut pas être vide")
    @Size(max = 50)
    private String postNom;
    @NotBlank(message = "le pretNom ne peut pas être vide")
    @Size(max = 50)
    private String preNom;
    @NotNull(message = "le sexe ne peut pas être vide")
    @Enumerated(EnumType.STRING)
    private Sexe sexe;
    @NotNull
    @Past(message = "la date de naissance doit être dans le passé")
    private LocalDate dateNaissance;
    @NotEmpty(message = "le lieu de naissance ne peut pas être vide")
    @Size(max = 100)
    private String lieuNaissance;
    @NotBlank
    private String nationalite;

    // Adresse
    @NotBlank
    private String ville;
    @NotBlank
    private String quartier;
    @NotBlank
    private String avenue;
    @NotBlank
    private String numeroMaison;

    // Informations de connexion
    @NotBlank
    private String role;

    private List<String> permissions;

    // Coordonnées
    @Pattern(regexp = "^[0-9+ ]{8,20}$", message = "numéro de téléphone invalide")
    private String numeroTelephone;
    @NotBlank
    @Email
    private String email;

    // Mot de passe
    @NotBlank
    @Size(min = 8, message = "le mot de passe doit contenir au moins 8 caractères")
    private String motDePasse;
}