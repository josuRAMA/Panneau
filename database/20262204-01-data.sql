-- PostgreSQL data insert script
-- Connect to the target database before running this script.
-- Example: psql -h localhost -U postgres -d PanneauSolaireDB -f 20262204-01-data.sql

INSERT INTO TrancheHeure (libelle, heure_debut, heure_fin)
VALUES
    ('maraina', '06:00:00', '17:00:00'),
    ('hariva', '17:00:00', '19:00:00'),
    ('alina', '19:00:00', '06:00:00');

INSERT INTO modelePanneau (nom)
VALUES ('Modele A'), ('Modele B');

INSERT INTO ConfigurationPanneauByTranche (id_tranche_heure, pourcentage_ensoleillement, modele_id)
VALUES
    (3, 50.0, 1),
    (3, 40.0, 2),
    (3, 0.0, 1);

INSERT INTO ConfigurationHeurePoint (modele_id, heure_debut, heure_fin, pourcentage_ouvrable, pourcentage_non_ouvrable)
VALUES
    (1, '12:00:00', '14:00:00', 50, 0),
    (1, '17:00:00', '19:00:00', 50, 40);

INSERT INTO ConfigurationPrixPanneau (modele_id, prix_jour_ouvrable, prix_jour_non_ouvrable)
VALUES
    (1, 190, 210);
