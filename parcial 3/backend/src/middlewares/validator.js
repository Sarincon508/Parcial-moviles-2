const ProductModel = require('../models/productModel');

/**
 * Middleware para validar datos de entrada de productos (POST y PUT)
 */
const validateProduct = async (req, res, next) => {
  try {
    const { nombre, codigo, precio, cantidad, categoria } = req.body;
    const errors = [];

    // Validar nombre
    if (!nombre || typeof nombre !== 'string' || nombre.trim().length === 0) {
      errors.push({ field: 'nombre', message: 'El campo "nombre" es obligatorio y debe ser un texto válido.' });
    }

    // Validar código
    if (!codigo || typeof codigo !== 'string' || codigo.trim().length === 0) {
      errors.push({ field: 'codigo', message: 'El campo "codigo" es obligatorio y debe ser un texto único.' });
    }

    // Validar precio
    if (precio === undefined || precio === null || isNaN(Number(precio)) || Number(precio) <= 0) {
      errors.push({ field: 'precio', message: 'El campo "precio" debe ser un número decimal mayor a 0.' });
    }

    // Validar cantidad
    if (
      cantidad === undefined ||
      cantidad === null ||
      isNaN(Number(cantidad)) ||
      !Number.isInteger(Number(cantidad)) ||
      Number(cantidad) < 0
    ) {
      errors.push({ field: 'cantidad', message: 'El campo "cantidad" debe ser un número entero mayor o igual a 0.' });
    }

    // Validar categoría
    if (!categoria || typeof categoria !== 'string' || categoria.trim().length === 0) {
      errors.push({ field: 'categoria', message: 'El campo "categoria" es obligatorio.' });
    }

    if (errors.length > 0) {
      return res.status(422).json({
        success: false,
        message: 'Error de validación en los datos del producto.',
        errors
      });
    }

    // Validar unicidad del código
    const currentId = req.params.id ? parseInt(req.params.id, 10) : null;
    const existing = await ProductModel.getByCodigo(codigo.trim().toUpperCase());

    if (existing && (!currentId || existing.id !== currentId)) {
      return res.status(422).json({
        success: false,
        message: `El código "${codigo.trim().toUpperCase()}" ya está registrado en otro producto.`,
        errors: [{ field: 'codigo', message: 'El código del producto ya existe en el inventario.' }]
      });
    }

    next();
  } catch (error) {
    next(error);
  }
};

/**
 * Middleware para validar el parámetro ID
 */
const validateId = (req, res, next) => {
  const id = parseInt(req.params.id, 10);
  if (isNaN(id) || id <= 0) {
    return res.status(400).json({
      success: false,
      message: 'El identificador del producto debe ser un entero positivo válido.'
    });
  }
  req.productId = id;
  next();
};

module.exports = {
  validateProduct,
  validateId
};
