const pool = require('../config/db');

const getSuppliers = async () => {
  const res = await pool.query('SELECT * FROM suppliers ORDER BY id DESC');
  return res.rows;
};

const addSupplier = async (name, phone, email, address, balance) => {
  const res = await pool.query(
    'INSERT INTO suppliers (name, phone, email, address, balance) VALUES ($1, $2, $3, $4, $5) RETURNING *',
    [name, phone, email, address, balance]
  );
  return res.rows[0];
};

const updateSupplier = async (id, name, phone, email, address, balance) => {
  const res = await pool.query(
    'UPDATE suppliers SET name=$1, phone=$2, email=$3, address=$4, balance=$5 WHERE id=$6 RETURNING *',
    [name, phone, email, address, balance, id]
  );
  return res.rows[0];
};

const deleteSupplier = async (id) => {
  const res = await pool.query('DELETE FROM suppliers WHERE id=$1 RETURNING id', [id]);
  return res.rows[0];
};

module.exports = { getSuppliers, addSupplier, updateSupplier, deleteSupplier };