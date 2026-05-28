require('dotenv').config();
const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const morgan = require('morgan');
const pool = require('./config/db'); // Import-ka pool-ka

const app = express();

// 1. MIDDLEWARES
app.use(cors({ origin: '*', methods: ['GET', 'POST', 'PUT', 'DELETE'], allowedHeaders: ['Content-Type', 'Authorization'] }));
app.use(helmet({ crossOriginResourcePolicy: false })); 
app.use(morgan('dev')); 
app.use(express.json({ limit: '50mb' })); 
app.use(express.urlencoded({ limit: '50mb', extended: true }));

// 2. DATABASE CONNECTION CHECK
pool.connect()
  .then(() => console.log('✅ Database connection is healthy.'))
  .catch(err => console.error('❌ Database connection error:', err.stack));

// 3. ROUTES
const userRoutes = require('./routes/userRoutes'); 
const customerRoutes = require('./routes/customerRoutes');
const kharashRoutes = require('./routes/kharashRoutes'); 
// ... (Isku xirka routes-kaaga kale sidii hore)

app.use('/api/users', userRoutes); 
app.use('/api/customers', customerRoutes); // Halkan waa kan cusub
app.use('/api/kharash', kharashRoutes); 

// 4. TEST ROUTE
app.get('/', (req, res) => {
  res.status(200).json({ success: true, message: '🚀 Perfume Backend is Running!' });
});

// 5. 404 & GLOBAL ERROR HANDLER
app.use((req, res) => res.status(404).json({ success: false, message: "Route-kan lama helin!" }));

app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({ success: false, message: "Server Error: " + err.message });
});

// 6. START SERVER
const PORT = process.env.PORT || 5000;
const server = app.listen(PORT, '0.0.0.0', () => console.log(`✅ Server is running on port ${PORT}`));

// Hubi in pool-ka la xiro marka server-ku istaago
process.on('SIGINT', () => {
    pool.end();
    server.close();
});