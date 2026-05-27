const express = require('express');
const router = express.Router();

// KU DAR { } MAREEYAHA (Destructuring)
const { getGeneralReport, addTransaction } = require('../controllers/transactionController');

// Hubi in magacyadani ay la mid yihiin kuwa Controller-ka ku jira
router.get('/report', getGeneralReport);

// LINE 9 (Halkan ayuu error-ku ka imaanayay haddii addTransaction ay undefined tahay)
router.post('/add', addTransaction); 

module.exports = router;