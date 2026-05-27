const pool = require('../config/db');

const Employee = {
    // Soo saarista xogta oo dhan
    getAll: async () => {
        const result = await pool.query('SELECT * FROM employees ORDER BY id DESC');
        return result.rows;
    },

    // Keydinta shaqaale cusub
    create: async (employeeData) => {
        const { name, position, phone, district } = employeeData;
        const result = await pool.query(
            'INSERT INTO employees (name, position, phone, district) VALUES ($1, $2, $3, $4) RETURNING *',
            [name, position, phone, district]
        );
        return result.rows[0];
    },

    // Wax ka bedelka xogta (Update)
    update: async (id, employeeData) => {
        const { name, position, phone, district } = employeeData;
        const result = await pool.query(
            'UPDATE employees SET name=$1, position=$2, phone=$3, district=$4 WHERE id=$5 RETURNING *',
            [name, position, phone, district, id]
        );
        return result.rows[0];
    },

    // Tirtirista shaqaalaha
    delete: async (id) => {
        const result = await pool.query('DELETE FROM employees WHERE id = $1', [id]);
        return result.rowCount > 0;
    }
};

module.exports = Employee;