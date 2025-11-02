DROP DATABASE IF EXISTS matounso;
CREATE DATABASE IF NOT EXISTS matounso;
USE matounso;
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
    dateModification TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS Permission(
    id_Permission BIGINT AUTO_INCREMENT PRIMARY KEY,
    nomPermission VARCHAR(50) NOT NULL UNIQUE,
    detail VARCHAR(255) NOT NULL
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
        FOREIGN KEY (id_User) REFERENCES User(id_User)
);

CREATE TABLE IF NOT EXISTS Statut(
    id_Statut BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_User BIGINT NOT NULL,
    statut ENUM('ACTIF', 'INACTIF', 'SUSPENDU', 'SUPPRIME') DEFAULT 'ACTIF',
    dateDebutStatut TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    dateFinStatut DATE,
    CONSTRAINT fk_Statut_User
    FOREIGN KEY (id_User) REFERENCES User(id_User),
    INDEX idx_Statut_id_User (id_User)
);

CREATE TABLE IF NOT EXISTS Fonction(
    id_Fonction BIGINT AUTO_INCREMENT PRIMARY KEY,
     id_User BIGINT NOT NULL,
    fonction VARCHAR(100) NOT NULL,
    detail TEXT NOT NULL,
    dateDebutFonction TIMESTAMP DEFAULT CURRENT_TIMESTAMP ,
    dateFinFonction DATE,
    CONSTRAINT fk_Fonction_User
    FOREIGN KEY (id_User) REFERENCES User(id_User),
    INDEX idx_Fonction_id_User (id_User)
);
CREATE TABLE IF NOT EXISTS Grade(
    id_Grade BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_User BIGINT NOT  NULL,
    grade VARCHAR(50) NOT NULL,
    detail TEXT NOT NULL,
    dateDebutGrade TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    dateFinGrade DATE,
    CONSTRAINT fk_Grade_User
    FOREIGN KEY (id_User) REFERENCES User(id_User),
     INDEX idx_Grade_id_User (id_User)
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
        FOREIGN KEY (id_User) REFERENCES User(id_User),
    INDEX idx_Niveau_Etude_id_User (id_User)
);


CREATE TABLE IF NOT EXISTS Mot_De_Passe(
    id_User BIGINT PRIMARY KEY NOT NULL,
    motDePasse VARCHAR(255) NOT NULL,
    dateCreation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    dateModification TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    dateExpiration DATE,
    CONSTRAINT fk_user_MotDePasse
        FOREIGN KEY (id_User) REFERENCES User(id_User),
    INDEX idx_Mot_De_Passe_id_User (id_User)
);

CREATE TABLE IF NOT EXISTS Coordonnee(
    id_User BIGINT PRIMARY KEY NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    telephone VARCHAR(15) NOT NULL UNIQUE,
    dateCreation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    dateModification TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
    CONSTRAINT fk_Coordonnee_User
        FOREIGN KEY (id_User) REFERENCES User(id_User),
    INDEX idx_Coordonnee_id_User (id_User)
);

CREATE TABLE IF NOT EXISTS Connexion(
    id_Connexion BIGINT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(100) NOT NULL ,
    nombreTentative INT,
    dateDerniereTentative TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    tempsBloquage TIMESTAMP 
);