const Expense = require('../models/expenseModel');

exports.getExpenses = async (req, res) => {
    try {
        const expenses = await Expense.getAll();
        res.status(200).json(expenses);
    } catch (error) {
        res.status(500).json({ error: "Cillad ayaa dhacday: " + error.message });
    }
};

exports.addExpense = async (req, res) => {
    try {
        const { title, amount, note, date, is_paid } = req.body;

        if (!title || amount === undefined) {
            return res.status(400).json({ error: "Title iyo Amount waa qasab!" });
        }

        const newExpense = await Expense.create({
            title,
            amount: parseFloat(amount), // Hubi inuu yahay number
            note: note || 'No notes',
            date: date || new Date(),
            is_paid: is_paid !== undefined ? is_paid : true
        });

        res.status(201).json(newExpense);
    } catch (error) {
        res.status(500).json({ error: "Laguma guulaysan kaydinta: " + error.message });
    }
};

exports.updateExpense = async (req, res) => {
    try {
        const updated = await Expense.update(req.params.id, req.body);
        if (updated) {
            res.status(200).json(updated);
        } else {
            res.status(404).json({ error: "Kharashka lama helin" });
        }
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

exports.deleteExpense = async (req, res) => {
    try {
        const deleted = await Expense.delete(req.params.id);
        if (deleted) {
            res.status(200).json({ message: "Kharashka waa la tirtiray" });
        } else {
            res.status(404).json({ error: "Kharashka lama helin" });
        }
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};