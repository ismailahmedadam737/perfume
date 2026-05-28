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
        // Waxaan ka saarnay calaamadaha (") waxaana isticmaalnay magacyo yaryar oo dhan.
        // HADDII database-kaaga uu ku jiro "shop_name", "currency_name" iwm, 
        // fadlan magacyada hoose u beddel kuwa database-kaaga.
        const query = `
            INSERT INTO shop_settings (id, shopname, currencyname, phone, weblink, social, logodata, isregistered)
            VALUES (1, $1, $2, $3, $4, $5, $6, $7)
            ON CONFLICT (id) DO UPDATE SET
                shopname = EXCLUDED.shopname,
                currencyname = EXCLUDED.currencyname,
                phone = EXCLUDED.phone,
                weblink = EXCLUDED.weblink,
                social = EXCLUDED.social,
                logodata = EXCLUDED.logodata,
                isregistered = EXCLUDED.isregistered,
                updatedat = CURRENT_TIMESTAMP
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

module.exports = { 
    getSettings, 
    saveSettings 
};