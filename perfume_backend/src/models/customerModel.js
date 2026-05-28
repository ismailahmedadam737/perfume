const pool = require('../config/db');

const Customer = {
    // Soo saarista dhamaan macaamiisha
    getAll: async () => {
        try {
            const res = await pool.query('SELECT * FROM customers ORDER BY id DESC');
            return res.rows;
        } catch (err) {
            console.error("❌ SQL Error (getAllCustomers):", err.message);
            throw err;
        }
    },

    // Diiwaangelinta macmiil cusub
    create: async (customerData) => {
        try {
            // Halkan ayaanu ka qaadanaynaa xogta (destructuring)
            const { name, phone, email, address, points } = customerData;
            
            // Hubi in points uu yahay number, haddii kale 0 ha noqdo
            const finalPoints = parseInt(points) || 0;

            const query = `
                INSERT INTO customers (name, phone, email, address, points) 
                VALUES ($1, $2, $3, $4, $5) 
                RETURNING *
            `;
            
            const values = [name, phone, email, address, finalPoints];
            const res = await pool.query(query, values);
            return res.rows[0];
        } catch (err) {
            console.error("❌ SQL Error (addCustomer):", err.message);
            throw err;
        }
    }
};

module.exports = Customer;