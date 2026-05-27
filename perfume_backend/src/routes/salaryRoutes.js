const express = require('express');
const router = express.Router();
const salaryController = require('../controllers/salaryController');

// GET: /api/salaries
router.get('/', salaryController.getSalaries);

// PUT: /api/salaries/pay/:id
router.put('/pay/:id', salaryController.paySalary);

module.exports = router;