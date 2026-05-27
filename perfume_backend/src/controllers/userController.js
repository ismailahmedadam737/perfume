const userModel = require('../models/userModel');

// 1. Soo qaado dhamaan users
exports.getUsers = async (req, res) => {
    try {
        const users = await userModel.getAllUsers();
        res.status(200).json(users);
    } catch (error) {
        console.error("❌ Controller Get Error:", error.message);
        res.status(500).json({ success: false, message: error.message });
    }
};

// 2. Ku dar user cusub
exports.addUser = async (req, res) => {
    try {
        const newUser = await userModel.createUser(req.body);
        res.status(201).json(newUser);
    } catch (error) {
        console.error("❌ Controller Add Error:", error.message);
        res.status(500).json({ success: false, message: error.message });
    }
};

// 3. Tirtir user
exports.deleteUser = async (req, res) => {
    try {
        const { id } = req.params;
        const deleted = await userModel.deleteUser(id);
        if (deleted) {
            res.status(200).json({ success: true, message: "User deleted successfully" });
        } else {
            res.status(404).json({ success: false, message: "User not found" });
        }
    } catch (error) {
        console.error("❌ Controller Delete Error:", error.message);
        res.status(500).json({ success: false, message: error.message });
    }
};

// --- 4. LOGIN USER (Kani waa kan kuu dhimanaa) ---
exports.loginUser = async (req, res) => {
    try {
        const { email, password } = req.body;

        // Waxaan raadinaynaa user-ka isagoo isticmaalaya model-ka
        const user = await userModel.getUserByEmailAndPassword(email, password);

        if (user) {
            // Haddii la helay qofka
            res.status(200).json(user);
        } else {
            // Haddii email ama password khaldan yahay
            res.status(401).json({ success: false, message: "Email ama Password khaldan" });
        }
    } catch (error) {
        console.error("❌ Controller Login Error:", error.message);
        res.status(500).json({ success: false, message: error.message });
    }
};