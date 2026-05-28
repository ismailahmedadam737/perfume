const express = require('express');
const router = express.Router();
const customerController = require('../controllers/customerController');

// Waxaan isticmaalaynaa '/all' si ay ula jaanqaado API-yadaada kale
router.get('/all', customerController.getAllCustomers);

// Waxaan isticmaalaynaa '/add' si ay ula jaanqaado habka POST-ka ee kharashka
router.post('/add', customerController.createCustomer);

module.exports = router;