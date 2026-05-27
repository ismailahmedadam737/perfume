const express = require('express');
const router = express.Router();

const controller = require('../controllers/supplierController');

// CRUD Routes
router.get('/', controller.getAllSuppliers);
router.post('/', controller.createSupplier);
router.put('/:id', controller.updateSupplier);
router.delete('/:id', controller.deleteSupplier);

module.exports = router;