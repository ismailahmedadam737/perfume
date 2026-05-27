const express = require('express');
const router = express.Router();
const kharashController = require('../controllers/kharashController');

router.get('/', kharashController.getKharashyada); // Waxaa fiican inuu noqdo / halkii uu ka ahaan lahaa /all
router.post('/', kharashController.addKharash);    // Waxaa fiican inuu noqdo / halkii uu ka ahaan lahaa /add
router.delete('/:id', kharashController.deleteKharash);

module.exports = router;