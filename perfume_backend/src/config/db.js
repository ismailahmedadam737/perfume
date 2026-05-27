const { Pool } = require('pg');

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  // Waxaan SSL-ka ka saarnay si aan u hubinno inay taasi tahay ciladdu
  ssl: false 
});

pool.connect()
  .then(() => {
    console.log('✅ PostgreSQL Connected (SSL Disabled)');
  })
  .catch((err) => {
    console.error('❌ Database Error:', err.message);
  });

module.exports = pool;