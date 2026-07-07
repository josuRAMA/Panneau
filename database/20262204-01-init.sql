-- PostgreSQL initialization script
-- Connect to the target database before running this script.
-- Example: psql -h localhost -U postgres -d PanneauSolaireDB -f 20262204-01-init.sql

CREATE TABLE IF NOT EXISTS "modelePanneau" (
    id SERIAL PRIMARY KEY,
    nom VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS "TrancheHeure" (
    id SERIAL PRIMARY KEY,
    libelle VARCHAR(120) NOT NULL,
    heure_debut TIME NOT NULL,
    heure_fin TIME NOT NULL
);

CREATE TABLE IF NOT EXISTS "ConfigurationPanneauByTranche" (
    id SERIAL PRIMARY KEY,
    id_tranche_heure INTEGER NOT NULL REFERENCES "TrancheHeure"(id),
    pourcentage_ensoleillement REAL NOT NULL,
    modele_id INTEGER NOT NULL REFERENCES "modelePanneau"(id)
);

CREATE TABLE IF NOT EXISTS "ConfigurationPrixPanneau" (
    id SERIAL PRIMARY KEY,
    modele_id INTEGER NOT NULL REFERENCES "modelePanneau"(id),
    prix_jour_ouvrable INTEGER NOT NULL DEFAULT 0,
    prix_jour_non_ouvrable INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS "ConfigurationHeurePoint" (
    id SERIAL PRIMARY KEY,
    modele_id INTEGER NOT NULL REFERENCES "modelePanneau"(id),
    heure_debut TIME NOT NULL,
    heure_fin TIME NOT NULL,
    pourcentage_ouvrable INTEGER NOT NULL DEFAULT 0,
    pourcentage_non_ouvrable INTEGER NOT NULL DEFAULT 0
);
