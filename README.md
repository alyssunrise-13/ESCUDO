# 🛡️ ESCUDO: Plataforma Institucional y Terminal SOC
## Manual de Usuario y Guía de Operación del Sistema

> **Estado del despliegue:** Operativo en producción  
> **Versión:** v2.6.4  
> **Enlace oficial:** [https://alyssunrise-13.github.io/ESCUDO/](https://alyssunrise-13.github.io/ESCUDO/)  
> **Sede académica:** Ayacucho, Perú
> **Consejo:** Se recomienda usar Ctrl + "-" si desea reducir los márgenes, ya que la web se muestra grande por temas de accesibilidad para personas con dificultades visuales.

---

## 📌 Tabla de Contenidos
1. [Descripción General](#1-descripción-general)
2. [Requisitos de Acceso y Compatibilidad](#2-requisitos-de-acceso-y-compatibilidad)
3. [Navegación y Accesibilidad Universal](#3-navegación-y-accesibilidad-universal)
4. [Manual Operativo de la Consola Táctica (SOC Terminal)](#4-manual-operativo-de-la-consola-táctica-soc-terminal)
5. [Exploración de Carreras y Auto-selección](#5-exploración-de-carreras-y-auto-selección)
6. [Módulo de Admisión y Persistencia en Supabase](#6-módulo-de-admisión-y-persistencia-en-supabase)
7. [Métricas de Impacto y Componentes Interactivos](#7-métricas-de-impacto-y-componentes-interactivos)
8. [Preguntas Frecuentes y Solución de Problemas (FAQ)](#8-preguntas-frecuentes-y-solución-de-problemas-faq)

---

## 1. Descripción General

**ESCUDO** (*Escuela de Seguridad Cibernética y Unidad de Defensa Operativa*) es un portal institucional diseñado para la orientación vocacional, exploración académica y captación automatizada de postulantes en carreras de tecnología crítica.

A diferencia de los sitios educativos tradicionales con esquemas claros genéricos, la plataforma implementa una interfaz técnica inspirada en un **Centro de Operaciones de Seguridad (SOC)** y laboratorio de simulación (*Cyber Range*). Cuenta con una estética de alto contraste (fondo oscuro profundo `#030503` y acentos en verde neón `#00ff41`), tipografía monoespaciada, monitoreo perimetral simulado y persistencia en tiempo real conectada a una base de datos relacional PostgreSQL en la nube.

---

## 2. Requisitos de Acceso y Compatibilidad

El portal funciona 100% en el lado del cliente (*client-side*), por lo que no requiere instalación de software adicional, servidores locales ni extensiones:

* **Navegadores recomendados:** Google Chrome, Microsoft Edge, Mozilla Firefox, Brave o Safari (versiones con soporte ES6+ y CSS Grid).
* **Conectividad:** Conexión a internet para la carga de tipografías desde Google Fonts, librerías de animación (GSAP, Particles.js) y sincronización REST con Supabase.
* **Diseño Adaptable (Responsive):** La interfaz integra reglas de estilo fluidas y una función programática de autoescalado (`window.autoEscalar`) que adapta los componentes desde pantallas móviles (390px) hasta monitores ultrawide (superiores a 1300px) sin desbordamientos horizontales.

---

## 3. Navegación y Accesibilidad Universal

La arquitectura del sitio sigue los estándares internacionales de accesibilidad web (WCAG 2.1 AAA):

* **Enlace de Salto Accesible:** Los usuarios que navegan mediante teclado o lectores de pantalla pueden pulsar la tecla `Tab` al cargar el sitio para activar el enlace oculto `.salto-contenido`, dirigiéndose directamente al área central de la página.
* **Barra de Navegación Fija:** Permite trasladarse con un clic entre las secciones `#inicio`, `#admision`, `#carreras`, `#nosotros` y `#resenas`. El menú detecta el desplazamiento mediante `IntersectionObserver` y resalta en tiempo real la sección visible.
* **Menú Móvil Colapsable:** En pantallas menores a 768px, el menú horizontal se compacta en un botón de menú que actualiza dinámicamente sus atributos `aria-expanded` y puede cerrarse mediante la tecla `Escape` o haciendo clic fuera del contenedor.
* **Sensibilidad al Movimiento:** Si el sistema operativo del usuario tiene activada la reducción de movimiento, la regla CSS `@media (prefers-reduced-motion: reduce)` y las validaciones de JavaScript desactivan automáticamente las animaciones complejas y efectos pulsantes.

---

## 4. Manual Operativo de la Consola Táctica (SOC Terminal)

En la sección de cabecera (*Hero*) se encuentra integrada la **Consola Operativa v2.6.4**, un simulador de consola de ciberseguridad interactivo para explorar la oferta académica.

### 4.1. Indicadores del Monitor Perimetral
* **Badges Superiores:** Muestran el estado activo del Firewall y el nivel defensivo del sistema (*IDS/IPS: DEFCON 4*).
* **Latencia de Red:** Un temporizador aleatorio calcula dinámicamente la latencia simulada (oscilando entre 11ms y 15ms).
* **Reloj Neon:** Muestra la hora local de Ayacucho en formato estricto de 24 horas (`hh:mm:ss`), actualizado al segundo mediante `setInterval()`.

### 4.2. Acciones Rápidas (Chips de Comando)
Encima de la línea de comandos, el usuario puede pulsar botones de acceso directo:
* `que_aprendere`: Imprime en la consola la estructura de la malla formativa de forma asíncrona y escalonada.
* `retos_practicos`: Explica la metodología de entrenamiento táctico basado en retos *Capture The Flag* (CTF).
* `carreras`: Muestra un resumen de especialidades y desplaza la pantalla automáticamente hacia la sección académica.
* `admision`: Redirige al formulario de postulación y coloca el foco de escritura en el campo del nombre.
* `limpiar`: Vacía el historial de la terminal y restablece el mensaje de bienvenida inicial.

### 4.3. Entrada Manual de Comandos (CLI)
El usuario puede redactar comandos en el campo con el prompt `escudo@soc:~$` y presionar `Enter` o el botón **EJECUTAR ↵**:

| Comando | Descripción de la Respuesta |
| :--- | :--- |
| `que_aprendere`, `plan`, `temario` | Despliega detalles sobre hacking ético, redes y proyectos defensivos. |
| `retos_practicos`, `ctf`, `practica` | Muestra la metodología de laboratorio en entornos vivos de auditoría. |
| `carreras`, `especialidades` | Ejecuta scroll suave hacia el catálogo de carreras. |
| `admision`, `postular`, `beca` | Desplaza la vista al formulario y enfoca el campo de postulación. |
| `escanear`, `scan` | Ejecuta un diagnóstico vocacional automatizado en la pantalla de la consola. |
| `ayuda`, `help` | Lista las órdenes básicas y comandos de exploración. |
| `limpiar`, `clear`, `cls` | Reinicia la ventana de eventos de la terminal. |
| `hack`, `matrix`, `sudo`, `root` | **Easter Egg de Seguridad:** Activa un modo visual de pulso neón intenso, emite una secuencia de sonido ascendente mediante la Web Audio API y desbloquea el código promocional `#HACKER-ESCUDO-2026`. |

---

## 5. Exploración de Carreras y Auto-selección

La sección **Carreras** (`#carreras`) presenta la cuadrícula de formación técnica especializada:

1. **Ciberseguridad y Defensa Digital:** Identificación de vulnerabilidades, auditorías y mitigación de incidentes.
2. **Desarrollo de Software:** Arquitectura de aplicaciones escalables y ciclo de vida de desarrollo.
3. **Redes y Bases de Datos:** Infraestructura de servidores, conectividad en la nube y administración de datos.
4. **Desarrollo Frontend:** Interfaces web de alto rendimiento, accesibilidad y diseño modular.
5. **Desarrollo Backend:** APIs RESTful, lógica de servidores, microservicios y autenticación.
6. **Inteligencia Artificial:** Redes neuronales, algoritmos predictivos y detección de anomalías.

> **Funcionalidad Integrada:** Cada tarjeta académica cuenta con un enlace `Me interesa ↗` con el atributo `data-programa`. Al hacer clic, el sistema realiza un scroll suave hacia el formulario y **selecciona automáticamente** la carrera elegida dentro de la lista desplegable, agilizando el registro.

---

## 6. Módulo de Admisión y Persistencia en Supabase

El formulario de la sección `#admision` sustituye los procesos manuales por una integración directa con una base de datos PostgreSQL alojada en **Supabase**.

### 6.1. Requisitos de Validación de Datos
Antes del despacho, la función `validarFormulario()` audita los datos ingresados:
* **Nombre completo:** Longitud de 2 a 120 caracteres, aceptando únicamente letras, tildes y espacios.
* **Correo electrónico:** Formato con estructura de usuario y dominio válido (`usuario@dominio.ext`).
* **Celular:** Longitud de 7 a 15 dígitos numéricos.
* **DNI:** Debe contener exactamente 8 números evaluados con la expresión regular `^[0-9]{8}$`.
* **Carrera y Modalidad:** Selección obligatoria dentro de las opciones válidas del sistema.
* **Aceptación de Privacidad:** Checkbox obligatorio para autorizar el tratamiento de los datos.

### 6.2. Capas de Ciberseguridad Integradas
* **Trampa Honeypot:** Campo oculto por CSS (`_hp_security_check`). Si un bot automatizado completa este campo, la solicitud se neutraliza en silencio sin registrarse en la base de datos.
* **Control de Tasa (Rate Limiting):** Mediante `sessionStorage`, el sistema bloquea envíos repetitivos realizados con menos de **8 segundos** de diferencia.
* **Sanitización de Entradas:** La función `sanitizarEntrada()` elimina caracteres de control y remueve los signos `<` y `>` para neutralizar vectores de inyección XSS.
* **Seguridad de Token:** El script valida en Base64 que la clave pública JWT contenga exclusivamente el rol `anon`, bloqueando cualquier despacho si detectara claves administrativas.

### 6.3. Confirmación de Envío
1. Al pulsar **Enviar solicitud ↗**, el botón se bloquea mostrando un estado de carga accesible (`aria-busy="true"`).
2. Se ejecuta una petición `POST` mediante la API `fetch` hacia el endpoint `/rest/v1/Postulantes`.
3. Cuenta con un temporizador de cancelación de 9 segundos (`AbortController`) por si la red se cuelga.
4. Al recibir la confirmación HTTP 201 de Supabase, el formulario se limpia (`reset()`) y se muestra el mensaje:  
   `¡Gracias! Recibimos tu solicitud y pronto nos comunicaremos contigo.`

---

## 7. Métricas de Impacto y Componentes Interactivos

* **Red de Partículas Interactivas:** El fondo de la sección `#red` renderiza un canvas interactivo mediante `particles.js` con nodos interconectados en color verde que reaccionan al pasar el cursor.
* **Contadores con Descifrado (Scramble Effect):** Las métricas institucionales (*1865 estudiantes* y *96% de meta formativa*) inician en ceros y calculan progresivamente caracteres alfanuméricos aleatorios hasta revelar la cifra real al entrar en el campo visual del usuario.
* **Carrusel de Testimonios:** La sección `#resenas` permite alternar entre las opiniones de la comunidad mediante botones direccionales accesibles (`‹` y `›`), actualizando la cita, el autor y la imagen sin recargar la página.
* **Canales Directos:** El pie de página integra accesos rápidos para iniciar contacto inmediato por **WhatsApp** (+51 945 683 199) o correo electrónico institucional.

---

## 8. Preguntas Frecuentes y Solución de Problemas (FAQ)

**¿Por qué el formulario muestra un error en el campo DNI?**  
El DNI en Perú exige exactamente 8 dígitos numéricos. Asegúrate de no incluir letras, guiones ni espacios en blanco.

**¿Qué ocurre si presiono el botón de envío varias veces seguidas?**  
Por seguridad contra saturación y duplicados accidentales, el sistema te solicitará esperar 8 segundos entre cada solicitud.

**¿Cómo restauro la consola si se llena de texto?**  
Puedes pulsar el botón interactivo `limpiar` o escribir el comando `limpiar` en la línea de órdenes y presionar `Enter`.

**¿Dónde se almacenan los datos registrados?**  
La información se transmite cifrada bajo el protocolo HTTPS / TLS 1.3 directamente a las tablas protegidas de Supabase, aplicando políticas de seguridad a nivel de fila (*Row Level Security* - RLS) que impiden el acceso no autorizado a los registros.
