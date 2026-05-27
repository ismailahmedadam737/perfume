const express = require('express');
const router = express.Router();
const salesController = require('../controllers/salesController');

// Routes-ku waxay ka bilaabanayaan /api/sales (oo lagu qeexay app.js)
// POST: /api/sales
router.post('/', salesController.addSale);

// GET: /api/sales
router.get('/', salesController.getSales);

module.exports = router;