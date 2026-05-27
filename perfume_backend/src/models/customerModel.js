const pool = require('../config/db');

const Customer = {
    // Soo saarista macaamiisha
    getCustomers: async () => {
        const result = await pool.query('SELECT * FROM customers ORDER BY id DESC');
        return result.rows;
    },

    // Diiwaangelinta macmiil cusub
    addCustomer: async (name, phone, email, address, points) => {
        const query = `
            INSERT INTO customers (name, phone, email, address, points) 
            VALUES ($1, $2, $3, $4, $5) 
            RETURNING *
        `;
        const values = [name, phone, email, address, points];
        const result = await pool.query(query, values);
        return result.rows[0];
    }
};

module.exports = Customer;