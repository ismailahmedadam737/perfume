const express = require('express');
const router = express.Router();
const userController = require('../controllers/userController');

router.get('/', userController.getUsers);
router.post('/', userController.addUser);
router.delete('/:id', userController.deleteUser);
router.post('/login', userController.loginUser); // Kan hubi inuu jiro

module.exports = router;