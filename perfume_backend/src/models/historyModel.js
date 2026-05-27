const pool = require('../config/db');

const Kharash = {
  create: async (data) => {
    const { title, amount, note } = data;
    // Halkan waxaan isticmaalnay "expenses"
    const query = `
      INSERT INTO expenses (title, amount, note, created_at)
      VALUES ($1, $2, $3, NOW())
      RETURNING *;
    `;
    const values = [title, amount, note];
    const { rows } = await pool.query(query, values);
    return rows[0];
  },

  getAll: async () => {
    const query = 'SELECT * FROM expenses ORDER BY created_at DESC;';
    const { rows } = await pool.query(query);
    return rows;
  },

  delete: async (id) => {
    const query = 'DELETE FROM expenses WHERE id = $1 RETURNING *;';
    const { rows } = await pool.query(query, [id]);
    return rows[0];
  }
};

module.exports = Kharash;