package com.muhibsoft.matounso.model;

import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.Setter;

@Entity
@Table(name = "delivrancemedicament")
@Getter
@Setter
public class DelivranceMedicament {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_delivrancemedicament")
    private Long idDelivranceMedicament;

    @Column(name = "quantite")
    private Byte quantite;
    @Column(name = "dateDispensation")
    private LocalDateTime dateDispensation;
    @Column(name = "posologie")
    private String posologie;
    @Column(name = "dureeJours")
    private Byte dureeJours;
    @Column(name = "commentaire")
    private String commentaire;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "medicament_id")
    private Medicament medicament;
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "prescription_id")
    private PrescriptionMedical prescription;
    @ManyToOne(fetch = FetchType.LAZY)
    @Column(name = "livreur_id")
    private User livreur;
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "lot_id")
    private StockLot lot;

}
