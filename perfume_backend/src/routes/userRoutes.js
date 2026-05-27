const express = require('express');
const router = express.Router();
const userController = require('../controllers/userController');

// Routes-ka hadda jira
router.get('/', userController.getUsers); 
router.post('/', userController.addUser);
router.delete('/:id', userController.deleteUser); 

// --- KU DAR REERKAN HOOSE ---
router.post('/login', userController.loginUser); 

module.exports = router;