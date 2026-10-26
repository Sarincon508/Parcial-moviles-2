# INFORME DE EVIDENCIAS — SEGUNDO PARCIAL PROGRAMACIÓN MÓVIL
## Sistema de Gestión de Inventario con API REST y Flutter

---

## 1. Identificación del Estudiante
- **Nombre Completo:** Samuel Alejandro Rincon Serna
- **Asignatura:** Programación Móvil
- **Semestre:** 2026-II
- **Docente:** [Nombre del Docente]
- **Fecha de Entrega:** [Fecha de Entrega]

---

## 2. Enlaces Oficiales de Entrega

| Recurso | Enlace de Acceso | Observaciones |
| :--- | :--- | :--- |
| **Repositorio GitHub** | [https://github.com/Sarincon508/Parcial-moviles-2.git](https://github.com/Sarincon508/Parcial-moviles-2.git) | Repositorio público con backend, frontend y documentación |
| **Video Explicativo** | *[PEGA AQUÍ TU ENLACE DE YOUTUBE U OCULTO / DRIVE]* | Video con audio explicativo y demostración completa |
| **API Desplegada (Bono 5%)** | [https://inventario-api-parcial2.onrender.com](https://inventario-api-parcial2.onrender.com) | API REST en producción activa con SQLite persistente |

> ⚠️ **Nota:** Asegúrate de que el enlace de tu video en YouTube esté en modo **"Oculto" (Unlisted)** o en Google Drive con acceso para **"Cualquier persona que tenga el enlace"** para que el docente pueda calificarlo sin requerir permisos.

---

## 3. Descripción de las Tecnologías Utilizadas

### 3.1. Backend (API REST)
- **Node.js & Express.js:** Entorno de ejecución y framework minimalista para construcción de APIs RESTful asíncronas de alto rendimiento.
- **SQLite3:** Base de datos relacional ligera con persistencia física en disco (`database.sqlite`).
- **CORS:** Middleware que habilita la interoperabilidad y consumo cruzado entre el backend y clientes Web, Android, iOS y Desktop.
- **Validaciones & Middlewares:** Control de integridad de datos (código único, campos obligatorios, cantidades y precios válidos con código HTTP 422).
- **Dotenv:** Administración segura de variables de entorno del servidor.
- **Render Cloud:** Despliegue de infraestructura automatizado con HTTPS público.

### 3.2. Frontend Móvil (Flutter)
- **Flutter Framework & Dart SDK:** Desarrollo de interfaz multiplataforma moderna con Material 3.
- **Dio:** Cliente HTTP avanzado para el consumo de la API REST, con configuración de timeouts, headers y manejo tipado de excepciones (`DioException`).
- **go_router:** Motor declarativo de rutas con soporte para parámetros por URL (`/productos/detalle/:id`), ShellRoute con menú de navegación inferior (BottomNavigationBar) y lateral (Drawer).
- **flutter_dotenv:** Carga de variables de configuración externa (`assets/.env`) para desacoplar la URL base del servidor.
- **Provider (ChangeNotifier):** Gestión de estado reactiva que separa la lógica de presentación de la comunicación con los servicios web.
- **Intl:** Formateo localizado de divisas y precios monetarios.

---

## 4. Evidencias del Backend y Base de Datos

### 4.1. Esquema de la Tabla `productos` en SQLite
```sql
CREATE TABLE IF NOT EXISTS productos (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  nombre TEXT NOT NULL,
  codigo TEXT UNIQUE NOT NULL,
  descripcion TEXT,
  precio REAL NOT NULL,
  cantidad INTEGER NOT NULL,
  categoria TEXT NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

### 4.2. Capturas de Pruebas en Postman / Thunder Client

1. **GET `/api/productos` (Listado general):**
   - *Pegar captura demostrando código de respuesta `200 OK` y el array JSON de productos con los 12 datos iniciales.*
2. **GET `/api/productos/stats` (Métricas del Dashboard):**
   - *Pegar captura mostrando `totalProductos: 12`, `totalUnidades: 295` y `valorTotalInventario`.*
3. **GET `/api/productos/:id` (Consulta por ID):**
   - *Pegar captura mostrando el detalle del producto #1 y otra con respuesta `404 Not Found` ante un ID inexistente.*
4. **POST `/api/productos` (Registro de nuevo producto):**
   - *Pegar captura mostrando respuesta `201 Created` con el ID autogenerado.*
   - *Pegar captura demostrando validación `422 Unprocessable Entity` al enviar código duplicado o precio negativo.*
5. **PUT `/api/productos/:id` (Actualización de producto):**
   - *Pegar captura modificando precio y cantidad con respuesta `200 OK`.*
6. **DELETE `/api/productos/:id` (Eliminación de producto):**
   - *Pegar captura eliminando un producto con código `200 OK`.*

---

## 5. Evidencias de la Aplicación Móvil en Flutter

### 5.1. Dashboard Principal
- *Pegar captura de la pantalla de inicio mostrando:*
  - Encabezado e identificación visual.
  - Tarjeta 1: Total de productos registrados.
  - Tarjeta 2: Total de unidades disponibles en inventario.
  - Tarjeta 3: Valor económico total del inventario (`suma de precio × cantidad`).
  - Accesos rápidos a la gestión de productos.

### 5.2. Menú de Navegación (BottomNavigationBar y Drawer)
- *Pegar captura desplegando el Drawer lateral y la barra inferior.*

### 5.3. Listado de Productos y Filtros
- *Pegar captura de la lista con nombre, precio, existencias y badges de stock.*
- *Pegar captura aplicando filtro por categorías o búsqueda.*

### 5.4. Consulta de Detalle de Producto
- *Pegar captura de la pantalla `/productos/detalle/:id` con todos los campos y valor total del stock.*

### 5.5. Formulario de Registro (POST)
- *Pegar captura del formulario con validaciones y SnackBar verde de confirmación.*

### 5.6. Formulario de Edición (PUT)
- *Pegar captura con los datos precargados y actualización.*

### 5.7. Eliminación con Diálogo de Confirmación (DELETE)
- *Pegar captura del modal de confirmación y posterior eliminación en vivo.*

---

## 6. Demostración de Persistencia Real de Datos
- *Explicación o captura demostrando que los datos se almacenan en el archivo `database.sqlite` y permanecen inalterados tras reiniciar la app y el servidor.*

---

## 7. Despliegue en la Nube (Bono 5% — Cumplido 🟢)
- **Proveedor:** Render.com
- **URL Pública del Backend:** [https://inventario-api-parcial2.onrender.com](https://inventario-api-parcial2.onrender.com)
- **Estado del Servicio:** `Live 🟢`
- *Pegar captura del Dashboard de Render mostrando el Web Service activo.*
- *Pegar captura de la app Flutter conectada a `https://inventario-api-parcial2.onrender.com/api` realizando operaciones.*
