const pool = require('../config/db'); 

// 1. Soo qaado dhamaan xogta
const getAllUsers = async () => {
    try {
        const res = await pool.query('SELECT id, name, email, role FROM users ORDER BY id DESC');
        return res.rows;
    } catch (error) {
        throw new Error("Error fetching users: " + error.message);
    }
};

// 2. Gali xog cusub
const createUser = async (userData) => {
    const { name, email, password, role } = userData;
    const query = 'INSERT INTO users (name, email, password, role) VALUES ($1, $2, $3, $4) RETURNING *';
    const values = [name, email, password, role || 'User'];
    
    try {
        const res = await pool.query(query, values);
        return res.rows[0];
    } catch (error) {
        throw new Error("Error creating user: " + error.message);
    }
};

// 3. Ka tirtir database-ka
const deleteUser = async (id) => {
    try {
        const res = await pool.query('DELETE FROM users WHERE id = $1 RETURNING *', [id]);
        return res.rowCount > 0;
    } catch (error) {
        throw new Error("Error deleting user: " + error.message);
    }
};

// --- 4. LOGIN LOGIC (KAN AYAA KA MAQNAA) ---
const getUserByEmailAndPassword = async (email, password) => {
    try {
        const query = 'SELECT id, name, email, role FROM users WHERE email = $1 AND password = $2';
        const values = [email, password];
        
        const res = await pool.query(query, values);
        return res.rows[0]; // Wuxuu soo celinayaa user-ka haddii la helay, haddii kale undefined
    } catch (error) {
        throw new Error("Error in login query: " + error.message);
    }
};

// MUHIIM: Ku dar getUserByEmailAndPassword liiskan hoose
module.exports = { 
    getAllUsers, 
    createUser, 
    deleteUser, 
    getUserByEmailAndPassword 
};