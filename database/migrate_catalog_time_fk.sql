SET NAMES utf8mb4;

-- Sixth pass: normalize catalog_spells.casting_time_de / duration_de (free
-- text) into proper FK-backed lookups, per explicit user request ("richtige
-- FK... z.B. time_units und rest_types"). The book itself enumerates these as
-- fixed categorical lists (5 durations, 4 casting times -- see Chapter 5,
-- "Casting Time"/"Duration"), so free text was never the right model; 3 of
-- each category are themselves one of the 3 catalog_time_units.
--
-- Also fixes a second occurrence of the "Stretch" mistranslated as "Stunde"
-- (Hour) bug (first one, Frost, was fixed in migrate_catalog_rules_reference.sql):
-- "Langer Schritt" (Longstrider) is Duration: Stretch per the rulebook, not
-- Duration: Hour, which isn't a valid Dragonbane spell duration at all.

CREATE TABLE catalog_spell_durations (
    code VARCHAR(20) PRIMARY KEY,
    name_de VARCHAR(50) NOT NULL,
    time_unit_code VARCHAR(20) NULL,
    description_de TEXT NOT NULL,
    FOREIGN KEY (time_unit_code) REFERENCES catalog_time_units(code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE catalog_casting_times (
    code VARCHAR(20) PRIMARY KEY,
    name_de VARCHAR(50) NOT NULL,
    time_unit_code VARCHAR(20) NULL,
    description_de TEXT NOT NULL,
    FOREIGN KEY (time_unit_code) REFERENCES catalog_time_units(code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO catalog_spell_durations (code, name_de, time_unit_code, description_de) VALUES
    ('sofort', 'Sofort', NULL, 'Der Effekt tritt sofort ein und hält nicht an.'),
    ('runde', 'Runde', 'runde', 'Der Effekt hält an, bis du in der nächsten Runde am Zug bist.'),
    ('viertel', 'Viertel', 'viertel', 'Der Effekt hält für ein Viertel an.'),
    ('tagesabschnitt', 'Tagesabschnitt', 'tagesabschnitt', 'Der Effekt hält bis zum Ende des aktuellen Tagesabschnitts an.'),
    ('konzentration', 'Konzentration', NULL, 'Der Effekt endet, wenn du eine andere Handlung durchführst, Schaden erleidest oder eine WIL-Probe gegen eine plötzliche Störung (z. B. ein Geräusch) nicht schaffst, um die Konzentration aufrechtzuerhalten (keine Aktion).');

INSERT INTO catalog_casting_times (code, name_de, time_unit_code, description_de) VALUES
    ('aktion', 'Aktion', NULL, 'Das Wirken des Zaubers zählt im Kampf als Aktion, sofern nicht anders angegeben.'),
    ('reaktion', 'Reaktion', NULL, 'Der Zauber wird außerhalb deines eigenen Zuges gewirkt, wie beim Parieren oder Ausweichen.'),
    ('viertel', 'Viertel', 'viertel', 'Das Wirken erfordert ein Viertel Vorbereitung (Ritual).'),
    ('tagesabschnitt', 'Tagesabschnitt', 'tagesabschnitt', 'Das Wirken erfordert einen ganzen Tagesabschnitt Vorbereitung (Ritual).');

ALTER TABLE catalog_spells
    ADD COLUMN casting_time_code VARCHAR(20) NULL AFTER components_de,
    ADD COLUMN duration_code VARCHAR(20) NULL AFTER range_de;

UPDATE catalog_spells SET casting_time_code = CASE casting_time_de
    WHEN 'Aktion' THEN 'aktion'
    WHEN 'Viertel' THEN 'viertel'
    ELSE NULL
END;

UPDATE catalog_spells SET duration_code = CASE duration_de
    WHEN 'Sofort' THEN 'sofort'
    WHEN 'Tagesabschnitt' THEN 'tagesabschnitt'
    WHEN 'Viertel' THEN 'viertel'
    WHEN 'Konzentration' THEN 'konzentration'
    WHEN 'Stunde' THEN 'viertel' -- bug fix: "Stunde" isn't a valid duration; the source is Duration: Stretch
    ELSE NULL
END;

-- Verification: every row that HAD a casting_time_de/duration_de value must
-- now have a matching code (i.e. the CASE mapping above was exhaustive).
SELECT 'unmapped casting_time' AS check_name, COUNT(*) AS bad_count
FROM catalog_spells WHERE casting_time_de IS NOT NULL AND casting_time_code IS NULL;

SELECT 'unmapped duration' AS check_name, COUNT(*) AS bad_count
FROM catalog_spells WHERE duration_de IS NOT NULL AND duration_code IS NULL;

-- Only proceed past this point once both counts above are 0.

ALTER TABLE catalog_spells
    DROP COLUMN casting_time_de,
    DROP COLUMN duration_de,
    ADD FOREIGN KEY (casting_time_code) REFERENCES catalog_casting_times(code),
    ADD FOREIGN KEY (duration_code) REFERENCES catalog_spell_durations(code);
