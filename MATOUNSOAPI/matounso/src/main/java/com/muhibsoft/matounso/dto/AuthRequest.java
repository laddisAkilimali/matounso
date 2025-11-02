package com.muhibsoft.matounso.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class AuthRequest {

    @NotBlank(message = "Email ne peut pas être vide")
    @Email(message = "Email Invalide")
    private String email;

    @NotBlank(message = "le mot de passe ne doit pas être vide")
    private String motDePasse;

}