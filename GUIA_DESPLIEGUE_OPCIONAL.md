# Guía de Despliegue en la Nube (Bono Opcional del 5%)

> **Requisito Oficial:**  
> *"Quienes deseen obtener el 5% correspondiente al despliegue deberán publicar su API en un servidor o plataforma en la nube, como Railway, Render u otro proveedor de su elección.  
> Se deberá demostrar:  
> - API accesible públicamente mediante una URL HTTPS.  
> - Base de datos funcional y persistente en el entorno desplegado.  
> - Aplicación Flutter conectada a la API publicada.  
> - Operaciones CRUD funcionando contra el servidor remoto."*

---

## 🚀 Opción Recomendada: Despliegue en 1 Clic con Render.com (Gratis)

Render es la plataforma más recomendada y sencilla para alojar APIs de Node.js con base de datos SQLite y certificados HTTPS automáticos sin costo.

El proyecto ya cuenta con el archivo de configuración **`render.yaml`** en la raíz del repositorio, por lo que **Render autodetectará toda la configuración técnica sin que tengas que escribir comandos**.

### Botón de Despliegue Directo:
Haz clic en el siguiente enlace o botón desde el README:
👉 **[https://render.com/deploy?repo=https://github.com/Sarincon508/Parcial-moviles-2](https://render.com/deploy?repo=https://github.com/Sarincon508/Parcial-moviles-2)**

---

### Paso a Paso Manual (si prefieres crearlo desde el panel):
1. En el Dashboard de Render, presiona el botón **"New +"** en la esquina superior derecha y selecciona **"Web Service"**.
2. Selecciona la opción **"Build and deploy from a Git repository"** y presiona **Next**.
3. Conecta tu repositorio de GitHub: `Sarincon508/Parcial-moviles-2`.
4. Configura los siguientes campos del servicio:
   - **Name:** `inventario-api-parcial2` (o el nombre que prefieras).
   - **Region:** Selecciona la más cercana (ej. `Ohio (US East)` o `Oregon (US West)`).
   - **Branch:** `main` (o `master`).
   - **Root Directory:** `backend` *(⚠️ Muy importante: colocar `backend` para que Render construya solo la API)*.
   - **Runtime:** `Node`.
   - **Build Command:** `npm install`.
   - **Start Command:** `npm start`.
   - **Instance Type:** `Free`.
5. En la sección **Environment Variables** (opcional, tiene valores por defecto):
   - `NODE_ENV`: `production`
   - `PORT`: `3000`
6. Presiona **"Create Web Service"**.

Render compilará la aplicación y en aproximadamente 1-2 minutos verás en los logs:
```
📦 Base de datos SQLite conectada en: /opt/render/project/src/backend/database.sqlite
🌱 Sembrando 12 productos iniciales de prueba...
✅ 12 productos de prueba sembrados exitosamente.
🚀 Servidor API REST ejecutándose en: http://0.0.0.0:3000
```

### Paso 4: Probar la URL Pública HTTPS
En la parte superior de Render verás tu URL pública, por ejemplo:
`https://inventario-api-parcial2.onrender.com`

Pruébala en tu navegador o en Postman:
- `https://inventario-api-parcial2.onrender.com/` (Debe responder con el JSON de bienvenida).
- `https://inventario-api-parcial2.onrender.com/api/productos` (Debe responder con los 12 productos).

---

## 📱 Paso 5: Conectar la Aplicación Flutter a la API Desplegada

Para que la aplicación Flutter consuma la API en la nube, tienes dos opciones muy sencillas:

### Opción A (Sin recompilar - En caliente desde la App):
1. Abre la aplicación móvil Flutter.
2. Toca el ícono de engranaje ⚙️ en el AppBar del Dashboard o abre el menú lateral Drawer y selecciona **"Configuración Servidor API"**.
3. Pega tu URL pública terminada en `/api`, por ejemplo:
   ```
   https://inventario-api-parcial2.onrender.com/api
   ```
4. Presiona **"Guardar y Reconectar"**.
5. ¡Listo! La app recargará automáticamente los productos y estadísticas directamente desde tu servidor en la nube.

### Opción B (Desde el archivo de entorno):
Edita el archivo `frontend/assets/.env` y reemplaza la variable:
```env
API_BASE_URL=https://inventario-api-parcial2.onrender.com/api
```
Ejecuta de nuevo la aplicación y consumirá directamente el servidor desplegado.

---

## 📷 Evidencias para el Video y PDF del Despliegue
Para asegurar el 5% completo en tu calificación:
1. Graba en tu video la pestaña de Render mostrando el Web Service en estado **"Live"** con su URL HTTPS.
2. Muestra una petición en Postman o en el navegador a esa URL pública.
3. Muestra en Flutter una operación CRUD (por ejemplo crear un nuevo producto llamado "Producto Nube") y verifica que aparezca registrado contra el servidor remoto.
