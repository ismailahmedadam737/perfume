const pool = require('../config/db');

const getUserByEmailAndPassword = async (email, password) => {
    try {
        // Waxaan hubinaynaa in columns-ka ay sax yihiin
        const query = 'SELECT id, name, email, role, password FROM users WHERE email = $1';
        const res = await pool.query(query, [email]);
        
        if (res.rows.length === 0) {
            return null; // User lama helin
        }
        
        const user = res.rows[0];
        
        // Hubinta password-ka (Haddii aad isticmaasho hashing mustaqbalka, halkan ayaad ku beddeli)
        if (user.password === password) {
            return user;
        }
        
        return null; // Password-ku wuu qaldan yahay
    } catch (error) {
        throw new Error("Database query failed: " + error.message);
    }
};

module.exports = { getUserByEmailAndPassword /* iyo function-yada kale */ };