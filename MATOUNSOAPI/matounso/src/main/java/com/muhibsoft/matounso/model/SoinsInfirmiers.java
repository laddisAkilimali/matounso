package com.muhibsoft.matounso.model;

import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.Setter;

@Entity
@Table(name = "soinsinfirmiers")
@Getter
@Setter
public class SoinsInfirmiers {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_soinsinfirmiers")
    private Long idSoinsInfirmiers;

    @Column(name = "typesoin")
    private String typeSoin;
    @Column(name = "descriptionsoin")
    private String descriptionSoin;
    @Column(name = "datesoin")
    private LocalDateTime dateSoin;
    @Column(name = "commentaire")
    private String commentaire;

    @ManyToOne(fetch = FetchType.LAZY)
    @Column(name = "actemedical_id", unique = true)
    private ActeMedical acteMedical;
    @ManyToOne(fetch = FetchType.LAZY)
    @Column(name = "infirmier_id")
    private User infirmier;
}
