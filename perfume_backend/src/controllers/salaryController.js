const Salary = require('../models/salaryModel');

exports.getSalaries = async (req, res) => {
    try {
        const data = await Salary.getAllAuto();
        res.status(200).json({ success: true, data: data });
    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
};

exports.paySalary = async (req, res) => {
    try {
        // Xogta ka imaanaysa Flutter: { amount, status, payment_method, bonus, deduction, payment_date }
        const data = await Salary.updateOrInsert(req.params.id, req.body);
        res.status(200).json({
            success: true,
            message: "Mushaharka si guul leh ayaa loo diwaangeliyay",
            data: data
        });
    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
};