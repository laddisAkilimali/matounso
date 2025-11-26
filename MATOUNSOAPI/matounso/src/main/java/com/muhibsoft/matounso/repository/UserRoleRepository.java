package com.muhibsoft.matounso.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.muhibsoft.matounso.composeKey.UserRoleKey;
import com.muhibsoft.matounso.enums.StatutEnum;
import com.muhibsoft.matounso.model.UserRole;

@Repository
public interface UserRoleRepository extends JpaRepository<UserRole, UserRoleKey> {
        @Query(value = """
                        SELECT r.nomRole
                        FROM UserRole uir
                        JOIN uir.role r
                        WHERE uir.user.idUser = :idUser
                        AND uir.statut = :statut
                        """)
        Optional<String> findNomRoleByIdUser(@Param("idUser") Long idUser,
                        @Param("statut") StatutEnum statut);
}
