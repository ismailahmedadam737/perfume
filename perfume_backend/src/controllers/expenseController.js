const Expense = require('../models/expenseModel');

// --- 1. SOO AQRI KHARASHAADKA (GET) ---
exports.getExpenses = async (req, res) => {
    try {
        const expenses = await Expense.getAll();
        res.status(200).json(expenses);
    } catch (error) {
        res.status(500).json({ error: "Cillad ayaa dhacday: " + error.message });
    }
};

// --- 2. KEYDI KHARASH CUSUB (POST) ---
exports.addExpense = async (req, res) => {
    try {
        // Hubi in req.body ay leedahay title iyo amount (waa qasab DB-gaaga)
        const { title, amount, note, date, is_paid } = req.body;

        if (!title || !amount) {
            return res.status(400).json({ error: "Title iyo Amount waa qasab!" });
        }

        const newExpense = await Expense.create({
            title,
            amount,
            note: note || 'No notes',
            date: date || new Date(),
            is_paid: is_paid !== undefined ? is_paid : true
        });

        res.status(201).json(newExpense);
    } catch (error) {
        res.status(500).json({ error: "Laguma guulaysan kaydinta: " + error.message });
    }
};

// --- 3. CUSUBAYSIIN (PUT) ---
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

// --- 4. TIRTIRID (DELETE) ---
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