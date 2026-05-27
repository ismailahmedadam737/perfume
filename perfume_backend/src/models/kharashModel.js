const pool = require('../config/db');

const Kharash = {
  // Inaad xog cusub ku darto
  create: async (data) => {
    const { title, amount, note } = data;
    const query = `
      INSERT INTO expenses (title, amount, note, date, is_paid)
      VALUES ($1, $2, $3, NOW(), true)
      RETURNING *;
    `;
    const values = [title, amount, note];
    const { rows } = await pool.query(query, values);
    return rows[0];
  },

  // Inaad soo aqriso dhamaan xogta
  getAll: async () => {
    const query = 'SELECT * FROM expenses ORDER BY date DESC;';
    const { rows } = await pool.query(query);
    return rows;
  },

  // --- QAYBTA CUSUB: TIRTIRISTA ---
  delete: async (id) => {
    const query = 'DELETE FROM expenses WHERE id = $1 RETURNING *;';
    const { rows } = await pool.query(query, [id]);
    return rows[0]; // Waxay soo celinaysaa xogtii la tirtiray si loo xaqiijiyo
  }
};

module.exports = Kharash;