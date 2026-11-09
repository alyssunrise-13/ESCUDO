-- ====================================================================
-- ESCUDO - DEMOSTRACIÓN DE CONSULTAS, RESTRICCIONES Y AUDITORÍA
-- ====================================================================

-- --------------------------------------------------------------------
-- 1. COMPROBACIÓN DE RESTRICCIONES EN EL DICCIONARIO DE DATOS
-- --------------------------------------------------------------------
SELECT 
    table_name        AS "TABLA",
    constraint_name   AS "NOMBRE RESTRICCIÓN",
    constraint_type   AS "TIPO",
    search_condition  AS "CONDICIÓN DE REGLA"
FROM user_constraints
WHERE table_name IN ('ESTUDIANTE', 'CURSO', 'EVALUACION', 'SECCION')
ORDER BY table_name, constraint_type;

-- 1.1 Error inducido: UNIQUE (DNI duplicado -> ORA-00001)
-- INSERT INTO ESTUDIANTE (id_estudiante, cod_estudiante, nombres, apellidos, dni, correo, telefono, id_carrera)
-- VALUES (999, 'EST-999', 'Prueba', 'Duplicado', '71829301', 'duplicado@escudo.edu.pe', '966000000', 1);

-- 1.2 Error inducido: CHECK (Nota > 20.00 -> ORA-02290)
-- INSERT INTO EVALUACION (id_evaluacion, cod_evaluacion, nota_obtenida, fecha_evaluacion, id_matricula, id_tipo_eval)
-- VALUES (9999, 'EV-9999', 25.00, SYSDATE, 1, 1);

-- 1.3 Valor por defecto (DEFAULT): duracion_semestres=6, estado='ACTIVO'
INSERT INTO CARRERA (id_carrera, cod_carrera, nombre_carrera) 
VALUES (7, 'TEST-07', 'Carrera Demostración Default');

SELECT id_carrera, cod_carrera, duracion_semestres, estado 
FROM CARRERA WHERE id_carrera = 7;

DELETE FROM CARRERA WHERE id_carrera = 7;
COMMIT;


-- --------------------------------------------------------------------
-- 2. CONSULTAS OFICIALES REQUERIDAS (PIAD-223)
-- --------------------------------------------------------------------

-- Consulta 1: Estudiantes registrados con su carrera profesional
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

-- Consulta 2: Estudiantes con sus respectivos cursos matriculados
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

-- Consulta 3: Cursos activos con docentes asignados
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

-- Consulta 4: Reporte de notas y condición académica (Escala vigesimal >= 12.5)
SELECT 
    e.nombres || ' ' || e.apellidos AS "ESTUDIANTE",
    cur.nombre_curso   AS "CURSO",
    te.codigo_tipo     AS "CÓD. EVAL",
    te.nombre_tipo     AS "RUBRO EVALUACIÓN",
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

-- Consulta 5: Demanda de matrícula por curso
SELECT 
    cur.cod_curso         AS "CÓDIGO",
    cur.nombre_curso      AS "CURSO",
    COUNT(m.id_matricula) AS "TOTAL MATRICULADOS"
FROM CURSO cur
INNER JOIN SECCION s  ON cur.id_curso = s.id_curso
LEFT JOIN MATRICULA m ON s.id_seccion = m.id_seccion
GROUP BY cur.cod_curso, cur.nombre_curso
ORDER BY COUNT(m.id_matricula) DESC;


-- --------------------------------------------------------------------
-- 3. AUDITORÍA (CREACIÓN, INSERCIÓN, TRUNCATE Y DROP)
-- --------------------------------------------------------------------
CREATE TABLE AUDITORIA_SISTEMA (
    id_log           NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    usuario_operador VARCHAR2(50) NOT NULL,
    accion_evento    VARCHAR2(100) NOT NULL,
    ip_terminal      VARCHAR2(25) NOT NULL,
    estado_evento    VARCHAR2(15) NOT NULL,
    fecha_hora       TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO AUDITORIA_SISTEMA (usuario_operador, accion_evento, ip_terminal, estado_evento)
VALUES ('admin_fioma', 'ACCESO_CONSOLA_APEX', '192.168.0.133', 'EXITOSO');

INSERT INTO AUDITORIA_SISTEMA (usuario_operador, accion_evento, ip_terminal, estado_evento)
VALUES ('soc_analyst_01', 'ALERTA_ESCANEO_PUERTOS', '192.168.0.105', 'BLOQUEADO');

INSERT INTO AUDITORIA_SISTEMA (usuario_operador, accion_evento, ip_terminal, estado_evento)
VALUES ('operador_matricula', 'REGISTRO_NUEVO_ESTUDIANTE', '192.168.0.45', 'EXITOSO');

INSERT INTO AUDITORIA_SISTEMA (usuario_operador, accion_evento, ip_terminal, estado_evento)
VALUES ('usuario_desconocido', 'INTENTO_FALLIDO_PASSWORD', '192.168.0.88', 'DENEGADO');
COMMIT;

SELECT * FROM AUDITORIA_SISTEMA ORDER BY fecha_hora DESC;

SELECT usuario_operador, accion_evento, ip_terminal, fecha_hora 
FROM AUDITORIA_SISTEMA 
WHERE estado_evento IN ('BLOQUEADO', 'DENEGADO');

-- Vaciado de registros (TRUNCATE) y eliminación física (DROP)
TRUNCATE TABLE AUDITORIA_SISTEMA;
SELECT COUNT(*) AS total_post_truncate FROM AUDITORIA_SISTEMA;
DROP TABLE AUDITORIA_SISTEMA PURGE;


-- --------------------------------------------------------------------
-- 4. ALTER TABLE (MODIFICACIÓN Y RESTRICCIÓN DE COLUMNA)
-- --------------------------------------------------------------------
ALTER TABLE ESTUDIANTE ADD (condicion_beca VARCHAR2(15) DEFAULT 'REGULAR' NOT NULL);

ALTER TABLE ESTUDIANTE ADD CONSTRAINT CK_ESTUDIANTE_BECA 
CHECK (condicion_beca IN ('REGULAR', 'BECA_TALENTO', 'SEMIBECA'));

-- Error inducido (Valor no permitido -> ORA-02290):
-- UPDATE ESTUDIANTE SET condicion_beca = 'GRATIS_TOTAL' WHERE id_estudiante = 1;

-- Actualización válida y limpieza de la columna demo:
UPDATE ESTUDIANTE SET condicion_beca = 'BECA_TALENTO' WHERE id_estudiante = 1;
COMMIT;

ALTER TABLE ESTUDIANTE DROP CONSTRAINT CK_ESTUDIANTE_BECA;
ALTER TABLE ESTUDIANTE DROP COLUMN condicion_beca;


-- --------------------------------------------------------------------
-- 5. INTEGRIDAD REFERENCIAL (DELETE CON REGISTROS HIJOS)
-- --------------------------------------------------------------------
-- Error inducido: Intento de borrar estudiante con matrículas asociadas -> ORA-02292
-- DELETE FROM ESTUDIANTE WHERE id_estudiante = 1;


-- --------------------------------------------------------------------
-- 6. FLUJO OPERATIVO: REGISTRO INTEGRAL DE UN NUEVO ESTUDIANTE
-- --------------------------------------------------------------------
-- 1. Registro del estudiante
INSERT INTO ESTUDIANTE (id_estudiante, cod_estudiante, nombres, apellidos, dni, correo, telefono, fecha_registro, id_carrera)
VALUES (91, 'EST-091', 'Alejandro', 'Vargas Quispe', '74829105', 'avargas@escudo.edu.pe', '966998877', SYSDATE, 1);

-- 2. Matrícula en Sección 1
INSERT INTO MATRICULA (id_matricula, cod_matricula, fecha_matricula, estado_matricula, id_estudiante, id_seccion)
VALUES (91, 'MAT-2026-091', SYSDATE, 'REGISTRADA', 91, 1);

-- 3. Registro de pago
INSERT INTO PAGO (id_pago, cod_recibo, monto_pagado, fecha_pago, metodo_pago, estado_pago, id_matricula, id_concepto)
VALUES (136, 'REC-2026-0136', 250.00, SYSDATE, 'BILLETERA_DIGITAL', 'PAGADO', 91, 1);

-- 4. Registro de evaluaciones
INSERT INTO EVALUACION (id_evaluacion, cod_evaluacion, nota_obtenida, fecha_evaluacion, id_matricula, id_tipo_eval)
VALUES (721, 'EV-0721', 18.00, SYSDATE, 91, 1);

INSERT INTO EVALUACION (id_evaluacion, cod_evaluacion, nota_obtenida, fecha_evaluacion, id_matricula, id_tipo_eval)
VALUES (722, 'EV-0722', 17.50, SYSDATE, 91, 2);
COMMIT;

-- 5. Consulta de la ficha completa generada
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
