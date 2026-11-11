/**
 * Middleware para rutas no encontradas (404)
 */
const notFoundHandler = (req, res, next) => {
  res.status(404).json({
    success: false,
    message: `Ruta no encontrada: ${req.method} ${req.originalUrl}`
  });
};

/**
 * Middleware global de manejo de excepciones y errores
 */
const errorHandler = (err, req, res, next) => {
  console.error('💥 Error inesperado en el servidor:', err);

  // Manejo de errores específicos de SQLite
  if (err.code === 'SQLITE_CONSTRAINT') {
    return res.status(422).json({
      success: false,
      message: 'Violación de restricción en la base de datos (posible duplicidad de clave única).',
      detail: err.message
    });
  }

  res.status(500).json({
    success: false,
    message: 'Error interno del servidor.',
    error: process.env.NODE_ENV === 'development' ? err.message : undefined
  });
};

module.exports = {
  notFoundHandler,
  errorHandler
};
