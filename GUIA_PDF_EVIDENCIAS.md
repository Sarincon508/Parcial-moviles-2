# Plantilla y Contenido para el Documento PDF de Evidencias

Este documento sirve como guía y contenido estructurado para armar el **PDF de Evidencias** exigido en el punto **8.3** de la entrega. Puedes copiar este contenido directamente a Microsoft Word, Google Docs o Canva y guardarlo como archivo `.pdf`.

---

# INFORME DE EVIDENCIAS — SEGUNDO PARCIAL PROGRAMACIÓN MÓVIL
## Sistema de Gestión de Inventario con API REST y Flutter

---

## 1. Identificación del Estudiante
- **Nombre Completo:** [Tu Nombre Completo Aquí]
- **Código Estudiantil:** [Tu Código / ID Aquí]
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
| **API Desplegada (Opcional 5%)** | *[PEGA AQUÍ TU URL HTTPS DE RENDER O RAILWAY]* | API REST en producción con SQLite persistente |

> ⚠️ **Nota Importante:** Verifique que el enlace del video en YouTube esté en modo **"Oculto" (Unlisted)** o en Google Drive con acceso para **"Cualquier persona que tenga el enlace"**, para que el evaluador pueda reproducirlo sin solicitar permisos.

---

## 3. Descripción de las Tecnologías Utilizadas

### 3.1. Backend (API REST)
- **Node.js & Express.js:** Entorno de ejecución y framework minimalista para construcción de APIs RESTful asíncronas de alto rendimiento.
- **SQLite3:** Base de datos relacional ligera embebida con persistencia física en disco (`database.sqlite`).
- **CORS:** Middleware que habilita la interoperabilidad y consumo cruzado entre el backend y clientes Web, Android, iOS y Desktop.
- **Validaciones & Middlewares:** Control de integridad de datos (código único, campos obligatorios, cantidades y precios válidos con código HTTP 422).
- **Dotenv:** Administración segura de variables de entorno del servidor.

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
*(Inserta aquí las capturas de pantalla de tus pruebas)*

1. **GET `/api/productos` (Listado general):**
   - *Captura demostrando código de respuesta `200 OK` y el array JSON de productos con los datos iniciales sembrados.*
2. **GET `/api/productos/stats` (Métricas del Dashboard):**
   - *Captura mostrando `totalProductos`, `totalUnidades` y `valorTotalInventario`.*
3. **GET `/api/productos/:id` (Consulta por ID):**
   - *Captura mostrando el detalle del producto #1 y otra mostrando respuesta `404 Not Found` ante un ID inexistente.*
4. **POST `/api/productos` (Registro de nuevo producto):**
   - *Captura mostrando respuesta `201 Created` con el ID autogenerado.*
   - *Captura mostrando error `422 Unprocessable Entity` al intentar ingresar un código duplicado o precio negativo.*
5. **PUT `/api/productos/:id` (Actualización de producto):**
   - *Captura demostrando la modificación de precio y cantidad con código `200 OK`.*
6. **DELETE `/api/productos/:id` (Eliminación de producto):**
   - *Captura demostrando la eliminación exitosa con respuesta `200 OK`.*

---

## 5. Evidencias de la Aplicación Móvil en Flutter

*(Inserta aquí las capturas de la aplicación corriendo en tu emulador o dispositivo)*

### 5.1. Dashboard Principal
- *Captura de la pantalla de inicio mostrando:*
  - Nombre de la aplicación y encabezado visual.
  - Tarjeta 1: Total de productos registrados.
  - Tarjeta 2: Total de unidades disponibles en inventario.
  - Tarjeta 3: Valor económico total del inventario (`suma de precio × cantidad`).
  - Botones de acceso rápido a la gestión de productos.

### 5.2. Menú de Navegación (BottomNavigationBar y Drawer)
- *Captura desplegando el Drawer lateral y la barra inferior implementada con `go_router`.*

### 5.3. Listado de Productos y Filtros
- *Captura mostrando la lista de tarjetas con nombre, precio unitario, unidades disponibles y etiquetas de estado de stock (disponible, bajo stock o agotado).*
- *Captura aplicando filtro por categoría o búsqueda por texto.*

### 5.4. Consulta de Detalle de Producto
- *Captura de la pantalla `/productos/detalle/:id` con la información completa: ID, código, nombre, categoría, precio, existencias, cálculo del valor total acumulado y descripción.*

### 5.5. Formulario de Registro (POST)
- *Captura del formulario validado al ingresar un nuevo producto.*
- *Captura del SnackBar de éxito tras el registro.*

### 5.6. Formulario de Edición (PUT)
- *Captura con los campos precargados y actualización de datos.*

### 5.7. Eliminación con Diálogo de Confirmación (DELETE)
- *Captura del diálogo modal `ConfirmDeleteDialog` preguntando al usuario si desea eliminar el producto.*
- *Captura del SnackBar confirmando la eliminación y lista actualizada.*

---

## 6. Demostración de Persistencia Real de Datos
- *Captura o explicación evidenciando que al reiniciar la aplicación móvil y el servidor backend, los registros creados y modificados permanecen intactos dentro del archivo `database.sqlite`.*

---

## 7. Despliegue en la Nube (Opcional — 5%)
*(Completar esta sección si realizaste el despliegue)*
- **Proveedor en la Nube:** [Render / Railway / Fly.io]
- **URL Pública del Backend:** `https://tu-api.onrender.com`
- **Captura del Dashboard del proveedor:** Demostrando el servicio activo en producción.
- **Captura de la App Flutter conectada a la URL remota:** Evidenciando las operaciones CRUD ejecutadas contra el servidor en la nube.
