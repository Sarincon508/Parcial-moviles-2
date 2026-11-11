# Sistema de Gestión de Inventario con Autenticación JWT (Parcial 3 / Taller JWT)

Este proyecto corresponde a la extensión del **Parcial 2**, incorporando **Autenticación mediante JSON Web Tokens (JWT)** tanto en la API REST (Backend Node.js/Express/SQLite) como en la aplicación móvil desarrollada en **Flutter (Dio + Provider + GoRouter)**.

---

## 🚀 Arquitectura y Tecnologías Utilizadas

### Backend (API REST)
- **Node.js & Express**: Arquitectura en capas (Controladores, Modelos, Rutas, Middlewares).
- **SQLite3**: Persistencia de productos y usuarios con contraseñas cifradas.
- **bcryptjs**: Hashing seguro de contraseñas con salt rounds.
- **jsonwebtoken (JWT)**: Generación y verificación criptográfica de tokens con expiración de 24 horas.
- **Middleware de Seguridad (`authMiddleware.js`)**: Valida el encabezado `Authorization: Bearer <token>` y protege todas las operaciones CRUD y estadísticas del inventario. Peticiones sin token o con token alterado reciben respuesta HTTP `401 Unauthorized`.

### Frontend (Flutter Mobile & Desktop)
- **Dio**: Cliente HTTP con interceptores para inyectar automáticamente el token JWT en el encabezado `Authorization` y para detectar respuestas `401 Unauthorized` (sesión expirada o inválida).
- **Almacenamiento Seguro Híbrido**:
  - `flutter_secure_storage`: Almacenamiento cifrado a nivel de sistema operativo (Android Keystore / iOS Keychain / Windows DPAPI) para el `access_token` JWT.
  - `shared_preferences`: Almacenamiento de datos de perfil no sensibles del usuario (nombre, correo electrónico, rol).
- **GoRouter**: Protección de rutas mediante `redirect` y `refreshListenable: authProvider`. Un usuario sin sesión es redirigido automáticamente a `/login` al intentar acceder al Dashboard o Productos.
- **Provider**: Gestión de estado reactiva (`AuthProvider` y `ProductProvider`).
- **Vista de Información de Sesión**: Visualización del nombre, correo, estado activo/inactivo, indicador de presencia del token (enmascarado sin revelar la carga completa) y botón de cierre de sesión.

---

## 🔑 Credenciales de Prueba Precargadas

| Rol | Correo Electrónico | Contraseña | Permisos |
| :--- | :--- | :--- | :--- |
| **Administrador** | `admin@inventario.com` | `admin123` | Acceso total al inventario y estadísticas |
| **Operador** | `usuario@inventario.com` | `user123` | Acceso estándar |

> **Nota:** La pantalla de Login incluye botones de acceso rápido para cargar estas credenciales con un solo toque.

---

## 🛠️ Instrucciones de Ejecución

### 1. Iniciar el Backend
```bash
cd "parcial 3/backend"
npm install
npm run dev
# O para iniciar directamente:
npm start
```
El backend estará disponible en `http://localhost:3000` (con endpoints bajo `http://localhost:3000/api`).

Para ejecutar las pruebas automáticas del backend:
```bash
npm run test:jwt
```

### 2. Iniciar la Aplicación Flutter
```bash
cd "parcial 3/frontend"
flutter pub get
flutter run
```

> **Conexión con el dispositivo:**
> - En **Windows / macOS / Web / Emulador iOS**: se conecta automáticamente a `http://localhost:3000/api`.
> - En **Emulador de Android**: `Env.dart` mapea automáticamente `localhost` a `10.0.2.2:3000/api`.
> - También puede cambiarse la URL en tiempo de ejecución desde el menú lateral o pantalla de login mediante el diálogo de configuración.

---

## 🧪 Demostración de Escenarios de Prueba Obligatorios

| # | Escenario Obligatorio | Procedimiento | Resultado Esperado |
| :---: | :--- | :--- | :--- |
| **1** | **Acceso sin autenticación** | Intentar abrir la app o navegar a `/` o `/productos` sin haber iniciado sesión. | GoRouter redirige de inmediato a `/login`. No se muestra el Dashboard ni los productos. |
| **2** | **Credenciales incorrectas** | Ingresar un correo o contraseña incorrectos en el formulario de login. | La API responde HTTP 401 y la app muestra un mensaje de error claro en pantalla sin iniciar sesión. |
| **3** | **Inicio de sesión correcto** | Ingresar `admin@inventario.com` / `admin123`. | La API retorna 200 con el token JWT. La app almacena el token en `flutter_secure_storage`, guarda el perfil en `shared_preferences` y redirige al Dashboard. |
| **4** | **Consumo de servicios protegidos** | Consultar métricas, listar productos, crear, editar o eliminar productos. | Dio inyecta `Authorization: Bearer <token>` en cada solicitud. El backend valida el token y autoriza las operaciones CRUD. |
| **5** | **Persistencia de sesión** | Cerrar la aplicación por completo y volver a abrirla. | `AuthProvider.checkAuthStatus()` recupera el token de `flutter_secure_storage` y los datos de `shared_preferences`, manteniendo la sesión activa sin solicitar login de nuevo. |
| **6** | **Validación directa desde backend** | Ejecutar petición `GET http://localhost:3000/api/productos` sin cabecera `Authorization` (en Postman o curl). | El backend responde HTTP 401: `Acceso no autorizado: Se requiere token de autenticación`. |
| **7** | **Cierre de sesión (Logout)** | Presionar el botón "Cerrar Sesión" en la pantalla de Información de Sesión o en el menú lateral. | Se purgan los datos de `flutter_secure_storage` y `shared_preferences`, y el usuario es redirigido inmediatamente a `/login`. |

---

## 📮 Colección Postman

En la carpeta `parcial 3/postman` se incluye el archivo:
- `Taller_JWT_Inventario_API.postman_collection.json`

Importe esta colección en Postman para probar de forma directa:
1. `POST /api/auth/login` (guarda automáticamente el token en `{{jwt_token}}`).
2. `POST /api/auth/login` con credenciales incorrectas (verifica el rechazo con 401).
3. `GET /api/auth/perfil` con token.
4. `GET /api/productos` sin token (comprueba la protección del backend con 401).
5. Operaciones CRUD (GET, POST, PUT, DELETE) con `Bearer {{jwt_token}}`.

---

## 🌿 Flujo de Trabajo Git (GitFlow)

- **Rama base:** `dev`
- **Rama de características:** `feature/taller_jwt`
- **Integración:** Pull Request hacia `dev` y posterior fusión hacia `main`.
