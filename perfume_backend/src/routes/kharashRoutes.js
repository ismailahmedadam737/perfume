const express = require('express');
const router = express.Router();
const kharashController = require('../controllers/kharashController');

// GET: Soo aqri dhamaan (URL: /api/kharash/all)
router.get('/all', kharashController.getKharashyada);

// POST: Ku dar xog cusub (URL: /api/kharash/add)
router.post('/add', kharashController.addKharash);

// DELETE: Tirtir xog gaar ah (URL: /api/kharash/delete/:id)
router.delete('/delete/:id', kharashController.deleteKharash);

module.exports = router;