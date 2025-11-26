package com.muhibsoft.matounso.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.muhibsoft.matounso.composeKey.UserRolePermissionKey;
import com.muhibsoft.matounso.enums.StatutEnum;
import com.muhibsoft.matounso.model.RolePermission;

@Repository
public interface RolePermissionRepository extends JpaRepository<RolePermission, UserRolePermissionKey> {

        @Query("""
                        SELECT rp.permission.nomPermission
                        FROM RolePermission rp
                        WHERE rp.role.nomRole = :nomRole
                        AND rp.statut = :statut
                        """)
        Iterable<String> findNomPermissionByNomRole(@Param("nomRole") String nomRole,
                        @Param("statut") StatutEnum statut);
}
