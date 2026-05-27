const pool = require('../config/db');

const Company = {
    // 1. Soo saarista dhamaan shirkadaha
    getAll: async () => {
        const result = await pool.query('SELECT * FROM companies ORDER BY id DESC');
        return result.rows;
    },

    // 2. Galinta shirkad cusub
    create: async (companyData) => {
        const { company_name, owner_name, phone, location } = companyData;
        const result = await pool.query(
            'INSERT INTO companies (company_name, owner_name, phone, location) VALUES ($1, $2, $3, $4) RETURNING *',
            [company_name, owner_name, phone, location]
        );
        return result.rows[0];
    },

    // 3. Cusubaysiinta
    update: async (id, companyData) => {
        const { company_name, owner_name, phone, location } = companyData;
        const result = await pool.query(
            'UPDATE companies SET company_name=$1, owner_name=$2, phone=$3, location=$4 WHERE id=$5 RETURNING *',
            [company_name, owner_name, phone, location, id]
        );
        return result.rows[0];
    },

    // 4. Tirtirista
    delete: async (id) => {
        const result = await pool.query('DELETE FROM companies WHERE id = $1', [id]);
        return result.rowCount > 0;
    }
};

module.exports = Company;