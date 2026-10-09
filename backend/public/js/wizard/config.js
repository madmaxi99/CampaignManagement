export const ATTRIBUTE_ORDER = ['STA', 'KON', 'GEW', 'INT', 'WIL', 'CHA'];

export const ATTRIBUTE_LABELS = {
    STA: 'Stärke',
    KON: 'Konstitution',
    GEW: 'Gewandtheit',
    INT: 'Intelligenz',
    WIL: 'Willenskraft',
    CHA: 'Charisma',
};

export const GEAR_ROLL_LABELS = { A: '1-2', B: '3-4', C: '5-6' };

export const POOL_PICK_COUNT = 6;
export const MAGIC_PICK_COUNT = 3;
export const MAX_ATTRIBUTE = 18;

export const AGE_TABLE = {
    jung: { label: 'Jung', extra: 2, total: 8, modifiers: { GEW: 1, KON: 1 } },
    erwachsen: { label: 'Erwachsen', extra: 4, total: 10, modifiers: {} },
    alt: { label: 'Alt', extra: 6, total: 12, modifiers: { STA: -2, GEW: -2, KON: -2, INT: 1, WIL: 1 } },
};

export const STEP_TITLES = {
    1: 'Volk',
    2: 'Beruf',
    3: 'Name, Alter, Fertigkeiten & Ausrüstung',
    4: 'Weitere Fertigkeiten',
    5: 'Magie',
    6: 'Attribute',
    7: 'Schwäche',
    8: 'Memento',
    9: 'Aussehen',
};
