const pool = require('../config/db');

const salesModel = {
    createSale: async (data) => {
        // Waxaan ka saarnay employee_id haddii aan la soo dirin
        const { invoice_no, employee_id, product_name, discount, quantity, total_amount, payment_method, sale_date } = data;
        
        const query = `
            INSERT INTO sales (invoice_no, employee_id, product_name, discount, quantity, total_amount, payment_method, sale_date)
            VALUES ($1, $2, $3, $4, $5, $6, $7, $8) RETURNING *`;
            
        // Haddii employee_id uu maqan yahay, u dhig NULL
        const values = [
            invoice_no, 
            employee_id || null, 
            product_name, 
            discount || 0, 
            quantity, 
            total_amount, 
            payment_method || 'Cash', 
            sale_date || new Date()
        ];
        
        const res = await pool.query(query, values);
        return res.rows[0];
    },

    getAllSales: async () => {
        const res = await pool.query('SELECT * FROM sales ORDER BY sale_date DESC');
        return res.rows;
    }
};

module.exports = salesModel;