const express = require('express');
const router = express.Router();
const userController = require('../controllers/userController');

// Routes
router.get('/', userController.getUsers);
router.post('/', userController.addUser);
router.delete('/:id', userController.deleteUser);
router.post('/login', userController.loginUser); // Tani waa /login (haddii ay ku hoos jirto /api/users, waxay noqonaysaa /api/users/login)

module.exports = router;