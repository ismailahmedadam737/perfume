const { Pool } = require('pg');

// Waxaan isticmaaleynaa DATABASE_URL oo laga keenayo environment variables
const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  // Render wuxuu u baahan yahay SSL si uu ula hadlo Neon Database
  // rejectUnauthorized: false ayaa u oggolaanaya xiriirka
  ssl: {
    rejectUnauthorized: false
  }
});

// KANI WAA QAYBTA U GUURINAYSA IN SERVER-KU UUSAN IS-DAMIN (CRASH)
// Haddii ay jirto dhibaato xiriirka database-ka, log-ga ayaan ku arki doonaa 
// laakiin server-ku wuu sii shaqaynayaa
pool.on('error', (err, client) => {
  console.error('❌ Unexpected error on idle database client', err);
});

// Hubinta in xiriirku uu guulaystay
pool.connect()
  .then(() => {
    console.log('✅ PostgreSQL Connected successfully');
  })
  .catch((err) => {
    console.error('❌ Database Connection Error:', err.message);
  });

module.exports = pool;