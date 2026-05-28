const pool = require('../config/db');

const Customer = {
  getAll: async () => {
    const { rows } = await pool.query('SELECT * FROM customers ORDER BY id DESC');
    return rows;
  },
  create: async (data) => {
    const { name, phone, email, address, points } = data;
    const { rows } = await pool.query(
      'INSERT INTO customers (name, phone, email, address, points) VALUES ($1, $2, $3, $4, $5) RETURNING *',
      [name, phone, email, address, points]
    );
    return rows[0];
  }
};
module.exports = Customer;