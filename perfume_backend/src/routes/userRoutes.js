const express = require('express');
const router = express.Router();
// Waxaan si toos ah u soo dhoofinaynaa controllers-ka
const userController = require('../controllers/userController');

// Halkan hubi in magacyadu ay yihiin kuwo sax ah
router.get('/', userController.getUsers);
router.post('/', userController.addUser);
router.delete('/:id', userController.deleteUser);
router.post('/login', userController.loginUser); // HUBI IN KANI JIRO

module.exports = router;