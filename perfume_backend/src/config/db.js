const { Pool } = require('pg');

const pool = new Pool({
  connectionString: process.env.DATABASE_URL, // Waxaan isticmaalaynaa hal link oo aan Environmental variable-ka ku gelinay
  ssl: {
    rejectUnauthorized: false // Waa muhiim Neon.tech
  }
});

pool.connect()
  .then(() => {
    console.log('✅ PostgreSQL Connected');
  })
  .catch((err) => {
    console.error('❌ Database Error:', err.message);
  });

module.exports = pool;