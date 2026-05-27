const userModel = require('../models/userModel');

// Function-ka Login-ka
const loginUser = async (req, res) => {
    try {
        const { email, password } = req.body;

        if (!email || !password) {
            return res.status(400).json({ success: false, message: "Fadlan geli email iyo password" });
        }
        
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
        
        // Qaybtan ayaa kuu sheegaysa haddii SQL uu fashilmo
        res.status(500).json({ 
            success: false, 
            message: "Cillad dhanka server-ka ah",
            errorDetails: error.message 
        });
    }
};

const getUsers = async (req, res) => {
    try {
        res.status(200).json({ success: true, message: "Waa liiska user-ada" });
    } catch (error) {
        res.status(500).json({ success: false, message: error.message });
    }
};

const addUser = async (req, res) => {
    res.status(201).json({ success: true, message: "User waa la daray" });
};

const deleteUser = async (req, res) => {
    res.status(200).json({ success: true, message: "User waa la tirtiray" });
};

module.exports = {
    loginUser,
    getUsers,
    addUser,
    deleteUser
};