const express = require('express');
const router = express.Router();
const pool = require('../config/db');

// POST: /api/purchases
router.post('/', async (req, res) => {
    try {
        const { 
            company_name, // Flutter waxay soo diraysaa magaca
            product_name, 
            invoice_no, 
            qty, 
            total_price, 
            department, 
            discount 
        } = req.body;

        // 1. Marka hore soo saar ID-ga shirkadda adoo isticmaalaya magaca
        const companyRes = await pool.query(
            "SELECT id FROM companies WHERE company_name = $1 LIMIT 1",
            [company_name]
        );

        if (companyRes.rows.length === 0) {
            return res.status(400).json({ success: false, message: "Shirkaddan lama helin!" });
        }

        const company_id = companyRes.rows[0].id;

        // 2. Hadda geli xogta Purchases adoo isticmaalaya company_id
        const result = await pool.query(
            `INSERT INTO purchases 
            (company_id, product_name, invoice_no, qty, total_price, department, discount, purchase_date) 
            VALUES ($1, $2, $3, $4, $5, $6, $7, NOW()) RETURNING *`,
            [company_id, product_name, invoice_no, qty, total_price, department, discount]
        );

        res.status(201).json({ success: true, data: result.rows[0] });
    } catch (err) {
        console.error("❌ DATABASE ERROR:", err.message);
        res.status(500).json({ success: false, error: err.message });
    }
});

// GET: /api/purchases
router.get('/', async (req, res) => {
    try {
        // Query-gan wuxuu soo saarayaa xogta isagoo magaca shirkadda ka keenaya miiska kale (JOIN)
        const result = await pool.query(`
            SELECT p.*, c.company_name 
            FROM purchases p 
            JOIN companies c ON p.company_id = c.id 
            ORDER BY p.id DESC
        `);
        res.status(200).json({ success: true, data: result.rows });
    } catch (err) {
        res.status(500).json({ success: false, error: err.message });
    }
});

module.exports = router;