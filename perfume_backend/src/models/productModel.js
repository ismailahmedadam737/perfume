const pool = require('../config/db');

// 1. Soo qaado dhamaan alaabta
const getAllProducts = async () => {
    try {
        const res = await pool.query('SELECT * FROM products ORDER BY id DESC');
        return res.rows;
    } catch (error) {
        throw new Error("Cilad baa ku dhacday soo aqrinta: " + error.message);
    }
};

// 2. Keydi alaab cusub
const createProduct = async (productData) => {
    const { name, brand, costPrice, sellPrice, quantity, gender, image } = productData;

    const query = `
        INSERT INTO products (name, brand, "costPrice", "sellPrice", quantity, gender, image)
        VALUES ($1, $2, $3, $4, $5, $6, $7) 
        RETURNING *
    `;

    const values = [
        name, 
        brand, 
        parseFloat(costPrice) || 0, 
        parseFloat(sellPrice) || 0, 
        parseInt(quantity) || 0,    
        gender, 
        image                  
    ];

    try {
        const res = await pool.query(query, values);
        return res.rows[0];
    } catch (error) {
        throw new Error("Cilad keydinta database-ka: " + error.message);
    }
};

// 3. Wax ka beddel alaab jira (Update)
const updateProduct = async (id, productData) => {
    const { name, brand, costPrice, sellPrice, quantity, gender, image } = productData;

    let query;
    let values;

    if (image) {
        query = `
            UPDATE products 
            SET name = $1, brand = $2, "costPrice" = $3, "sellPrice" = $4, quantity = $5, gender = $6, image = $7
            WHERE id = $8 
            RETURNING *
        `;
        values = [name, brand, parseFloat(costPrice), parseFloat(sellPrice), parseInt(quantity), gender, image, id];
    } else {
        query = `
            UPDATE products 
            SET name = $1, brand = $2, "costPrice" = $3, "sellPrice" = $4, quantity = $5, gender = $6
            WHERE id = $7 
            RETURNING *
        `;
        values = [name, brand, parseFloat(costPrice), parseFloat(sellPrice), parseInt(quantity), gender, id];
    }

    try {
        const res = await pool.query(query, values);
        return res.rows[0];
    } catch (error) {
        throw new Error("Cilad wax ka beddelka (Update): " + error.message);
    }
};

// 4. Tirtir alaab (Delete)
const deleteProduct = async (id) => {
    try {
        const res = await pool.query('DELETE FROM products WHERE id = $1 RETURNING *', [id]);
        return res.rowCount > 0;
    } catch (error) {
        throw new Error("Cilad tirtirista (Delete): " + error.message);
    }
};

module.exports = { 
    getAllProducts, 
    createProduct, 
    updateProduct, 
    deleteProduct 
};