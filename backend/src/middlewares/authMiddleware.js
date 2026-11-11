const jwt = require('jsonwebtoken');

const JWT_SECRET = process.env.JWT_SECRET || 'super_secreto_jwt_parcial2_inventario_2026_key';

/**
 * Middleware para validar token JWT en peticiones protegidas
 */
const authMiddleware = (req, res, next) => {
  const authHeader = req.headers.authorization;

  if (!authHeader) {
    return res.status(401).json({
      success: false,
      message: 'Acceso no autorizado: Se requiere token de autenticación en la cabecera Authorization',
      error: 'Token no proporcionado'
    });
  }

  // Verificar formato Bearer <token>
  const parts = authHeader.split(' ');
  if (parts.length !== 2 || parts[0] !== 'Bearer') {
    return res.status(401).json({
      success: false,
      message: 'Formato de autorización inválido. Debe ser: Bearer <token>',
      error: 'Formato de cabecera inválido'
    });
  }

  const token = parts[1];

  try {
    const decoded = jwt.verify(token, JWT_SECRET);
    req.user = decoded;
    next();
  } catch (err) {
    let message = 'Acceso no autorizado: Token inválido o manipulado';
    if (err.name === 'TokenExpiredError') {
      message = 'Acceso no autorizado: El token ha expirado. Por favor inicie sesión nuevamente';
    }

    return res.status(401).json({
      success: false,
      message,
      error: err.message
    });
  }
};

module.exports = authMiddleware;
