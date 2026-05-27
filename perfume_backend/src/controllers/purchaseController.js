const Purchase = require('../models/purchaseModel');

const getAllPurchases = async (req, res) => {
    try {
        const purchases = await Purchase.getAll();
        res.status(200).json({ success: true, data: purchases });
    } catch (err) {
        res.status(500).json({ success: false, error: err.message });
    }
};

const createPurchase = async (req, res) => {
    try {
        const newPurchase = await Purchase.create(req.body);
        res.status(201).json({ success: true, data: newPurchase });
    } catch (err) {
        res.status(500).json({ success: false, error: err.message });
    }
};

const updatePurchase = async (req, res) => {
    try {
        const updated = await Purchase.update(req.params.id, req.body);
        if (!updated) return res.status(404).json({ success: false, message: "Lama helin" });
        res.status(200).json({ success: true, data: updated });
    } catch (err) {
        res.status(500).json({ success: false, error: err.message });
    }
};

const deletePurchase = async (req, res) => {
    try {
        const deleted = await Purchase.delete(req.params.id);
        if (!deleted) return res.status(404).json({ success: false, message: "Lama helin" });
        res.status(200).json({ success: true, message: "Waa la tirtiray" });
    } catch (err) {
        res.status(500).json({ success: false, error: err.message });
    }
};

module.exports = { getAllPurchases, createPurchase, updatePurchase, deletePurchase };