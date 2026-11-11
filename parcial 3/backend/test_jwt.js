const http = require('http');
const app = require('./src/app');
const { initDatabase } = require('./src/config/database');

async function testBackend() {
  await initDatabase();

  const server = http.createServer(app);
  await new Promise((resolve) => server.listen(3001, resolve));
  console.log('Test server running on port 3001');

  async function request(path, options = {}) {
    return new Promise((resolve, reject) => {
      const req = http.request(`http://localhost:3001${path}`, options, (res) => {
        let data = '';
        res.on('data', chunk => data += chunk);
        res.on('end', () => {
          try {
            resolve({ status: res.statusCode, data: JSON.parse(data) });
          } catch (e) {
            resolve({ status: res.statusCode, raw: data });
          }
        });
      });
      req.on('error', reject);
      if (options.body) {
        req.write(typeof options.body === 'string' ? options.body : JSON.stringify(options.body));
      }
      req.end();
    });
  }

  try {
    // 1. Acceso sin autenticacion a endpoint protegido
    console.log('\n--- 1. Test: Acceso sin token a /api/productos ---');
    const res1 = await request('/api/productos');
    console.log('Status code (esperado 401):', res1.status);
    console.log('Respuesta:', res1.data);
    if (res1.status !== 401) throw new Error('Debería ser 401');

    // 2. Intento de login con credenciales incorrectas
    console.log('\n--- 2. Test: Login con credenciales incorrectas ---');
    const res2 = await request('/api/auth/login', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: { email: 'admin@inventario.com', password: 'password_invalido' }
    });
    console.log('Status code (esperado 401):', res2.status);
    console.log('Respuesta:', res2.data);
    if (res2.status !== 401) throw new Error('Debería ser 401');

    // 3. Login con credenciales correctas
    console.log('\n--- 3. Test: Login exitoso con admin@inventario.com / admin123 ---');
    const res3 = await request('/api/auth/login', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: { email: 'admin@inventario.com', password: 'admin123' }
    });
    console.log('Status code (esperado 200):', res3.status);
    console.log('Usuario devuelto:', res3.data.data.usuario);
    console.log('Token obtenido (longitud):', res3.data.data.token.length);
    const token = res3.data.data.token;
    if (res3.status !== 200 || !token) throw new Error('Debería ser 200 con token');

    // 4. Acceso con token a endpoint protegido /api/productos
    console.log('\n--- 4. Test: Acceso con Bearer token a /api/productos ---');
    const res4 = await request('/api/productos', {
      headers: { 'Authorization': `Bearer ${token}` }
    });
    console.log('Status code (esperado 200):', res4.status);
    console.log('Total productos recibidos:', res4.data.data ? res4.data.data.length : 'N/A');
    if (res4.status !== 200) throw new Error('Debería ser 200 con token');

    // 5. Acceso con token a perfil de usuario /api/auth/perfil
    console.log('\n--- 5. Test: Acceso con Bearer token a /api/auth/perfil ---');
    const res5 = await request('/api/auth/perfil', {
      headers: { 'Authorization': `Bearer ${token}` }
    });
    console.log('Status code (esperado 200):', res5.status);
    console.log('Perfil recibido:', res5.data.data.usuario);
    if (res5.status !== 200) throw new Error('Debería ser 200 con perfil');

    // 6. Acceso con token falso/invalido
    console.log('\n--- 6. Test: Acceso con Bearer token inválido ---');
    const res6 = await request('/api/productos', {
      headers: { 'Authorization': `Bearer token_falso_invalido_123` }
    });
    console.log('Status code (esperado 401):', res6.status);
    console.log('Respuesta:', res6.data);
    if (res6.status !== 401) throw new Error('Debería ser 401 para token inválido');

    console.log('\n🎉 ¡TODOS LOS TESTS DEL BACKEND PASARON EXITOSAMENTE!');
  } finally {
    server.close();
  }
}

testBackend().catch(err => {
  console.error('Test falló:', err);
  process.exit(1);
});
