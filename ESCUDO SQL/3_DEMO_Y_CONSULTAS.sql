-- ====================================================================
-- ARCHIVO 3: GUÍA INTEGRAL DE DEMOSTRACIÓN, CONSULTAS, AUDITORÍA Y RESTRICCIONES
-- INSTITUTO TECNOLÓGICO ESCUDO / SENATI - TRABAJO FINAL PIAD-223
-- CONTENIDO:
-- 1. Comprobaciones de Restricciones (CHECK, UNIQUE, DEFAULT, PK, FK).
-- 2. Las 5 Consultas SELECT Oficiales requeridas por SENATI.
-- 3. Sistema de Auditoría con Ejemplos Reales (TRUNCATE vs DROP).
-- 4. Demostración de ALTER TABLE con error inducido ORA-02290.
-- 5. Demostración de DELETE con error inducido ORA-02292 (Foreign Key).
-- 6. Demostración en vivo: Registrar a un nuevo estudiante paso a paso.
-- ====================================================================


-- ====================================================================
-- PARTE 1: COMPROBACIONES DE RESTRICCIONES (DIAPOSITIVAS DE SENATI)
-- Demuestra el cumplimiento de las reglas de integridad de la base de datos:
-- PRIMARY KEY, FOREIGN KEY, UNIQUE, CHECK y DEFAULT.
-- ====================================================================

-- 1.1. Inspección de restricciones en el Diccionario de Datos de Oracle:
-- Tipos: 'P' = Primary Key, 'R' = Referential (FK), 'U' = Unique, 'C' = Check / Not Null
SELECT 
    table_name        AS "TABLA",
    constraint_name   AS "NOMBRE RESTRICCIÓN",
    constraint_type   AS "TIPO",
    search_condition  AS "CONDICIÓN DE REGLA"
FROM user_constraints
WHERE table_name IN ('ESTUDIANTE', 'CURSO', 'EVALUACION', 'SECCION')
ORDER BY table_name, constraint_type;

-- 1.2. COMPROBACIÓN DE RESTRICCIÓN UNIQUE (Error Inducido):
-- Regla: No pueden existir dos estudiantes con el mismo DNI o correo.
-- Intentamos insertar un estudiante con el DNI de Lucero Fioma ('71829301'):
-- Descomenta la siguiente línea para mostrar el error en vivo al docente:
-- INSERT INTO ESTUDIANTE (id_estudiante, cod_estudiante, nombres, apellidos, dni, correo, telefono, id_carrera)
-- VALUES (999, 'EST-999', 'Prueba', 'Duplicado', '71829301', 'duplicado@escudo.edu.pe', '966000000', 1);
-- RESULTADO OBTENIDO: ORA-00001: unique constraint (SYSTEM.UK_ESTUDIANTE_DNI) violated

-- 1.3. COMPROBACIÓN DE RESTRICCIÓN CHECK (Error Inducido):
-- Regla: Las notas deben pertenecer estrictamente a la escala vigesimal (0.00 a 20.00).
-- Intentamos insertar una nota de 25.00:
-- Descomenta la siguiente línea para mostrar el error en vivo:
-- INSERT INTO EVALUACION (id_evaluacion, cod_evaluacion, nota_obtenida, fecha_evaluacion, id_matricula, id_tipo_eval)
-- VALUES (9999, 'EV-9999', 25.00, SYSDATE, 1, 1);
-- RESULTADO OBTENIDO: ORA-02290: check constraint (SYSTEM.CK_EVAL_NOTA) violated

-- 1.4. COMPROBACIÓN DE VALOR POR DEFECTO (DEFAULT):
-- Regla: Si se omite la fecha de registro o estado, Oracle asigna SYSDATE y 'ACTIVO'.
INSERT INTO CARRERA (id_carrera, cod_carrera, nombre_carrera) 
VALUES (7, 'TEST-07', 'Carrera de Demostración Default');

-- Verificamos que duracion_semestres tomó 6 y estado tomó 'ACTIVO' automáticamente:
SELECT id_carrera, cod_carrera, duracion_semestres, estado 
FROM CARRERA WHERE id_carrera = 7;

-- Limpieza de la prueba:
DELETE FROM CARRERA WHERE id_carrera = 7;
COMMIT;



-- ====================================================================
-- PARTE 2: LAS 5 CONSULTAS OFICIALES REQUERIDAS POR SENATI (PIAD-223)
-- ====================================================================

-- --------------------------------------------------------------------
-- CONSULTA 1: Estudiantes registrados con su carrera profesional
-- Requisito: "Una consulta que muestre todos los estudiantes registrados con su carrera"
-- Cláusulas: INNER JOIN, ORDER BY
-- --------------------------------------------------------------------
SELECT 
    e.cod_estudiante   AS "CÓDIGO",
    e.dni              AS "DNI",
    e.apellidos || ', ' || e.nombres AS "ESTUDIANTE",
    e.correo           AS "CORREO INSTITUCIONAL",
    e.telefono         AS "CELULAR",
    c.nombre_carrera   AS "CARRERA PROFESIONAL",
    TO_CHAR(e.fecha_registro, 'DD/MM/YYYY') AS "FECHA REGISTRO"
FROM ESTUDIANTE e
INNER JOIN CARRERA c ON e.id_carrera = c.id_carrera
ORDER BY e.apellidos ASC;


-- --------------------------------------------------------------------
-- CONSULTA 2: Estudiantes con sus respectivos cursos matriculados
-- Requisito: "Una consulta que muestre estudiantes con sus respectivos cursos"
-- Cláusulas: Relaciona 4 tablas (ESTUDIANTE, MATRICULA, SECCION, CURSO)
-- --------------------------------------------------------------------
SELECT 
    e.cod_estudiante   AS "CÓD. ESTUDIANTE",
    e.nombres || ' ' || e.apellidos AS "ESTUDIANTE",
    cur.cod_curso      AS "CÓD. CURSO",
    cur.nombre_curso   AS "CURSO MATRICULADO",
    s.cod_seccion      AS "SECCIÓN",
    s.aula             AS "LABORATORIO",
    s.turno            AS "TURNO",
    m.estado_matricula AS "ESTADO MATRÍCULA"
FROM ESTUDIANTE e
INNER JOIN MATRICULA m ON e.id_estudiante = m.id_estudiante
INNER JOIN SECCION s   ON m.id_seccion = s.id_seccion
INNER JOIN CURSO cur   ON s.id_curso = cur.id_curso
ORDER BY cur.nombre_curso, e.apellidos;


-- --------------------------------------------------------------------
-- CONSULTA 3: Cursos activos con sus docentes especialistas asignados
-- Requisito: "Una consulta que muestre cursos con sus docentes asignados y filtro WHERE"
-- Cláusulas: INNER JOIN, WHERE, ORDER BY
-- --------------------------------------------------------------------
SELECT 
    cur.cod_curso    AS "CÓDIGO",
    cur.nombre_curso AS "CURSO FORMATIVO",
    cur.creditos     AS "CRÉDITOS",
    cur.horas        AS "HORAS",
    d.nombres || ' ' || d.apellidos AS "DOCENTE A CARGO",
    d.especialidad   AS "ESPECIALIDAD DOCENTE",
    s.aula           AS "LABORATORIO",
    s.turno          AS "TURNO"
FROM CURSO cur
INNER JOIN SECCION s ON cur.id_curso = s.id_curso
INNER JOIN DOCENTE d ON s.id_docente = d.id_docente
WHERE cur.estado = 'ACTIVO'
ORDER BY cur.nombre_curso;


-- --------------------------------------------------------------------
-- CONSULTA 4: Reporte Académico Integral de Notas y Condición Aprobatoria
-- Requisito: "Notas de estudiantes por curso y condición de aprobado/desaprobado"
-- Cláusulas: 5 tablas relacionadas, CASE WHEN con escala vigesimal (Aprobado >= 12.5)
-- --------------------------------------------------------------------
SELECT 
    e.nombres || ' ' || e.apellidos AS "ESTUDIANTE",
    cur.nombre_curso   AS "CURSO",
    te.codigo_tipo     AS "CÓD. EVAL",
    te.nombre_tipo     AS "RUBRO DE EVALUACIÓN",
    te.peso_porcentaje || '%' AS "PESO",
    ev.nota_obtenida   AS "NOTA",
    CASE 
        WHEN ev.nota_obtenida >= 12.5 THEN 'APROBADO' 
        ELSE 'DESAPROBADO' 
    END AS "CONDICIÓN",
    TO_CHAR(ev.fecha_evaluacion, 'DD/MM/YYYY') AS "FECHA EVALUACIÓN"
FROM ESTUDIANTE e
INNER JOIN MATRICULA m        ON e.id_estudiante = m.id_estudiante
INNER JOIN SECCION s          ON m.id_seccion = s.id_seccion
INNER JOIN CURSO cur          ON s.id_curso = cur.id_curso
INNER JOIN EVALUACION ev      ON m.id_matricula = ev.id_matricula
INNER JOIN TIPO_EVALUACION te ON ev.id_tipo_eval = te.id_tipo_eval
ORDER BY cur.nombre_curso, e.apellidos, te.id_tipo_eval;


-- --------------------------------------------------------------------
-- CONSULTA 5: Ranking de Cursos con Mayor Demanda de Matrícula
-- Requisito: "¿Qué cursos tienen mayor cantidad de matrículas?"
-- Cláusulas: GROUP BY, COUNT, ORDER BY DESC
-- --------------------------------------------------------------------
SELECT 
    cur.cod_curso         AS "CÓDIGO",
    cur.nombre_curso      AS "CURSO",
    COUNT(m.id_matricula) AS "TOTAL MATRICULADOS"
FROM CURSO cur
INNER JOIN SECCION s  ON cur.id_curso = s.id_curso
LEFT JOIN MATRICULA m ON s.id_seccion = m.id_seccion
GROUP BY cur.cod_curso, cur.nombre_curso
ORDER BY COUNT(m.id_matricula) DESC;



-- ====================================================================
-- PARTE 3: AUDITORÍA DEL SISTEMA (CREACIÓN, EJEMPLOS, TRUNCATE Y DROP)
-- ====================================================================

-- 3.1. Creación de la tabla de auditoría:
CREATE TABLE AUDITORIA_SISTEMA (
    id_log NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    usuario_operador VARCHAR2(50) NOT NULL,
    accion_evento    VARCHAR2(100) NOT NULL,
    ip_terminal      VARCHAR2(25) NOT NULL,
    estado_evento    VARCHAR2(15) NOT NULL,
    fecha_hora       TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3.2. Inserción de eventos de auditoría del SOC:
INSERT INTO AUDITORIA_SISTEMA (usuario_operador, accion_evento, ip_terminal, estado_evento)
VALUES ('admin_fioma', 'ACCESO_CONSOLA_APEX', '192.168.0.133', 'EXITOSO');

INSERT INTO AUDITORIA_SISTEMA (usuario_operador, accion_evento, ip_terminal, estado_evento)
VALUES ('soc_analyst_01', 'ALERTA_ESCANEO_PUERTOS', '192.168.0.105', 'BLOQUEADO');

INSERT INTO AUDITORIA_SISTEMA (usuario_operador, accion_evento, ip_terminal, estado_evento)
VALUES ('operador_matricula', 'REGISTRO_NUEVO_ESTUDIANTE', '192.168.0.45', 'EXITOSO');

INSERT INTO AUDITORIA_SISTEMA (usuario_operador, accion_evento, ip_terminal, estado_evento)
VALUES ('usuario_desconocido', 'INTENTO_FALLIDO_PASSWORD', '192.168.0.88', 'DENEGADO');

COMMIT;

-- 3.3. Consultas de auditoría con filtros WHERE:
SELECT * FROM AUDITORIA_SISTEMA ORDER BY fecha_hora DESC;

SELECT usuario_operador, accion_evento, ip_terminal, fecha_hora 
FROM AUDITORIA_SISTEMA 
WHERE estado_evento IN ('BLOQUEADO', 'DENEGADO');

-- 3.4. Demostración de TRUNCATE:
-- Vacía instantáneamente todos los registros conservando la tabla y sus metadatos (DDL).
TRUNCATE TABLE AUDITORIA_SISTEMA;

SELECT COUNT(*) AS total_post_truncate FROM AUDITORIA_SISTEMA;

-- 3.5. Demostración de DROP:
-- Elimina por completo la tabla del diccionario de datos de Oracle.
DROP TABLE AUDITORIA_SISTEMA PURGE;



-- ====================================================================
-- PARTE 4: DEMOSTRACIÓN DE ALTER TABLE (EVOLUCIÓN DEL ESQUEMA)
-- ====================================================================

-- 4.1. Agregar columna para control de becas:
ALTER TABLE ESTUDIANTE ADD (condicion_beca VARCHAR2(15) DEFAULT 'REGULAR' NOT NULL);

-- 4.2. Agregar restricción de validación (CHECK constraint):
ALTER TABLE ESTUDIANTE ADD CONSTRAINT CK_ESTUDIANTE_BECA 
CHECK (condicion_beca IN ('REGULAR', 'BECA_TALENTO', 'SEMIBECA'));

-- 4.3. ERROR INDUCIDO (Descomenta para mostrar el error en vivo):
-- UPDATE ESTUDIANTE SET condicion_beca = 'GRATIS_TOTAL' WHERE id_estudiante = 1;
-- RESULTADO OBTENIDO: ORA-02290: check constraint (SYSTEM.CK_ESTUDIANTE_BECA) violated

-- 4.4. Solución Correcta:
UPDATE ESTUDIANTE SET condicion_beca = 'BECA_TALENTO' WHERE id_estudiante = 1;
COMMIT;

-- 4.5. Limpieza: Dejar el modelo original de 11 tablas intacto:
ALTER TABLE ESTUDIANTE DROP CONSTRAINT CK_ESTUDIANTE_BECA;
ALTER TABLE ESTUDIANTE DROP COLUMN condicion_beca;



-- ====================================================================
-- PARTE 5: DEMOSTRACIÓN DE DELETE Y PROTECCIÓN DE INTEGRIDAD REFERENCIAL
-- ====================================================================

-- 5.1. ERROR INDUCIDO (Intentar borrar a un estudiante matriculado):
-- DELETE FROM ESTUDIANTE WHERE id_estudiante = 1;
-- RESULTADO OBTENIDO: ORA-02292: integrity constraint (SYSTEM.FK_MATRICULA_ESTUDIANTE) violated - child record found

-- 5.2. EXPLICACIÓN PARA TU EVALUACIÓN:
-- "Oracle protege la integridad referencial. El estudiante posee registros vinculados
-- en MATRICULA, EVALUACION y PAGO. El motor prohíbe eliminarlo directamente
-- para evitar inconsistencias y registros huérfanos en la base de datos."



-- ====================================================================
-- PARTE 6: DEMOSTRACIÓN EN VIVO - REGISTRO DE UN NUEVO ESTUDIANTE
-- ====================================================================

-- Paso 1: Registrar al nuevo estudiante en Ciberseguridad
INSERT INTO ESTUDIANTE (id_estudiante, cod_estudiante, nombres, apellidos, dni, correo, telefono, fecha_registro, id_carrera)
VALUES (91, 'EST-091', 'Alejandro', 'Vargas Quispe', '74829105', 'avargas@escudo.edu.pe', '966998877', SYSDATE, 1);

-- Paso 2: Matricularlo en la Sección 1 (Turno Mañana)
INSERT INTO MATRICULA (id_matricula, cod_matricula, fecha_matricula, estado_matricula, id_estudiante, id_seccion)
VALUES (91, 'MAT-2026-091', SYSDATE, 'REGISTRADA', 91, 1);

-- Paso 3: Registrar el pago de su matrícula (S/ 250.00 con Billetera Digital)
INSERT INTO PAGO (id_pago, cod_recibo, monto_pagado, fecha_pago, metodo_pago, estado_pago, id_matricula, id_concepto)
VALUES (136, 'REC-2026-0136', 250.00, SYSDATE, 'BILLETERA_DIGITAL', 'PAGADO', 91, 1);

-- Paso 4: Registrar sus notas del sistema ESCUDO (Foro: 18.00 y Tarea 1: 17.50)
INSERT INTO EVALUACION (id_evaluacion, cod_evaluacion, nota_obtenida, fecha_evaluacion, id_matricula, id_tipo_eval)
VALUES (721, 'EV-0721', 18.00, SYSDATE, 91, 1);

INSERT INTO EVALUACION (id_evaluacion, cod_evaluacion, nota_obtenida, fecha_evaluacion, id_matricula, id_tipo_eval)
VALUES (722, 'EV-0722', 17.50, SYSDATE, 91, 2);

COMMIT;

-- Paso 5: Consultar la ficha integral del nuevo estudiante registrado
SELECT 
    e.cod_estudiante   AS "CÓDIGO",
    e.nombres || ' ' || e.apellidos AS "ALUMNO",
    c.nombre_carrera   AS "CARRERA",
    cur.nombre_curso   AS "CURSO",
    s.turno            AS "TURNO",
    s.aula             AS "LABORATORIO",
    d.nombres || ' ' || d.apellidos AS "DOCENTE",
    t.codigo_tipo      AS "EVAL",
    ev.nota_obtenida   AS "NOTA",
    p.monto_pagado     AS "PAGO (S/)",
    p.metodo_pago      AS "MÉTODO"
FROM ESTUDIANTE e
JOIN CARRERA c ON e.id_carrera = c.id_carrera
JOIN MATRICULA m ON e.id_estudiante = m.id_estudiante
JOIN SECCION s ON m.id_seccion = s.id_seccion
JOIN CURSO cur ON s.id_curso = cur.id_curso
JOIN DOCENTE d ON s.id_docente = d.id_docente
LEFT JOIN EVALUACION ev ON m.id_matricula = ev.id_matricula
LEFT JOIN TIPO_EVALUACION t ON ev.id_tipo_eval = t.id_tipo_eval
LEFT JOIN PAGO p ON m.id_matricula = p.id_matricula
WHERE e.id_estudiante = 91;
