# 🛡️ ESCUDO: Plataforma Institucional, Terminal SOC e Intranet ORDS
## Manual de Usuario y Guía de Operación del Sistema

> **Estado del despliegue:** Operativo en producción  
> **Versión:** v3.0.0 (Actualizada con Intranet y Oracle Cloud)  
> **Portal Web:** [https://alyssunrise-13.github.io/ESCUDO/](https://alyssunrise-13.github.io/ESCUDO/)  
> **Intranet Institucional:** [https://alyssunrise-13.github.io/ESCUDO/intranet.html](https://alyssunrise-13.github.io/ESCUDO/intranet.html)  
> **Sede académica:** Ayacucho, Perú

> **Consejo:** Se recomienda usar `Ctrl` + `-` si desea reducir los márgenes, ya que la interfaz está diseñada con escala táctica de alta accesibilidad para pantallas SOC.

---

## 📌 Tabla de Contenidos
1. [Descripción General](#1-descripción-general)
2. [Requisitos de Acceso y Compatibilidad](#2-requisitos-de-acceso-y-compatibilidad)
3. [Navegación y Accesibilidad Universal](#3-navegación-y-accesibilidad-universal)
4. [Manual Operativo de la Consola Táctica (SOC Terminal)](#4-manual-operativo-de-la-consola-táctica-soc-terminal)
5. [Exploración de Carreras y Auto-selección](#5-exploración-de-carreras-y-auto-selección)
6. [Módulo de Admisión y Persistencia en Supabase](#6-módulo-de-admisión-y-persistencia-en-supabase)
7. [Intranet Institucional y Conexión en Vivo con Oracle ORDS (Nuevo)](#7-intranet-institucional-y-conexión-en-vivo-con-oracle-ords-nuevo)
8. [Arquitectura de Base de Datos y Data Modeler (Nuevo)](#8-arquitectura-de-base-de-datos-y-data-modeler-nuevo)
9. [Preguntas Frecuentes y Solución de Problemas (FAQ)](#9-preguntas-frecuentes-y-solución-de-problemas-faq)

---

## 1. Descripción General

**ESCUDO** (*Escuela de Seguridad Cibernética y Unidad de Defensa Operativa*) es un portal institucional diseñado para la orientación vocacional, captación de postulantes y gestión académica integral en tecnologías de ciberseguridad e ingeniería de software.

La plataforma cuenta con una estética inspirada en un **Centro de Operaciones de Seguridad (SOC)** con fondo oscuro `#030503`, acentos en verde neón `#00ff41`, consola interactiva, persistencia de postulantes en **Supabase** y un panel de gestión académica sincronizado vía REST con **Oracle Database 23ai**.

---

## 2. Requisitos de Acceso y Compatibilidad

El portal funciona 100% en el navegador (*client-side*):
* **Navegadores recomendados:** Google Chrome, Microsoft Edge, Mozilla Firefox, Brave o Safari.
* **Conectividad:** Conexión a internet para tipografías, librerías (`particles.js`) y APIs REST (Supabase y Oracle ORDS).
* **Diseño Adaptable:** Autoescalado fluido desde pantallas móviles (390px) hasta monitores ultrawide (>1300px).

---

## 3. Navegación y Accesibilidad Universal

Sigue los estándares internacionales WCAG 2.1 AAA:
* **Enlace de Salto Accesible:** Tecla `Tab` para activar `.salto-contenido` y enfocar el contenido principal.
* **Barra de Navegación Fija:** Enlaces directos a `#inicio`, `#admision`, `#carreras`, `#nosotros`, `#resenas` y acceso a la `Intranet`.
* **Menú Móvil Colapsable:** Desplegable accesible para smartphones con control de teclado (`Escape`).
* **Sensibilidad al Movimiento:** Regla CSS `@media (prefers-reduced-motion: reduce)` para mitigar animaciones.

---

## 4. Manual Operativo de la Consola Táctica (SOC Terminal)

En la sección de cabecera (*Hero*) se encuentra la **Consola Operativa v2.6.4** interactiva.

### 4.1. Indicadores del Monitor Perimetral
* **Badges:** Firewall Activo e IDS/IPS en DEFCON 4.
* **Latencia de Red:** Temporizador dinámico entre 11ms y 15ms.
* **Reloj Neon:** Hora oficial de Ayacucho en formato estricto 24 horas (`hh:mm:ss`).

### 4.2. Comandos CLI Soportados
Escribe en el prompt `escudo@soc:~$` y presiona `Enter`:

| Comando | Descripción de la Respuesta |
| :--- | :--- |
| `que_aprendere`, `plan`, `temario` | Despliega detalles sobre hacking ético, redes y proyectos defensivos. |
| `retos_practicos`, `ctf`, `practica` | Metodología de laboratorio táctico *Capture The Flag*. |
| `carreras`, `especialidades` | Desplaza suavemente hacia el catálogo de carreras. |
| `admision`, `postular`, `beca` | Desplaza la vista al formulario y enfoca el campo de postulación. |
| `escanear`, `scan` | Diagnóstico vocacional automatizado en consola. |
| `ayuda`, `help` | Lista las órdenes básicas y comandos de exploración. |
| `limpiar`, `clear`, `cls` | Reinicia la ventana de eventos de la terminal. |
| `hack`, `matrix`, `sudo`, `root` | **Easter Egg:** Pulso neón, audio de alerta y código promocional `#HACKER-ESCUDO-2026`. |

---

## 5. Exploración de Carreras y Auto-selección

La sección **Carreras** (`#carreras`) presenta la formación técnica especializada:
1. **Ciberseguridad y Defensa Digital**
2. **Desarrollo de Software**
3. **Redes y Bases de Datos**
4. **Desarrollo Frontend**
5. **Desarrollo Backend**
6. **Inteligencia Artificial**

> Al pulsar `Me interesa ↗` en cualquier tarjeta, el sistema se desplaza al formulario y **selecciona automáticamente** la carrera elegida.

---

## 6. Módulo de Admisión y Persistencia en Supabase

Formulario en `#admision` conectado con una base de datos PostgreSQL alojada en **Supabase**.

* **Validaciones:** Nombre completo (letras y tildes), correo con formato válido, celular (7 a 15 dígitos) y DNI obligatorio de 8 dígitos numéricos (`^[0-9]{8}$`).
* **Seguridad Integrada:**
  - **Honeypot:** Campo oculto `_hp_security_check` contra bots.
  - **Rate Limiting:** Bloqueo de envíos repetitivos antes de los **8 segundos**.
  - **Sanitización XSS:** Neutralización de etiquetas antes del envío.
  - **Auth Pública:** Validación en Base64 para uso exclusivo del rol `anon`.

---

## 7. Intranet Institucional y Conexión en Vivo con Oracle ORDS (Nuevo)

Accesible desde `intranet.html`, es el centro de mando operativo conectado a **Oracle Database 23ai** a través de **Oracle REST Data Services (ORDS)** en `https://oracleapex.com/ords/escudo/`.

### 7.1. Niveles de Acceso (Clearance Levels)
* **Estudiantes (LVL-1) / Docentes (LVL-2):** En mantenimiento y auditoría semestral temporal.
* **Dirección Académica (LVL-4):** Acceso habilitado con validación criptográfica en **SHA-256** y protección contra ataques de fuerza bruta (bloqueo forzoso de 30 segundos tras 3 intentos erróneos).

### 7.2. Módulos Operativos del Dashboard
1. **`[01] Estudiantes & Matrículas:`** Padrón de 90 alumnos matriculados, filtros interactivos por turno y carrera, notas individuales, insignia de rendimiento y exportación a **CSV**.
2. **`[02] Carreras & Cursos:`** Catálogo de las 6 carreras técnicas y 18 especialidades curriculares.
3. **`[03] Plana Docente:`** Registro de 8 docentes titulares de cursos.
4. **`[04] Secciones & Horarios:`** 18 secciones distribuidas en turnos Mañana, Tarde y Noche y aulas/laboratorios tácticos.
5. **`[05] Rúbricas & Evaluaciones:`** 8 rúbricas oficiales vigesimales SENATI (FOR1, TA1, TA2, TA3, EP, RUB, PROY, EF) con ponderación al 100%.
6. **`[06] Auditoría de Pagos:`** Fiscalización de 135 recibos emitidos con estados (`PAGADO`/`PENDIENTE`), métodos de pago y monto consolidado.

---

## 8. Arquitectura de Base de Datos y Data Modeler (Nuevo)

El modelo de datos institucional fue diseñado y normalizado en **Tercera Forma Normal (3FN)** con **Oracle SQL Developer Data Modeler**.

### 8.1. Estructura de Archivos
* `ESCUDO DATA MODELER/` y `ESCUDO DATA MODELER.dmd`: Modelo lógico y relacional completo.
* `ESCUDO SQL/0_DDL_ESTRUCTURA.sql`: Creación de las 11 tablas con Primary Keys, Foreign Keys y restricciones de comprobación (`CHECK`).
* `ESCUDO SQL/1_DML_LIMPIO.sql`: Poblado de datos (90 estudiantes, 18 secciones, 720 notas vigesimales, 135 pagos).
* `ESCUDO SQL/2_DML_MODIFICADO.sql` y `3_DEMO_Y_CONSULTAS.sql`: Consultas analíticas y reportes académicos.
* `ESCUDO SQL/HABILITAR_ORDS_APEX.sql`: Script de habilitación de endpoints REST en Oracle Cloud.
* `ESCUDO SQL/ESCUDOlogico.png` y `ESCUDOrelacional.png`: Diagramas visuales de la arquitectura.

### 8.2. Entidades Relacionales (11 Tablas)
`ESTUDIANTE` ➔ `MATRICULA` ➔ `SECCION` ➔ `CURSO` ➔ `CARRERA`  
`DOCENTE` ➔ `CURSO` | `PERIODO` ➔ `MATRICULA`  
`MATRICULA` ➔ `EVALUACION` ➔ `TIPO_EVALUACION` (Notas 00 a 20)  
`MATRICULA` ➔ `PAGO` ➔ `CONCEPTO_PAGO`  

---

## 9. Preguntas Frecuentes y Solución de Problemas (FAQ)

**¿Cómo accedo a la Intranet?**  
Ingresa a `intranet.html` desde el botón superior del sitio, selecciona **Dirección Académica** e ingresa la contraseña institucional autorizada.

**¿Qué pasa si fallo la contraseña 3 veces?**  
El sistema activa el protocolo de defensa y bloquea el botón de acceso durante 30 segundos.

**¿Dónde se guardan los postulantes y los datos académicos?**  
Los postulantes del formulario web se registran en **Supabase (PostgreSQL)**, mientras que la información académica y financiera institucional reside en **Oracle Database 23ai** sincronizada por **ORDS**.

**¿Dónde veo los diagramas de base de datos?**  
En la carpeta `ESCUDO SQL/` del repositorio: `ESCUDOlogico.png` (Modelo Lógico) y `ESCUDOrelacional.png` (Modelo Relacional).
