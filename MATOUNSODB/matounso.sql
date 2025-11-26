DROP DATABASE IF EXISTS matounso;
CREATE DATABASE IF NOT EXISTS matounso;
USE matounso;
CREATE TABLE IF NOT EXISTS Statut(
    id_Statut BIGINT AUTO_INCREMENT PRIMARY KEY,
    
    libelleStatut VARCHAR(50) NOT NULL UNIQUE,
    descriptionStatut VARCHAR(255) NULL,
    actif TINYINT(1) NOT NULL DEFAULT 1,
    dateCreation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    dateModification TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS Adresse(
    id_Adresse BIGINT AUTO_INCREMENT PRIMARY KEY,
    ville VARCHAR(50) NOT NULL DEFAULT "Goma",
    quartier VARCHAR(50) NOT NULL,
    avenue VARCHAR(100) NOT NULL,
    numeroMaison VARCHAR(20),
    UNIQUE (ville, quartier, avenue, numeroMaison),
    dateCreation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    dateModification TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS _Role(
    id_Role BIGINT AUTO_INCREMENT PRIMARY KEY,
    nomRole VARCHAR(50) NOT NULL UNIQUE,
    dateCreation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    dateModification TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_role_nomRole (nomRole)
);

CREATE TABLE IF NOT EXISTS Permission(
    id_Permission BIGINT AUTO_INCREMENT PRIMARY KEY,
    nomPermission VARCHAR(50) NOT NULL UNIQUE,
    detail VARCHAR(255) NOT NULL,
    INDEX idx_permission_nomPermission (nomPermission)
);

CREATE TABLE IF NOT EXISTS Role_Permission(
    id_Role BIGINT NOT NULL,
    id_Permission BIGINT NOT NULL,
    dateActivation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    statut ENUM('ACTIF', 'INACTIF', 'SUSPENDU', 'SUPPRIME') DEFAULT 'ACTIF',
    dateDesactivation DATE,
    PRIMARY KEY (id_Role, id_Permission),
    CONSTRAINT fk_Role
        FOREIGN KEY (id_Role) REFERENCES _Role(id_Role),
    CONSTRAINT fk_Permission
        FOREIGN KEY (id_Permission) REFERENCES Permission(id_Permission)
);

CREATE TABLE IF NOT EXISTS User(
    id_User BIGINT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(50) NOT NULL,
    postNom VARCHAR(50) NOT NULL,
    preNom VARCHAR(50) NOT NULL,
    sexe ENUM('MASCULIN', 'FEMININ', 'AUTRE') NOT NULL,
    dateNaissance DATE NOT NULL,
    lieuNaissance VARCHAR(100) NOT NULL,
    nationalite VARCHAR(50) NOT NULL,
    id_Adresse BIGINT NOT NULL,
    dateCreation TIMESTAMP DEFAULT CURRENT_TIMESTAMP ,
    dateModification TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE (nom, preNom, postNom, dateNaissance),
    CONSTRAINT fk_user_Adresse
        FOREIGN KEY (id_Adresse) REFERENCES Adresse(id_Adresse)
);

CREATE TABLE IF NOT EXISTS user_Role(
    id_Role BIGINT NOT NULL,
    id_User BIGINT NOT NULL,
    dateAttribution TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    statut ENUM('ACTIF', 'INACTIF', 'SUSPENDU', 'SUPPRIME') DEFAULT 'ACTIF',
    dateDesactivation DATE,
    PRIMARY KEY(id_Role, id_User),
    CONSTRAINT fk_Role_User
        FOREIGN KEY (id_Role) REFERENCES _Role(id_Role),
    CONSTRAINT fk_User_Role
        FOREIGN KEY (id_User) REFERENCES User(id_User),
    INDEX idx_userRole_statut (statut)
);


CREATE TABLE IF NOT EXISTS Niveau_Etude(
    id_NiveauEtude BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_User BIGINT NOT NULL,
    niveauEtude VARCHAR(100) NOT NULL,
    etablissement VARCHAR(255) NOT NULL,
    filiere VARCHAR(255) NOT NULL,
    mention VARCHAR(100) NOT NULL,
    detail VARCHAR(255) NOT NULL,
    dateObtention DATE,
    CONSTRAINT fk_Niveau_Etude_User
        FOREIGN KEY (id_User) REFERENCES User(id_User)
);


CREATE TABLE IF NOT EXISTS Mot_De_Passe(
    id_User BIGINT PRIMARY KEY NOT NULL,
    motDePasse VARCHAR(255) NOT NULL,
    dateCreation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    dateModification TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    dateExpiration DATE,
    CONSTRAINT fk_user_MotDePasse
        FOREIGN KEY (id_User) REFERENCES User(id_User),
    INDEX idx_MotDePasse_motDePasse (motDePasse)
);

CREATE TABLE IF NOT EXISTS Coordonnee(
    id_User BIGINT PRIMARY KEY NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    telephone VARCHAR(15) NOT NULL UNIQUE,
    dateCreation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    dateModification TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
    CONSTRAINT fk_Coordonnee_User
        FOREIGN KEY (id_User) REFERENCES User(id_User),
    INDEX idx_Coordonnee_email (email)
);

CREATE TABLE IF NOT EXISTS Connexion(
    id_Connexion BIGINT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(100) NOT NULL ,
    nombreTentative INT,
    dateDerniereTentative TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    tempsBloquage TIMESTAMP
);

-- La les tables métiers commence ici

CREATE TABLE IF NOT EXISTS Priorite(
  id_Priorite BIGINT AUTO_INCREMENT PRIMARY KEY,
  createur_id BIGINT NOT NULL,

  libelle VARCHAR(50) NOT NULL UNIQUE,
  actif TINYINT(1) NOT NULL DEFAULT 1,
  dateCreation DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  dateModification DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_priorite_createur
    FOREIGN KEY(createur_id) REFERENCES User(id_User)
);

CREATE TABLE IF NOT EXISTS Patient(
    id_patient BIGINT PRIMARY KEY AUTO_INCREMENT,
    codePatient VARCHAR(30) UNIQUE,
    createur_id BIGINT NOT NULL,
    statut_id BIGINT NOT NULL,
    nom VARCHAR(100) NOT NULL,
    postNom VARCHAR(100) NOT NULL,
    preNom VARCHAR(100) NOT NULL,
    sexe ENUM('FEMININ', 'MASCULIN') NOT NULL,
    dateNaissance DATE NOT NULL,
    telephone VARCHAR(20),
    id_Adresse BIGINT,
    dateEnregistrement TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    etatCivil ENUM('CELIBATAIRE','MARIE','DIVORCE','VEUF'),
    profession VARCHAR(100),
    groupeSanguin ENUM('A','B','AB','O'),
    rhesus ENUM('PLUS','MOINS'),
    email VARCHAR(100),
    CONSTRAINT fkPatientAdresse
        FOREIGN KEY (id_Adresse) REFERENCES Adresse(id_Adresse),
    CONSTRAINT fk_patent_user
        FOREIGN KEY (createur_id) REFERENCES User(id_User),
    CONSTRAINT fk_patient_statut
        FOREIGN KEY (statut_id) REFERENCES Statut(id_Statut),

    INDEX idx_Patient_Noms (nom,postNom,preNom),
    INDEX idx_patient_telephone (telephone)
);

-- Elle Sert à refference aux traitements médicale patient
CREATE TABLE IF NOT EXISTS dossierMedical (
  id_dossierMedical BIGINT PRIMARY KEY AUTO_INCREMENT,
  patient_id BIGINT NOT NULL UNIQUE,
  statut_id BIGINT NOT NULL,

  codeDossier VARCHAR(30) NOT NULL UNIQUE,
  dateCreation DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  antecedent TEXT NULL,
  allergie TEXT NULL,
  noteGenerale TEXT NULL,
  CONSTRAINT fkDossierMedicalPatient
  FOREIGN KEY (patient_id) REFERENCES patient(id_Patient),
  CONSTRAINT fkDossierMedicalStatut
  FOREIGN KEY (statut_id) REFERENCES Statut(id_Statut)
);

-- Elle sert les traitements temporaire d'un patient
CREATE TABLE IF NOT EXISTS EpisodeSoin (
  id_EpisodeSoin BIGINT PRIMARY KEY AUTO_INCREMENT,
  dossierMedical_id BIGINT NOT NULL,
  statut_id BIGINT NOT NULL,
  codeEpisodeSoin VARCHAR(30) NULL UNIQUE,
  motif TEXT NULL,
  dateDebut DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  dateFin   DATETIME NULL,

CONSTRAINT fk_EpisodeSoin_DossierMedical
  FOREIGN KEY(id_dossierMedical) REFERENCES dossierMedical(id_dossierMedical),
CONSTRAINT fk_EpisodeSoin_Statut
  FOREIGN KEY(statut_id) REFERENCES Statut(id_Statut)
);

CREATE TABLE Service (
  id_Service BIGINT PRIMARY KEY AUTO_INCREMENT,
  codeService VARCHAR(30) UNIQUE,
  nomService  VARCHAR(120) NOT NULL,
  actif TINYINT(1) NOT NULL DEFAULT 1,
  serviceParent_id BIGINT NULL,
  respossable_id BIGINT NULL,
  description TEXT NULL,

  CONSTRAINT fk_service_parent 
    FOREIGN KEY (serviceParent_id) REFERENCES Service(id_Service),
  CONSTRAINT fk_service_responsable 
    FOREIGN KEY (respossable_id) REFERENCES User(id_User),
  INDEX idx_service_nomService (nomService)
);
-- La table de la file d'attente des patients dans les services 
CREATE TABLE IF NOT EXISTS FileAttente (
  id_FileAttende BIGINT PRIMARY KEY AUTO_INCREMENT,
  episodeSoin_id   BIGINT NULL,  
  service_id  BIGINT NOT NULL,
  statut_id BIGINT NOT NULL,
  priorite_id BIGINT NOT NULL,

  heureArrivee TIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  heurePriseEnCharge TIME NULL,
  position INT NULL,
  commentaire VARCHAR(255) NULL,

  CONSTRAINT fk_fileAttente_episodeSoin
    FOREIGN KEY (episodeSoin_id) REFERENCES Episode_Soin(id_EpisodeSoin),
  CONSTRAINT fk_fileAttente_service
  FOREIGN KEY (service_id) REFERENCES Service(id_Service),
  CONSTRAINT fk_fileAttente_statut
    FOREIGN KEY (statut_id) REFERENCES Statut(id_Statut),
    CONSTRAINT fk_fileAttente_priorite
    FOREIGN KEY (priorite_id) REFERENCES Priorite(id_Priorite)
);


-- les niveaux d'alertes
CREATE TABLE IF NOT EXISTS NiveauAlerte(
  id_NiveauAlerte BIGINT AUTO_INCREMENT PRIMARY KEY,
  nomAlerte VARCHAR(20) NOT NULL
);

CREATE TABLE IF NOT EXISTS Pharmacie(
  id_Pharmacie BIGINT AUTO_INCREMENT PRIMARY KEY,
  nomPharmacie VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS Medicament(
  id_Medicament BIGINT AUTO_INCREMENT PRIMARY KEY,
  pharmacie_id BIGINT NOT NULL,

  nomMedicament VARCHAR(150) NOT NULL,
  forme VARCHAR(50) NULL,
  dosage VARCHAR(50) NOT NULL,
  presentation VARCHAR(100) NULL,
  descriptionMedicament TEXT NULL,
  actif TINYINT(1) NOT NULL,

  CONSTRAINT fk_medicament_pharmacie
    FOREIGN KEY (pharmacie_id) REFERENCES Pharmacie(id_Pharmacie),
  INDEX idx_medicament_nomMedicament (nomMedicament)
);


-- Les tarifs associés aux services
CREATE TABLE ServiceTarif (
  id_ServiceTarif BIGINT PRIMARY KEY AUTO_INCREMENT,
  service_id  BIGINT NOT NULL,

  codeTarif   VARCHAR(30) UNIQUE,
  libelle     VARCHAR(160) NOT NULL,
  prixUnitaire        DECIMAL(12,2) NOT NULL,
  devise      ENUM('USD','CFD') NOT NULL,
  actif       TINYINT(1) NOT NULL,
  descriptionTarif VARCHAR(255) NULL,

  CONSTRAINT fk_Tarif_Service 
    FOREIGN KEY (service_id) REFERENCES Service(id_Service),
  INDEX idx_serviceTarif_libelle (libelle)
);

--La table des actes médicaux réalisés
CREATE TABLE ActeMedical (
  id_ActeMedical BIGINT PRIMARY KEY AUTO_INCREMENT,
  episodeSoin_id BIGINT NOT NULL,
  serviceTarif_id BIGINT NOT NULL,
  statut_id BIGINT NOT NULL,
 
  dateActeMedical   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  commentaire VARCHAR(255) NULL,

  CONSTRAINT fk_acteMedical_episodeSoin
    FOREIGN KEY (episodeSoin_id) REFERENCES EpisodeSoin(id_EpisodeSoin),
  CONSTRAINT fk_acte_ServiceTarif 
    FOREIGN KEY (serviceTarif_id) REFERENCES ServiceTarif(id_ServiceTarif),
  CONSTRAINT fk_acteMedical_statut
    FOREIGN KEY (statut_id) REFERENCES Statut(id_Statut)
);

-- La facture émise pour un patient
CREATE TABLE Facture (
  id_Facture BIGINT PRIMARY KEY AUTO_INCREMENT,
  codeFacture   VARCHAR(30) NULL UNIQUE,
  patient_id    BIGINT NOT NULL,
  episodeSoin_id    BIGINT NULL,
  facturateur_id   BIGINT NULL,
  statut_id BIGINT NOT NULL,
  
  dateFacturation   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  montantTotal  DECIMAL(12,2),
  commentaire   VARCHAR(255) NULL,

  CONSTRAINT fk_Facture_Patient 
    FOREIGN KEY (patient_id) REFERENCES Patient(id_Patient),
  CONSTRAINT fk_Facture_EpisodeSoin 
    FOREIGN KEY (episodeSoin_id) REFERENCES Episode_Soin(id_EpisodeSoin),
  CONSTRAINT fk_Facture_
    FOREIGN KEY (facturateur_id) REFERENCES User(id_User),
  CONSTRAINT fk_Facture_Statut
    FOREIGN KEY (statut_id) REFERENCES Statut(id_Statut)
);

CREATE TABLE FactureDetail (
  id_FactureDetail BIGINT PRIMARY KEY AUTO_INCREMENT,
  facture_id   BIGINT NOT NULL,
  acteMedical_id BIGINT NOT NULL UNIQUE,

  quantite       DECIMAL(10,2) NOT NULL DEFAULT 1,
  prixUnitaire  DECIMAL(12,2) NOT NULL,
  montant        DECIMAL(12,2) NOT NULL,
  commentaire    VARCHAR(255) NULL,
  
  CONSTRAINT fk_factureDetail_facture
    FOREIGN KEY (facture_id) REFERENCES Facture(id_Facture),
  CONSTRAINT fk_factureDetail_acteMedical
    FOREIGN KEY(acteMedical_id) REFERENCES ActeMedical(id_ActeMedical)
);




-- Les paiements effectués pour une facture
CREATE TABLE Paiement (
  id_Paiement BIGINT PRIMARY KEY AUTO_INCREMENT,
  facture_id   BIGINT NOT NULL,
  caissier_id  BIGINT NOT NULL,

  datePaiement DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  montantPaye      DECIMAL(12,2) NOT NULL,
  devise       ENUM('USD', 'FCD') NOT NULL,
  modePaiement VARCHAR(30) NOT NULL,
  reference    VARCHAR(50) NULL,
  commentaire  VARCHAR(255) NULL,

  CONSTRAINT fk_Paiement_Facture 
    FOREIGN KEY (facture_id) REFERENCES Facture(id_Facture),
  CONSTRAINT fk_Paiement_Caissier 
    FOREIGN KEY (caissier_id) REFERENCES User(id_User)
);


CREATE TABLE Preconsultation (
  id_Preconsultation BIGINT PRIMARY KEY AUTO_INCREMENT,
  episodeSoin_id   BIGINT NOT NULL UNIQUE,
  preconsultant_id     BIGINT NOT NULL,
  serviceDestination_id BIGINT NULL,

  datePreconsultation   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  motifVisite TEXT NULL,
  poids          DECIMAL(5,2) NULL,
  taille         SMALLINT UNSIGNED NULL,
  temperature     DECIMAL(4,1) NULL,
  tensionSystolique TINYINT UNSIGNED NULL,
  tensionDiastolique TINYINT UNSIGNED NULL,
  frequenceCardiaque TINYINT UNSIGNED NULL,
  frequenceRespiratoire TINYINT UNSIGNED NULL,
  saturationO2      TINYINT UNSIGNED NULL,
  glycemieCapillaire DECIMAL(5,2) NULL,
  commentaire TEXT NULL,


  CONSTRAINT fk_preconsultation_episodeSoin 
    FOREIGN KEY (episodeSoin_id)  REFERENCES EpisodeSoin(id_Episode),
  CONSTRAINT fk_preconsultation_user  
    FOREIGN KEY (preconsultant_id)    REFERENCES User(id_User),
  CONSTRAINT fk_preconsultation_serviceDestination
    FOREIGN KEY(serviceDestination_id) REFERENCES Service(id_Service)
);

-- LES ENUMERATION DYNAMIQUE
CREATE TABLE IF NOT EXISTS TypeDiagnostique(
  id_TypeDiagnostique BIGINT AUTO_INCREMENT PRIMARY KEY,
  createur_id BIGINT NOT NULL,

  libelle VARCHAR(50) NOT NULL UNIQUE,
  actif TINYINT(1) NOT NULL DEFAULT 1,
  dateCreation DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  dateModification DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_typeConsultation_createur
    FOREIGN KEY(createur_id) REFERENCES User(id_User)
);

CREATE TABLE IF NOT EXISTS TypeConsultation(
  id_TypeConsultation BIGINT AUTO_INCREMENT PRIMARY KEY,
  createur_id BIGINT NOT NULL,

  libelle VARCHAR(50) NOT NULL UNIQUE,
  actif TINYINT(1) NOT NULL DEFAULT 1,
  dateCreation DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  dateModification DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_typeConsultation_createur
    FOREIGN KEY(createur_id) REFERENCES User(id_User)
);
CREATE TABLE IF NOT EXISTS TypeRdv(
  id_TypeRdv BIGINT AUTO_INCREMENT PRIMARY KEY,
  createur_id BIGINT NOT NULL,

  libelle VARCHAR(50) NOT NULL UNIQUE,
  actif TINYINT(1) NOT NULL DEFAULT 1,
  dateCreation DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  dateModification DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_typeRdv_createur
    FOREIGN KEY(createur_id) REFERENCES User(id_User)
);

CREATE TABLE IF NOT EXISTS TypePrescription(
  id_TypePrescription BIGINT AUTO_INCREMENT PRIMARY KEY,
  createur_id BIGINT NOT NULL,

  libelle VARCHAR(50) NOT NULL UNIQUE,
  actif TINYINT(1) NOT NULL DEFAULT 1,
  dateCreation DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  dateModification DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_typeRdv_createur
    FOREIGN KEY(createur_id) REFERENCES User(id_User)
);

CREATE TABLE IF NOT EXISTS TypeSalle(
  id_TypeSalle BIGINT AUTO_INCREMENT PRIMARY KEY,
  createur_id BIGINT NOT NULL,

  libelle VARCHAR(50) NOT NULL UNIQUE,
  actif TINYINT(1) NOT NULL DEFAULT 1,
  dateCreation DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  dateModification DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_typeRdv_createur
    FOREIGN KEY(createur_id) REFERENCES User(id_User)
);

CREATE TABLE IF NOT EXISTS CategorieSalle(
  id_CategorieSalle BIGINT AUTO_INCREMENT PRIMARY KEY,
  createur_id BIGINT NOT NULL,

  libelle VARCHAR(50) NOT NULL UNIQUE,
  actif TINYINT(1) NOT NULL DEFAULT 1,
  dateCreation DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  dateModification DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_typeRdv_createur
    FOREIGN KEY(createur_id) REFERENCES User(id_User)
);

-- FIN ENUMERATION DYNAMIQUE

-- La table des consultations médicales
CREATE TABLE IF NOT EXISTS Consultation (
  id_Consultation BIGINT PRIMARY KEY AUTO_INCREMENT,
  acteMedical_id BIGINT NOT NULL UNIQUE,
  medecinConsultant_id   BIGINT NOT NULL,
  Service_id BIGINT NOT NULL,
  statut_id BIGINT NOT NULL,
  typeConsultation_id BIGINT NOT NULL,

  dateConsultation DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  anamnese   TEXT NULL,
  conclusion TEXT NULL,

  CONSTRAINT fk_consultation_acteMedical
   FOREIGN KEY (acteMedical_id) REFERENCES ActeMedical(id_ActeMedical),
  CONSTRAINT fk_consultation_user 
    FOREIGN KEY (medecinConsultant_id) REFERENCES User(id_User),
  CONSTRAINT fk_consultation_service
    FOREIGN KEY (Service_id) REFERENCES Service(id_Service),
  CONSTRAINT fk_consultation_statut
    FOREIGN KEY (statut_id) REFERENCES Statut(id_Statut),
  CONSTRAINT fk_consultation_typeConsultation
    FOREIGN KEY (typeConsultation_id) REFERENCES TypeConsultation(id_TypeConsultation)
);


-- La table des diagnostics posés lors des consultations
CREATE TABLE Diagnostic (
  id_Diagnostic BIGINT PRIMARY KEY AUTO_INCREMENT,
  consultation_id BIGINT NOT NULL,
  typeDiagnostique_id BIGINT NOT NULL,

  codeCIM10  VARCHAR(10) NOT NULL,
  libelle    VARCHAR(160) NOT NULL,
  principal   TINYINT(1) NOT NULL,
  dateDiagnostic DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  commentaire TEXT NULL,

  CONSTRAINT fk_diagnostic_consultation
   FOREIGN KEY (consultation_id) REFERENCES Consultation(id_Consultation),
  CONSTRAINT fk_diagnostic_typeDiagnostique
   FOREIGN KEY (typeDiagnostique_id) REFERENCES TypeDiagnostique(id_TypeDiagnostique)
);

-- La table des rendez-vous des patients
CREATE TABLE IF NOT EXISTS RendezVous (
  id_RendezVous BIGINT PRIMARY KEY AUTO_INCREMENT,
  patient_id   BIGINT NOT NULL,
  planificateurRendezVous_id   BIGINT NOT NULL,
  serviceRendezVous_id BIGINT NOT NULL,
  statut_id BIGINT NOT NULL,
  typeRdv_id BIGINT NOT NULL,
  
  daterendezvous    DATETIME NOT NULL,
  dureeRendezvous TINYINT UNSIGNED NULL,
  objet        VARCHAR(160) NOT NULL,
  commentaire  VARCHAR(255) NULL,
  dateCreation   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

  CONSTRAINT fk_rdv_patient  
    FOREIGN KEY (patient_id)  REFERENCES Patient(id_Patient),
  CONSTRAINT fk_rdv_service
    FOREIGN KEY (serviceRendezVous_id) REFERENCES Service(id_service),
  CONSTRAINT fk_rdv_creator  
    FOREIGN KEY (planificateurRendezVous_id)  REFERENCES User(id_User),
  CONSTRAINT fk_rdv_statut
    FOREIGN KEY (statut_id) REFERENCES Statut(id_Statut),
  CONSTRAINT fk_rdv_typeRdv
    FOREIGN KEY (typeRdv_id) REFERENCES TypeRdv(id_TypeRdv),
  INDEX idx_rendezVous_dateHeureStatut (dateHeure)
);


-- examens demandés pour un patient
CREATE TABLE DemandeExamen (
  id_DemandeExamen BIGINT PRIMARY KEY AUTO_INCREMENT,
  consultation_id     BIGINT NOT NULL,
  acteMedical_id BIGINT NOT NULL UNIQUE,
  serviceExamination_id BIGINT NOT NULL,
  statut_id BIGINT NOT NULL,
  priorite_id BIGINT NOT NULL,

  dateDemande     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  commentaire VARCHAR(255) NULL,

  CONSTRAINT fk_DemandeExamen_Consultation
    FOREIGN KEY(consultation_id) REFERENCES Consultation(id_Consultation),
  CONSTRAINT fk_DemandeExamen_ActeMedical
    FOREIGN KEY(acteMedical_id) REFERENCES ActeMedical(id_ActeMedical),
   CONSTRAINT fk_DemandeExamen_service
    FOREIGN KEY(serviceExamination_id) REFERENCES Service(id_Service),
  CONSTRAINT fk_DemandeExamen_statut
    FOREIGN KEY(statut_id) REFERENCES Statut(id_Statut),
  CONSTRAINT fk_DemandeExamen_priorite
    FOREIGN KEY(priorite_id) REFERENCES Priorite(id_Priorite),
  INDEX idx_demandeExamen_prioriteStatut (dateDemande)
);

--les demande d'examen dans les service de Laboratoire et leurs resultant
CREATE TABLE ExamenLabo (
  id_ExamenLabo BIGINT PRIMARY KEY AUTO_INCREMENT,
  demandeExamen_id BIGINT NOT NULL UNIQUE,
  statut_id BIGINT NOT NULL,

  codeEchantillon VARCHAR(50) NULL,
  typeEchantillon VARCHAR(50) NULL,
  datePrelevement DATETIME NULL,
  dateResultat DATETIME NULL,

  resultatTexte TEXT NULL,
  valeurNumerique DECIMAL(10,2) NULL,
  unite VARCHAR(20) NULL,
  referenceMin DECIMAL(10,2) NULL,
  referenceMax DECIMAL(10,2) NULL,

  technicienLabo_id BIGINT NOT NULL,
  commentaire TEXT NULL,

  CONSTRAINT fk_ExamenLabo_demandeExamen
    FOREIGN KEY (demandeExamen_id) REFERENCES DemandeExamen(id_DemandeExamen),
  CONSTRAINT fk_ExamenLabo_user
    FOREIGN KEY (technicienLabo_id) REFERENCES User(id_User),
  CONSTRAINT fk_ExamenLabo_statut
    FOREIGN KEY (statut_id) REFERENCES Statut(id_Statut)
);

-- Stock demicament
CREATE TABLE IF NOT EXISTS StockLot(
  id_StockLot BIGINT AUTO_INCREMENT PRIMARY KEY,
  medicament_id BIGINT NOT NULL,
  pharmacie_id BIGINT NOT NULL,

  numeroLot VARCHAR(50) NOT NULL,
  datePeremption DATE NOT NULL,
  quaniteInitiale INT NOT NULL,
  quantiteActuelle INT NOT NULL,
  prixAchatUnit DECIMAL(10,2) NULL,
  dateEntree DATETIME NOT NULL,
  fournisseur VARCHAR(100) NULL,
  actif TINYINT(1) NOT NULL,

  CONSTRAINT fk_stockLot_medicament
    FOREIGN KEY (medicament_id) REFERENCES Medicament(id_Medicament),
  CONSTRAINT fk_stockLot_pharmacie
    FOREIGN KEY (pharmacie_id) REFERENCES Pharmacie(id_Pharmacie)
);


-- La table des prescriptions médicales
CREATE TABLE PrescriptionMedical (
  id_Prescription BIGINT PRIMARY KEY AUTO_INCREMENT,
  acteMedical_id BIGINT NOT NULL UNIQUE,
  consultation_id BIGINT NOT NULL UNIQUE,
  statut_id BIGINT NOT NULL,
  typePrescription_id BIGINT NOT NULL,

  datePrescription DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  commentaire VARCHAR(255) NULL,

  CONSTRAINT fk_prescription_acteMedical
    FOREIGN KEY (acteMedical_id) REFERENCES ActeMedical(id_ActeMedical),
  CONSTRAINT fk_PrescriptionMedical_Consultation
    FOREIGN KEY (consultation_id) REFERENCES Consultation(id_Consultation),
  CONSTRAINT fk_prescription_statut
    FOREIGN KEY (statut_id) REFERENCES Statut(id_Statut),
   CONSTRAINT fk_prescription_typePrescription
    FOREIGN KEY (typePrescription_id) REFERENCES TypePrescription(id_TypePrescription),
  INDEX idx_prescriptionMedical_datePrescriptionStatut (datePrescription)
);

-- Medicament livrés pour une Prescription et mode de dispensation
CREATE TABLE IF NOT EXISTS DelivranceMedicament (
  id_DelivranceMedicament BIGINT AUTO_INCREMENT PRIMARY KEY,
  medicament_id BIGINT NOT NULL,
  lot_id BIGINT NOT NULL,
  livreur_id BIGINT NOT NULL,
  prescription_id BIGINT  NULL,

  quantite TINYINT UNSIGNED NOT NULL,
  dateDispensation DATETIME NOT NULL,
  posologie VARCHAR(255) NULL,
  dureeJours TINYINT UNSIGNED NULL,
  commentaire TEXT NULL,

CONSTRAINT fk_delivranceMedicament_medicament
  FOREIGN KEY(medicament_id) REFERENCES Medicament(id_Medicament),
CONSTRAINT fk_delivranceMedicament_stockLot
  FOREIGN KEY(lot_id) REFERENCES StockLot(id_StockLot),
CONSTRAINT fk_delivranceMedicament_user
  FOREIGN KEY(livreur_id) REFERENCES User(id_User),
CONSTRAINT fk_delivranceMedicament_prescriptionMedical
  FOREIGN KEY(prescription_id) REFERENCES PrescriptionMedical(id_Prescription)
);

-- toute les Chambres dans l'hopital
CREATE TABLE IF NOT EXISTS Salle(
  id_Salle BIGINT AUTO_INCREMENT PRIMARY KEY,
  CodeSalle VARCHAR(50) NOT NULL,
  service_id BIGINT NOT NULL,
  createur_id BIGINT NOT NULL,
  statut_id BIGINT NOT NULL,
  typeSalle_id BIGINT NOT NULL,
  categorieSalle_id BIGINT NOT NULL,

  nomSalle VARCHAR(100) NOT NULL UNIQUE,
  sexeSalle ENUM('MASCULIN','FEMININ','MIXTE') NOT NULL,
  capacite TINYINT UNSIGNED NULL,
  localisation VARCHAR(100) NULL,
  actif TINYINT(1) DEFAULT 1,
  dateCreation DATETIME DEFAULT CURRENT_TIMESTAMP,
  dateModification DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  CONSTRAINT fk_salle_service
    FOREIGN KEY (service_id) REFERENCES Service(id_Service),
  CONSTRAINT fk_salle_User
    FOREIGN KEY (createur_id) REFERENCES User(id_User),
  CONSTRAINT fk_salle_statut
    FOREIGN KEY (statut_id) REFERENCES Statut(id_Statut),
  CONSTRAINT fk_salle_typeSalle
    FOREIGN KEY (typeSalle_id) REFERENCES TypeSalle(id_TypeSalle),
  CONSTRAINT fk_salle_categorieSalle
    FOREIGN KEY (categorieSalle_id) REFERENCES CategorieSalle(id_CategorieSalle),
  INDEX idx_salle_typeSalleCategorieStatut (sexeSalle)
);

-- les Lits dans l'hopital
CREATE TABLE IF NOT EXISTS Lit(
  id_Lit BIGINT AUTO_INCREMENT PRIMARY KEY,
  codeLit VARCHAR(50) NOT NULL UNIQUE,
  salle_id BIGINT NOT NULL,
  statut_id BIGINT NOT NULL,
  numeroLit SMALLINT UNSIGNED NOT NULL UNIQUE,
  typeLit VARCHAR(50) NOT NULL,

  CONSTRAINT fk_lit_salle
    FOREIGN KEY (chambre_id) REFERENCES Salle(id_Salle),
  CONSTRAINT fk_lit_statut
    FOREIGN KEY (statut_id) REFERENCES Statut(id_Statut),
  INDEX idx_lit_typeLitStatut (typeLit),
  INDEX idx_lit_numeroLit (numeroLit)
);


-- table des admissions(hospitalisation) des patients
CREATE TABLE Admission (
  id_Admission BIGINT PRIMARY KEY AUTO_INCREMENT,

  patient_id  BIGINT NOT NULL,
  episode_id  BIGINT NOT NULL UNIQUE,
  lit_id      BIGINT NULL,
  serviceAdmision_id BIGINT NOT NULL,
  medecinResponsable_id BIGINT NOT NULL,
  statut_id BIGINT NOT NULL,

  dateAdmission      DATE NOT NULL DEFAULT CURRENT_TIMESTAMP,
  dateSortiePrevue   DATE NULL,
  dateSortieReelle   DATE NULL,

  motifAdmission     TEXT NULL,
  commentaire VARCHAR(255) NULL,

  CONSTRAINT fk_admision_patient   
    FOREIGN KEY (patient_id) REFERENCES Patient(id_Patient),
  CONSTRAINT fk_admision_episodeSoin
    FOREIGN KEY (episode_id) REFERENCES Episode_Soin(id_Episode),
  CONSTRAINT fk_admision_service
    FOREIGN KEY (serviceAdmision_id) REFERENCES Service(id_Service),
  CONSTRAINT fk_admision_lit
    FOREIGN KEY (lit_id) REFERENCES Lit(id_Lit),
  CONSTRAINT fk_admision_User
    FOREIGN KEY (medecinResponsable_id) REFERENCES User(id_User),
  CONSTRAINT fk_admision_statut
    FOREIGN KEY (statut_id) REFERENCES Statut(id_Statut),
  INDEX idx_admission_patient_dateAdmission (patient_id, dateAdmission)
);

CREATE TABLE IF NOT EXISTS NoteInfirmiere(
  id_NoteInfirmiere BIGINT AUTO_INCREMENT PRIMARY KEY,
  admission_id BIGINT NOT NULL,
  infirmier_id BIGINT NOT NULL,

  typeNote VARCHAR(30) NOT NULL,
  observation TEXT NOT NULL,
  actionPrevue TEXT NULL,
  niveauAlerte VARCHAR(20) NOT NULL,
  visibleMedecin TINYINT(1) NOT NULL,
  dateCreation DATETIME DEFAULT CURRENT_TIMESTAMP,
  dateModification DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  CONSTRAINT fk_noteInfirmiere_User
    FOREIGN KEY (infirmier_id) REFERENCES User(id_User),
  CONSTRAINT fk_noteInfirmiere_Admission
    FOREIGN KEY (admission_id) REFERENCES Admission(id_Admission)
);

CREATE TABLE soinsInfirmiers (
  id_SoinInfirmier  BIGINT PRIMARY KEY AUTO_INCREMENT,
  acteMedical_id  BIGINT NOT NULL UNIQUE,
  infirmier_id     BIGINT NOT NULL,

  typeSoin        VARCHAR(100) NOT NULL,
  descriptionSoin      TEXT NULL,
  dateSoin        DATETIME NOT NULL,
  commentaire      TEXT NULL,

  CONSTRAINT fk_soin_acteMedical
     FOREIGN KEY (acteMedical_id) REFERENCES ActeMedical(id_ActeMedical),
  CONSTRAINT fk_soin_infirmier
     FOREIGN KEY (infirmier_id) REFERENCES User(id_User),
  INDEX idx_soin_typeSoin_dateSoin (typeSoin, dateSoin)
);


-- catalogue des paramtrès
CREATE TABLE IF NOT EXISTS ParametreType(
  id_parametreType BIGINT AUTO_INCREMENT PRIMARY KEY,
  codeParametre VARCHAR(50) NOT NULL UNIQUE,
  createur_id BIGINT NOT NULL,

  libelle VARCHAR(100) NOT NULL,
  unite VARCHAR(20) NOT NULL,
  valeurMinNormale DECIMAL(10,2) NOT NULL,
  valeurMaxNormale DECIMAL(10,2) NOT NULL,
  actif TINYINT(1) NOT NULL,

  dateCreation DATETIME DEFAULT CURRENT_TIMESTAMP,
  dateModification DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_parametreType_user
    FOREIGN KEY (createur_id) REFERENCES User(id_User),
  INDEX idx_parametreType_libelle (libelle)
);

CREATE TABLE IF NOT EXISTS ParametreObserve(
  id_ParametreObserve BIGINT AUTO_INCREMENT PRIMARY KEY,
  parametreType_id BIGINT NOT NULL,
  patient_id BIGINT NOT NULL,
  NiveauAlerte_id BIGINT NULL,
  soingant_id BIGINT NOT NULL,

  dateObservation DATETIME NOT NULL,
  valeurNumerique DECIMAL(10,2) NULL,
  valeurTexte VARCHAR(100) NULL,
  remarque TEXT,

  dateCreation DATETIME DEFAULT CURRENT_TIMESTAMP,
  dateModification DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP

  CONSTRAINT fk_parametreObserve_parametreType
    FOREIGN KEY(parametreType_id) REFERENCES ParametreType(id_parametreType),
  CONSTRAINT fk_parametreObserve_patient
    FOREIGN KEY(patient_id) REFERENCES Patient(id_patient),
  CONSTRAINT fk_parametreObserve_niveauAlerte
    FOREIGN KEY(NiveauAlerte_id) REFERENCES NiveauxAlerte(id_NiveauAlerte),
  CONSTRAINT fk_parametreObserve_user
    FOREIGN KEY(soingant_id) REFERENCES User(id_User)
);