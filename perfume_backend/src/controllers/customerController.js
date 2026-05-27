const Customer = require('../models/customerModel');

const getAllCustomers = async (req, res) => {
    try {
        const customers = await Customer.getCustomers();
        res.status(200).json(customers);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
};

const createCustomer = async (req, res) => {
    try {
        const { name, phone, email, address, points } = req.body;
        const newCustomer = await Customer.addCustomer(name, phone, email, address, points);
        res.status(201).json(newCustomer);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
};

module.exports = { getAllCustomers, createCustomer };