const { getSettings, saveSettings } = require('../models/settingModels');

exports.getSettings = async (req, res) => {
    try {
        const settings = await getSettings();
        res.status(200).json({ success: true, data: settings || null });
    } catch (error) {
        res.status(500).json({ success: false, message: "Cillad ayaa dhacday", error: error.message });
    }
};

exports.updateSettings = async (req, res) => {
    try {
        const { shopName, currencyName, phone, webLink, social, logoData, isRegistered } = req.body;
        
        const settings = await saveSettings(
            shopName, currencyName, phone, webLink, social, logoData, isRegistered
        );

        res.status(200).json({
            success: true,
            message: "Xogta si guul leh ayaa loo keydiyey",
            data: settings
        });
    } catch (error) {
        res.status(500).json({ success: false, message: "Ma la keydin waayey xogta", error: error.message });
    }
};