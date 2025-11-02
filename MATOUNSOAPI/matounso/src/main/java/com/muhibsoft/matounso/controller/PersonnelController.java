package com.muhibsoft.matounso.controller;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.muhibsoft.matounso.dto.ajoutPersonnelleRequest;
import com.muhibsoft.matounso.service.InscriptionPersonnelService;

import jakarta.validation.Valid;

@RestController
@RequestMapping("/matounso/personnel")
public class PersonnelController {

    @Autowired
    InscriptionPersonnelService inscriptionPersonnel;

    @PostMapping("/inscription")
    public ResponseEntity<?> inscription(@Valid @RequestBody ajoutPersonnelleRequest request, BindingResult result) {

        if (result.hasErrors()) {
            return ResponseEntity.badRequest().body(result.getAllErrors());
        }

        try {
            Map<String, String> reponse = inscriptionPersonnel.savePersonnel(request);

            return ResponseEntity.ok().body(
                    reponse);

        } catch (Exception e) {
            return ResponseEntity.ok().body(
                    Map.of(
                            "statut", "erreur",
                            "message", e.getMessage()));
        }
    }
}
