package com.muhibsoft.matounso.configuration;

import java.util.HashSet;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import com.muhibsoft.matounso.enums.UserStatutEnum;
import com.muhibsoft.matounso.model.Coordonnee;
import com.muhibsoft.matounso.model.MotDePasse;
import com.muhibsoft.matounso.repository.CoordonneeRepository;
import com.muhibsoft.matounso.repository.MotDePasseRepository;
import com.muhibsoft.matounso.repository.RolePermissionRepository;
import com.muhibsoft.matounso.repository.UserRepository;
import com.muhibsoft.matounso.repository.UserRoleRepository;

import jakarta.transaction.Transactional;

@Service
public class CustomUserDetailsService implements UserDetailsService {

        @Autowired
        private CoordonneeRepository coordonneeRepository;

        @Autowired
        private UserRepository userRepository;

        @Autowired
        private MotDePasseRepository motDePasseRepository;

        @Autowired
        private UserRoleRepository userRoleRepository;

        @Autowired
        private RolePermissionRepository rolePermissionRepository;

        @Override
        @Transactional
        public UserDetails loadUserByUsername(String email) throws UsernameNotFoundException {

                // Vérifier si l'email existe dans UserCoordonnee
                Coordonnee coordonnee = coordonneeRepository.findCoordonneeByEmail(email)
                                .orElseThrow(() -> new UsernameNotFoundException(
                                                "email : " + email + " n'existe pas."));

                // Récupérer l'user associée à cet email
                com.muhibsoft.matounso.model.User user = userRepository.findUserByCoordonneeEmail(email)
                                .orElseThrow(
                                                () -> new UsernameNotFoundException(
                                                                "Identité non trouvée pour l'email : " + email));

                // Récupérer le mot de passe associé à l'user
                MotDePasse motDePasse = motDePasseRepository
                                .findMotDePasseByUserIdUser(user.getIdUser())
                                .orElseThrow(() -> new UsernameNotFoundException(
                                                "Mot de passe non trouvé pour l'utilisateur : " + email));

                // Récupérer le rôle de l'utilisateur
                String nomRole = userRoleRepository
                                .findNomRoleByIdUser(user.getIdUser(), UserStatutEnum.ACTIF)
                                .orElseThrow(() -> new UsernameNotFoundException(
                                                "Rôle non trouvé pour l'utilisateur : " + email));

                Iterable<String> nomPermissions = rolePermissionRepository.findNomPermissionByNomRole(nomRole,
                                UserStatutEnum.ACTIF);
                Set<GrantedAuthority> authorities = new HashSet<>();

                nomPermissions.forEach(nomPermission -> {
                        authorities.add(new SimpleGrantedAuthority(nomPermission));
                });

                authorities.add(new SimpleGrantedAuthority("ROLE_" + nomRole));

                // Retourner un UserDetails pour Spring Security
                return User.builder()
                                .username(coordonnee.getEmail())
                                .password(motDePasse.getMotDePasse())
                                .authorities(authorities)
                                .build();
        }

}
