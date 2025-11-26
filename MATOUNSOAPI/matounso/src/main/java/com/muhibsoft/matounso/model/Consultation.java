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
@Table(name = "consultation")
@Getter
@Setter
public class Consultation {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_consultation")
    private Long idConsultation;

    @Column(name = "dateconsultation")
    private LocalDateTime dateConsultation;
    @Column(name = "anamnese")
    private String anamnese;
    @Column(name = "conclusion")
    private String conclusion;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "actemedical_id", unique = true)
    private ActeMedical acteMedical;
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "medecinconultant_id")
    private User medecinConsultant;
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "service_id")
    private Service service;
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "statut_id")
    private Statut statut;
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "typeconsultation_id")
    private TypeConsultation tyPeConsultation;

}
