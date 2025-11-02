package com.muhibsoft.matounso.model;

import java.time.LocalDate;
import java.time.LocalDateTime;

import com.muhibsoft.matounso.composeKey.UserRoleKey;
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

@Entity
@Getter
@Setter
@Table(name = "user_role")
public class UserRole {

    @EmbeddedId
    private UserRoleKey key;

    @ManyToOne(fetch = FetchType.LAZY)
    @MapsId("idUser")
    @JoinColumn(name = "id_user")
    private User user;

    @ManyToOne(fetch = FetchType.LAZY)
    @MapsId("idRole")
    @JoinColumn(name = "id_role")
    private Role role;

    @Column(name = "dateattribution", insertable = false)
    private LocalDateTime dateAttribution;

    @Column(name = "datedesactivation")
    private LocalDate dateDesactivation;

    @Enumerated(EnumType.STRING)
    @Column(name = "statut", insertable = false)
    private UserStatutEnum statut;

}