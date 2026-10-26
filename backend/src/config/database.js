const sqlite3 = require('sqlite3').verbose();
const path = require('path');
const fs = require('fs');

const dbPath = process.env.DB_PATH || path.resolve(__dirname, '../../database.sqlite');

// Asegurar que el directorio de la base de datos exista
const dbDir = path.dirname(dbPath);
if (!fs.existsSync(dbDir)) {
  fs.mkdirSync(dbDir, { recursive: true });
}

const db = new sqlite3.Database(dbPath, (err) => {
  if (err) {
    console.error('❌ Error conectando a SQLite:', err.message);
  } else {
    console.log(`📦 Base de datos SQLite conectada en: ${dbPath}`);
  }
});

/**
 * Inicializar tablas y datos semilla
 */
const initDatabase = () => {
  return new Promise((resolve, reject) => {
    db.serialize(() => {
      // Crear tabla de productos
      db.run(
        `CREATE TABLE IF NOT EXISTS productos (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          nombre TEXT NOT NULL,
          codigo TEXT UNIQUE NOT NULL,
          descripcion TEXT,
          precio REAL NOT NULL,
          cantidad INTEGER NOT NULL,
          categoria TEXT NOT NULL,
          created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
          updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
        )`,
        (err) => {
          if (err) {
            console.error('❌ Error creando tabla productos:', err.message);
            return reject(err);
          }

          // Verificar si hay productos para sembrar datos iniciales (mínimo 10)
          db.get('SELECT COUNT(*) as total FROM productos', (err, row) => {
            if (err) {
              console.error('❌ Error consultando conteo de productos:', err.message);
              return reject(err);
            }

            if (row.total === 0) {
              console.log('🌱 Sembrando 12 productos iniciales de prueba...');
              const initialProducts = [
                ['Laptop Dell Inspiron 15', 'PROD-001', 'Intel Core i7, 16GB RAM, 512GB SSD', 899.99, 15, 'Tecnología'],
                ['Mouse Inalámbrico Logitech MX Master 3', 'PROD-002', 'Sensor óptico de alta precisión con scroll electromagnético', 99.50, 45, 'Accesorios'],
                ['Teclado Mecánico RGB Redragon', 'PROD-003', 'Switches mecánicos Outemu Blue, retroiluminación RGB', 54.90, 30, 'Accesorios'],
                ['Monitor Samsung 27 Pulgadas Curvo', 'PROD-004', 'Panel VA FHD 144Hz 4ms FreeSync', 219.00, 20, 'Tecnología'],
                ['Smartphone Samsung Galaxy S23', 'PROD-005', 'Pantalla Dynamic AMOLED 2X, 128GB, 8GB RAM', 749.99, 12, 'Telefonía'],
                ['Auriculares Sony WH-1000XM5', 'PROD-006', 'Cancelación de ruido activa líder en el mercado', 349.90, 18, 'Audio'],
                ['Tablet Apple iPad 10ma Gen', 'PROD-007', 'Pantalla Liquid Retina 10.9 pulgadas, chip A14 Bionic', 449.00, 22, 'Tecnología'],
                ['Impresora Multifuncional Epson EcoTank L3250', 'PROD-008', 'Tanque de tinta recargable con conectividad Wi-Fi', 189.50, 10, 'Oficina'],
                ['Disco Duro Externo Seagate 2TB', 'PROD-009', 'USB 3.0 compatible con PC, Mac y consolas', 69.99, 50, 'Almacenamiento'],
                ['Memoria RAM Corsair Vengeance 16GB DDR4', 'PROD-010', '3200MHz CL16 con disipador de aluminio anodizado', 45.00, 40, 'Componentes'],
                ['Silla Ergonómica de Oficina Sihoo', 'PROD-011', 'Soporte lumbar ajustable, malla transpirable', 159.00, 8, 'Mobiliario'],
                ['Cámara Web Logitech C920 HD Pro', 'PROD-012', 'Video Full HD 1080p a 30fps con micrófonos estéreo', 79.99, 25, 'Video']
              ];

              const stmt = db.prepare(
                'INSERT INTO productos (nombre, codigo, descripcion, precio, cantidad, categoria) VALUES (?, ?, ?, ?, ?, ?)'
              );

              for (const p of initialProducts) {
                stmt.run(p);
              }

              stmt.finalize((err) => {
                if (err) {
                  console.error('❌ Error sembrando productos:', err.message);
                  return reject(err);
                }
                console.log('✅ 12 productos de prueba sembrados exitosamente.');
                resolve(db);
              });
            } else {
              console.log(`ℹ️ La base de datos ya contiene ${row.total} productos persistidos.`);
              resolve(db);
            }
          });
        }
      );
    });
  });
};

module.exports = { db, initDatabase };
