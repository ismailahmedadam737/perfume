const { Pool } = require('pg');
require('dotenv').config();

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: {
    rejectUnauthorized: false // Tani waa muhiim Neon
  },
  // Waxaan ku darnay xaddidaad si looga fogaado timeout
  connectionTimeoutMillis: 10000, 
  idleTimeoutMillis: 30000,
});

pool.on('error', (err) => {
  console.error('Unexpected error on idle client', err);
});

module.exports = pool;