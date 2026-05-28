const express = require('express');
const router = express.Router();
const userController = require('../controllers/userController');

// Waxaan halkan ku xaqiijineynaa in function kasta oo la wacayo uu jiro
router.get('/', userController.getUsers);
router.post('/', userController.addUser);
router.delete('/:id', userController.deleteUser);
router.post('/login', userController.loginUser);

module.exports = router;