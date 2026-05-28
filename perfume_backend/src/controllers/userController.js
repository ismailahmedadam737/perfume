const pool = require('../config/db');

// 1. LOGIN USER - Si buuxda loo saxay
const loginUser = async (req, res) => {
    try {
        const { email, password } = req.body;
        
        // Query-ga si sax ah u soo saaraya role-ka
        const query = 'SELECT id, name, email, role FROM users WHERE email = $1 AND password = $2';
        const result = await pool.query(query, [email, password]);

        if (result.rows.length > 0) {
            let user = result.rows[0];
            
            // MUHIIM: Waxaan role-ka ka dhigeynaa xaraf yar (admin/user)
            user.role = user.role ? user.role.toLowerCase().trim() : 'user';
            
            // DEBUG: Halkan ka eeg Render Logs si aad u hubiso waxa ka soo baxaya DB-ka
            console.log(`LOGIN DEBUG: User ${user.email} logged in with role: ${user.role}`);
            
            res.status(200).json({ 
                success: true, 
                user: user 
            });
        } else {
            res.status(401).json({ success: false, message: "Email ama Password khaldan" });
        }
    } catch (error) {
        console.error("Login Error:", error);
        res.status(500).json({ success: false, message: error.message });
    }
};

// 2. GET USERS - Si loo soo saaro liiska isticmaalayaasha
const getUsers = async (req, res) => {
    try {
        const result = await pool.query('SELECT id, name, email, role FROM users');
        res.status(200).json(result.rows);
    } catch (error) {
        res.status(500).json({ success: false, message: error.message });
    }
};

// 3. ADD USER - Hubinta default role-ka markii la samaynayo
const addUser = async (req, res) => {
    try {
        const { name, email, password, role } = req.body;
        // Haddii role la waayo, waxaa lagu darayaa 'user'
        const userRole = role ? role.toLowerCase().trim() : 'user';
        
        const query = 'INSERT INTO users (name, email, password, role) VALUES ($1, $2, $3, $4) RETURNING *';
        const result = await pool.query(query, [name, email, password, userRole]);
        
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

module.exports = {
    loginUser,
    getUsers,
    addUser,
    deleteUser
};