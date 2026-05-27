const userModel = require('../models/userModel');

exports.loginUser = async (req, res) => {
    try {
        const { email, password } = req.body;

        if (!email || !password) {
            return res.status(400).json({ success: false, message: "Fadlan geli email iyo password" });
        }
        
        const user = await userModel.getUserByEmailAndPassword(email, password);

        if (user) {
            const { password, ...userWithoutPassword } = user;
            res.status(200).json({ success: true, user: userWithoutPassword });
        } else {
            res.status(401).json({ success: false, message: "Email ama Password khaldan" });
        }
    } catch (error) {
        console.error("❌ Login Controller Error:", error.message);
        res.status(500).json({ success: false, message: "Cillad dhanka server-ka ah" });
    }
};