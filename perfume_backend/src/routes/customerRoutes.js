const express = require('express');
const router = express.Router();
const customerController = require('../controllers/customerController');

// Waxaan isticmaalayaa '/all' iyo '/add' si ay ula jaanqaadaan koodhkaaga kale
router.get('/all', customerController.getAllCustomers);
router.post('/add', customerController.createCustomer);

module.exports = router;