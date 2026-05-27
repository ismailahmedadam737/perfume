const productModel = require('../models/productModel');

// 1. Soo saarista dhamaan alaabta
const getProducts = async (req, res) => {
    try {
        const products = await productModel.getAllProducts();
        res.status(200).json(products);
    } catch (error) {
        console.error("❌ Get Products Error:", error.message);
        res.status(500).json({ error: error.message });
    }
};

// 2. Ku darista alaab cusub
const addProduct = async (req, res) => {
    try {
        const newProduct = await productModel.createProduct(req.body);
        res.status(201).json(newProduct);
    } catch (error) {
        console.error("❌ Add Product Error:", error.message);
        res.status(500).json({ error: error.message });
    }
};

// 3. Cusubaysiinta alaabta (Update)
const updateProduct = async (req, res) => {
    const { id } = req.params;
    try {
        const updatedProduct = await productModel.updateProduct(id, req.body);
        if (!updatedProduct) {
            return res.status(404).json({ error: "Alaabtan lama helin" });
        }
        res.status(200).json(updatedProduct);
    } catch (error) {
        console.error("❌ Update Product Error:", error.message);
        res.status(500).json({ error: error.message });
    }
};

// 4. Tirtirista alaabta (Delete)
const deleteProduct = async (req, res) => {
    const { id } = req.params;
    try {
        const deleted = await productModel.deleteProduct(id);
        if (!deleted) {
            return res.status(404).json({ error: "Alaabtan lama helin" });
        }
        res.status(200).json({ message: "Alaabta waa la tirtiray" });
    } catch (error) {
        console.error("❌ Delete Product Error:", error.message);
        res.status(500).json({ error: error.message });
    }
};

module.exports = { 
    getProducts, 
    addProduct, 
    updateProduct, 
    deleteProduct 
};