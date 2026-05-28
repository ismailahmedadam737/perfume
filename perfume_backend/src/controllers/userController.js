const pool = require('../config/db');

// 1. LOGIN USER
const loginUser = async (req, res) => {
    try {
        const { email, password } = req.body;
        const query = 'SELECT * FROM users WHERE email = $1 AND password = $2';
        const result = await pool.query(query, [email, password]);

        if (result.rows.length > 0) {
            const user = result.rows[0];
            const { password, ...userWithoutPassword } = user;
            res.status(200).json({ success: true, user: userWithoutPassword });
        } else {
            res.status(401).json({ success: false, message: "Email ama Password khaldan" });
        }
    } catch (error) {
        res.status(500).json({ success: false, message: error.message });
    }
};

// 2. GET USERS
const getUsers = async (req, res) => {
    try {
        const result = await pool.query('SELECT id, name, email, role FROM users');
        res.status(200).json(result.rows);
    } catch (error) {
        res.status(500).json({ success: false, message: error.message });
    }
};

// 3. ADD USER
const addUser = async (req, res) => {
    try {
        const { name, email, password, role } = req.body;
        const query = 'INSERT INTO users (name, email, password, role) VALUES ($1, $2, $3, $4) RETURNING *';
        const values = [name, email, password, role || 'User'];
        const result = await pool.query(query, values);
        res.status(201).json({ success: true, user: result.rows[0] });
    } catch (error) {
        res.status(500).json({ success: false, message: error.message });
    }
};

// 4. DELETE USER
const deleteUser = async (req, res) => {
    try {
        const { id } = req.params;
        await pool.query('DELETE FROM users WHERE id = $1', [id]);
        res.status(200).json({ success: true, message: "User waa la tirtiray" });
    } catch (error) {
        res.status(500).json({ success: false, message: error.message });
    }
};

// MUHIIM: Halkan waa halka Node.js uu function-yada ka aqoonsanayo
module.exports = {
    loginUser,
    getUsers,
    addUser,
    deleteUser
};