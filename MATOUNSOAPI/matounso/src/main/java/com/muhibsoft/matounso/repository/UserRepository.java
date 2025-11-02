package com.muhibsoft.matounso.repository;

import java.time.LocalDate;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;

import com.muhibsoft.matounso.model.User;

public interface UserRepository extends JpaRepository<User, Long> {

    public Optional<User> findUserByCoordonneeEmail(String email);

    public Optional<User> findByNomAndPostNomAndPreNomAndDateNaissance(String nom, String postNom, String preNom,
            LocalDate dateNaissance);

}
