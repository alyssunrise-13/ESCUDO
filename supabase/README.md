# ESCUDO // Guía de Conexión y Seguridad con Supabase

Este documento detalla el estado actual de la integración con Supabase, las protecciones de ciberseguridad aplicadas y los pasos exactos que debes seguir para dejarlo 100% operativo.

---

## 📌 Checklist: ¿Qué te falta hacer en Supabase?

Sigue estos 3 sencillos pasos en tu panel de control de Supabase:

### Paso 1: Ejecutar el script SQL de Base de Datos
1. Abre tu navegador e ingresa a tu proyecto en [Supabase Dashboard](https://supabase.com/dashboard).
2. En el menú lateral izquierdo, haz clic en el ícono **SQL Editor**.
3. Haz clic en el botón **+ New query**.
4. Abre el archivo `supabase/schema.sql` de este proyecto, copia todo su contenido, pégalo en el editor de Supabase y haz clic en el botón verde **Run**.
5. Verás el mensaje `Success. No rows returned`. Con esto, la tabla `Postulantes`, sus políticas de seguridad (RLS), el índice anti-spam y el trigger de sanitización quedarán creados y blindados.

### Paso 2: Verificar o actualizar tus credenciales
1. En el menú lateral izquierdo de Supabase, ve a **Project Settings** (el engranaje abajo a la izquierda) -> pestaña **API**.
2. Verifica que tu **Project URL** coincida con la que está en `supabase-config.js`.
3. Verifica que tu clave pública anónima (**anon public**) o publishable key coincida con la de `supabase-config.js`.
   > ⚠️ **IMPORTANTE:** Nunca coloques en `supabase-config.js` tu clave `service_role` ni ninguna clave que empiece con `sb_secret_`. Esas claves son privadas y anularían la seguridad. Usa únicamente la clave `anon` o `publishable`.

### Paso 3: Probar el envío desde la web
1. Abre la web con Live Server (`http://127.0.0.1:5500/index.html`).
2. Ve a la sección **Admisión**, llena el formulario con tus datos y presiona **Enviar solicitud**.
3. Ve a tu panel de Supabase -> **Table Editor** -> selecciona la tabla **Postulantes**.
4. ¡Verás tu solicitud registrada en tiempo real con su fecha, carrera, modalidad y estado `pendiente`!

---

## 🛡️ Medidas de Ciberseguridad Aplicadas en la Web

Como auditor de seguridad, se han implementado múltiples capas de defensa (Defensa en Profundidad):

1. **Content Security Policy (CSP):** Se añadieron cabeceras y meta tags de seguridad en `index.html` para prevenir ataques de Cross-Site Scripting (XSS), Clickjacking (`frame-ancestors 'none'`) e inyección de recursos externos no autorizados.
2. **Trampa Honeypot Anti-Bot:** El formulario contiene un campo señuelo invisible para humanos. Si un bot automatizado de spam llena este campo, su petición se descarta automáticamente sin consumir recursos de base de datos.
3. **Limitación de Frecuencia (Rate Limiting en Cliente):** Se agregó un temporizador de enfriamiento (cooldown de 8 segundos) que previene ataques de denegación de servicio (DoS) o flooding de envíos repetidos desde el navegador.
4. **Validación Estricta y Whitelisting:** Nombre, correo, celular, DNI, carrera y modalidad se sanean y validan contra listas blancas de valores permitidos tanto en HTML como en JavaScript antes de enviarse.
5. **Row Level Security (RLS) Defensivo:** En Supabase, el rol público `anon` únicamente tiene permiso para `INSERT`. Nadie desde internet puede leer (`SELECT`), alterar (`UPDATE`) ni borrar (`DELETE`) la base de datos de postulantes.
6. **Trigger de Saneamiento y Normalización en PostgreSQL:** La base de datos limpia automáticamente caracteres peligrosos (`<`, `>`), fuerza minúsculas en correos y estandariza los datos entrantes.
7. **Índice Anti-Duplicados:** Previene que un mismo DNI sea registrado múltiples veces en un mismo día por scripts maliciosos.
