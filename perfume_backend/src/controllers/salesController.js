const salesModel = require('../models/salesModel');

exports.addSale = async (req, res) => {
    try {
        const newSale = await salesModel.createSale(req.body);
        res.status(201).json({ success: true, data: newSale });
    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
};

exports.getSales = async (req, res) => {
    try {
        const sales = await salesModel.getAllSales();
        res.status(200).json(sales);
    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
};