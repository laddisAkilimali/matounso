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
@Table(name = "diagnostic")
@Getter
@Setter
public class Diagnostic {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_diagnostic")
    private Long idDiagnostic;

    @Column(name = "codeCIM10")
    private String codeCIM10;
    @Column(name = "libelle")
    private String libelle;
    @Column(name = "principal")
    private Boolean principal;
    @Column(name = "dateDiagnostic")
    private LocalDateTime dateDiagnostic;
    @Column(name = "commentaire")
    private String commentaire;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "consultation_id")
    private Consultation consultation;
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "typediagnostique_id")
    private TypeDiagnostique TypeDiagnostique;

}
