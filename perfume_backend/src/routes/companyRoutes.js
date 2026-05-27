const express = require('express');
const router = express.Router();
const pool = require('../config/db'); // Hubi in path-kan uu saxan yahay

// POST: /api/companies
router.post('/', async (req, res) => {
    try {
        const { company_name, owner_name, phone, location } = req.body;
        
        const newCompany = await pool.query(
            "INSERT INTO companies (company_name, owner_name, phone, location) VALUES ($1, $2, $3, $4) RETURNING *",
            [company_name, owner_name, phone, location]
        );

        res.status(201).json({
            success: true,
            data: newCompany.rows[0]
        });
    } catch (err) {
        console.error(err.message);
        res.status(500).json({ success: false, message: "Server Error" });
    }
});

// GET: /api/companies
router.get('/', async (req, res) => {
    try {
        const companies = await pool.query("SELECT * FROM companies ORDER BY id DESC");
        res.json({ success: true, data: companies.rows });
    } catch (err) {
        res.status(500).json({ success: false, message: err.message });
    }
});

module.exports = router; // <--- TAN MA KU DARTAY?