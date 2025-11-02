package com.muhibsoft.matounso.service;

import java.util.HashSet;
import java.util.Map;
import java.util.Optional;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.muhibsoft.matounso.composeKey.UserRoleKey;
import com.muhibsoft.matounso.composeKey.UserRolePermissionKey;
import com.muhibsoft.matounso.dto.ajoutPersonnelleRequest;
import com.muhibsoft.matounso.model.Adresse;
import com.muhibsoft.matounso.model.Coordonnee;
import com.muhibsoft.matounso.model.MotDePasse;
import com.muhibsoft.matounso.model.Permission;
import com.muhibsoft.matounso.model.Role;
import com.muhibsoft.matounso.model.RolePermission;
import com.muhibsoft.matounso.model.User;
import com.muhibsoft.matounso.model.UserRole;
import com.muhibsoft.matounso.repository.AdresseRepository;
import com.muhibsoft.matounso.repository.CoordonneeRepository;
import com.muhibsoft.matounso.repository.PermissionsRepository;
import com.muhibsoft.matounso.repository.RolePermissionRepository;
import com.muhibsoft.matounso.repository.RoleRepository;
import com.muhibsoft.matounso.repository.UserRepository;

import jakarta.transaction.Transactional;
import lombok.Setter;
import lombok.Getter;

@Service
@Getter
@Setter
public class InscriptionPersonnelService {

    @Autowired
    CoordonneeRepository coordonneeRepository;
    @Autowired
    UserRepository userRepository;
    @Autowired
    AdresseRepository adresseRepository;
    @Autowired
    PasswordEncoder passwordEncoder;
    @Autowired
    RoleRepository roleRepository;
    @Autowired
    PermissionsRepository permissionsRepository;
    @Autowired
    RolePermissionRepository rolePermissionRepository;

    @Transactional
    public Map<String, String> savePersonnel(ajoutPersonnelleRequest request) {

        User userInscrit;
        Coordonnee userInscritCoordonnee;
        Adresse userInscritAdresse;
        MotDePasse userInscritMotDePasse;
        Role userInscritRole;
        UserRole userRole;
        RolePermission rolePermission;

        try {
            userInscrit = new User();
            // Verification de l'existence d'un utilisateur avec le meme email
            Optional<Coordonnee> coordonneeEmail = coordonneeRepository.findCoordonneeByEmail(request.getEmail());
            if (coordonneeEmail.isPresent()) {
                return Map.of(
                        "statut", "echec",
                        "message", "l'Email entré est déjà utiliser");
            }

            Optional<Coordonnee> coordoneeTelephone = coordonneeRepository
                    .findByTelephone(request.getNumeroTelephone());

            if (coordoneeTelephone.isPresent()) {
                return Map.of(
                        "statut", "echec",
                        "message", "le numéro est déjà utiliser");
            }

            // Enregistrement des coordonnees
            userInscritCoordonnee = new Coordonnee();
            userInscritCoordonnee.setEmail(request.getEmail());
            userInscritCoordonnee.setTelephone(request.getNumeroTelephone());

            // Enregistrement du mot de passe
            userInscritMotDePasse = new MotDePasse();
            userInscritMotDePasse.setMotDePasse(passwordEncoder.encode(request.getMotDePasse()));

            // Verification de l'existence de l'adresse
            Optional<Adresse> adresseExistante = adresseRepository
                    .findByVilleAndQuartierAndAvenueAndNumeroMaison(
                            request.getVille(),
                            request.getQuartier(),
                            request.getAvenue(),
                            request.getNumeroMaison());

            if (adresseExistante.isPresent()) {
                userInscritAdresse = adresseExistante.get();
            } else {
                // Enregistrement de la nouvelle adresse
                userInscritAdresse = new Adresse();
                userInscritAdresse.setVille(request.getVille());
                userInscritAdresse.setQuartier(request.getQuartier());
                userInscritAdresse.setAvenue(request.getAvenue());
                userInscritAdresse.setNumeroMaison(request.getNumeroMaison());
            }

            // Verification de l'existence du role
            userInscritRole = roleRepository.findByNomRole(request.getRole())
                    .orElseGet(() -> {
                        Role nouveauRole = new Role();
                        nouveauRole.setNomRole(request.getRole());
                        return roleRepository.save(nouveauRole);
                    });

            // Persist utilisateur avant d'attacher le role pour eviter id_adresse nul
            userInscrit.setAdresse(userInscritAdresse);
            userInscrit.setCoordonnee(userInscritCoordonnee);
            userInscritCoordonnee.setUser(userInscrit);
            userInscrit.setMotDePasse(userInscritMotDePasse);
            userInscritMotDePasse.setUser(userInscrit);

            userInscrit.setNom(request.getNom());
            userInscrit.setPostNom(request.getPostNom());
            userInscrit.setPreNom(request.getPreNom());
            userInscrit.setSexe(request.getSexe());
            userInscrit.setDateNaissance(request.getDateNaissance());
            userInscrit.setLieuNaissance(request.getLieuNaissance());
            userInscrit.setNationalite(request.getNationalite());

            userInscrit = userRepository.save(userInscrit);

            // Attribution du role a l'utilisateur
            userRole = new UserRole();
            userRole.setKey(new UserRoleKey(
                    userInscrit.getIdUser(),
                    userInscritRole.getIdRole()));
            userRole.setUser(userInscrit);
            userRole.setRole(userInscritRole);

            userInscrit.getUserRoles().add(userRole);
            userInscritRole.getUserRoles().add(userRole);

            // Attribution des permissions au role de l'utilisateur
            if (request.getPermissions() != null) {
                Set<String> permissionsDemandees = new HashSet<>(request.getPermissions());
                for (String nomPermission : permissionsDemandees) {
                    Optional<Permission> permission = permissionsRepository.findByNomPermission(nomPermission);

                    if (permission.isEmpty()) {
                        continue;
                    }

                    Permission permissionEntity = permission.get();
                    UserRolePermissionKey key = new UserRolePermissionKey(
                            userInscritRole.getIdRole(),
                            permissionEntity.getIdPermission());

                    if (rolePermissionRepository.existsById(key)) {
                        continue;
                    }

                    rolePermission = new RolePermission();
                    rolePermission.setKey(key);
                    rolePermission.setRole(userInscritRole);
                    rolePermission.setPermission(permissionEntity);

                    userInscritRole.getRolePermissions().add(rolePermission);
                    permissionEntity.getRolePermissions().add(rolePermission);
                }
            }

            return Map.of("statut", "succes",
                    "message", "utilisateur ajouter avec succès");
        } catch (Exception e) {
            return Map.of(
                    "statut", "echec",
                    "message", "Erreur " + e.getMessage());

        }
    }
}
