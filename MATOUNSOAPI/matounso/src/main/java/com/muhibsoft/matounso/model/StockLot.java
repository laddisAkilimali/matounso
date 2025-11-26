package com.muhibsoft.matounso.model;

import java.time.LocalDate;
import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.Setter;

@Entity
@Table(name = "stocklot")
@Getter
@Setter
public class StockLot {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_stocklot")
    private Long idStockLot;

    @Column(name = "numerolot")
    private String numeroLot;
    @Column(name = "dateperemption")
    private LocalDate datePeremption;
    @Column(name = "quantiteinitiale")
    private Integer quantiteInitiale;
    @Column(name = "quantiteactuelle")
    private Integer quantiteActuelle;
    @Column(name = "prixachatunit")
    private Double prixAchatUnit;
    @Column(name = "dateentree")
    private LocalDateTime dateEntree;
    @Column(name = "fournisseur")
    private String fournisseur;
    @Column(name = "actif")
    private Boolean actif;

    @ManyToOne
    @JoinColumn(name = "medicament_id")
    private Medicament medicament;
    @JoinColumn(name = "pharmacie_id")
    private Pharmacie pharmacie;
}
