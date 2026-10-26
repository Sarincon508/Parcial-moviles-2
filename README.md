# 📦 Sistema de Gestión de Inventario — Parcial 2 Móviles

Solución informática completa para la gestión y control de inventario de productos en un establecimiento comercial, compuesta por una **API REST propia con persistencia en base de datos SQLite** y una **aplicación móvil desarrollada en Flutter** que consume dicha API mediante la librería **Dio**, navegación con **GoRouter** y gestión de estado reactiva con **Provider**.

---

## 📑 Tabla de Contenidos

1. [Descripción General](#-descripción-general)
2. [Despliegue en la Nube (Opcional 5%)](#-despliegue-en-la-nube-opcional-5--activo-y-en-producción-)
3. [Arquitectura del Proyecto](#-arquitectura-del-proyecto)
4. [Tecnologías Utilizadas](#-tecnologías-utilizadas)
5. [Estructura del Repositorio](#-estructura-del-repositorio)
6. [Instalación y Puesta en Marcha](#-instalación-y-puesta-en-marcha)
   - [Backend (API REST)](#1-ejecución-del-backend-nodejs)
   - [Frontend (Flutter)](#2-ejecución-del-frontend-flutter)
7. [Descripción de la Base de Datos](#-descripción-de-la-base-de-datos)
8. [Endpoints de la API REST](#-endpoints-de-la-api-rest)
9. [Ejemplos de Peticiones y Respuestas JSON](#-ejemplos-de-peticiones-y-respuestas-json)
10. [Funcionalidades de la Aplicación Móvil](#-funcionalidades-de-la-aplicación-móvil)
11. [Colección para Pruebas (Postman / Thunder Client)](#-colección-para-pruebas)
12. [Guías y Entregables](#-guías-y-entregables)

---

## 🌟 Descripción General

El sistema permite a un establecimiento comercial administrar integralmente su catálogo de productos. A diferencia de soluciones basadas en listas estáticas en memoria, toda la información se almacena permanentemente en una base de datos relacional y se sincroniza en tiempo real entre el servidor y los dispositivos móviles.

La aplicación móvil cuenta con un **Dashboard analítico** que calcula en tiempo real:
- Total de productos registrados.
- Total de existencias físicas disponibles.
- Valor económico total del inventario ($\sum \text{precio} \times \text{cantidad}$).

---

## ☁️ Despliegue en la Nube (Opcional 5%) — ¡Activo y en Producción! 🟢

El backend se encuentra desplegado y accesible públicamente con HTTPS en **Render**:

- **URL Pública del Backend:** [https://inventario-api-parcial2.onrender.com](https://inventario-api-parcial2.onrender.com)
- **Endpoint de Productos:** [https://inventario-api-parcial2.onrender.com/api/productos](https://inventario-api-parcial2.onrender.com/api/productos)
- **Endpoint de Estadísticas:** [https://inventario-api-parcial2.onrender.com/api/productos/stats](https://inventario-api-parcial2.onrender.com/api/productos/stats)

La aplicación Flutter en `frontend/assets/.env` está configurada por defecto para consumir directamente este servidor en la nube.

---

## 🏛️ Arquitectura del Proyecto

El proyecto aplica una estricta **separación de responsabilidades**:

```
                              ┌────────────────────────────────────────┐
                              │            FLUTTER MOBILE              │
                              │  (Material 3, GoRouter, Provider)      │
                              └──────────────────┬─────────────────────┘
                                                 │
                                           Peticiones HTTP
                                        (Dio + flutter_dotenv)
                                                 │
                                                 ▼
                              ┌────────────────────────────────────────┐
                              │            API REST BACKEND            │
                              │       (Node.js + Express.js)           │
                              └──────────────────┬─────────────────────┘
                                                 │
                                            Consultas SQL
                                        (sqlite3 con Promises)
                                                 │
                                                 ▼
                              ┌────────────────────────────────────────┐
                              │      BASE DE DATOS PERSISTENTE         │
                              │            SQLite (.sqlite)            │
                              └────────────────────────────────────────┘
```

- **Cero peticiones directas en widgets visuales:** La interfaz interactúa exclusivamente a través del `ProductProvider`, el cual delega en `ProductService` y en `ApiService`.
- **Manejo tipado de errores:** Excepciones HTTP, timeouts y errores de validación (422) son transformados en mensajes claros para el usuario mediante SnackBars informativos.

---

## 🚀 Tecnologías Utilizadas

### Backend
- **Node.js** (v18+)
- **Express.js** (v4.21)
- **SQLite3** (Base de datos relacional con archivo persistente en disco)
- **CORS** (Permite peticiones desde emuladores Android, web y dispositivos físicos)
- **Morgan** (Logger HTTP para desarrollo)
- **Dotenv** (Configuración de entorno)

### Frontend Móvil
- **Flutter Framework** (v3.24+)
- **Dart SDK** (v3.5+)
- **Dio** (v5.11+): Cliente HTTP avanzado para peticiones asíncronas con interceptores y timeouts.
- **go_router** (v18.1+): Enrutamiento declarativo y navegación anidada con ShellRoute.
- **flutter_dotenv** (v6.0+): Gestión desacoplada de la URL del backend mediante archivo `.env`.
- **provider** (v6.1+): Manejo de estado reactivo y separación de la lógica de negocio.
- **intl** (v0.20+): Formateo numérico y de moneda localizado.

---

## 📂 Estructura del Repositorio

```
.
├── backend/                         # Proyecto API REST
│   ├── src/
│   │   ├── config/
│   │   │   └── database.js          # Conexión SQLite y Seeder inicial (12 productos)
│   │   ├── controllers/
│   │   │   └── productController.js # Lógica de los endpoints CRUD y métricas
│   │   ├── middlewares/
│   │   │   ├── errorHandler.js      # Manejador centralizado de errores y 404
│   │   │   └── validator.js         # Validaciones de integridad, tipos y unicidad
│   │   ├── models/
│   │   │   └── productModel.js      # Consultas SQL preparadas
│   │   ├── routes/
│   │   │   └── productRoutes.js     # Mapeo de rutas HTTP
│   │   └── app.js                   # Configuración de Express y middlewares
│   ├── .env.example                 # Variables de entorno de ejemplo
│   ├── .gitignore
│   ├── database.sqlite              # Base de datos física persistente
│   ├── package.json
│   ├── server.js                    # Arranque del servidor HTTP
│   └── README.md
│
├── frontend/                        # Proyecto Móvil Flutter
│   ├── android/                     # Configuración Android con permisos de Internet
│   ├── assets/
│   │   └── .env                     # Configuración de URL base de la API
│   ├── lib/
│   │   ├── config/
│   │   │   ├── env.dart             # Lectura de variables de entorno y auto-adaptador
│   │   │   ├── router.dart          # Configuración de go_router y rutas
│   │   │   └── theme.dart           # Tema visual Material 3
│   │   ├── models/
│   │   │   ├── product.dart         # Modelo de datos Producto
│   │   │   └── inventory_stats.dart # Modelo de estadísticas del Dashboard
│   │   ├── services/
│   │   │   ├── api_service.dart     # Cliente Dio con interceptor y manejo de errores
│   │   │   └── product_service.dart # Métodos CRUD que consumen la API
│   │   ├── providers/
│   │   │   └── product_provider.dart# Gestor de estado reactivo
│   │   ├── presentation/
│   │   │   ├── screens/
│   │   │   │   ├── main_layout_screen.dart    # Shell con BottomNavigationBar y Drawer
│   │   │   │   ├── dashboard_screen.dart      # Pantalla de métricas clave
│   │   │   │   ├── product_list_screen.dart   # Listado, búsqueda y filtros
│   │   │   │   ├── product_detail_screen.dart # Consulta completa por ID
│   │   │   │   └── product_form_screen.dart   # Formulario unificado de Crear/Editar
│   │   │   └── widgets/
│   │   │       ├── metric_card.dart           # Tarjetas con gradiente para el Dashboard
│   │   │       ├── product_card.dart          # Tarjeta de producto con acciones
│   │   │       └── status_views.dart          # Loading, Error, Empty, Diálogos
│   │   └── main.dart                # Punto de entrada de la aplicación
│   ├── pubspec.yaml
│   └── .env.example
│
├── docs/
│   └── api_collection.json          # Colección importable para Postman y Thunder Client
│
├── GUIA_VIDEO_Y_EXPOSICION.md       # Guion paso a paso y minutero para grabar el video
├── GUIA_PDF_EVIDENCIAS.md           # Estructura y plantilla para el informe PDF
├── GUIA_DESPLIEGUE_OPCIONAL.md      # Instrucciones para desplegar en Render/Railway (5%)
├── render.yaml                      # Configuración de infraestructura en Render
└── README.md                        # Documentación principal
```

---

## 🛠️ Instalación y Puesta en Marcha

### 1. Ejecución del Backend (Node.js)

```bash
# 1. Navegar a la carpeta backend
cd backend

# 2. Instalar dependencias
npm install

# 3. Iniciar el servidor
npm start
```

El backend se iniciará en `http://localhost:3000`. Al arrancar por primera vez, creará la base de datos `database.sqlite` y sembrará automáticamente **12 productos de prueba**.

---

### 2. Ejecución del Frontend (Flutter)

```bash
# 1. Navegar a la carpeta frontend
cd frontend

# 2. Descargar paquetes de Flutter
flutter pub get

# 3. Ejecutar la aplicación
# Para Windows Desktop:
flutter run -d windows

# Para Emulador Android:
flutter run -d android

# Para Google Chrome (Web):
flutter run -d chrome
```

---

## 🗄️ Descripción de la Base de Datos

La base de datos relacional utiliza **SQLite** y cuenta con la siguiente tabla:

### Tabla: `productos`

| Campo | Tipo SQL | Restricciones | Descripción |
| :--- | :--- | :--- | :--- |
| `id` | `INTEGER` | `PRIMARY KEY AUTOINCREMENT` | Identificador único autogenerado. |
| `nombre` | `TEXT` | `NOT NULL` | Nombre descriptivo del producto. |
| `codigo` | `TEXT` | `UNIQUE NOT NULL` | Código único de referencia (ej. `PROD-001`). |
| `descripcion` | `TEXT` | `NULL` | Información detallada u opcional. |
| `precio` | `REAL` | `NOT NULL, CHECK (precio > 0)` | Precio unitario con decimales. |
| `cantidad` | `INTEGER` | `NOT NULL, CHECK (cantidad >= 0)` | Unidades físicas disponibles en stock. |
| `categoria` | `TEXT` | `NOT NULL` | Clasificación o departamento del producto. |
| `created_at` | `DATETIME` | `DEFAULT CURRENT_TIMESTAMP` | Fecha de creación del registro. |
| `updated_at` | `DATETIME` | `DEFAULT CURRENT_TIMESTAMP` | Fecha de última modificación. |

---

## 📡 Endpoints de la API REST

| Método | Endpoint | Descripción | Códigos HTTP |
| :--- | :--- | :--- | :--- |
| **GET** | `/` | Información del servicio y estado | `200` |
| **GET** | `/api/productos` | Listar todos los productos (permite `?search=` y `?categoria=`) | `200`, `500` |
| **GET** | `/api/productos/stats` | Estadísticas del Dashboard (Totales y Valorización) | `200`, `500` |
| **GET** | `/api/productos/categorias` | Obtener categorías disponibles | `200`, `500` |
| **GET** | `/api/productos/:id` | Consultar el detalle completo de un producto por ID | `200`, `400`, `404` |
| **POST** | `/api/productos` | Registrar un nuevo producto con validación | `201`, `422`, `500` |
| **PUT** | `/api/productos/:id` | Actualizar un producto existente | `200`, `400`, `404`, `422` |
| **DELETE** | `/api/productos/:id` | Eliminar físicamente un producto | `200`, `400`, `404`, `500` |

---

## 📄 Ejemplos de Peticiones y Respuestas JSON

### 1. Listar Productos (`GET /api/productos`)
**Respuesta (`200 OK`):**
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

### 2. Estadísticas del Dashboard (`GET /api/productos/stats`)
**Respuesta (`200 OK`):**
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

---

## 🧪 Colección para Pruebas

En la carpeta `docs/` se incluye el archivo:
- [`docs/api_collection.json`](file:///F:/Users/Max/Desktop/moviles/parcial%202/docs/api_collection.json)

Puedes importarlo directamente en **Postman** o en la extensión **Thunder Client** de Visual Studio Code para ejecutar y demostrar todas las peticiones HTTP de forma inmediata.

---

## 📚 Guías y Entregables

- [Guion y Metodología para la Grabación del Video](file:///F:/Users/Max/Desktop/moviles/parcial%202/GUIA_VIDEO_Y_EXPOSICION.md): Minutero y texto sugerido para la exposición en video.
- [Plantilla del Documento PDF de Evidencias](file:///F:/Users/Max/Desktop/moviles/parcial%202/GUIA_PDF_EVIDENCIAS.md): Estructura para armar el documento de entrega con capturas.
- [Guía de Despliegue en la Nube](file:///F:/Users/Max/Desktop/moviles/parcial%202/GUIA_DESPLIEGUE_OPCIONAL.md): Instrucciones de Render (Bono del 5%).

---

## 👤 Autor
- **Estudiante:** Samuel Alejandro Rincon Serna
- **Repositorio:** [https://github.com/Sarincon508/Parcial-moviles-2.git](https://github.com/Sarincon508/Parcial-moviles-2.git)
- **Licencia:** MIT
