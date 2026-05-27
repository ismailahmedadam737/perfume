const { Pool } = require('pg');
require('dotenv').config();

// Waxaan ku darnay 'max' iyo 'idleTimeoutMillis' si aan u xallinno mushkiladda Connection Timeout
const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: {
    rejectUnauthorized: false // Waa lama huraan Neon
  },
  max: 20, // Tirada ugu badan ee connections-ka (dhaqso ayuu u furanayaa)
  idleTimeoutMillis: 30000, // Waqtiga uu xirayo connection-ka haddii uusan isticmaalin
  connectionTimeoutMillis: 5000, // Waqtiga uu sugayo inuu xiriir la sameeyo
});

// Debugging: Hubi inuu si sax ah ula xiriiray
pool.connect((err, client, release) => {
  if (err) {
    return console.error('Error acquiring client', err.stack);
  }
  console.log('✅ PostgreSQL Connected successfully (SSL enabled)');
  release();
});

pool.on('error', (err) => {
  console.error('Unexpected error on idle client', err);
  process.exit(-1);
});

module.exports = pool;