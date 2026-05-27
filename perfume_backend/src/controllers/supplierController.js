const Supplier = require('../models/supplierModel');

// GET ALL SUPPLIERS
const getAllSuppliers = async (req, res) => {
  try {
    const suppliers = await Supplier.getSuppliers();
    // Maadaama model-ku hadda soo celinayo res.rows, halkan si toos ah u isticmaal
    res.status(200).json(suppliers);
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
};

// CREATE SUPPLIER
const createSupplier = async (req, res) => {
  try {
    const { name, phone, email, address, balance } = req.body;

    // Hubi in xogta daruuriga ah ay timid
    if (!name || !phone) {
      return res.status(400).json({ error: "Name and Phone are required" });
    }

    const newSupplier = await Supplier.addSupplier(
      name,
      phone,
      email,
      address,
      balance || 0
    );

    res.status(201).json(newSupplier);
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
};

// UPDATE SUPPLIER
const updateSupplier = async (req, res) => {
  try {
    const { id } = req.params;
    const { name, phone, email, address, balance } = req.body;

    const updatedSupplier = await Supplier.updateSupplier(
      id,
      name,
      phone,
      email,
      address,
      balance
    );

    if (!updatedSupplier) {
      return res.status(404).json({ error: "Supplier not found" });
    }

    res.status(200).json(updatedSupplier);
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
};

// DELETE SUPPLIER
const deleteSupplier = async (req, res) => {
  try {
    const { id } = req.params;

    const deleted = await Supplier.deleteSupplier(id);

    if (!deleted) {
      return res.status(404).json({ error: "Supplier not found" });
    }

    res.status(200).json({ message: 'Supplier deleted successfully' });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
};

module.exports = {
  getAllSuppliers,
  createSupplier,
  updateSupplier,
  deleteSupplier
};