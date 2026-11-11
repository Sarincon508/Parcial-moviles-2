const jwt = require('jsonwebtoken');
const bcrypt = require('bcryptjs');
const UserModel = require('../models/userModel');

const JWT_SECRET = process.env.JWT_SECRET || 'super_secreto_jwt_parcial2_inventario_2026_key';
const JWT_EXPIRES_IN = process.env.JWT_EXPIRES_IN || '24h';

/**
 * Iniciar sesión y generar token JWT
 * POST /api/auth/login
 */
const login = async (req, res, next) => {
  try {
    const { email, password } = req.body;

    if (!email || !password) {
      return res.status(400).json({
        success: false,
        message: 'Debe ingresar el correo electrónico y la contraseña',
        errors: [
          ...(!email ? [{ field: 'email', message: 'El correo electrónico es obligatorio' }] : []),
          ...(!password ? [{ field: 'password', message: 'La contraseña es obligatoria' }] : [])
        ]
      });
    }

    const user = await UserModel.findByEmail(email.trim().toLowerCase());
    if (!user) {
      return res.status(401).json({
        success: false,
        message: 'Credenciales inválidas. Correo electrónico o contraseña incorrectos.'
      });
    }

    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.status(401).json({
        success: false,
        message: 'Credenciales inválidas. Correo electrónico o contraseña incorrectos.'
      });
    }

    // Generar Token JWT con información básica del usuario
    const payload = {
      id: user.id,
      nombre: user.nombre,
      email: user.email,
      rol: user.rol
    };

    const token = jwt.sign(payload, JWT_SECRET, { expiresIn: JWT_EXPIRES_IN });

    return res.status(200).json({
      success: true,
      message: 'Inicio de sesión exitoso',
      data: {
        token,
        usuario: {
          id: user.id,
          nombre: user.nombre,
          email: user.email,
          rol: user.rol,
          created_at: user.created_at
        }
      }
    });
  } catch (error) {
    next(error);
  }
};

/**
 * Obtener perfil del usuario autenticado actual
 * GET /api/auth/perfil
 */
const getPerfil = async (req, res, next) => {
  try {
    const user = await UserModel.findById(req.user.id);
    if (!user) {
      return res.status(404).json({
        success: false,
        message: 'Usuario no encontrado'
      });
    }

    return res.status(200).json({
      success: true,
      message: 'Perfil de usuario obtenido correctamente',
      data: {
        usuario: user,
        session_info: {
          token_valid: true,
          expires_in: JWT_EXPIRES_IN,
          auth_payload: req.user
        }
      }
    });
  } catch (error) {
    next(error);
  }
};

/**
 * Registro de un nuevo usuario (opcional / auxiliar)
 * POST /api/auth/register
 */
const register = async (req, res, next) => {
  try {
    const { nombre, email, password, rol } = req.body;

    if (!nombre || !email || !password) {
      return res.status(400).json({
        success: false,
        message: 'Nombre, email y contraseña son obligatorios'
      });
    }

    const existing = await UserModel.findByEmail(email.trim().toLowerCase());
    if (existing) {
      return res.status(409).json({
        success: false,
        message: 'El correo electrónico ya se encuentra registrado'
      });
    }

    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash(password, salt);

    const newUser = await UserModel.create({
      nombre: nombre.trim(),
      email: email.trim().toLowerCase(),
      password: hashedPassword,
      rol: rol || 'operador'
    });

    return res.status(201).json({
      success: true,
      message: 'Usuario registrado exitosamente',
      data: {
        usuario: newUser
      }
    });
  } catch (error) {
    next(error);
  }
};

module.exports = {
  login,
  getPerfil,
  register
};
