const express = require('express');
const router = express.Router();
const employeeController = require('../controllers/employeeController');

// 1. Soo saarista dhamaan shaqaalaha
router.get('/', employeeController.getEmployees);

// 2. Galinta shaqaale cusub
router.post('/', employeeController.addEmployee);

// 3. Cusubaysiinta xogta (Edit)
router.put('/:id', employeeController.updateEmployee);

// 4. Tirtirista shaqaalaha (Delete)
router.delete('/:id', employeeController.deleteEmployee);

module.exports = router;