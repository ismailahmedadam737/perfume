const pool = require('../config/db');

const productModel = {
    getAllProducts: async () => {
        const res = await pool.query('SELECT * FROM products ORDER BY id DESC');
        return res.rows;
    },

    createProduct: async (data) => {
        const { name, brand, costPrice, sellPrice, quantity, gender, image } = data;
        const query = `INSERT INTO products (name, brand, costPrice, sellPrice, quantity, gender, image) 
                       VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING *`;
        const res = await pool.query(query, [name, brand, costPrice, sellPrice, quantity, gender, image]);
        return res.rows[0];
    },

    updateProduct: async (id, data) => {
        const { name, brand, costPrice, sellPrice, quantity, gender, image } = data;
        const query = `UPDATE products SET name=$1, brand=$2, costPrice=$3, sellPrice=$4, 
                       quantity=$5, gender=$6, image=$7 WHERE id=$8 RETURNING *`;
        const res = await pool.query(query, [name, brand, costPrice, sellPrice, quantity, gender, image, id]);
        return res.rows[0];
    },

    deleteProduct: async (id) => {
        const res = await pool.query('DELETE FROM products WHERE id = $1', [id]);
        return res.rowCount > 0;
    }
};

module.exports = productModel;