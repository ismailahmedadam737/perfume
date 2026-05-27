const pool = require('../config/db');

const DashboardModel = {
    getCounts: async () => {
        try {
            const query = `
                SELECT 
                    (SELECT COUNT(*) FROM products) AS total_products,
                    (SELECT COUNT(*) FROM employees) AS total_employees,
                    (SELECT COUNT(*) FROM customers) AS total_customers,
                    (SELECT COUNT(*) FROM shop_settings) AS total_settings
            `;
            const result = await pool.query(query);
            return result.rows[0];
        } catch (error) {
            console.error("Database Query Error:", error.message);
            throw error;
        }
    }
};

module.exports = DashboardModel;