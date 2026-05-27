const express = require('express');
const router = express.Router();
const settingController = require('../controllers/settingController');

// 1. Soo qaado xogta dukaanka: GET /api/settings
// Marka Flutter-ka uu soo codsado xogta bilowga ah
router.get('/', settingController.getSettings);

// 2. Keydi ama Cusboonaysii xogta: POST /api/settings
// Marka la riixo button-ka "Keydi Xogta"
router.post('/', settingController.updateSettings);

module.exports = router;