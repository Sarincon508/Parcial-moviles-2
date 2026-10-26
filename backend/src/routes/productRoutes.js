const express = require('express');
const router = express.Router();

const {
  getProducts,
  getProductById,
  createProduct,
  updateProduct,
  deleteProduct,
  getStats,
  getCategorias
} = require('../controllers/productController');

const { validateProduct, validateId } = require('../middlewares/validator');

/**
 * Endpoints del recurso Productos
 */

// Rutas auxiliares (declaradas antes de :id para evitar colisiones)
router.get('/stats', getStats);
router.get('/categorias', getCategorias);

// Endpoints obligatorios del CRUD
router.get('/', getProducts);
router.get('/:id', validateId, getProductById);
router.post('/', validateProduct, createProduct);
router.put('/:id', validateId, validateProduct, updateProduct);
router.delete('/:id', validateId, deleteProduct);

module.exports = router;
