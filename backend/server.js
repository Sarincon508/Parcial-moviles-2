require('dotenv').config();
const app = require('./src/app');
const { initDatabase } = require('./src/config/database');

const PORT = process.env.PORT || 3000;
const HOST = process.env.HOST || '0.0.0.0';

// Inicializar la base de datos antes de arrancar el servidor HTTP
initDatabase()
  .then(() => {
    app.listen(PORT, HOST, () => {
      console.log('========================================================');
      console.log(`🚀 Servidor API REST ejecutándose en:`);
      console.log(`   - Local:    http://localhost:${PORT}`);
      console.log(`   - Red / IP: http://${HOST}:${PORT}`);
      console.log(`   - Endpoint: http://localhost:${PORT}/api/productos`);
      console.log('========================================================');
    });
  })
  .catch((err) => {
    console.error('❌ Error fatal al inicializar la base de datos:', err);
    process.exit(1);
  });
