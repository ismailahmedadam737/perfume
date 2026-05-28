const Customer = require('../models/customerModel');

// 1. Soo saarista dhamaan macaamiisha
exports.getAllCustomers = async (req, res) => {
    try {
        const customers = await Customer.getAll(); // Halkan isticmaal magaca cusub ee model-ka (getAll)
        
        // Waxaan ku darnay "success: true" iyo "data" si uu Flutter u aqriyo
        res.status(200).json({ 
            success: true, 
            data: customers 
        });
    } catch (err) {
        res.status(500).json({ 
            success: false, 
            message: err.message 
        });
    }
};

// 2. Abuurista macmiil cusub
exports.createCustomer = async (req, res) => {
    try {
        // Waxaan u gudbinaynaa req.body oo dhan Model-ka
        const newCustomer = await Customer.create(req.body); 
        
        res.status(201).json({ 
            success: true, 
            data: newCustomer 
        });
    } catch (err) {
        res.status(500).json({ 
            success: false, 
            message: err.message 
        });
    }
};