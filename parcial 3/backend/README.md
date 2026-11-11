# Backend — API REST de Gestión de Inventario

API REST desarrollada con **Node.js** y **Express**, conectada a una base de datos persistente **SQLite**. Provee operaciones CRUD completas y cálculo de estadísticas en tiempo real para ser consumida por la aplicación móvil Flutter.

---

## 🚀 Tecnologías Utilizadas

- **Node.js** (v18+)
- **Express.js** (Framework HTTP rápido y minimalista)
- **SQLite3** (Base de datos relacional ligera, local y persistente)
- **CORS** (Soporte multiplataforma para Flutter Web, Android, iOS y Desktop)
- **Morgan** (Logger HTTP para desarrollo)
- **Dotenv** (Gestión de variables de entorno)

---

## 📦 Estructura del Proyecto Backend

```
backend/
├── src/
│   ├── config/
│   │   └── database.js          # Conexión SQLite y sembrado automático de datos
│   ├── controllers/
│   │   └── productController.js # Lógica de los endpoints CRUD y estadísticas
│   ├── middlewares/
│   │   ├── errorHandler.js      # Manejo global de excepciones y 404
│   │   └── validator.js         # Validaciones de campos, tipos y unicidad
│   ├── models/
│   │   └── productModel.js      # Consultas SQL preparadas a SQLite
│   ├── routes/
│   │   └── productRoutes.js     # Definición de rutas y mapeo a controladores
│   └── app.js                   # Configuración de Express, CORS y middlewares
├── .env.example                 # Plantilla de variables de entorno
├── .gitignore                   # Archivos excluidos del control de versiones
├── database.sqlite              # Archivo de base de datos persistente
├── package.json                 # Metadatos y dependencias
└── server.js                    # Punto de entrada del servidor
```

---

## 🛠️ Instalación y Ejecución

### 1. Clonar o navegar al directorio backend
```bash
cd backend
```

### 2. Instalar dependencias
```bash
npm install
```

### 3. Configurar variables de entorno
Copie `.env.example` a `.env` (opcional, tiene valores por defecto):
```bash
cp .env.example .env
```

Contenido del archivo `.env`:
```env
PORT=3000
HOST=0.0.0.0
NODE_ENV=development
DB_PATH=./database.sqlite
```

### 4. Iniciar el servidor
```bash
# Modo producción / estándar
npm start

# Modo desarrollo con recarga automática
npm run dev
```

El servidor quedará disponible en:
- `http://localhost:3000`
- `http://127.0.0.1:3000`
- Para emulador Android: `http://10.0.2.2:3000`
- Para dispositivo físico: `http://<TU_IP_LOCAL>:3000`

---

## 📋 Endpoints de la API

| Método | Endpoint | Descripción | Códigos HTTP |
| :--- | :--- | :--- | :--- |
| **GET** | `/` | Estado de la API y bienvenida | `200` |
| **GET** | `/api/productos` | Listar todos los productos (permite `?search=` y `?categoria=`) | `200`, `500` |
| **GET** | `/api/productos/stats` | Estadísticas del Dashboard (total productos, total unidades, valor total) | `200`, `500` |
| **GET** | `/api/productos/categorias` | Lista de categorías existentes | `200`, `500` |
| **GET** | `/api/productos/:id` | Consultar detalle de un producto por ID | `200`, `400`, `404` |
| **POST** | `/api/productos` | Registrar nuevo producto | `201`, `422`, `500` |
| **PUT** | `/api/productos/:id` | Actualizar producto existente | `200`, `400`, `404`, `422` |
| **DELETE** | `/api/productos/:id` | Eliminar producto por ID | `200`, `400`, `404`, `500` |

---

## 📝 Ejemplos de Peticiones y Respuestas

### 1. Listar Productos
- **Petición**: `GET /api/productos`
- **Respuesta (200 OK)**:
```json
{
  "success": true,
  "count": 12,
  "data": [
    {
      "id": 1,
      "nombre": "Laptop Dell Inspiron 15",
      "codigo": "PROD-001",
      "descripcion": "Intel Core i7, 16GB RAM, 512GB SSD",
      "precio": 899.99,
      "cantidad": 15,
      "categoria": "Tecnología",
      "created_at": "2026-10-26 15:54:25",
      "updated_at": "2026-10-26 15:54:25"
    }
  ]
}
```

### 2. Registrar Producto
- **Petición**: `POST /api/productos`
- **Headers**: `Content-Type: application/json`
- **Body**:
```json
{
  "nombre": "Monitor Gamer 144Hz",
  "codigo": "PROD-099",
  "descripcion": "24 pulgadas IPS con tiempo de respuesta 1ms",
  "precio": 199.99,
  "cantidad": 10,
  "categoria": "Tecnología"
}
```
- **Respuesta (201 Created)**:
```json
{
  "success": true,
  "message": "Producto registrado exitosamente.",
  "data": {
    "id": 13,
    "nombre": "Monitor Gamer 144Hz",
    "codigo": "PROD-099",
    "descripcion": "24 pulgadas IPS con tiempo de respuesta 1ms",
    "precio": 199.99,
    "cantidad": 10,
    "categoria": "Tecnología",
    "created_at": "2026-10-26 16:00:00",
    "updated_at": "2026-10-26 16:00:00"
  }
}
```

### 3. Estadísticas del Inventario
- **Petición**: `GET /api/productos/stats`
- **Respuesta (200 OK)**:
```json
{
  "success": true,
  "data": {
    "totalProductos": 12,
    "totalUnidades": 295,
    "valorTotalInventario": 59646.68
  }
}
```
