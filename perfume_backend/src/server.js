require('dotenv').config();
const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const morgan = require('morgan');

// Database connection
const pool = require('./config/db');

const app = express();

// 1. MIDDLEWARES 
app.use(cors({
    origin: '*', 
    methods: ['GET', 'POST', 'PUT', 'DELETE'],
    allowedHeaders: ['Content-Type', 'Authorization']
}));

app.use(helmet({
    crossOriginResourcePolicy: false,
})); 

app.use(morgan('dev')); 
app.use(express.json({ limit: '50mb' })); 
app.use(express.urlencoded({ limit: '50mb', extended: true }));

// 2. ROUTES IMPORTS
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

// 3. ROUTES USAGE
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

// 4. TEST ROUTE
app.get('/', (req, res) => {
  res.status(200).json({ 
    success: true, 
    message: '🚀 Perfume Backend is Running!',
    status: 'Healthy'
  });
});

// 5. ERROR HANDLING (404)
app.use((req, res) => {
  res.status(404).json({ 
    success: false, 
    message: "Route-kan lama helin!" 
  });
});

// 6. START SERVER
const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
  console.log(`✅ Server running on port ${PORT}`);
});