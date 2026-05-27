const pool = require('../config/db');

const getTodaySales = async () => {
    try {
        const query = `
            SELECT 
                id, 
                product_name as name, 
                total_amount as price, 
                quantity as qty, 
                sale_date as time 
            FROM sales 
            WHERE sale_date::date = CURRENT_DATE
            ORDER BY id DESC`;
            
        const res = await pool.query(query);
        return res.rows;
    } catch (error) {
        console.error("SQL ERROR:", error.message); 
        throw new Error("Error fetching history: " + error.message);
    }
};

module.exports = { getTodaySales };