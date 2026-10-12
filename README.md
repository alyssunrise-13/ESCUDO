# 🛡️ ESCUDO - Escuela de Seguridad Cibernética y Unidad de Defensa Operativa

Un micrositio institucional moderno y completamente funcional, diseñado bajo la estética inmersiva de un Centro de Operaciones de Seguridad (SOC). Este proyecto fue desarrollado como Trabajo Final para el curso de Frontend Developer Web de SENATI, enfocándose en la usabilidad, seguridad de datos y un diseño visual de alto impacto.
[Visualiza la página aquí.](https://alyssunrise-13.github.io/ESCUDO/)

## 🚀 Características Principales

* **Diseño Inmersivo y Responsive:** Maquetación fluida a dos columnas utilizando CSS Grid y Flexbox, garantizando una adaptabilidad perfecta desde monitores ultrawide hasta dispositivos móviles.
* **Interactividad Avanzada del DOM:** Implementación de un reloj digital en tiempo real y un radar de escaneo animado utilizando CSS puro y JavaScript Vanilla.
* **Terminal SOC Operativa:** Consola interactiva programada para recibir comandos de texto y desplegar respuestas dinámicas y "easter eggs" ocultos.
* **Validación Estricta (Client-Side):** Formulario de admisión protegido con expresiones regulares (RegEx) personalizadas para asegurar la integridad de los datos (DNI, correos, celulares) y trampas *honeypot* para mitigar ataques de bots.
* **Integración Backend (BaaS):** Conexión asíncrona (`fetch` API) mediante el método POST a una base de datos real en Supabase (PostgreSQL), gestionando el registro de postulantes de forma segura sin recargar la página.

## 🛠️ Tecnologías Utilizadas

* **HTML5:** Estructura 100% semántica y accesible.
* **CSS3:** Variables globales, animaciones personalizadas (`@keyframes`), selectores avanzados y diseño responsivo sin depender en exceso de frameworks.
* **JavaScript (ES6+):** Lógica de control, manipulación del DOM, asincronía (`async/await`) y manejo de excepciones (`try/catch`).
* **Supabase:** Backend as a Service para la persistencia de datos.

## ⚙️ Instalación y Pruebas Locales

1. Clona este repositorio: `git clone https://github.com/TuUsuario/Escudo.git`
2. Abre el archivo `index.html` en tu navegador preferido o utiliza una extensión como *Live Server* en VS Code.
3. Para probar el envío del formulario, asegúrate de configurar tus credenciales públicas de Supabase en el archivo `supabase-config.js`.
