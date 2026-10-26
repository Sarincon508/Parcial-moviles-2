# 📦 Sistema de Gestión de Inventario — Parcial 2 Móviles

Solución informática completa para la gestión y control de inventario de productos en un establecimiento comercial, compuesta por una **API REST propia con persistencia en base de datos SQLite** y una **aplicación móvil desarrollada en Flutter** que consume dicha API mediante la librería **Dio**, navegación con **GoRouter** y gestión de estado reactiva con **Provider**.

---

## 📑 Tabla de Contenidos

1. [Descripción General](#-descripción-general)
2. [Arquitectura del Proyecto](#-arquitectura-del-proyecto)
3. [Tecnologías Utilizadas](#-tecnologías-utilizadas)
4. [Estructura del Repositorio](#-estructura-del-repositorio)
5. [Instalación y Puesta en Marcha](#-instalación-y-puesta-en-marcha)
   - [Backend (API REST)](#1-ejecución-del-backend-nodejs)
   - [Frontend (Flutter)](#2-ejecución-del-frontend-flutter)
6. [Descripción de la Base de Datos](#-descripción-de-la-base-de-datos)
7. [Endpoints de la API REST](#-endpoints-de-la-api-rest)
8. [Ejemplos de Peticiones y Respuestas JSON](#-ejemplos-de-peticiones-y-respuestas-json)
9. [Funcionalidades de la Aplicación Móvil](#-funcionalidades-de-la-aplicación-móvil)
10. [Colección para Pruebas (Postman / Thunder Client)](#-colección-para-pruebas)
11. [Guías y Entregables](#-guías-y-entregables)
12. [Despliegue en la Nube (Opcional 5%)](#-despliegue-en-la-nube-opcional-5)

---

## 🌟 Descripción General

El sistema permite a un establecimiento comercial administrar integralmente su catálogo de productos. A diferencia de soluciones basadas en listas estáticas en memoria, toda la información se almacena permanentemente en una base de datos relacional y se sincroniza en tiempo real entre el servidor y los dispositivos móviles.

La aplicación móvil cuenta con un **Dashboard analítico** que calcula en tiempo real:
- Total de productos registrados.
- Total de existencias físicas disponibles.
- Valor económico total del inventario ($\sum \text{precio} \times \text{cantidad}$).

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

> 💡 **Nota sobre la URL de la API:**
> - En **Windows Desktop** y **Web**, la app se conecta a `http://localhost:3000/api`.
> - En el **Emulador Android**, la app detecta automáticamente el emulador y redirige a `http://10.0.2.2:3000/api`.
> - Además, la aplicación incluye una ventana de configuración (ícono de engranaje ⚙️ en el Dashboard) para cambiar la URL en caliente sin tener que recompilar el código.

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

### 3. Registrar Producto (`POST /api/productos`)
**Cuerpo de la Petición:**
```json
{
  "nombre": "Silla Ergonómica Pro",
  "codigo": "PROD-100",
  "descripcion": "Soporte lumbar ajustable y apoyabrazos 3D",
  "precio": 179.99,
  "cantidad": 8,
  "categoria": "Mobiliario"
}
```
**Respuesta (`201 Created`):**
```json
{
  "success": true,
  "message": "Producto registrado exitosamente.",
  "data": {
    "id": 13,
    "nombre": "Silla Ergonómica Pro",
    "codigo": "PROD-100",
    "descripcion": "Soporte lumbar ajustable y apoyabrazos 3D",
    "precio": 179.99,
    "cantidad": 8,
    "categoria": "Mobiliario",
    "created_at": "2026-10-26 16:10:00",
    "updated_at": "2026-10-26 16:10:00"
  }
}
```

### 4. Error de Validación (`POST /api/productos` con código duplicado o precio inválido)
**Respuesta (`422 Unprocessable Entity`):**
```json
{
  "success": false,
  "message": "El código \"PROD-100\" ya está registrado en otro producto.",
  "errors": [
    {
      "field": "codigo",
      "message": "El código del producto ya existe en el inventario."
    }
  ]
}
```

---

## 📱 Funcionalidades de la Aplicación Móvil

1. **Dashboard Principal:**
   - 3 tarjetas con diseño moderno en degradé con las métricas calculadas en tiempo real.
   - Acceso rápido a las opciones del menú y recarga manual.
2. **Gestión de Productos (CRUD Completo):**
   - **Listado:** visualización con tarjetas, indicador de disponibilidad según el nivel de stock (verde, naranja, rojo).
   - **Búsqueda & Filtro:** barra de búsqueda dinámica y chips horizontales por categorías.
   - **Detalle:** vista completa con cálculo automático del valor total acumulado del stock.
   - **Registro:** formulario con validación interactiva de campos y formateadores numéricos.
   - **Edición:** precarga de datos existentes y envío mediante método PUT.
   - **Eliminación:** confirmación obligatoria mediante cuadro de diálogo modal antes de ejecutar la petición DELETE.
3. **Manejo de Estados de UI:**
   - Vistas dedicadas para estado de **Carga** (`CircularProgressIndicator`), **Error** con botón de reintento y **Vacío** con llamado a la acción.
   - Mensajes emergentes (`SnackBar`) flotantes con código de color (verde para éxito, rojo para error).

---

## 🧪 Colección para Pruebas

En la carpeta `docs/` se incluye el archivo:
- [`docs/api_collection.json`](file:///F:/Users/Max/Desktop/moviles/parcial%202/docs/api_collection.json)

Puedes importarlo directamente en **Postman** o en la extensión **Thunder Client** de Visual Studio Code para ejecutar y demostrar todas las peticiones HTTP de forma inmediata.

---

## 📚 Guías y Entregables

- [Guion y Metodología para la Grabación del Video](file:///F:/Users/Max/Desktop/moviles/parcial%202/GUIA_VIDEO_Y_EXPOSICION.md): Minutero y texto sugerido para la exposición en video.
- [Plantilla del Documento PDF de Evidencias](file:///F:/Users/Max/Desktop/moviles/parcial%202/GUIA_PDF_EVIDENCIAS.md): Estructura para armar el documento de entrega con capturas.
- [Guía de Despliegue en la Nube](file:///F:/Users/Max/Desktop/moviles/parcial%202/GUIA_DESPLIEGUE_OPCIONAL.md): Instrucciones para desplegar gratis en Render o Railway (Bono del 5%).

---

## ☁️ Despliegue en la Nube (Opcional 5%)

El backend está 100% preparado y configurado con `render.yaml` para despliegue automático en la nube gratuita de **Render.com**.

### Despliegue en 1 Clic con Render:

[![Deploy to Render](https://render.com/images/deploy-to-render-button.svg)](https://render.com/deploy?repo=https://github.com/Sarincon508/Parcial-moviles-2)

1. Haz clic en el botón **"Deploy to Render"** de arriba (o inicia sesión con tu GitHub en [render.com](https://render.com)).
2. Render detectará automáticamente el archivo `render.yaml` configurado en el repositorio:
   - Directorio raíz: `backend`
   - Comando de compilación: `npm install`
   - Comando de inicio: `npm start`
   - Variables de entorno preconfiguradas.
3. Presiona **"Apply"** o **"Create Web Service"**.
4. En 1 minuto obtendrás tu URL pública con HTTPS gratis, por ejemplo:
   `https://inventario-api-parcial2.onrender.com`
5. Conecta tu app móvil Flutter ingresando dicha URL en la app o en `frontend/assets/.env`.

---

## 👤 Autor
- **Estudiante:** Samuel Alejandro Rincon Serna
- **Repositorio:** [https://github.com/Sarincon508/Parcial-moviles-2.git](https://github.com/Sarincon508/Parcial-moviles-2.git)
- **Licencia:** MIT
