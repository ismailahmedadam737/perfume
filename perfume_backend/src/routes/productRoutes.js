const express = require('express');
const router = express.Router();
const productController = require('../controllers/productController');

// 1. Soo qaado dhamaan (GET)
router.get('/', productController.getProducts);

// 2. Ku dar mid cusub (POST)
router.post('/', productController.addProduct);

// 3. Wax ka beddel (PUT)
router.put('/:id', productController.updateProduct);

// 4. Tirtir (DELETE)
router.delete('/:id', productController.deleteProduct);

module.exports = router;