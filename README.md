# 🛡️ ESCUDO: Plataforma Institucional & Intranet ORDS
> **Plataforma Web:** [alyssunrise-13.github.io/ESCUDO](https://alyssunrise-13.github.io/ESCUDO/)  
> **Intranet Táctica:** [alyssunrise-13.github.io/ESCUDO/intranet.html](https://alyssunrise-13.github.io/ESCUDO/intranet.html)  
> **Motor de Base de Datos:** Oracle Database 23ai + Oracle REST Data Services (ORDS)  
> **Sede:** Ayacucho, Perú
---
## 🎯 Descripción
**ESCUDO** (*Escuela de Seguridad Cibernética y Unidad de Defensa Operativa*) es un portal institucional y sistema de gestión académica con estética táctica SOC (*Security Operations Center*).
Integra:
1. **Portal Público:** Terminal interactiva de comandos vocacionales, catálogo de 6 carreras y formulario de admisión conectado en tiempo real con **Supabase PostgreSQL**.
2. **Intranet Táctica:** Centro de mando conectado en vivo mediante API REST a **Oracle Database 23ai** a través de **Oracle REST Data Services (ORDS)**.
---
## 🏛️ Intranet Institucional (`intranet.html`)
Panel de control para la **Dirección Académica (Nivel 4)** con autenticación SHA-256 y bloqueo anti-fuerza bruta:
* **Motor REST:** Conexión directa a `https://oracleapex.com/ords/escudo/`.
* **Módulos Operativos:**
  1. `[01] Estudiantes & Matrículas:` 90 alumnos, filtros por turno/carrera, notas individuales y exportación a CSV.
  2. `[02] Carreras & Cursos:` 6 carreras técnicas y 18 asignaturas especializadas.
  3. `[03] Plana Docente:` 8 instructores y asignaturas titulares.
  4. `[04] Secciones & Horarios:` 18 secciones en turnos Mañana, Tarde y Noche en laboratorios tácticos.
  5. `[05] Rúbricas & Evaluaciones:` 8 rúbricas oficiales (FOR1, TA1, TA2, TA3, EP, RUB, PROY, EF) con ponderación al 100%.
  6. `[06] Auditoría de Pagos:` 135 comprobantes registrados con balances y montos totales.
---
## 💾 Arquitectura de Datos y Data Modeler
Base de datos relacional modelada en **Tercera Forma Normal (3FN)** con **Oracle SQL Developer Data Modeler**.
```text
ESCUDO/
├── ESCUDO DATA MODELER.dmd      # Diseño maestro en Oracle Data Modeler
├── ESCUDO DATA MODELER/         # Modelos lógicos y relacionales
├── ESCUDO SQL/                  # Scripts y artefactos de BD
│   ├── 0_DDL_ESTRUCTURA.sql    # Creación de las 11 tablas y constraints
│   ├── 1_DML_LIMPIO.sql        # Poblado masivo (90 alumnos, 720 notas, 135 pagos)
│   ├── 2_DML_MODIFICADO.sql    # Casos de prueba y auditoría
│   ├── 3_DEMO_Y_CONSULTAS.sql  # Consultas analíticas y reportes
│   ├── HABILITAR_ORDS_APEX.sql # Exposición de endpoints REST en Oracle APEX
│   ├── ESCUDOlogico.png        # Diagrama Lógico Entidad-Relación
│   └── ESCUDOrelacional.png    # Diagrama Físico Relacional
├── supabase/                    # Script SQL para postulaciones en Supabase
├── apex-config.js               # Conexión frontend con ORDS
├── index.html                   # Landing institucional y terminal SOC
├── intranet.html                # Dashboard administrativo
├── main.js                      # Lógica de terminal y admisión
└── styles.css                   # Estilos tácticos neón / alto contraste
```
### Entidades del Modelo (11 Tablas)
* `ESTUDIANTE` | `CARRERA` | `CURSO` | `DOCENTE` | `SECCION` | `PERIODO`
* `MATRICULA` | `TIPO_EVALUACION` | `EVALUACION` (Notas 0-20) | `CONCEPTO_PAGO` | `PAGO`
---
## ⚡ Ejecución Rápida
No requiere servidores locales ni instalaciones complejas:
1. Clona el repositorio:
   ```bash
   git clone https://github.com/alyssunrise-13/ESCUDO.git
   ```
2. Abre `index.html` para la plataforma pública o `intranet.html` para el dashboard de gestión.
3. Para desplegar la base de datos en Oracle: ejecuta en orden los scripts dentro de `ESCUDO SQL/` en DBeaver o SQL Developer.
