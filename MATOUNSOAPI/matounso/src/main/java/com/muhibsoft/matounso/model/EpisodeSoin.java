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
@Table(name = "episodesoin")
@Getter
@Setter
class EpisodeSoin {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_episodesoin")
    private Long idEpisodeSoin;

    @Column(name = "codeepisodesoin")
    private String codeEpisodeSoin;
    @Column(name = "motif")
    private String motif;
    @Column(name = "datedebut", insertable = false)
    private LocalDateTime dateDebut;
    @Column(name = "dateFiin")
    private LocalDateTime dateFin;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "dossiermedical_id")
    private DossierMedical dossierMedical;
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "statut_id")
    private Statut statut;
}
