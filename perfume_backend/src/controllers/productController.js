const productModel = require('../models/productModel');

const getProducts = async (req, res) => {
    try {
        const products = await productModel.getAllProducts();
        res.status(200).json(products);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

const addProduct = async (req, res) => {
    try {
        const newProduct = await productModel.createProduct(req.body);
        res.status(201).json(newProduct);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

const updateProduct = async (req, res) => {
    const { id } = req.params;
    try {
        const updatedProduct = await productModel.updateProduct(id, req.body);
        if (!updatedProduct) {
            return res.status(404).json({ error: "Alaabtan lama helin" });
        }
        res.status(200).json(updatedProduct);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

const deleteProduct = async (req, res) => {
    const { id } = req.params;
    try {
        const deleted = await productModel.deleteProduct(id);
        if (!deleted) {
            return res.status(404).json({ error: "Alaabtan lama helin" });
        }
        res.status(200).json({ message: "Alaabta waa la tirtiray" });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

module.exports = { getProducts, addProduct, updateProduct, deleteProduct };