const pool = require('../config/db');

// 1. Soo qaado xogta dukaanka
const getSettings = async () => {
    try {
        const res = await pool.query('SELECT * FROM shop_settings WHERE id = 1 LIMIT 1');
        return res.rows[0];
    } catch (err) {
        console.error("❌ SQL Error (getSettings):", err.message);
        throw err;
    }
};

// 2. Keydi ama Update garee xogta (UPSERT)
const saveSettings = async (shopName, currencyName, phone, webLink, social, logoData, isRegistered) => {
    try {
        const query = `
            INSERT INTO shop_settings (id, "shopName", "currencyName", phone, "webLink", social, "logoData", "isRegistered")
            VALUES (1, $1, $2, $3, $4, $5, $6, $7)
            ON CONFLICT (id) DO UPDATE SET
                "shopName" = EXCLUDED."shopName",
                "currencyName" = EXCLUDED."currencyName",
                phone = EXCLUDED.phone,
                "webLink" = EXCLUDED."webLink",
                social = EXCLUDED.social,
                "logoData" = EXCLUDED."logoData",
                "isRegistered" = EXCLUDED."isRegistered",
                "updatedAt" = CURRENT_TIMESTAMP
            RETURNING *;
        `;

        const values = [shopName, currencyName, phone, webLink, social, logoData, isRegistered];
        const res = await pool.query(query, values);
        return res.rows[0];
    } catch (err) {
        console.error("❌ SQL Error (saveSettings):", err.message);
        throw err;
    }
};

// MUHIIM: In loo dhoofiyo sidii Object
module.exports = { 
    getSettings, 
    saveSettings 
};