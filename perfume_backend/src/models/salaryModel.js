const pool = require('../config/db');

const Salary = {
    getAllAuto: async () => {
        const result = await pool.query(`
            SELECT 
                e.id, 
                e.name, 
                e.position AS role, 
                COALESCE(s.amount, 0) AS amount, 
                COALESCE(s.status, 'Pending') AS status,
                COALESCE(s.payment_method, 'None') AS payment_method,
                COALESCE(s.bonus, 0) AS bonus,
                COALESCE(s.deduction, 0) AS deduction,
                COALESCE(TO_CHAR(s.payment_date, 'YYYY-MM-DD'), '') AS payment_date
            FROM employees e
            LEFT JOIN salary s ON e.id = s.id 
            ORDER BY e.id DESC
        `);
        return result.rows;
    },

    updateOrInsert: async (employeeId, data) => {
        const { amount, status, payment_method, bonus, deduction, payment_date } = data;
        
        const check = await pool.query('SELECT id FROM salary WHERE id = $1', [employeeId]);

        if (check.rowCount > 0) {
            const res = await pool.query(
                `UPDATE salary 
                 SET amount = $1, status = $2, payment_method = $3, bonus = $4, deduction = $5, payment_date = $6
                 WHERE id = $7 RETURNING *`,
                [amount, status, payment_method, bonus, deduction, payment_date, employeeId]
            );
            return res.rows[0];
        } else {
            const emp = await pool.query('SELECT name, position FROM employees WHERE id = $1', [employeeId]);
            const { name, position } = emp.rows[0];

            const res = await pool.query(
                `INSERT INTO salary (id, name, role, amount, status, payment_method, bonus, deduction, payment_date) 
                 VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9) RETURNING *`,
                [employeeId, name, position, amount, status, payment_method, bonus, deduction, payment_date]
            );
            return res.rows[0];
        }
    }
};

module.exports = Salary;