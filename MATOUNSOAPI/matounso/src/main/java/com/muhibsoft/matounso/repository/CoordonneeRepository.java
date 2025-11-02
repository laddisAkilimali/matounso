package com.muhibsoft.matounso.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.muhibsoft.matounso.model.Coordonnee;

@Repository
public interface CoordonneeRepository extends JpaRepository<Coordonnee, Long> {
    public Optional<Coordonnee> findCoordonneeByEmail(String email);

    public Optional<Coordonnee> findByTelephone(String telephone);
}
