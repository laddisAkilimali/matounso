package com.muhibsoft.matounso.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.muhibsoft.matounso.model.Connexion;

public interface ConnexionRepository extends JpaRepository<Connexion, Long> {
    Optional<Connexion> findByEmail(String email);
}
