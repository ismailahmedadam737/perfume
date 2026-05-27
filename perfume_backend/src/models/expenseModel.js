const pool = require('../config/db');

const Expense = {
    // 1. Soo saarista dhamaan kharashyada (Read)
    getAll: async () => {
        const result = await pool.query('SELECT * FROM expenses ORDER BY id DESC');
        return result.rows;
    },

    // 2. Galinta kharash cusub (Create)
    create: async (expenseData) => {
        const { title, amount, note, date, is_paid } = expenseData;
        const result = await pool.query(
            'INSERT INTO expenses (title, amount, note, date, is_paid) VALUES ($1, $2, $3, $4, $5) RETURNING *',
            [title, amount, note, date, is_paid]
        );
        return result.rows[0];
    },

    // 3. Cusubaysiinta xogta kharashka (Update)
    update: async (id, expenseData) => {
        const { title, amount, note, date, is_paid } = expenseData;
        const result = await pool.query(
            'UPDATE expenses SET title=$1, amount=$2, note=$3, date=$4, is_paid=$5 WHERE id=$6 RETURNING *',
            [title, amount, note, date, is_paid, id]
        );
        return result.rows[0];
    },

    // 4. Tirtirista kharashka (Delete)
    delete: async (id) => {
        const result = await pool.query('DELETE FROM expenses WHERE id = $1', [id]);
        return result.rowCount > 0;
    }
};

module.exports = Expense;