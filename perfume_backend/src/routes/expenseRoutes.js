const express = require('express');
const router = express.Router();
const expenseController = require('../controllers/expenseController');

// Wadada: /api/kharash (Hubi inaad index.js ugu magac dartay sidan)
router.get('/', expenseController.getExpenses);
router.post('/', expenseController.addExpense);
router.put('/:id', expenseController.updateExpense);
router.delete('/:id', expenseController.deleteExpense);

module.exports = router;