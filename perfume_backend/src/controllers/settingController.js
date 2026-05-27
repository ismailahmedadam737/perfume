const { getSettings, saveSettings } = require('../models/settingModels');

// 1. GET Settings
exports.getSettings = async (req, res) => {
    try {
        const settings = await getSettings();
        
        res.status(200).json({
            success: true,
            data: settings || null
        });
    } catch (error) {
        console.error("❌ Controller Error (GET):", error.message);
        res.status(500).json({ 
            success: false, 
            message: "Cillad ayaa dhacday soo qaadista xogta", 
            error: error.message 
        });
    }
};

// 2. POST/UPDATE Settings
exports.updateSettings = async (req, res) => {
    try {
        const { shopName, currencyName, phone, webLink, social, logoData, isRegistered } = req.body;
        
        // Wacitaanka function-ka model-ka
        const settings = await saveSettings(
            shopName, 
            currencyName, 
            phone, 
            webLink, 
            social, 
            logoData, 
            isRegistered
        );

        res.status(200).json({
            success: true,
            message: "Xogta si guul leh ayaa loo keydiyey",
            data: settings
        });
    } catch (error) {
        console.error("❌ Controller Error (POST):", error.message);
        res.status(500).json({ 
            success: false, 
            message: "Ma la keydin waayey xogta", 
            error: error.message 
        });
    }
};