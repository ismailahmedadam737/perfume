const express = require('express');
const router = express.Router();
const customerController = require('../controllers/customerController');

// Halkan waa meesha dad badani ka qaldamaan
// Haddii index.js uu yahay '/api/customers'
// Markaas route-kan hoose wuxuu noqonayaa '/api/customers/all'
router.get('/all', customerController.getAllCustomers); 
router.post('/add', customerController.createCustomer);

module.exports = router;