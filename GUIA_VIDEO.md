# 🎬 Guía Completa de Grabación de Video — Taller JWT (Parcial 3)

Esta guía contiene todo lo que necesitas para grabar tu video de sustentación: el guión minuto a minuto, lo que debes decir, lo que debes mostrar en pantalla, y la explicación detallada de dónde se ve la validación del login en la aplicación.

---

## 📑 Índice Rápido
1. [Preparación Previa en 1 Clic](#1-preparación-previa-en-1-clic)
2. [Configuración de Conexión (Render vs Local)](#2-configuración-de-conexión-render-vs-local)
3. [Dónde se ve la Validación de Login en la Aplicación](#3-dónde-se-ve-la-validación-de-login-en-la-aplicación)
4. [Guión Minuto a Minuto del Video (Texto exacto a pronunciar)](#4-guión-minuto-a-minuto-del-video)
5. [Lista de Chequeo Final (Rúbrica 100%)](#5-lista-de-chequeo-final)

---

## 1. Preparación Previa en 1 Clic

1. Ve a la carpeta `parcial 3/` y haz doble clic sobre:
   👉 **`ABRIR_ENTORNO_VIDEO_JWT.bat`**
2. Se abrirán en tu pantalla:
   - **VS Code:** Con el código del backend y frontend.
   - **DB Browser for SQLite:** Con la base de datos `database.sqlite` (tabla `usuarios` y `productos`).
   - **Postman:** Para probar los endpoints.
   - **Emulador Android (Pixel 7):** Iniciando automáticamente.
   - **Backend:** Listo si deseas probar localmente.
3. **Espera a que el celular Android termine de encender** y muestre la pantalla de inicio con los íconos de Android.
4. Presiona cualquier tecla en la ventana negra del `.bat` para que compile y abra la aplicación Flutter directamente en el emulador.
5. Abre tu grabadora de pantalla (**OBS Studio**, **Clipchamp**, o presiona **`Win + G`** para Xbox Game Bar).

---

## 2. Configuración de Conexión (Render vs Local)

Tu backend ya está **100% desplegado en la nube en Render con seguridad JWT**:
* **URL en Render:** `https://inventario-api-parcial2.onrender.com/api`
* La app Flutter en `assets/.env` ya está conectada a esta URL.
* En **Postman** puedes hacer todas las pruebas directamente contra esta URL pública HTTPS.

---

## 3. Dónde se ve la Validación de Login en la Aplicación

Para tu explicación en el video, la validación se evidencia en 3 niveles:

### A. A Nivel Visual en la Aplicación Móvil (Lo que muestras al usuario)
1. **Validación de campos vacíos o formato erróneo:**
   - Si dejas el correo vacío o sin `@` ➔ Aparece el texto en rojo: *"Por favor ingrese su correo electrónico"* o *"Ingrese un formato de correo válido"*.
   - Si dejas la contraseña vacía ➔ *"Por favor ingrese su contraseña"*.
2. **Validación de credenciales incorrectas contra el backend (HTTP 401):**
   - Si ingresas un correo o contraseña que no coinciden (o presionas el chip rápido **"Inválida: error123"**):
   - El botón muestra un spinner de carga mientras consulta al servidor.
   - Al responder el servidor con código `401`, la pantalla despliega un **banner rojo destacado con ícono de advertencia**:  
     `[!] Credenciales inválidas. Correo electrónico o contraseña incorrectos.`
   - El acceso es denegado y te mantiene en la pantalla de login.
3. **Validación de credenciales correctas (HTTP 200 + JWT):**
   - Si seleccionas el chip **"Admin: admin123"** y presionas "Iniciar Sesión":
   - El backend entrega el token JWT.
   - La app muestra un **SnackBar flotante verde**: *"¡Bienvenido, Administrador Sistema!"*.
   - El usuario es redirigido inmediatamente al **Dashboard**.

### B. En el Código Fuente (Archivos en VS Code)
1. **Interfaz y Banner de Error:**  
   `frontend/lib/presentation/screens/login_screen.dart` (Líneas 100-120: contenedor condicional que dibuja el error cuando `authProvider.errorMessage != null`).
2. **Lógica de Estado y llamada a la API:**  
   `frontend/lib/providers/auth_provider.dart` (Método `login`: captura el error 401 y actualiza la interfaz).
3. **Guards de Navegación (Restricción de Acceso):**  
   `frontend/lib/config/router.dart` (Función `redirect`: si `isAuthenticated` es falso, nadie puede acceder a `/` ni a `/productos`, forzando la redirección a `/login`).
4. **Validación en el Backend:**  
   `backend/src/controllers/authController.js` (Método `login`: compara con `bcrypt.compare` y genera el token con `jwt.sign`).

---

## 4. Guión Minuto a Minuto del Video

### 🟢 Minuto 0:00 - 0:45 │ Presentación del Proyecto
* **Qué muestras:** La pantalla de inicio de la app o VS Code.
* **Lo que dices:**
  > *"Hola, profesor y compañeros. Mi nombre es [Tu Nombre] y presento la sustentación del Taller de Autenticación mediante JSON Web Tokens (JWT).*  
  > *Para esta entrega elegí la **Opción 1: Continuar con el proyecto del Parcial 2**, el cual corresponde a un Sistema de Gestión de Inventario con API REST y aplicación móvil en Flutter.*  
  > *El objetivo principal del taller es blindar el sistema implementando autenticación JWT en el backend y protegiendo las rutas CRUD, junto con un inicio de sesión seguro en Flutter mediante Dio, GoRouter, `flutter_secure_storage` y `shared_preferences`."*

---

### 🟢 Minuto 0:45 - 2:00 │ Implementación JWT en el Backend
* **Qué muestras en VS Code:** Carpeta `backend/src/` o `parcial 3/backend/src/`.
* **Lo que dices mientras muestras los archivos:**
  > 1. **`models/userModel.js` y `config/database.js`:** *"En la base de datos SQLite creamos la tabla `usuarios`, donde las contraseñas se almacenan cifradas mediante `bcryptjs` con 10 rondas de hashing. Tenemos usuarios de prueba como `admin@inventario.com` y `usuario@inventario.com`."*  
  > 2. **`controllers/authController.js`:** *"En el controlador de autenticación creamos el endpoint `POST /api/auth/login`. Si las credenciales no coinciden, rechazamos la petición con código 401. Si son correctas, firmamos y retornamos un token JWT con vigencia de 24 horas."*  
  > 3. **`middlewares/authMiddleware.js`:** *"Desarrollamos el middleware que intercepta la cabecera `Authorization: Bearer <token>`, validando la firma criptográfica con `jwt.verify`. Si falta el token o es inválido, bloquea el acceso con un error 401."*  
  > 4. **`routes/productRoutes.js`:** *"Aplicamos `router.use(authMiddleware)` en la raíz del recurso productos, asegurando que ninguna operación CRUD ni métrica del dashboard pueda consultarse sin token."*

---

### 🟢 Minuto 2:00 - 3:15 │ Integración en Flutter
* **Qué muestras en VS Code:** Carpeta `frontend/lib/` o `parcial 3/frontend/lib/`.
* **Lo que dices mientras muestras los archivos:**
  > 1. **`services/storage_service.dart`:** *"Para cumplir con el requisito 2.4 de almacenamiento híbrido, usamos `flutter_secure_storage` para guardar de forma cifrada el token JWT en el Keystore del dispositivo, y `shared_preferences` para la información no sensible del perfil de usuario como nombre, correo y rol."*  
  > 2. **`services/api_service.dart`:** *"En Dio configuramos interceptores: en cada petición saliente se inyecta automáticamente el token en `Authorization: Bearer <token>`. Y en el manejador de errores, si la API responde 401 por sesión expirada, se desautentica al usuario automáticamente."*  
  > 3. **`config/router.dart`:** *"En GoRouter implementamos un guard de redirección vinculado al estado de autenticación. Si un usuario no autenticado intenta ir al Dashboard o a Productos, el router lo expulsa directamente al login."*

---

### 🟢 Minuto 3:15 - 4:15 │ Demostración de Inicio de Sesión
* **Qué muestras:** La aplicación Flutter en el emulador.
* **Acciones a realizar:**
  1. **Credenciales Incorrectas:**  
     - Escribe `admin@inventario.com` y una clave incorrecta (o presiona el chip **"Inválida: error123"**).
     - Presiona **"Iniciar Sesión"**.
     - Muestra el **banner rojo de error** en pantalla y el status 401.
  2. **Credenciales Correctas:**  
     - Presiona el chip **"Admin: admin123"**.
     - Presiona **"Iniciar Sesión"**.
     - Muestra el **SnackBar verde de bienvenida** y la redirección automática al **Dashboard**.

---

### 🟢 Minuto 4:15 - 5:15 │ Consumo de Servicios CRUD Protegidos
* **Qué muestras:** La app Flutter autenticada.
* **Acciones a realizar:**
  1. Muestra el **Dashboard** cargando las estadísticas en tiempo real desde la API.
  2. Ve a la pestaña **Productos** y haz scroll mostrando la lista obtenida con el token.
  3. Presiona el botón `+` y **crea un producto**:  
     - Nombre: `Mouse Ergonómico Pro`  
     - Código: `MOU-777`  
     - Precio: `45.50`  
     - Cantidad: `15`  
     - Categoría: `Accesorios`  
     - Guarda y muestra cómo se agrega a la lista y cómo el Dashboard recalcula el inventario.
  4. Edítale el precio a `50.00` y guarda.
  5. Elimina el producto y confirma el diálogo.

---

### 🟢 Minuto 5:15 - 6:00 │ Prueba en Postman: Backend Rechaza Petición sin Token (401)
* **Qué muestras:** Postman.
* **Acciones a realizar:**
  1. Abre la petición `GET https://inventario-api-parcial2.onrender.com/api/productos`.
  2. En la pestaña **Authorization**, selecciona **No Auth** (sin token).
  3. Presiona **Send**.
  4. Muestra en pantalla el resultado:  
     - **Status:** `401 Unauthorized`.  
     - **Mensaje JSON:** `"Acceso no autorizado: Se requiere token de autenticación en la cabecera Authorization"`.
  5. *Comentario clave:*  
     > *"Esto comprueba que la protección existe verdaderamente en el backend, rechazando cualquier intento de consumo no autenticado."*

---

### 🟢 Minuto 6:00 - 7:00 │ Vista de Información de Sesión y Persistencia
* **Qué muestras:** La app Flutter.
* **Acciones a realizar:**
  1. Abre el menú lateral (Drawer) o la barra inferior y ve a **"Sesión"** (`/sesion`).
  2. **Muestra y explica los puntos del requisito 2.5:**
     - Nombre del usuario: `Administrador Sistema`.
     - Correo electrónico: `admin@inventario.com`.
     - Estado: `Sesión Activa 🟢`.
     - **Indicador de Token Almacenado:** Muestra cómo el token aparece enmascarado (ej. `eyJhbGciOi...[TOKEN_PROTEGIDO_JWT]...t3Yw`), **sin revelar el contenido sensible completo**.
     - Indica que el token reside en `flutter_secure_storage` y el perfil en `shared_preferences`.
  3. **Demostración de Persistencia:**  
     - Cierra la aplicación Flutter completamente (mata la app en el emulador).
     - Vuelve a abrirla.
     - Muestra que entra **directamente al Dashboard** sin pedir login de nuevo, porque recuperó la sesión desde el almacenamiento seguro.

---

### 🟢 Minuto 7:00 - 7:45 │ Cierre de Sesión y Restricción Posterior
* **Qué muestras:** La app Flutter en la pantalla de Sesión.
* **Acciones a realizar:**
  1. Presiona el botón rojo **"Cerrar Sesión"**.
  2. Confirma en el diálogo modal.
  3. Muestra cómo:
     - Se eliminan las credenciales de `flutter_secure_storage` y `shared_preferences`.
     - La app expulsa inmediatamente al usuario a la pantalla de **Login**.
  4. Intenta presionar el botón "Atrás" de Android y muestra que **el acceso al Dashboard y a los productos queda completamente restringido**.

---

### 🟢 Minuto 7:45 - 8:00 │ Conclusión
* **Lo que dices:**
  > *"Con esto queda evidenciado el cumplimiento completo de todos los requisitos técnicos del taller: autenticación JWT en backend y frontend, almacenamiento híbrido seguro, persistencia, control de errores y restricción de acceso. Muchas gracias por su atención."*

---

## 5. Lista de Chequeo Final (Checklist)

- [ ] ¿El backend en Render está respondiendo (`https://inventario-api-parcial2.onrender.com/api`)?
- [ ] ¿El emulador Android está visible y encendido?
- [ ] ¿Mostraste el login fallido (banner rojo 401) y luego el exitoso?
- [ ] ¿Mostraste las operaciones CRUD en la aplicación?
- [ ] ¿Mostraste la petición en Postman sin token rechazada con 401?
- [ ] ¿Mostraste la pantalla de Información de Sesión con el token enmascarado?
- [ ] ¿Demostraste la persistencia cerrando y abriendo la app?
- [ ] ¿Demostraste el cierre de sesión y el bloqueo de acceso?
- [ ] ¿Mencionaste el repositorio en GitHub ([https://github.com/Sarincon508/Parcial-moviles-2](https://github.com/Sarincon508/Parcial-moviles-2))?
