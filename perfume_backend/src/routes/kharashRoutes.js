const express = require('express');
const router = express.Router();
const kharashController = require('../controllers/kharashController');

// GET: Soo aqri dhamaan (http://localhost:5000/api/kharash/all)
router.get('/all', kharashController.getKharashyada);

// POST: Ku dar xog cusub (http://localhost:5000/api/kharash/add)
router.post('/add', kharashController.addKharash);

// DELETE: Tirtir xog gaar ah (http://localhost:5000/api/kharash/delete/:id)
router.delete('/delete/:id', kharashController.deleteKharash);

module.exports = router;