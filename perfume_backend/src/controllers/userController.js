const userModel = require('../models/userModel');

exports.loginUser = async (req, res) => {
    try {
        const { email, password } = req.body;
        
        // Wacista Model-ka
        const user = await userModel.getUserByEmailAndPassword(email, password);

        if (user) {
            // Ka saar password-ka ka hor inta aadan u celin Flutter
            const { password, ...userWithoutPassword } = user;
            res.status(200).json({ success: true, user: userWithoutPassword });
        } else {
            res.status(401).json({ success: false, message: "Email ama Password khaldan" });
        }
    } catch (error) {
        console.error("❌ Login Controller Error:", error.message);
        res.status(500).json({ success: false, message: error.message });
    }
};
// ... (Waa in aad haysataa function-yadii kale ee getUsers, addUser, deleteUser)