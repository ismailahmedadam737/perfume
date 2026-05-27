const Supplier = require('../models/supplierModel');

const getAllSuppliers = async (req, res) => {
  try {
    const suppliers = await Supplier.getSuppliers();
    res.status(200).json(suppliers);
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
};

const createSupplier = async (req, res) => {
  try {
    const { name, phone, email, address, balance } = req.body;
    if (!name || !phone) return res.status(400).json({ error: "Name and Phone are required" });
    
    const newSupplier = await Supplier.addSupplier(name, phone, email, address, balance || 0);
    res.status(201).json(newSupplier);
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
};

const updateSupplier = async (req, res) => {
  try {
    const { id } = req.params;
    const { name, phone, email, address, balance } = req.body;
    const updated = await Supplier.updateSupplier(id, name, phone, email, address, balance);
    if (!updated) return res.status(404).json({ error: "Supplier not found" });
    res.status(200).json(updated);
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
};

const deleteSupplier = async (req, res) => {
  try {
    const deleted = await Supplier.deleteSupplier(req.params.id);
    if (!deleted) return res.status(404).json({ error: "Supplier not found" });
    res.status(200).json({ message: 'Supplier deleted successfully' });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
};

module.exports = { getAllSuppliers, createSupplier, updateSupplier, deleteSupplier };