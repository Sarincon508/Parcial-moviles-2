const ProductModel = require('../models/productModel');

/**
 * GET /api/productos
 * Listar todos los productos (con soporte para búsqueda y filtrado por categoría)
 */
const getProducts = async (req, res, next) => {
  try {
    const { search, categoria } = req.query;
    const productos = await ProductModel.getAll({ search, categoria });
    res.status(200).json({
      success: true,
      count: productos.length,
      data: productos
    });
  } catch (error) {
    next(error);
  }
};

/**
 * GET /api/productos/:id
 * Consultar el detalle de un producto por ID
 */
const getProductById = async (req, res, next) => {
  try {
    const { id } = req.params;
    const producto = await ProductModel.getById(id);

    if (!producto) {
      return res.status(404).json({
        success: false,
        message: `Producto con ID ${id} no encontrado en la base de datos.`
      });
    }

    res.status(200).json({
      success: true,
      data: producto
    });
  } catch (error) {
    next(error);
  }
};

/**
 * POST /api/productos
 * Registrar un nuevo producto
 */
const createProduct = async (req, res, next) => {
  try {
    const { nombre, codigo, descripcion, precio, cantidad, categoria } = req.body;
    const nuevoProducto = await ProductModel.create({
      nombre,
      codigo,
      descripcion,
      precio,
      cantidad,
      categoria
    });

    res.status(201).json({
      success: true,
      message: 'Producto registrado exitosamente.',
      data: nuevoProducto
    });
  } catch (error) {
    next(error);
  }
};

/**
 * PUT /api/productos/:id
 * Actualizar un producto existente
 */
const updateProduct = async (req, res, next) => {
  try {
    const { id } = req.params;
    const { nombre, codigo, descripcion, precio, cantidad, categoria } = req.body;

    const productoActualizado = await ProductModel.update(id, {
      nombre,
      codigo,
      descripcion,
      precio,
      cantidad,
      categoria
    });

    if (!productoActualizado) {
      return res.status(404).json({
        success: false,
        message: `Producto con ID ${id} no encontrado para actualizar.`
      });
    }

    res.status(200).json({
      success: true,
      message: 'Producto actualizado exitosamente.',
      data: productoActualizado
    });
  } catch (error) {
    next(error);
  }
};

/**
 * DELETE /api/productos/:id
 * Eliminar un producto de la base de datos
 */
const deleteProduct = async (req, res, next) => {
  try {
    const { id } = req.params;
    const productoExistente = await ProductModel.getById(id);

    if (!productoExistente) {
      return res.status(404).json({
        success: false,
        message: `Producto con ID ${id} no encontrado para eliminar.`
      });
    }

    const eliminado = await ProductModel.delete(id);

    if (!eliminado) {
      return res.status(500).json({
        success: false,
        message: 'No se pudo eliminar el producto de la base de datos.'
      });
    }

    res.status(200).json({
      success: true,
      message: `Producto "${productoExistente.nombre}" (ID: ${id}) eliminado correctamente.`,
      data: productoExistente
    });
  } catch (error) {
    next(error);
  }
};

/**
 * GET /api/productos/stats
 * Consultar estadísticas para el Dashboard de la aplicación móvil
 */
const getStats = async (req, res, next) => {
  try {
    const stats = await ProductModel.getStats();
    res.status(200).json({
      success: true,
      data: stats
    });
  } catch (error) {
    next(error);
  }
};

/**
 * GET /api/productos/categorias
 * Obtener listado de categorías disponibles
 */
const getCategorias = async (req, res, next) => {
  try {
    const categorias = await ProductModel.getCategorias();
    res.status(200).json({
      success: true,
      data: categorias
    });
  } catch (error) {
    next(error);
  }
};

module.exports = {
  getProducts,
  getProductById,
  createProduct,
  updateProduct,
  deleteProduct,
  getStats,
  getCategorias
};
