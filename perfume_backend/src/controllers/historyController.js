const historyModel = require('../models/historyModel');

exports.getHistory = async (req, res) => {
    try {
        const history = await historyModel.getTodaySales();
        res.status(200).json(history);
    } catch (error) {
        console.error("❌ History Controller Error:", error.message);
        res.status(500).json({ 
            success: false, 
            message: error.message // Waxay kuu soo diraysaa qaladka dhabta ah
        });
    }
};