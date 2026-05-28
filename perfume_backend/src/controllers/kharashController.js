const Kharash = require('../models/kharashModel');

// 1. Inaad soo aqriso kharashyada
exports.getKharashyada = async (req, res) => {
  try {
    const data = await Kharash.getAll();
    res.status(200).json({ success: true, data });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// 2. Inaad keydiso kharash cusub
exports.addKharash = async (req, res) => {
  try {
    const { title, amount, note } = req.body;

    if (!title || !amount) {
      return res.status(400).json({ 
        success: false, 
        message: "Fadlan soo geli cinwaanka iyo lacagta!" 
      });
    }

    const newEntry = await Kharash.create({ title, amount, note });
    res.status(201).json({ success: true, data: newEntry });
  } catch (error) {
    res.status(500).json({ success: false, message: "Cilad ayaa dhacday: " + error.message });
  }
};

// 3. Tirtiridda
exports.deleteKharash = async (req, res) => {
  try {
    const { id } = req.params;
    const deleted = await Kharash.delete(id);

    if (deleted) {
      res.status(200).json({ 
        success: true, 
        message: "Kharashka si guul leh ayaa loo tirtiray." 
      });
    } else {
      res.status(404).json({ 
        success: false, 
        message: "Kharashka lama helin!" 
      });
    }
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};