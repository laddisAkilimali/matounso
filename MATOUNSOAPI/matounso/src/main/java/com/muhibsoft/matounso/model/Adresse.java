package com.muhibsoft.matounso.model;

import java.time.LocalDateTime;
import java.util.List;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.Setter;

@Entity
@Table(name = "adresse")
@Getter
@Setter
public class Adresse {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_adresse")
    private Long idAdresse;

    @Column(name = "ville")
    private String ville;

    @Column(name = "quartier")
    private String quartier;

    @Column(name = "avenue")
    private String avenue;

    @Column(name = "numeromaison")
    private String numeroMaison;

    @Column(name = "datecreation", insertable = false)
    private LocalDateTime dateCreation;

    @Column(name = "datemodification")
    private LocalDateTime dateModification;

    @OneToMany(mappedBy = "adresse", fetch = FetchType.LAZY, cascade = {
            CascadeType.REFRESH, CascadeType.MERGE })
    private List<User> user;

}
