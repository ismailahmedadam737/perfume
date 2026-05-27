const pool = require('../config/db');

exports.getGeneralReport = async (req, res) => {
    try {
        // 1. Dakhliga (Sales) - Hubi in table-kaagu yahay 'sales' tiirkuna yahay 'total_price'
        const salesRes = await pool.query('SELECT COALESCE(SUM(total_price), 0) as total_income FROM sales');
        const income = parseFloat(salesRes.rows[0].total_income);

        // 2. Kharashka (Kharash) - Hubi in table-kaagu yahay 'kharash' tiirkuna yahay 'amount'
        const expenseRes = await pool.query('SELECT COALESCE(SUM(amount), 0) as total_expense FROM kharash');
        const expense = parseFloat(expenseRes.rows[0].total_expense);

        // 3. Dhaqdhaqaaqyadii u dambeeyay
        const recentSales = await pool.query(`
            SELECT customer_name as title, total_price as amount, 'income' as type, created_at 
            FROM sales 
            ORDER BY created_at DESC LIMIT 5
        `);

        const profit = income - expense;

        res.status(200).json({
            success: true,
            stats: {
                totalIncome: income,
                totalExpense: expense,
                netProfit: profit,
                count: recentSales.rowCount
            },
            transactions: recentSales.rows
        });
    } catch (err) {
        console.error("REPORT ERROR:", err.message); // Kani wuxuu kuu soo qorayaa Terminal-ka waxa qaldan
        res.status(500).json({ 
            success: false, 
            error: "Database Query Error", 
            detail: err.message 
        });
    }
};

exports.addTransaction = async (req, res) => {
    res.status(201).json({ message: "Ready" });
};