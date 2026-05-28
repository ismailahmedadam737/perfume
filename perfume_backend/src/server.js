require('dotenv').config();
const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const morgan = require('morgan');
const pool = require('./config/db');

const app = express();

// --- LOGS: Middlwares ---
console.log("🛠 Starting Middlewares...");
app.use(cors({ origin: '*', methods: ['GET', 'POST', 'PUT', 'DELETE'] }));
app.use(helmet({ crossOriginResourcePolicy: false }));
app.use(morgan('dev'));
app.use(express.json({ limit: '50mb' }));
app.use(express.urlencoded({ limit: '50mb', extended: true }));

// --- LOGS: Database Connection ---
console.log("🔌 Attempting to connect to Database...");
pool.query('SELECT NOW()', (err, res) => {
    if (err) {
        console.error('❌ CRITICAL: Database connection failed:', err.message);
    } else {
        console.log('✅ SUCCESS: Database connected at:', res.rows[0].now);
    }
});

// --- ROUTES ---
const customerRoutes = require('./routes/customerRoutes');
// (Isku xirka routes-kaaga kale halkan ku dhaaf)
app.use('/api/customers', (req, res, next) => {
    console.log(`📡 API Request to: ${req.originalUrl}`);
    next();
}, customerRoutes);

// --- LOGS: Test Table existence (Cilad raadinta) ---
const checkTables = async () => {
    try {
        const result = await pool.query(`SELECT table_name FROM information_schema.tables WHERE table_schema = 'public'`);
        console.log("📋 Current Tables in Database:", result.rows.map(r => r.table_name));
    } catch (e) {
        console.error("❌ Error checking tables:", e.message);
    }
};
checkTables();

// --- TEST ROUTE ---
app.get('/', (req, res) => {
    res.status(200).json({ success: true, message: 'Server is running!' });
});

// --- GLOBAL ERROR HANDLER ---
app.use((err, req, res, next) => {
    console.error("🚨 GLOBAL ERROR CAUGHT:", err.message);
    res.status(500).json({ success: false, message: "Server Error: " + err.message });
});

// --- START SERVER ---
const PORT = process.env.PORT || 5000;
app.listen(PORT, '0.0.0.0', () => {
    console.log(`✅ Server is running on port ${PORT}`);
});