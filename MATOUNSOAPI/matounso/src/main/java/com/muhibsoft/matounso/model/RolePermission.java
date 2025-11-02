package com.muhibsoft.matounso.model;

import java.time.LocalDate;
import java.time.LocalDateTime;
import com.muhibsoft.matounso.composeKey.UserRolePermissionKey;
import com.muhibsoft.matounso.enums.UserStatutEnum;

import jakarta.persistence.Column;
import jakarta.persistence.EmbeddedId;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.FetchType;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.MapsId;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Entity
@Table(name = "role_permission")
public class RolePermission {

    @EmbeddedId
    private UserRolePermissionKey key;

    @ManyToOne(fetch = FetchType.LAZY)
    @MapsId("idRole")
    @JoinColumn(name = "id_role")
    private Role role;

    @ManyToOne(fetch = FetchType.LAZY)
    @MapsId("idPermission")
    @JoinColumn(name = "id_permission")
    private Permission permission;

    @Column(name = "dateactivation", insertable = false)
    private LocalDateTime dateActivation;

    @Enumerated(EnumType.STRING)
    @Column(name = "statut", insertable = false)
    private UserStatutEnum statut;

    @Column(name = "datedesactivation")
    private LocalDate dateDesactivation;
}
