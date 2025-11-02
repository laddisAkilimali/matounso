package com.muhibsoft.matounso.controller;

import org.springframework.http.HttpHeaders;

import java.time.Duration;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseCookie;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.muhibsoft.matounso.configuration.JwtService;
import com.muhibsoft.matounso.dto.AuthRequest;
import com.muhibsoft.matounso.model.Connexion;
import com.muhibsoft.matounso.repository.ConnexionRepository;
import com.muhibsoft.matounso.repository.PermissionsRepository;
import com.muhibsoft.matounso.repository.UserRepository;

import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.GetMapping;

@RestController
@RequestMapping("/matounso/auth")
public class AuthController {

        @Autowired
        AuthenticationManager authenticationManager;
        @Autowired
        JwtService jwtService;
        @Autowired
        UserRepository userRepository;
        @Autowired
        PermissionsRepository permissionsRepository;
        @Autowired
        ConnexionRepository connexionRepository;

        @PostMapping("/login")
        public ResponseEntity<?> login(@Valid @RequestBody AuthRequest request, BindingResult result) {
                if (result.hasErrors()) {
                        return ResponseEntity.badRequest().body(result.getAllErrors());
                }

                String email = request.getEmail().trim();
                // recuperztion de l'historique de connexion
                Connexion historiqueConnexion = connexionRepository.findByEmail(email).orElseGet(() -> {
                        Connexion neuve = new Connexion();
                        neuve.setEmail(email);
                        neuve.setNombreTentative(0);
                        neuve.setTempsBloquage(null);
                        neuve.setDateDerniereTentative(LocalDateTime.now());

                        return neuve;
                });

                // temps actuel
                LocalDateTime maintenant = LocalDateTime.now();
                try {
                        // Securisation contre les attaques force brute

                        boolean dejaEnregistre = historiqueConnexion.getIdConnexion() != null;
                        if (dejaEnregistre) {
                                if (historiqueConnexion.getNombreTentative() <= 5) {

                                        if (maintenant.isAfter(historiqueConnexion.getDateDerniereTentative()
                                                        .plusMinutes(10))) {
                                                historiqueConnexion.setTempsBloquage(null);
                                                historiqueConnexion.setNombreTentative(0);
                                                historiqueConnexion.setDateDerniereTentative(maintenant);
                                                connexionRepository.save(historiqueConnexion);
                                        }
                                } else {
                                        LocalDateTime blocage = historiqueConnexion.getTempsBloquage();

                                        if (blocage != null && maintenant.isAfter(blocage)) {
                                                historiqueConnexion.setTempsBloquage(null);
                                                historiqueConnexion.setNombreTentative(0);
                                                historiqueConnexion.setDateDerniereTentative(maintenant);
                                                connexionRepository.save(historiqueConnexion);
                                        } else {
                                                if (blocage != null) {
                                                        Duration tempRestant = Duration.between(maintenant,
                                                                        blocage);

                                                        return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                                                                        .body(Map.of(
                                                                                        "statut", "error",
                                                                                        "message",
                                                                                        "Veillez patienter "
                                                                                                        + tempRestant
                                                                                                                        .toMinutes()
                                                                                                        + "minutes "));

                                                }

                                        }
                                }

                        } else {
                                connexionRepository.save(historiqueConnexion);
                        }

                        // proccessus d'authentification

                        Authentication auth = authenticationManager.authenticate(
                                        new UsernamePasswordAuthenticationToken(email,
                                                        request.getMotDePasse().trim()));

                        UserDetails userDetails = (UserDetails) auth.getPrincipal();

                        // Récupérer l'user associée à cet email
                        com.muhibsoft.matounso.model.User user = userRepository
                                        .findUserByCoordonneeEmail(email)
                                        .orElseThrow(() -> new BadCredentialsException("Identifiants incorrects"));

                        // Génération du token et cookie
                        String accessToken = jwtService.generateAccessToken(userDetails.getUsername());

                        ResponseCookie cookie = ResponseCookie.from("accessToken", accessToken)
                                        .httpOnly(true)
                                        .secure(false)
                                        .sameSite("Lax")
                                        .path("/")
                                        .build();

                        return ResponseEntity.ok()
                                        .header(HttpHeaders.SET_COOKIE, cookie.toString())
                                        .body(
                                                        Map.of(
                                                                        "statut", "success",
                                                                        "userName",
                                                                        user.getNom() + " " + user.getPostNom()));

                } catch (BadCredentialsException e) {

                        historiqueConnexion.setNombreTentative(
                                        historiqueConnexion.getNombreTentative() + 1);

                        if (historiqueConnexion.getNombreTentative() > 5) {
                                historiqueConnexion.setTempsBloquage(
                                                historiqueConnexion.getDateDerniereTentative().plusMinutes(10));
                        }
                        connexionRepository.save(historiqueConnexion);

                        return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                                        .body(Map.of(
                                                        "statut", "error",
                                                        "message", "Identifiants incorrects"));

                } catch (Exception e) {
                        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                                        .body(Map.of(
                                                        "statut", "error",
                                                        "message", "Erreur interne"));
                }

        }

        @GetMapping("/userPermissions")
        public ResponseEntity<?> getUserPermission(Authentication authentication) {
                List<String> permissions = authentication.getAuthorities()
                                .stream()
                                .map(GrantedAuthority::getAuthority)
                                .toList();

                return ResponseEntity.ok(permissions);

        }

        @GetMapping("/getAllPermissions")
        public ResponseEntity<?> getAllPermissions(Authentication authentication) {
                boolean isSuperAdmin = authentication.getAuthorities().stream().map(GrantedAuthority::getAuthority)
                                .anyMatch("ROLE_SUPER_ADMIN"::equals);
                List<String> allPermissions = permissionsRepository.findAllNomPermission();
                if (isSuperAdmin)
                        return ResponseEntity.ok(allPermissions);

                List<String> filtrer = allPermissions.stream().filter(p -> !p.equalsIgnoreCase("AJOUTER ADMIN"))
                                .toList();
                return ResponseEntity.ok(filtrer);
        }

}
