package com.muhibsoft.matounso.model;

import java.math.BigDecimal;

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
@Table(name = "facturedetail")
@Getter
@Setter
public class FactureDetail {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_facturedetail")
    private Long idFactureDetail;

    @Column(name = "quantite")
    private Integer quantite;
    @Column(name = "prixunitaire", precision = 12, scale = 2)
    private BigDecimal prixUnitaire;
    @Column(name = "montant", precision = 12, scale = 2)
    private BigDecimal montant;
    @Column(name = "commentaire")
    private String commentaire;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "facture_id")
    private Facture facture;
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "actemedical_id", unique = true)
    private ActeMedical acteMedical;
}
