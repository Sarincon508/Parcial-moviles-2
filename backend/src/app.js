const express = require('express');
const cors = require('cors');
const morgan = require('morgan');
const productRoutes = require('./routes/productRoutes');
const { notFoundHandler, errorHandler } = require('./middlewares/errorHandler');

const app = express();

// Middlewares globales
app.use(cors({
  origin: '*',
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization']
}));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(morgan('dev'));

// Ruta raíz de verificación de salud y documentación básica
app.get('/', (req, res) => {
  res.status(200).json({
    nombre: 'API REST - Sistema de Gestión de Inventario',
    version: '1.0.0',
    estado: 'En línea 🟢',
    descripcion: 'API para la gestión de productos con persistencia SQLite para aplicación Flutter',
    endpoints: {
      listar_productos: 'GET /api/productos',
      detalle_producto: 'GET /api/productos/:id',
      registrar_producto: 'POST /api/productos',
      actualizar_producto: 'PUT /api/productos/:id',
      eliminar_producto: 'DELETE /api/productos/:id',
      estadisticas_dashboard: 'GET /api/productos/stats',
      categorias_disponibles: 'GET /api/productos/categorias'
    },
    documentacion: 'Consulte el archivo README.md o la colección de Postman/Thunder Client'
  });
});

// Registrar rutas de la API
app.use('/api/productos', productRoutes);

// Manejo de 404 y Errores
app.use(notFoundHandler);
app.use(errorHandler);

module.exports = app;
