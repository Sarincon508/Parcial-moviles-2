# Guion y Metodología para la Grabación del Video Explicativo

> **Actividad:** Segundo Parcial de Programación Móvil  
> **Tema:** Solución de Gestión de Inventario (API REST Node.js/SQLite + Frontend Flutter con Dio)  
> **Objetivo del Video:** Demostrar el funcionamiento completo del sistema, la arquitectura implementada, la persistencia en base de datos y la sincronización en tiempo real.

---

## 🛠️ 1. Preparación Previa a la Grabación

### A. Herramientas Recomendadas para Grabar
- **Software de grabación:** OBS Studio, Clipchamp (Windows), GeForce Experience o Xbox Game Bar (`Win + G`).
- **Resolución sugerida:** 1080p (1920x1080) a 30 o 60 FPS.
- **Audio:** Micrófono claro, sin eco ni ruido ambiental fuerte.
- **Plataforma de entrega:** Subir a **YouTube en modo "Oculto" (Unlisted)** o a **Google Drive con permiso de "Cualquier persona con el enlace puede ver"**.

### B. Ventanas que debes tener abiertas y listas en tu pantalla
1. **Visual Studio Code (o tu editor):** con las carpetas `backend/` y `frontend/` abiertas.
2. **Terminal 1:** con el Backend en ejecución (`npm start` o `npm run dev` en `backend/`).
3. **Herramienta de pruebas de API:** Thunder Client en VS Code o Postman con la colección importada (`docs/api_collection.json`).
4. **Aplicación Flutter en ejecución:** En Emulador Android (`Pixel 7`), en Windows Desktop o en Google Chrome (`flutter run -d windows` o `flutter run -d chrome`).
5. **Visor de Base de Datos (opcional pero muy recomendado):** DB Browser for SQLite o la extensión SQLite Viewer en VS Code, para mostrar que los registros se escriben físicamente en `database.sqlite`.

---

## ⏱️ 2. Estructura y Minutero del Guion del Video (Duración estimada: 7 a 10 minutos)

| Bloque | Tiempo Estimado | Sección | Qué Mostrar en Pantalla | Qué Explicar con tu Voz |
| :--- | :--- | :--- | :--- | :--- |
| **1** | `00:00 - 00:45` | **Introducción y Presentación** | Tu cara/cámara (o pantalla con el README) | Saludo cordial, tu nombre completo, código institucional, nombre de la asignatura y resumen del proyecto. |
| **2** | `00:45 - 02:15` | **Arquitectura del Backend y Base de Datos** | VS Code en la carpeta `backend/` | Explicar Node.js + Express, estructura MVC, modelo SQLite, migraciones/seed con 12 productos iniciales y middlewares de validación. |
| **3** | `02:15 - 03:45` | **Pruebas de la API (Thunder Client / Postman)** | Postman o Thunder Client ejecutando peticiones | Demostrar los 5 endpoints obligatorios + estadísticas. Probar respuestas `200`, `201`, `422` (código duplicado o campos vacíos) y `404`. |
| **4** | `03:45 - 05:00` | **Arquitectura de Flutter y Consumo con Dio** | VS Code en `frontend/lib/` | Mostrar organización de carpetas (Clean/Feature), `env.dart` con `flutter_dotenv`, `api_service.dart` con interceptores de `dio`, `go_router` y `provider`. |
| **5** | `05:00 - 07:30` | **Demostración Funcional de la App Móvil (CRUD completo)** | Emulador o ventana de la app en vivo | 1. Dashboard y métricas automáticas.<br>2. Listado y búsqueda.<br>3. Consulta de detalle.<br>4. Registro (POST).<br>5. Edición (PUT).<br>6. Eliminación con confirmación (DELETE). |
| **6** | `07:30 - 08:30` | **Comprobación de Persistencia Real** | Cerrar la app / backend y reabrir, o mostrar SQLite | Mostrar que los cambios siguen guardados en el disco y no en memoria RAM. |
| **7** | `08:30 - 09:30` | **Despliegue en la Nube (Opcional 5%)** | Navegador con URL pública HTTPS (Render/Railway) | Mostrar la URL remota, cómo se conecta Flutter cambiando el `.env` y consumiendo la API desplegada. |
| **8** | `09:30 - 10:00` | **Conclusiones y Despedida** | Repositorio GitHub en pantalla | Agradecer la atención, mostrar el repositorio con sus commits y despedirse. |

---

## 🎙️ 3. Guion Textual Paso a Paso (Lo que puedes decir palabra por palabra)

### Bloque 1: Introducción (`00:00 - 00:45`)
> *"Buenas profesor y compañeros. Mi nombre es [Tu Nombre Completo] y a continuación presento el desarrollo del Segundo Parcial de Programación Móvil.  
> La solución consiste en un sistema integral de control de inventario para un establecimiento comercial, compuesto por una API REST construida en Node.js y Express con persistencia real en una base de datos SQLite, y una aplicación móvil desarrollada en Flutter que consume este servicio utilizando la librería Dio, navegación mediante GoRouter y gestión de estado con Provider."*

---

### Bloque 2: Backend y Base de Datos (`00:45 - 02:15`)
*(Muestra en VS Code la carpeta `backend`)*
> *"Para el backend seleccioné Node.js con Express debido a su ligereza, rendimiento asíncrono y compatibilidad nativa.  
> La base de datos elegida es SQLite, un motor relacional persistente que almacena los datos en un archivo físico llamado `database.sqlite`.  
> En el archivo `src/config/database.js` implementé una función que crea la tabla `productos` con todos los campos exigidos: `id`, `nombre`, `codigo` único, `descripcion`, `precio`, `cantidad` y `categoria`. Además, incluye un sembrador o seeder que registra automáticamente 12 productos de prueba si la base de datos está vacía.  
> En `src/middlewares/validator.js` implementamos validaciones estrictas: los campos obligatorios, que el precio sea mayor a cero, la cantidad sea un entero positivo, y la verificación de unicidad del código del producto antes de permitir el registro o actualización, respondiendo con el código HTTP 422 si hay alguna inconsistencia."*

---

### Bloque 3: Pruebas de la API REST (`02:15 - 03:45`)
*(Pasa a Postman o Thunder Client y ejecuta las peticiones una por una)*
> *"Ahora comprobamos los endpoints implementados:  
> 1. Primero, hacemos un `GET /api/productos`. Observamos que responde con código 200 OK y el listado en formato JSON con los 12 productos iniciales.  
> 2. Segundo, hacemos un `GET /api/productos/stats`. Este endpoint calcula mediante consultas SQL el total de productos, la sumatoria de unidades y el valor económico total del inventario (`SUM(precio * cantidad)`), el cual utilizaremos en el Dashboard de la app móvil.  
> 3. Tercero, consultamos el detalle de un producto específico mediante `GET /api/productos/1`. Responde 200 OK con toda su información. Si consultamos un ID inexistente como el 9999, la API responde 404 Not Found.  
> 4. Cuarto, probamos el registro con `POST /api/productos`. Enviamos un producto nuevo y vemos que retorna código 201 Created y el objeto generado con su ID autoincremental. Si intentamos crearlo de nuevo con el mismo código, el validador nos devuelve un 422 con un mensaje claro de error.  
> 5. Quinto, probamos el método `PUT /api/productos/:id` para modificar el stock y el precio, respondiendo 200 OK.  
> 6. Por último, probamos `DELETE /api/productos/:id`, el cual elimina el registro de la base de datos y retorna 200 OK."*

---

### Bloque 4: Arquitectura en Flutter y Buenas Prácticas (`03:45 - 05:00`)
*(Muestra la carpeta `frontend/lib/` en VS Code)*
> *"Pasando a la aplicación móvil en Flutter, la arquitectura se estructuró bajo el principio de separación de responsabilidades:  
> - En `config/env.dart`, utilizamos `flutter_dotenv` para leer las variables de entorno desde `assets/.env`. De esta manera desacoplamos la URL del servidor del código fuente.  
> - En `services/api_service.dart`, configuramos una instancia centralizada de **Dio**, estableciendo tiempos de espera o timeouts, headers de tipo JSON y un interceptor para depurar las peticiones en consola y capturar errores de red o excepciones HTTP de forma limpia mediante una clase `ApiException`.  
> - En `services/product_service.dart`, encapsulamos las llamadas a los endpoints. Nótese que **ningún widget de la interfaz hace peticiones HTTP directamente**, cumpliendo con los lineamientos de buenas prácticas.  
> - En `providers/product_provider.dart`, gestionamos el estado de manera reactiva mediante `ChangeNotifier`. Cuando se crea, edita o elimina un producto, el provider actualiza la lista y recalcula las métricas automáticamente.  
> - Para la navegación utilizamos **go_router** configurado en `config/router.dart`, implementando un ShellRoute con menú de navegación inferior y lateral (Drawer), además de rutas hijas para el detalle y el formulario."*

---

### Bloque 5: Demostración Funcional de la App Móvil (`05:00 - 07:30`)
*(Interactúa en tiempo real con la app en el emulador o desktop)*
> *"A continuación demostramos la aplicación en ejecución:  
> 1. **Dashboard Principal:** Al iniciar, observamos el encabezado y las 3 tarjetas de métricas calculadas con datos reales de la API:  
>    - Total de productos registrados.  
>    - Unidades disponibles en stock.  
>    - Valor económico total del inventario.  
> 2. **Navegación:** Usamos la barra inferior o el Drawer lateral para desplazarnos a la sección de **Productos**.  
> 3. **Listado y Filtros:** Vemos cada producto con su nombre, categoría, precio unitario y cantidad disponible con etiquetas de color según el nivel de stock (verde disponible, amarillo bajo stock, rojo agotado). Podemos filtrar por categorías o buscar mediante la barra de búsqueda en tiempo real.  
> 4. **Consultar Detalle:** Al presionar sobre un producto, GoRouter nos lleva a la pantalla de detalle, donde apreciamos el código, precio, stock, descripción completa y el cálculo del valor total acumulado de ese producto.  
> 5. **Registrar Producto (POST):** Pulsamos el botón flotante 'Nuevo Producto'. Si intentamos enviar el formulario vacío, los validadores nos alertan. Ingresamos los datos de un nuevo artículo, pulsamos guardar y vemos el indicador de carga. Al completarse, nos muestra un SnackBar de éxito en verde y el nuevo producto ya aparece en la lista.  
> 6. **Actualizar Producto (PUT):** Seleccionamos el producto recién creado, pulsamos 'Editar', modificamos el precio y la cantidad, y guardamos. La interfaz se actualiza al instante con los nuevos valores.  
> 7. **Eliminar Producto (DELETE):** Pulsamos el ícono de basura. La aplicación nos solicita confirmación mediante un diálogo modal para evitar borrados accidentales. Confirmamos, el producto desaparece de la lista y vemos el mensaje de confirmación."*

---

### Bloque 6: Verificación de Persistencia Real (`07:30 - 08:30`)
*(Regresa al Dashboard)*
> *"Fíjense cómo, tras agregar y modificar productos, volvemos al Dashboard y las tres tarjetas de métricas reflejan de inmediato las nuevas cantidades y el nuevo valor monetario total del inventario.  
> Ahora, para demostrar que los datos son persistentes y no estáticos:  
> - Cerramos completamente la aplicación Flutter.  
> - Detenemos el servidor de Node.js en la terminal.  
> - Volvemos a levantar el servidor backend (`npm start`).  
> - Reabrimos la aplicación Flutter.  
> Como pueden apreciar, todos los registros creados y modificados permanecen exactamente iguales, demostrando que la persistencia reside en el archivo SQLite y no en la memoria volátil."*

---

### Bloque 7: Despliegue en la Nube (Opcional 5% - Si lo realizaste) (`08:30 - 09:30`)
*(Abre el navegador con la URL de Render o Railway)*
> *"Para optar por el 5% correspondiente al despliegue, la API fue publicada en la nube mediante [Render / Railway] accesible mediante la URL pública HTTPS `https://tu-api.onrender.com`.  
> En la aplicación móvil, gracias al diálogo de configuración que implementamos o ajustando el archivo `.env`, conectamos Flutter a esta URL remota, demostrando que todas las operaciones CRUD funcionan de manera idéntica contra el servidor en la nube."*

---

### Bloque 8: Conclusiones y Despedida (`09:30 - 10:00`)
*(Muestra la página del repositorio en GitHub con los commits)*
> *"Para finalizar, muestro el repositorio de GitHub público donde se encuentra alojado tanto el código del backend como del frontend, con su historial de commits descriptivos y un archivo README exhaustivo con las instrucciones de instalación.  
> Muchas gracias por su atención."*

---

## 💡 4. Consejos Prácticos para Grabar con Éxito
1. **Haz una prueba de 30 segundos:** Graba un clip corto y escúchalo para verificar que tu voz se escuche clara y no saturada.
2. **Aumenta el tamaño de fuente en VS Code:** Usa `Ctrl + +` en VS Code para que el código sea legible en el video.
3. **No te preocupes por equivocarte:** Si te trabas en una palabra, haz una pausa de 2 segundos y repite la frase; puedes recortar fácilmente ese pedazo con cualquier editor gratuito (como CapCut, Clipchamp o DaVinci Resolve) o dejarlo fluir de manera natural.
4. **Permisos de visualización:** Una vez grabado y subido el video a Google Drive o YouTube, asegúrate de abrir el enlace en una ventana en **Modo Incógnito** para certificar que cualquier persona con el link puede verlo sin pedir inicio de sesión.
