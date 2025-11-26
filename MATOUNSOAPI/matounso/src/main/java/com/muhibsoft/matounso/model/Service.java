package com.muhibsoft.matounso.model;

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
@Table(name = "service")
@Getter
@Setter
public class Service {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_service")
    private Long idService;

    @Column(name = "codeservice")
    private String codeService;
    @Column(name = "nomservice")
    private String nomService;
    @Column(name = "actif")
    private boolean actif;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "respossable_id")
    private User respossable;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "serviceparent_id")
    private Service serviceParent;
}
