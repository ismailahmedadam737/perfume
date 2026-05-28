const pool = require('../config/db'); // Hubi inuu pool-ku ka imanayo db.js

// ... koodhka kale ee kor ku jira ...

const addUser = async (req, res) => {
    try {
        const { name, email, password, role } = req.body;
        
        // SQL query sax ah si loo geliyo xogta
        const query = 'INSERT INTO users (name, email, password, role) VALUES ($1, $2, $3, $4) RETURNING *';
        const values = [name, email, password, role || 'User']; // Halkan ayuu ka qaadanayaa 'Admin' ama 'User'

        const result = await pool.query(query, values);
        
        res.status(201).json({ success: true, user: result.rows[0] });
    } catch (error) {
        console.error("❌ Add User Error:", error.message);
        res.status(500).json({ success: false, message: error.message });
    }
};

const getUsers = async (req, res) => {
    try {
        const result = await pool.query('SELECT id, name, email, role FROM users');
        res.status(200).json(result.rows);
    } catch (error) {
        res.status(500).json({ success: false, message: error.message });
    }
};

const deleteUser = async (req, res) => {
    try {
        const { id } = req.params;
        await pool.query('DELETE FROM users WHERE id = $1', [id]);
        res.status(200).json({ success: true, message: "User waa la tirtiray" });
    } catch (error) {
        res.status(500).json({ success: false, message: error.message });
    }
};