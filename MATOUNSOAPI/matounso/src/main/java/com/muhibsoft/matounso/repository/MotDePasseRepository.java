package com.muhibsoft.matounso.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.muhibsoft.matounso.model.MotDePasse;

@Repository
public interface MotDePasseRepository extends JpaRepository<MotDePasse, Long> {
    public Optional<MotDePasse> findMotDePasseByUserIdUser(Long idUser);
}
