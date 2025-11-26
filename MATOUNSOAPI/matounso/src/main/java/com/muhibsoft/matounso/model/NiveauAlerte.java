package com.muhibsoft.matounso.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.Setter;

@Entity
@Table(name = "niveaualerte")
@Getter
@Setter
public class NiveauAlerte {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_niveaualerte")
    private Long idNiveauAlerte;

    @Column(name = "nomalerte", nullable = false, length = 20)
    private String nomAlerte;
}
