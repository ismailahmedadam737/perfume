const pool = require('../config/db');

const DashboardModel = {
    getCounts: async () => {
        try {
            // Waxaan ku darnay "public." hortooda
            const query = `
                SELECT 
                    (SELECT COUNT(*) FROM public.products) AS total_products,
                    (SELECT COUNT(*) FROM public.employees) AS total_employees,
                    (SELECT COUNT(*) FROM public.customers) AS total_customers,
                    (SELECT COUNT(*) FROM public.shop_settings) AS total_settings
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