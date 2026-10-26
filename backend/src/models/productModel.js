const { db } = require('../config/database');

class ProductModel {
  /**
   * Obtener todos los productos con filtros opcionales (búsqueda y categoría)
   */
  static getAll({ search, categoria } = {}) {
    return new Promise((resolve, reject) => {
      let query = 'SELECT * FROM productos WHERE 1=1';
      const params = [];

      if (search && search.trim() !== '') {
        query += ' AND (nombre LIKE ? OR codigo LIKE ? OR descripcion LIKE ?)';
        const term = `%${search.trim()}%`;
        params.push(term, term, term);
      }

      if (categoria && categoria.trim() !== '' && categoria !== 'Todas') {
        query += ' AND categoria = ?';
        params.push(categoria.trim());
      }

      query += ' ORDER BY id DESC';

      db.all(query, params, (err, rows) => {
        if (err) return reject(err);
        resolve(rows);
      });
    });
  }

  /**
   * Obtener un producto por su ID
   */
  static getById(id) {
    return new Promise((resolve, reject) => {
      const query = 'SELECT * FROM productos WHERE id = ?';
      db.get(query, [id], (err, row) => {
        if (err) return reject(err);
        resolve(row || null);
      });
    });
  }

  /**
   * Obtener un producto por su Código único
   */
  static getByCodigo(codigo) {
    return new Promise((resolve, reject) => {
      const query = 'SELECT * FROM productos WHERE codigo = ?';
      db.get(query, [codigo], (err, row) => {
        if (err) return reject(err);
        resolve(row || null);
      });
    });
  }

  /**
   * Crear un nuevo producto
   */
  static create({ nombre, codigo, descripcion, precio, cantidad, categoria }) {
    return new Promise((resolve, reject) => {
      const query = `
        INSERT INTO productos (nombre, codigo, descripcion, precio, cantidad, categoria)
        VALUES (?, ?, ?, ?, ?, ?)
      `;
      const params = [
        nombre.trim(),
        codigo.trim().toUpperCase(),
        descripcion ? descripcion.trim() : '',
        parseFloat(precio),
        parseInt(cantidad, 10),
        categoria.trim()
      ];

      db.run(query, params, function (err) {
        if (err) return reject(err);
        ProductModel.getById(this.lastID)
          .then((product) => resolve(product))
          .catch(reject);
      });
    });
  }

  /**
   * Actualizar un producto existente
   */
  static update(id, { nombre, codigo, descripcion, precio, cantidad, categoria }) {
    return new Promise((resolve, reject) => {
      const query = `
        UPDATE productos
        SET nombre = ?,
            codigo = ?,
            descripcion = ?,
            precio = ?,
            cantidad = ?,
            categoria = ?,
            updated_at = CURRENT_TIMESTAMP
        WHERE id = ?
      `;
      const params = [
        nombre.trim(),
        codigo.trim().toUpperCase(),
        descripcion !== undefined ? (descripcion ? descripcion.trim() : '') : '',
        parseFloat(precio),
        parseInt(cantidad, 10),
        categoria.trim(),
        id
      ];

      db.run(query, params, function (err) {
        if (err) return reject(err);
        if (this.changes === 0) return resolve(null);
        ProductModel.getById(id)
          .then((product) => resolve(product))
          .catch(reject);
      });
    });
  }

  /**
   * Eliminar un producto por ID
   */
  static delete(id) {
    return new Promise((resolve, reject) => {
      const query = 'DELETE FROM productos WHERE id = ?';
      db.run(query, [id], function (err) {
        if (err) return reject(err);
        resolve(this.changes > 0);
      });
    });
  }

  /**
   * Obtener métricas calculadas del inventario:
   * - Total de productos
   * - Total de unidades
   * - Valor económico total (SUM(precio * cantidad))
   */
  static getStats() {
    return new Promise((resolve, reject) => {
      const query = `
        SELECT 
          COUNT(*) AS totalProductos,
          COALESCE(SUM(cantidad), 0) AS totalUnidades,
          COALESCE(SUM(precio * cantidad), 0.0) AS valorTotalInventario
        FROM productos
      `;
      db.get(query, [], (err, row) => {
        if (err) return reject(err);
        resolve({
          totalProductos: Number(row.totalProductos || 0),
          totalUnidades: Number(row.totalUnidades || 0),
          valorTotalInventario: Number(parseFloat(row.valorTotalInventario || 0).toFixed(2))
        });
      });
    });
  }

  /**
   * Obtener todas las categorías distintas
   */
  static getCategorias() {
    return new Promise((resolve, reject) => {
      const query = 'SELECT DISTINCT categoria FROM productos WHERE categoria IS NOT NULL AND categoria != "" ORDER BY categoria ASC';
      db.all(query, [], (err, rows) => {
        if (err) return reject(err);
        resolve(rows.map((r) => r.categoria));
      });
    });
  }
}

module.exports = ProductModel;
