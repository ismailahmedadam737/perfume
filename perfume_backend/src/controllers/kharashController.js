const Kharash = require('../models/kharashModel');

const getKharashyada = async (req, res) => {
  try {
    const data = await Kharash.getAll();
    res.status(200).json(data); // Soo celi array-ga xogta
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

const addKharash = async (req, res) => {
  try {
    const { title, amount, note } = req.body;
    if (!title || !amount) {
      return res.status(400).json({ success: false, message: "Fadlan soo geli cinwaanka iyo lacagta!" });
    }
    const newEntry = await Kharash.create({ title, amount, note });
    res.status(201).json(newEntry);
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

const deleteKharash = async (req, res) => {
  try {
    const { id } = req.params;
    const deleted = await Kharash.delete(id);
    if (!deleted) {
      return res.status(404).json({ success: false, message: "Kharashka lama helin!" });
    }
    res.status(200).json({ success: true, message: "Kharashka si guul leh ayaa loo tirtiray." });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

module.exports = { getKharashyada, addKharash, deleteKharash };