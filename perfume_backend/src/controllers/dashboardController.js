const DashboardModel = require('../models/dashboardModel');

const getDashboardStats = async (req, res) => {
    try {
        const counts = await DashboardModel.getCounts();
        
        res.status(200).json({
            success: true,
            data: {
                products: parseInt(counts.total_products) || 0,
                employees: parseInt(counts.total_employees) || 0,
                customers: parseInt(counts.total_customers) || 0,
                settings: parseInt(counts.total_settings) || 0
            }
        });
    } catch (error) {
        console.log("Dashboard Controller Error:", error.message);
        res.status(500).json({
            success: false,
            message: "Server Error",
            error: error.message 
        });
    }
};

module.exports = { getDashboardStats };