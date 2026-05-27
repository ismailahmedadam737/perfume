const pool = require('../config/db');

const Transaction = {
    // Inaad soo akhriso dhamaantood
    getAll: async () => {
        const res = await pool.query('SELECT * FROM general_transactions ORDER BY created_at DESC');
        return res.rows;
    },

    // Inaad mid cusub ku darto (Iib ama Kharash)
    create: async (title, amount, type) => {
        const res = await pool.query(
            'INSERT INTO general_transactions (title, amount, type) VALUES ($1, $2, $3) RETURNING *',
            [title, amount, type]
        );
        return res.rows[0];
    }
};

module.exports = Transaction;