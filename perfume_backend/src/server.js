require('dotenv').config();
const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const morgan = require('morgan');

const app = express();

// 1. MIDDLEWARES - CORS halkan u daa sidatan
app.use(cors({
    origin: '*', 
    methods: ['GET', 'POST', 'PUT', 'DELETE'],
    allowedHeaders: ['Content-Type', 'Authorization']
}));

app.use(helmet({ crossOriginResourcePolicy: false })); 
app.use(morgan('dev')); 
app.use(express.json({ limit: '50mb' })); 
app.use(express.urlencoded({ limit: '50mb', extended: true }));

// 2. DATABASE (Halkan waa meeshii hore)
const pool = require('./config/db'); 

// 3. ROUTES (Halkan waa meeshii hore)
// ... (Routes-kaaga oo dhan halkan ayay ku jiraan) ...

// 4. START SERVER - Tani waa qaybta Render looga baahan yahay
const PORT = process.env.PORT || 5000;
app.listen(PORT, '0.0.0.0', () => { // '0.0.0.0' ayaa lagama maarmaan u ah Render
  console.log(`✅ Server is running on port ${PORT}`);
});