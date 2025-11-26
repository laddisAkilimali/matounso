package com.muhibsoft.matounso.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

import com.muhibsoft.matounso.enums.Devise;
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
@Table(name = "paiement")
@Getter
@Setter
public class Paiement {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_paiement")
    private Long idPaiement;

    @Column(name = "datepaiement", insertable = false)
    private LocalDateTime datePaiement;
    @Column(name = "montantpaye", nullable = false, precision = 12, scale = 2)
    private BigDecimal montantPaye;
    @Column(name = "devise", nullable = false)
    private Devise devise;
    @Column(name = "modepaiement", nullable = false)
    private String modePaiement;
    @Column(name = "reference")
    private String reference;
    @Column(name = "commentaire")
    private String commentaire;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "facture_id")
    private Facture facture;
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "caissier_id")
    private User caissier;
}
