package com.muhibsoft.matounso.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import com.muhibsoft.matounso.model.Permission;

@Repository
public interface PermissionsRepository extends JpaRepository<Permission, Long> {
    @Query("select p.nomPermission from Permission p")
    List<String> findAllNomPermission();

    Optional<Permission> findByNomPermission(String nomPermission);

}
