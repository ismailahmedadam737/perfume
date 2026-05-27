const express = require('express');
const router = express.Router();
const expenseController = require('../controllers/expenseController');

// Wadada: /api/expenses
router.get('/', expenseController.getExpenses);   // Soo aqrin
router.post('/', expenseController.addExpense);  // Kaydin

// Wadada: /api/expenses/:id
router.put('/:id', expenseController.updateExpense);    // Wax ka badal
router.delete('/:id', expenseController.deleteExpense); // Tirtir

module.exports = router;