const express = require('express');
const cors = require('cors');
const morgan = require('morgan');
const authRoutes = require('./routes/authRoutes');
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
    nombre: 'API REST - Sistema de Gestión de Inventario con Autenticación JWT',
    version: '2.0.0',
    estado: 'En línea 🟢',
    descripcion: 'API con seguridad JWT para la gestión de productos y persistencia SQLite',
    endpoints: {
      auth_login: 'POST /api/auth/login',
      auth_perfil: 'GET /api/auth/perfil [Protegido con Bearer token]',
      auth_register: 'POST /api/auth/register',
      listar_productos: 'GET /api/productos [Protegido con Bearer token]',
      detalle_producto: 'GET /api/productos/:id [Protegido con Bearer token]',
      registrar_producto: 'POST /api/productos [Protegido con Bearer token]',
      actualizar_producto: 'PUT /api/productos/:id [Protegido con Bearer token]',
      eliminar_producto: 'DELETE /api/productos/:id [Protegido con Bearer token]',
      estadisticas_dashboard: 'GET /api/productos/stats [Protegido con Bearer token]',
      categorias_disponibles: 'GET /api/productos/categorias [Protegido con Bearer token]'
    },
    usuarios_prueba: {
      admin: { email: 'admin@inventario.com', clave: 'admin123' },
      operador: { email: 'usuario@inventario.com', clave: 'user123' }
    }
  });
});

// Registrar rutas de la API
app.use('/api/auth', authRoutes);
app.use('/api/productos', productRoutes);

// Manejo de 404 y Errores
app.use(notFoundHandler);
app.use(errorHandler);

module.exports = app;
