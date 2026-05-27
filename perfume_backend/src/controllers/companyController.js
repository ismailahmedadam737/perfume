const Company = require('../models/companyModel');

const getCompanies = async (req, res) => {
    try {
        const companies = await Company.getAll();
        res.status(200).json({ success: true, data: companies });
    } catch (err) {
        res.status(500).json({ success: false, error: err.message });
    }
};

const createCompany = async (req, res) => {
    try {
        const newCompany = await Company.create(req.body);
        res.status(201).json({ success: true, data: newCompany });
    } catch (err) {
        res.status(500).json({ success: false, error: err.message });
    }
};

const updateCompany = async (req, res) => {
    try {
        const updated = await Company.update(req.params.id, req.body);
        if (!updated) return res.status(404).json({ success: false, message: "Lama helin" });
        res.status(200).json({ success: true, data: updated });
    } catch (err) {
        res.status(500).json({ success: false, error: err.message });
    }
};

const deleteCompany = async (req, res) => {
    try {
        const deleted = await Company.delete(req.params.id);
        if (!deleted) return res.status(404).json({ success: false, message: "Lama helin" });
        res.status(200).json({ success: true, message: "Waa la tirtiray" });
    } catch (err) {
        res.status(500).json({ success: false, error: err.message });
    }
};

module.exports = { getCompanies, createCompany, updateCompany, deleteCompany };