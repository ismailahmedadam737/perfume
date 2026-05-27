const Employee = require('../models/employeeModel');

// --- GET ALL EMPLOYEES ---
exports.getEmployees = async (req, res) => {
    try {
        const employees = await Employee.getAll();
        res.status(200).json(employees);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

// --- CREATE NEW EMPLOYEE ---
exports.addEmployee = async (req, res) => {
    try {
        const newEmployee = await Employee.create(req.body);
        res.status(201).json(newEmployee);
    } catch (error) {
        res.status(500).json({ error: "Lama kaydin: " + error.message });
    }
};

// --- UPDATE EMPLOYEE (Cusub) ---
exports.updateEmployee = async (req, res) => {
    try {
        const updated = await Employee.update(req.params.id, req.body);
        if (updated) {
            res.status(200).json(updated);
        } else {
            res.status(404).json({ error: "Shaqaalaha lama helin" });
        }
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

// --- DELETE EMPLOYEE (Cusub) ---
exports.deleteEmployee = async (req, res) => {
    try {
        const deleted = await Employee.delete(req.params.id);
        if (deleted) {
            res.status(200).json({ message: "Shaqaalaha waa la tirtiray" });
        } else {
            res.status(404).json({ error: "Shaqaalaha lama helin" });
        }
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};