package com.muhibsoft.matounso.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

import com.muhibsoft.matounso.model.Adresse;

@Repository
public interface AdresseRepository extends JpaRepository<Adresse, Long> {
    public Optional<Adresse> findByVilleAndQuartierAndAvenueAndNumeroMaison(String ville, String quartier,
            String avenue,
            String numeroMaison);
}
