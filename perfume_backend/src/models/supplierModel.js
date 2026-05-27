const pool = require('../config/db');

// --- GET ALL SUPPLIERS ---
const getSuppliers = async () => {
  try {
    const res = await pool.query(
      'SELECT * FROM suppliers ORDER BY id DESC'
    );
    return res.rows; // Waxaan soo celinaynaa safafka xogta kaliya
  } catch (err) {
    throw err;
  }
};

// --- ADD SUPPLIER ---
const addSupplier = async (name, phone, email, address, balance) => {
  try {
    const res = await pool.query(
      `INSERT INTO suppliers (name, phone, email, address, balance)
       VALUES ($1, $2, $3, $4, $5) RETURNING *`,
      [name, phone, email, address, balance]
    );
    return res.rows[0]; // Waxaan soo celinaynaa supplier-ka cusub ee la abuuray
  } catch (err) {
    throw err;
  }
};

// --- UPDATE SUPPLIER ---
const updateSupplier = async (id, name, phone, email, address, balance) => {
  try {
    const res = await pool.query(
      `UPDATE suppliers 
       SET name=$1, phone=$2, email=$3, address=$4, balance=$5
       WHERE id=$6 RETURNING *`,
      [name, phone, email, address, balance, id]
    );
    return res.rows[0]; // Soo celi xogta la cusubaysay
  } catch (err) {
    throw err;
  }
};

// --- DELETE SUPPLIER ---
const deleteSupplier = async (id) => {
  try {
    const res = await pool.query(
      'DELETE FROM suppliers WHERE id=$1 RETURNING id',
      [id]
    );
    return res.rows[0]; // Waxay muujinaysaa in si guul leh loo tirtiray
  } catch (err) {
    throw err;
  }
};

module.exports = {
  getSuppliers,
  addSupplier,
  updateSupplier,
  deleteSupplier
};