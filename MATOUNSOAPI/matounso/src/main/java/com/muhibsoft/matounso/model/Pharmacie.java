package com.muhibsoft.matounso.model;

import jakarta.persistence.Column;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;

public class Pharmacie {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_pharmacie")
    private Long idPharmacie;

    @Column(name = "nompharmacie", nullable = false, length = 100)
    private String nomPharmacie;
}
