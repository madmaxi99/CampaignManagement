const ATTRIBUTES = ['STA', 'KON', 'GEW', 'INT', 'WIL', 'CHA'];

const skills = Array.from({ length: 24 }, (_, index) => ({
    id: index + 1,
    name_de: `Fertigkeit ${index + 1}`,
    attribute_code: ATTRIBUTES[index % 6],
    category: index % 5 === 0 ? 'combat' : 'regular',
    description_de: `Beschreibung ${index + 1}`,
}));

const gearOption = {
    gearOptionId: 11,
    label: 'A',
    silverDice: 'W6',
    extra_de: null,
    items: [{ name: 'Schwert', quantity: 1 }],
};

/** A small but complete creation catalog: a fighter, a mage, one kin that fits both. */
export const catalog = {
    kins: [
        {
            code: 'human',
            name_de: 'Mensch',
            d12_min: 1,
            d12_max: 6,
            abilities: [{ name_de: 'Anpassungsfähig', wp_note_de: null, description_de: 'Vielseitig.' }],
        },
    ],
    professions: [
        {
            code: 'fighter',
            name_de: 'Kämpfer',
            kin_restriction: null,
            grants_magic: 0,
            key_attribute_code: 'STA',
            skillPool: skills.slice(0, 8),
            heroicAbilities: [{ id: 5, name_de: 'Wuchtschlag', description_de: 'Fest zuschlagen.' }],
            gearOptions: [gearOption],
        },
        {
            code: 'mage',
            name_de: 'Magier',
            kin_restriction: null,
            grants_magic: 1,
            key_attribute_code: 'INT',
            skillPool: skills.slice(8, 15),
            heroicAbilities: [],
            gearOptions: [{ ...gearOption, gearOptionId: 21, silverDice: null }],
        },
    ],
    skills,
    magic: {
        schools: [
            { id: 1, skill_id: null, name_de: 'Allgemein', description_de: 'Für alle.', attribute_code: 'INT' },
            { id: 2, skill_id: 30, name_de: 'Elementarismus', description_de: 'Feuer.', attribute_code: 'INT' },
        ],
        spells: [
            ...[1, 2, 3, 4].map((id) => ({ id, school_id: 2, type: 'trick', name_de: `Trick ${id}`, effect_de: 'x' })),
            ...[11, 12, 13, 14].map((id) => ({
                id,
                school_id: 2,
                type: 'spell',
                name_de: `Zauber ${id}`,
                effect_de: 'x',
            })),
        ],
    },
    flaws: [
        { roll_min: 1, name_de: 'Feige', description_de: 'Ängstlich.' },
        { roll_min: 2, name_de: 'Gierig', description_de: 'Will mehr.' },
    ],
    mementos: [{ description_de: 'Ein Kiesel' }],
    appearances: [{ description_de: 'Narbig' }],
};
