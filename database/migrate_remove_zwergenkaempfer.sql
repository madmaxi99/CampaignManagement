SET NAMES utf8mb4;

-- "Zwergenkämpfer" war nie ein eigener Beruf im Regelwerk -- der Name war nur
-- ein RP-Beiname für Urd Bitterkinns Kämpfer-Charakter (siehe
-- docs/superpowers/specs/2026-09-27-character-creation-wizard-design.md,
-- Abschnitt "Wichtige Korrektur zu Zwergenkämpfer"). seed_character_creation_
-- catalog.sql und seed_pregens.sql wurden entsprechend korrigiert; dieses
-- Skript zieht dieselbe Korrektur auf einer bereits laufenden/befüllten
-- MariaDB-Instanz nach (docker-entrypoint-initdb.d läuft nur beim allerersten
-- Start des mariadb_data-Volumes, siehe provisioning/docker-compose.yml).
--
-- Einmalig manuell ausführen, z. B.:
--   docker compose exec -T mariadb mysql -u"$DB_USER" -p"$DB_PASSWORD" "$DB_NAME" < database/migrate_remove_zwergenkaempfer.sql

-- Bestehende Charaktere (z. B. der Pregen Urd Bitterkinn) auf den echten
-- Beruf ummappen, bevor die Profession selbst gelöscht wird.
UPDATE characters SET profession_code = 'kaempfer' WHERE profession_code = 'zwergenkaempfer';

DELETE FROM catalog_profession_gear_option_items
WHERE gear_option_id IN (
    SELECT id FROM (
        SELECT id FROM catalog_profession_gear_options WHERE profession_code = 'zwergenkaempfer'
    ) AS doomed
);
DELETE FROM catalog_profession_gear_options WHERE profession_code = 'zwergenkaempfer';
DELETE FROM catalog_profession_heroic_abilities WHERE profession_code = 'zwergenkaempfer';
DELETE FROM catalog_profession_key_skills WHERE profession_code = 'zwergenkaempfer';
DELETE FROM catalog_professions WHERE code = 'zwergenkaempfer';
