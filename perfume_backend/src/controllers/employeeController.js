const pool = require('../config/db');

// 1. Soo saarista dhamaan shaqaalaha
const getEmployees = async (req, res) => {
    try {
        const result = await pool.query('SELECT * FROM employees ORDER BY id ASC');
        res.status(200).json(result.rows);
    } catch (error) {
        res.status(500).json({ success: false, message: error.message });
    }
};

// 2. Galinta shaqaale cusub
const addEmployee = async (req, res) => {
    const { name, email, phone, position, salary_amount } = req.body;
    try {
        const query = `INSERT INTO employees (name, email, phone, position, salary_amount) 
                       VALUES ($1, $2, $3, $4, $5) RETURNING *`;
        const result = await pool.query(query, [name, email, phone, position, salary_amount]);
        res.status(201).json({ success: true, employee: result.rows[0] });
    } catch (error) {
        res.status(500).json({ success: false, message: error.message });
    }
};

// 3. Cusubaysiinta xogta
const updateEmployee = async (req, res) => {
    const { id } = req.params;
    const { name, email, phone, position, salary_amount } = req.body;
    try {
        const query = `UPDATE employees SET name=$1, email=$2, phone=$3, position=$4, salary_amount=$5 
                       WHERE id=$6 RETURNING *`;
        const result = await pool.query(query, [name, email, phone, position, salary_amount, id]);
        res.status(200).json({ success: true, employee: result.rows[0] });
    } catch (error) {
        res.status(500).json({ success: false, message: error.message });
    }
};

// 4. Tirtirista shaqaalaha
const deleteEmployee = async (req, res) => {
    const { id } = req.params;
    try {
        await pool.query('DELETE FROM employees WHERE id=$1', [id]);
        res.status(200).json({ success: true, message: "Shaqaalihii waa la tirtiray" });
    } catch (error) {
        res.status(500).json({ success: false, message: error.message });
    }
};

module.exports = { getEmployees, addEmployee, updateEmployee, deleteEmployee };