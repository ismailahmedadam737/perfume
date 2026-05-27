const pool = require('../config/db');

const Purchase = {
    // 1. Soo saarista dhamaan iibka
    getAll: async () => {
        const result = await pool.query('SELECT * FROM purchases ORDER BY id DESC');
        return result.rows;
    },

    // 2. Galinta iib cusub
    create: async (purchaseData) => {
        const { company_name, product_name, invoice_no, qty, total_price, department, discount } = purchaseData;
        const result = await pool.query(
            'INSERT INTO purchases (company_name, product_name, invoice_no, qty, total_price, department, discount) VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING *',
            [company_name, product_name, invoice_no, qty, total_price, department, discount]
        );
        return result.rows[0];
    },

    // 3. Cusubaysiinta iibka
    update: async (id, purchaseData) => {
        const { company_name, product_name, invoice_no, qty, total_price, department, discount } = purchaseData;
        const result = await pool.query(
            'UPDATE purchases SET company_name=$1, product_name=$2, invoice_no=$3, qty=$4, total_price=$5, department=$6, discount=$7 WHERE id=$8 RETURNING *',
            [company_name, product_name, invoice_no, qty, total_price, department, discount, id]
        );
        return result.rows[0];
    },

    // 4. Tirtirista iibka
    delete: async (id) => {
        const result = await pool.query('DELETE FROM purchases WHERE id = $1', [id]);
        return result.rowCount > 0;
    }
};

module.exports = Purchase;