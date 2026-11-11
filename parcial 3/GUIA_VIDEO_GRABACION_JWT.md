# 🎬 Guía y Libreto Paso a Paso para la Grabación del Video (Taller JWT)

Esta guía contiene la estructura exacta, el guión minuto a minuto y la lista de acciones que debes mostrar en pantalla para cumplir con el 100% de la rúbrica de evaluación.

---

## ⏱️ Estructura del Video (Duración estimada: 7 a 9 minutos)

```
0:00 - 0:45 │ 1. Presentación y Opción Seleccionada
0:45 - 2:00 │ 2. Explicación de la Implementación Backend (JWT, bcrypt, Middleware)
2:00 - 3:15 │ 3. Explicación de la Integración Frontend (Dio, Secure Storage, Router)
3:15 - 4:15 │ 4. Demostración de Login: Credenciales Incorrectas vs Correctas
4:15 - 5:15 │ 5. Demostración de Servicios CRUD Protegidos en Flutter
5:15 - 6:00 │ 6. Demostración en Postman: Endpoint Protegido Rechazado sin Token (401)
6:00 - 7:00 │ 7. Vista de Información de Sesión y Persistencia (Reiniciar App)
7:00 - 7:45 │ 8. Cierre de Sesión y Restricción Posterior de Acceso
7:45 - 8:00 │ 9. Conclusión y Cierre
```

---

## 🛠️ Paso Previo: Preparar el Entorno en 1 Clic

1. Ve a la carpeta `parcial 3/` y haz doble clic sobre:
   👉 **`ABRIR_ENTORNO_VIDEO_JWT.bat`**
2. Se abrirán automáticamente:
   - **Visual Studio Code** con el proyecto abierto.
   - **DB Browser for SQLite** con la base de datos `database.sqlite` (tabla `usuarios` y `productos`).
   - **Postman** (o ábrelo si no está abierto).
   - **Terminal del Backend** corriendo en `http://localhost:3000`.
   - **Aplicación Flutter** en ejecución en tu emulador Android o ventana Windows.
3. Abre tu grabador de pantalla favorito (OBS Studio, Xbox Game Bar `Win + G`, o Clipchamp).

---

## 🎙️ Guión Minuto a Minuto (Lo que dices y lo que muestras)

---

### 🟢 Bloque 1: Presentación y Opción Seleccionada (0:00 - 0:45)
* **Qué muestras en pantalla:** La portada de Visual Studio Code o la pantalla inicial de la aplicación móvil.
* **Lo que debes decir:**
  > *"Hola, profesor y compañeros. Mi nombre es [Tu Nombre] y a continuación presento la sustentación práctica del Taller de Autenticación mediante JSON Web Tokens (JWT).*
  >
  > *Para este taller seleccioné la **Opción 1: Continuar con el proyecto del Parcial 2**, el cual consiste en un Sistema de Gestión de Inventario con API REST propia en Node.js y SQLite, y una aplicación móvil desarrollada en Flutter.*
  >
  > *El objetivo principal de esta entrega es proteger integralmente el sistema, asegurando que ninguna operación CRUD ni métrica del dashboard pueda ser consumida sin un token JWT válido, almacenando las credenciales de forma cifrada mediante `flutter_secure_storage` y `shared_preferences`."*

---

### 🟢 Bloque 2: Implementación JWT en el Backend (0:45 - 2:00)
* **Qué muestras en pantalla:** En VS Code, abre la carpeta `backend/src/`.
* **Archivos a enfocar:**
  1. `config/database.js` y `models/userModel.js`:
     > *"En el backend incorporamos la tabla de usuarios con contraseñas cifradas mediante `bcryptjs` con un salt de 10 rondas. Tenemos usuarios de prueba precargados como `admin@inventario.com` y `usuario@inventario.com`."*
  2. `controllers/authController.js`:
     > *"En el controlador de autenticación implementamos el método `login`. Validamos si el correo existe y comparamos el hash con `bcrypt.compare`. Si las credenciales coinciden, generamos un token JWT firmado mediante `jwt.sign` con los datos del usuario y un tiempo de expiración de 24 horas. Si las credenciales son incorrectas, respondemos inmediatamente con un código HTTP 401 Unauthorized."*
  3. `middlewares/authMiddleware.js`:
     > *"Creamos el middleware `authMiddleware`, el cual extrae el encabezado `Authorization: Bearer <token>`. Utiliza `jwt.verify` para validar la firma y vigencia del token. Si no se envía el token o viene corrupto, bloquea la petición con error 401."*
  4. `routes/productRoutes.js`:
     > *"Aplicamos `router.use(authMiddleware)` en la raíz de las rutas de productos. De esta manera, las operaciones GET, POST, PUT y DELETE quedan 100% blindadas en el servidor."*

---

### 🟢 Bloque 3: Integración en Flutter (2:00 - 3:15)
* **Qué muestras en pantalla:** En VS Code, abre la carpeta `frontend/lib/`.
* **Archivos a enfocar:**
  1. `pubspec.yaml` y `services/storage_service.dart`:
     > *"En Flutter implementamos una estrategia de almacenamiento local seguro cumpliendo el requisito 2.4:*
     > *- Utilizamos `flutter_secure_storage` para guardar de forma cifrada en el Keystore del dispositivo el `access_token` JWT.*
     > *- Utilizamos `shared_preferences` para almacenar información no sensible como nombre, correo y rol del usuario."*
  2. `services/api_service.dart`:
     > *"Configuramos el cliente HTTP Dio con un interceptor que inyecta automáticamente la cabecera `Authorization: Bearer <token>` en cada petición saliente. Además, en el interceptor `onError`, si el servidor responde con un código 401 por sesión expirada, se dispara un callback que limpia los datos locales y redirige al usuario al login."*
  3. `config/router.dart`:
     > *"En GoRouter configuramos guards de navegación mediante `redirect` vinculado al `AuthProvider`. Si un usuario sin sesión intenta ingresar al Dashboard o al listado de productos, la aplicación lo redirige forzosamente a la pantalla de inicio de sesión."*

---

### 🟢 Bloque 4: Demostración de Login (Incorrecto vs Correcto) (3:15 - 4:15)
* **Qué muestras en pantalla:** El emulador o ventana de la app Flutter en la pantalla de Login.
* **Acciones a realizar:**
  1. **Prueba 1 (Credenciales Incorrectas):**
     - Escribe `admin@inventario.com` y en contraseña pon `clave_erronea_123`.
     - Presiona **"Iniciar Sesión"**.
     - **Muestra:** Aparece el banner rojo de error: *"Credenciales inválidas. Correo electrónico o contraseña incorrectos."* y en la consola de Dio se observa el status `401`.
  2. **Prueba 2 (Credenciales Correctas):**
     - Presiona el chip de acceso rápido **"Admin: admin123"** (o escríbelo).
     - Presiona **"Iniciar Sesión"**.
     - **Muestra:** Se activa el indicador de carga, aparece el SnackBar verde de bienvenida y GoRouter redirige automáticamente al **Dashboard Principal**.

---

### 🟢 Bloque 5: Consumo de Servicios CRUD Protegidos (4:15 - 5:15)
* **Qué muestras en pantalla:** La app Flutter autenticada y la consola de depuración.
* **Acciones a realizar:**
  1. **Lectura y Métricas (GET):**
     - Muestra el Dashboard con las métricas cargadas desde `/api/productos/stats`.
     - Ve a la pestaña **Productos** y haz scroll mostrando la lista traída de `/api/productos`.
     - Destaca en la consola de Flutter: `[DIO] Token JWT inyectado en cabecera Authorization`.
  2. **Crear Producto (POST):**
     - Presiona el botón flotante `+`.
     - Llena los campos: Nombre: `Audífonos Gamer Pro`, Código: `AUD-999`, Precio: `150`, Stock: `20`, Categoría: `Audio`.
     - Guarda el producto. Muestra cómo aparece en la lista y cómo el Dashboard recalcula las estadísticas.
  3. **Editar Producto (PUT):**
     - Edita el producto que acabas de crear, cámbiale el precio a `180`. Guarda y muestra que se actualizó.
  4. **Eliminar Producto (DELETE):**
     - Elimina el producto y confirma el diálogo. Muestra cómo desaparece de la lista.

---

### 🟢 Bloque 6: Validación de Endpoint Protegido en Backend sin Token (5:15 - 6:00)
* **Qué muestras en pantalla:** Postman con la colección `Taller JWT - Sistema de Inventario API REST`.
* **Acciones a realizar:**
  1. Abre la petición **"2.1 Acceso SIN Token a GET /productos"**.
  2. Haz clic en **Send**.
  3. **Muestra en pantalla:**
     - Status HTTP: **401 Unauthorized**.
     - Respuesta JSON:
       ```json
       {
         "success": false,
         "message": "Acceso no autorizado: Se requiere token de autenticación en la cabecera Authorization",
         "error": "Token no proporcionado"
       }
       ```
  4. Abre la petición **"2.2 Acceso con Token INVÁLIDO"** y presiona **Send**.
     - Status HTTP: **401 Unauthorized** (`jwt malformed`).
  5. *Comentario clave:*
     > *"Esto demuestra que ocultar botones o pantallas en Flutter no es la única defensa; el backend valida de forma independiente y rechaza cualquier petición no autenticada."*

---

### 🟢 Bloque 7: Información de Sesión y Persistencia (6:00 - 7:00)
* **Qué muestras en pantalla:** La app Flutter.
* **Acciones a realizar:**
  1. Abre el menú lateral (Drawer) o el icono de perfil en la barra superior y selecciona **"Información de Sesión"** (o navega a la 3ra pestaña "Sesión").
  2. **Muestra y explica cada elemento del requisito 2.5:**
     - Nombre del usuario: `Administrador Sistema`.
     - Correo electrónico: `admin@inventario.com`.
     - Rol: `ADMIN`.
     - Estado de autenticación: `Sesión Activa 🟢`.
     - **Indicador de Token Almacenado:** Muestra cómo el token está presente de forma segura y enmascarada (ej. `eyJhbGciOi...[TOKEN_PROTEGIDO_JWT]...t3Yw (241 chars)`), **sin exponer el texto sensible completo**.
     - Menciona que el token reside en `flutter_secure_storage` y el perfil en `shared_preferences`.
  3. **Demostración de Persistencia:**
     - Cierra la aplicación Flutter completamente (mata el proceso o cierra la ventana).
     - Vuelve a ejecutar `flutter run` o ábrela nuevamente desde el emulador.
     - **Muestra:** La aplicación detecta el token almacenado y entra **directamente al Dashboard** sin volver a pedir credenciales.

---

### 🟢 Bloque 8: Cierre de Sesión y Restricción de Acceso (7:00 - 7:45)
* **Qué muestras en pantalla:** La pantalla de Información de Sesión o el Drawer.
* **Acciones a realizar:**
  1. Presiona el botón rojo **"Cerrar Sesión"**.
  2. Confirma en el diálogo modal.
  3. **Muestra:**
     - `flutter_secure_storage` elimina el token.
     - `shared_preferences` limpia los datos del usuario.
     - GoRouter redirige de inmediato a la pantalla de **Login**.
  4. Intenta presionar el botón "Atrás" de Android o forzar la navegación:
     - La app se mantiene en el login. El acceso al Dashboard y productos queda completamente bloqueado.

---

### 🟢 Bloque 9: Cierre (7:45 - 8:00)
* **Lo que debes decir:**
  > *"Con esto queda evidenciado el cumplimiento de todos los requisitos del taller: autenticación con JWT, protección en frontend y backend, consumo con Dio, almacenamiento híbrido seguro, persistencia, control de sesión y manejo de errores. Muchas gracias por su atención."*

---

## 📋 Lista de Chequeo Final (Checklist)

- [ ] ¿El backend está corriendo en consola (`npm run dev`)?
- [ ] ¿El emulador Android o ventana de Flutter está visible y fluido?
- [ ] ¿Postman tiene importada la colección `Taller_JWT_Inventario_API.postman_collection.json`?
- [ ] ¿El audio del micrófono se escucha nítido y sin eco?
- [ ] ¿Se muestra la prueba del 401 en Postman sin token?
- [ ] ¿Se muestra el login fallido y luego el login exitoso?
- [ ] ¿Se muestra la pantalla de Información de Sesión con el token enmascarado?
- [ ] ¿Se demuestra el cierre de sesión y bloqueo de acceso?
