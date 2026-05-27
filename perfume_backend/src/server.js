require('dotenv').config();
const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const morgan = require('morgan');

const app = express();

// 1. MIDDLEWARES 
// Waxaan u habaynay CORS si uu u xalliyo ClientException-ka Chrome-ka
app.use(cors({
    origin: '*', // Waxay oggolaanaysaa dhammaan aaladaha (Flutter Web, Android, iwm)
    methods: ['GET', 'POST', 'PUT', 'DELETE'],
    allowedHeaders: ['Content-Type', 'Authorization']
}));

// Helmet waxay u baahan tahay in yar oo habayn ah haddii sawirrada (Base64) la soo bandhigayo
app.use(helmet({
    crossOriginResourcePolicy: false,
})); 

app.use(morgan('dev')); 
app.use(express.json({ limit: '50mb' })); 
app.use(express.urlencoded({ limit: '50mb', extended: true }));

// 2. DATABASE CONNECTION (Hubi in faylkan config/db.js uu sax yahay)
const pool = require('./config/db'); 

// 3. ROUTES IMPORTS
const userRoutes = require('./routes/userRoutes'); 
const supplierRoutes = require('./routes/supplierRoutes');
const customerRoutes = require('./routes/customerRoutes');
const employeeRoutes = require('./routes/employeeRoutes'); 
const settingRoutes = require('./routes/settingRoutes');
const productRoutes = require('./routes/productRoutes'); 
const salesRoutes = require('./routes/salesRoutes');
const historyRoutes = require('./routes/historyRoutes');
const companyRoutes = require('./routes/companyRoutes'); 
const purchaseRoutes = require('./routes/purchaseRoutes');
const kharashRoutes = require('./routes/kharashRoutes'); 
const salaryRoutes = require('./routes/salaryRoutes'); 
const transactionRoutes = require('./routes/transactionRoutes'); 
const dashboardRoutes = require('./routes/dashboardRoutes'); 

// 4. ROUTES USAGE
app.use('/api/users', userRoutes); 
app.use('/api/suppliers', supplierRoutes);
app.use('/api/customers', customerRoutes);
app.use('/api/employees', employeeRoutes); 
app.use('/api/settings', settingRoutes);
app.use('/api/products', productRoutes); 
app.use('/api/sales', salesRoutes);
app.use('/api/history', historyRoutes);
app.use('/api/companies', companyRoutes); 
app.use('/api/purchases', purchaseRoutes);
app.use('/api/kharash', kharashRoutes); 
app.use('/api/salaries', salaryRoutes); 
app.use('/api/general', transactionRoutes); 
app.use('/api/dashboard', dashboardRoutes); 

// 5. TEST ROUTE
app.get('/', (req, res) => {
  res.status(200).json({ 
    success: true, 
    message: '🚀 Perfume Backend is Running!',
    status: 'Healthy'
  });
});

// 6. ERROR HANDLING (404)
app.use((req, res, next) => {
  res.status(404).json({ 
    success: false, 
    message: "Route-kan lama helin!" 
  });
});

// 7. START SERVER
const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
  console.log(`✅ Server running on port ${PORT}`);
  console.log(`📡 Dashboard API: http://localhost:${PORT}/api/dashboard/stats`);
});