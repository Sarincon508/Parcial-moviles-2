const { db } = require('../config/database');

class UserModel {
  /**
   * Buscar usuario por correo electrónico
   */
  static findByEmail(email) {
    return new Promise((resolve, reject) => {
      db.get('SELECT * FROM usuarios WHERE email = ?', [email], (err, row) => {
        if (err) return reject(err);
        resolve(row);
      });
    });
  }

  /**
   * Buscar usuario por ID
   */
  static findById(id) {
    return new Promise((resolve, reject) => {
      db.get(
        'SELECT id, nombre, email, rol, created_at FROM usuarios WHERE id = ?',
        [id],
        (err, row) => {
          if (err) return reject(err);
          resolve(row);
        }
      );
    });
  }

  /**
   * Registrar nuevo usuario
   */
  static create({ nombre, email, password, rol = 'operador' }) {
    return new Promise((resolve, reject) => {
      const query = `
        INSERT INTO usuarios (nombre, email, password, rol)
        VALUES (?, ?, ?, ?)
      `;
      db.run(query, [nombre, email, password, rol], function (err) {
        if (err) return reject(err);
        UserModel.findById(this.lastID)
          .then(resolve)
          .catch(reject);
      });
    });
  }
}

module.exports = UserModel;
