const pool = require('../config/db');

const getUserByEmailAndPassword = async (email, password) => {
    try {
        // Waxaan hubinaynaa in query-ga uu yahay mid sax ah
        const query = 'SELECT id, name, email, role, password FROM users WHERE email = $1';
        const res = await pool.query(query, [email]);
        
        // Debugging: Hubi inuu database-ku soo celinayo natiijo
        console.log("Database response count:", res.rows.length);

        if (res.rows.length === 0) {
            return null; // User lama helin
        }
        
        const user = res.rows[0];
        
        // Hubinta password-ka
        if (user.password === password) {
            return user;
        }
        
        console.log("Password-ku wuu qaldan yahay.");
        return null; // Password-ku wuu qaldan yahay
    } catch (error) {
        console.error("Database query failed:", error.message);
        throw new Error("Database query failed: " + error.message);
    }
};

module.exports = { 
    getUserByEmailAndPassword 
};