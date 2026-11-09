-- Generado por Oracle SQL Developer Data Modeler 24.3.1.351.0831
--   en:        2026-11-08 19:44:28 PET
--   sitio:      Oracle Database 21c
--   tipo:      Oracle Database 21c



-- predefined type, no DDL - MDSYS.SDO_GEOMETRY

-- predefined type, no DDL - XMLTYPE

CREATE TABLE CARRERA 
    ( 
     id_carrera         NUMBER (10)  NOT NULL , 
     cod_carrera        VARCHAR2 (10)  NOT NULL , 
     nombre_carrera     VARCHAR2 (100)  NOT NULL , 
     duracion_semestres NUMBER (2) DEFAULT 6  NOT NULL , 
     estado             VARCHAR2 (15) DEFAULT 'ACTIVO'  NOT NULL 
    );

ALTER TABLE CARRERA 
    ADD CONSTRAINT CK_CARRERA_ESTADO 
    CHECK (estado IN ('ACTIVO', 'INACTIVO'));
ALTER TABLE CARRERA 
    ADD CONSTRAINT PK_CARRERA PRIMARY KEY ( id_carrera ) ;

ALTER TABLE CARRERA 
    ADD CONSTRAINT UK_CARRERA_COD UNIQUE ( cod_carrera ) ;

CREATE TABLE CONCEPTO_PAGO 
    ( 
     id_concepto  NUMBER (10)  NOT NULL , 
     cod_concepto VARCHAR2 (10)  NOT NULL , 
     descripcion  VARCHAR2 (80)  NOT NULL , 
     monto_base   NUMBER (8,2)  NOT NULL 
    );

ALTER TABLE CONCEPTO_PAGO 
    ADD CONSTRAINT CK_CONCEPTO_MONTO 
    CHECK (monto_base > 0);
ALTER TABLE CONCEPTO_PAGO 
    ADD CONSTRAINT PK_CONCEPTO_PAGO PRIMARY KEY ( id_concepto ) ;

ALTER TABLE CONCEPTO_PAGO 
    ADD CONSTRAINT UK_CONCEPTO_COD UNIQUE ( cod_concepto ) ;

CREATE TABLE CURSO 
    ( 
     id_curso     NUMBER (10)  NOT NULL , 
     cod_curso    VARCHAR2 (10)  NOT NULL , 
     nombre_curso VARCHAR2 (100)  NOT NULL , 
     creditos     NUMBER (2)  NOT NULL , 
     horas        NUMBER (3)  NOT NULL , 
     ciclo_nivel  NUMBER (2) DEFAULT 1  NOT NULL , 
     estado       VARCHAR2 (15) DEFAULT 'ACTIVO'  NOT NULL , 
     id_carrera   NUMBER (10)  NOT NULL 
    );

ALTER TABLE CURSO 
    ADD CONSTRAINT CK_CURSO_CREDITOS 
    CHECK (creditos BETWEEN 1 AND 10);


ALTER TABLE CURSO 
    ADD CONSTRAINT CK_CURSO_ESTADO 
    CHECK (estado IN ('ACTIVO', 'INACTIVO'));


ALTER TABLE CURSO 
    ADD CONSTRAINT CK_CURSO_HORAS 
    CHECK (horas > 0);
ALTER TABLE CURSO 
    ADD CONSTRAINT PK_CURSO PRIMARY KEY ( id_curso ) ;

ALTER TABLE CURSO 
    ADD CONSTRAINT UK_CURSO_COD UNIQUE ( cod_curso ) ;

CREATE TABLE DOCENTE 
    ( 
     id_docente   NUMBER (10)  NOT NULL , 
     cod_docente  VARCHAR2 (10)  NOT NULL , 
     nombres      VARCHAR2 (80)  NOT NULL , 
     apellidos    VARCHAR2 (80)  NOT NULL , 
     especialidad VARCHAR2 (100)  NOT NULL , 
     correo       VARCHAR2 (100)  NOT NULL , 
     telefono     VARCHAR2 (15) 
    );

ALTER TABLE DOCENTE 
    ADD CONSTRAINT PK_DOCENTE PRIMARY KEY ( id_docente ) ;

ALTER TABLE DOCENTE 
    ADD CONSTRAINT UK_DOCENTE_COD UNIQUE ( cod_docente ) ;

ALTER TABLE DOCENTE 
    ADD CONSTRAINT UK_DOCENTE_CORREO UNIQUE ( correo ) ;

CREATE TABLE ESTUDIANTE 
    ( 
     id_estudiante  NUMBER (10)  NOT NULL , 
     cod_estudiante VARCHAR2 (10)  NOT NULL , 
     nombres        VARCHAR2 (80)  NOT NULL , 
     apellidos      VARCHAR2 (80)  NOT NULL , 
     dni            CHAR (8)  NOT NULL , 
     correo         VARCHAR2 (100)  NOT NULL , 
     telefono       VARCHAR2 (15) , 
     fecha_registro DATE DEFAULT SYSDATE  NOT NULL , 
     id_carrera     NUMBER (10)  NOT NULL 
    );

ALTER TABLE ESTUDIANTE 
    ADD CONSTRAINT CK_ESTUDIANTE_DNI 
    CHECK (LENGTH(dni) = 8);
ALTER TABLE ESTUDIANTE 
    ADD CONSTRAINT PK_ESTUDIANTE PRIMARY KEY ( id_estudiante ) ;

ALTER TABLE ESTUDIANTE 
    ADD CONSTRAINT UK_ESTUDIANTE_COD UNIQUE ( cod_estudiante ) ;

ALTER TABLE ESTUDIANTE 
    ADD CONSTRAINT UK_ESTUDIANTE_CORREO UNIQUE ( correo ) ;

ALTER TABLE ESTUDIANTE 
    ADD CONSTRAINT UK_ESTUDIANTE_DNI UNIQUE ( dni ) ;

CREATE TABLE EVALUACION 
    ( 
     id_evaluacion    NUMBER (10)  NOT NULL , 
     cod_evaluacion   VARCHAR2 (20)  NOT NULL , 
     nota_obtenida    NUMBER (4,2)  NOT NULL , 
     fecha_evaluacion DATE DEFAULT SYSDATE  NOT NULL , 
     id_matricula     NUMBER (10)  NOT NULL , 
     id_tipo_eval     NUMBER (10)  NOT NULL 
    );

ALTER TABLE EVALUACION 
    ADD CONSTRAINT CK_EVAL_NOTA 
    CHECK (nota_obtenida BETWEEN 0.00 AND 20.00);
ALTER TABLE EVALUACION 
    ADD CONSTRAINT PK_EVALUACION PRIMARY KEY ( id_evaluacion ) ;

ALTER TABLE EVALUACION 
    ADD CONSTRAINT UK_EVALUACION_COD UNIQUE ( cod_evaluacion ) ;

CREATE TABLE MATRICULA 
    ( 
     id_matricula     NUMBER (10)  NOT NULL , 
     cod_matricula    VARCHAR2 (20)  NOT NULL , 
     fecha_matricula  DATE DEFAULT SYSDATE  NOT NULL , 
     estado_matricula VARCHAR2 (20) DEFAULT 'REGISTRADA'  NOT NULL , 
     id_estudiante    NUMBER (10)  NOT NULL , 
     id_seccion       NUMBER (10)  NOT NULL 
    );

ALTER TABLE MATRICULA 
    ADD CONSTRAINT CK_MATRICULA_ESTADO 
    CHECK (estado_matricula IN ('REGISTRADA', 'RETIRADO', 'CULMINADO'));
ALTER TABLE MATRICULA 
    ADD CONSTRAINT PK_MATRICULA PRIMARY KEY ( id_matricula ) ;

ALTER TABLE MATRICULA 
    ADD CONSTRAINT UK_MATRICULA_COD UNIQUE ( cod_matricula ) ;

ALTER TABLE MATRICULA 
    ADD CONSTRAINT UK_MATRICULA_UNICA UNIQUE ( id_estudiante , id_seccion ) ;

CREATE TABLE PAGO 
    ( 
     id_pago      NUMBER (10)  NOT NULL , 
     cod_recibo   VARCHAR2 (20)  NOT NULL , 
     monto_pagado NUMBER (8,2)  NOT NULL , 
     fecha_pago   DATE DEFAULT SYSDATE  NOT NULL , 
     metodo_pago  VARCHAR2 (25)  NOT NULL , 
     estado_pago  VARCHAR2 (15) DEFAULT 'PAGADO'  NOT NULL , 
     id_matricula NUMBER (10)  NOT NULL , 
     id_concepto  NUMBER (10)  NOT NULL 
    );

ALTER TABLE PAGO 
    ADD CONSTRAINT CK_PAGO_ESTADO 
    CHECK (estado_pago IN ('PAGADO', 'PENDIENTE', 'ANULADO'));


ALTER TABLE PAGO 
    ADD CONSTRAINT CK_PAGO_METODO 
    CHECK (metodo_pago IN ('TRANSFERENCIA', 'TARJETA', 'BILLETERA_DIGITAL', 'EFECTIVO'));


ALTER TABLE PAGO 
    ADD CONSTRAINT CK_PAGO_MONTO 
    CHECK (monto_pagado > 0);
ALTER TABLE PAGO 
    ADD CONSTRAINT PK_PAGO PRIMARY KEY ( id_pago ) ;

ALTER TABLE PAGO 
    ADD CONSTRAINT UK_PAGO_RECIBO UNIQUE ( cod_recibo ) ;

CREATE TABLE PERIODO_ACADEMICO 
    ( 
     id_periodo   NUMBER (10)  NOT NULL , 
     cod_periodo  VARCHAR2 (10)  NOT NULL , 
     fecha_inicio DATE  NOT NULL , 
     fecha_fin    DATE  NOT NULL , 
     estado       VARCHAR2 (15) DEFAULT 'ACTIVO'  NOT NULL 
    );

ALTER TABLE PERIODO_ACADEMICO 
    ADD CONSTRAINT CK_PERIODO_ESTADO 
    CHECK (estado IN ('ACTIVO', 'CERRADO', 'PLANIFICADO'));


ALTER TABLE PERIODO_ACADEMICO 
    ADD CONSTRAINT CK_PERIODO_FECHAS 
    CHECK (fecha_fin > fecha_inicio);
ALTER TABLE PERIODO_ACADEMICO 
    ADD CONSTRAINT PK_PERIODO PRIMARY KEY ( id_periodo ) ;

ALTER TABLE PERIODO_ACADEMICO 
    ADD CONSTRAINT UK_PERIODO_COD UNIQUE ( cod_periodo ) ;

CREATE TABLE SECCION 
    ( 
     id_seccion    NUMBER (10)  NOT NULL , 
     cod_seccion   VARCHAR2 (20)  NOT NULL , 
     turno         VARCHAR2 (15)  NOT NULL , 
     aula          VARCHAR2 (20)  NOT NULL , 
     cupos_totales NUMBER (3) DEFAULT 30  NOT NULL , 
     id_curso      NUMBER (10)  NOT NULL , 
     id_docente    NUMBER (10)  NOT NULL , 
     id_periodo    NUMBER (10)  NOT NULL 
    );

ALTER TABLE SECCION 
    ADD CONSTRAINT CK_SECCION_CUPOS 
    CHECK (cupos_totales > 0);


ALTER TABLE SECCION 
    ADD CONSTRAINT CK_SECCION_TURNO 
    CHECK (turno IN ('MAÑANA', 'MANANA', 'TARDE', 'NOCHE'));
ALTER TABLE SECCION 
    ADD CONSTRAINT PK_SECCION PRIMARY KEY ( id_seccion ) ;

ALTER TABLE SECCION 
    ADD CONSTRAINT UK_SECCION_COD UNIQUE ( cod_seccion ) ;

CREATE TABLE TIPO_EVALUACION 
    ( 
     id_tipo_eval    NUMBER (10)  NOT NULL , 
     codigo_tipo     VARCHAR2 (10)  NOT NULL , 
     nombre_tipo     VARCHAR2 (60)  NOT NULL , 
     peso_porcentaje NUMBER (3)  NOT NULL 
    );

ALTER TABLE TIPO_EVALUACION 
    ADD CONSTRAINT CK_TIPO_EVAL_PESO 
    CHECK (peso_porcentaje BETWEEN 1 AND 100);
ALTER TABLE TIPO_EVALUACION 
    ADD CONSTRAINT PK_TIPO_EVAL PRIMARY KEY ( id_tipo_eval ) ;

ALTER TABLE TIPO_EVALUACION 
    ADD CONSTRAINT UK_TIPO_EVAL_COD UNIQUE ( codigo_tipo ) ;

ALTER TABLE CURSO 
    ADD CONSTRAINT FK_CURSO_CARRERA FOREIGN KEY 
    ( 
     id_carrera
    ) 
    REFERENCES CARRERA 
    ( 
     id_carrera
    ) 
    NOT DEFERRABLE;

ALTER TABLE ESTUDIANTE 
    ADD CONSTRAINT FK_ESTUDIANTE_CARRERA FOREIGN KEY 
    ( 
     id_carrera
    ) 
    REFERENCES CARRERA 
    ( 
     id_carrera
    ) 
    NOT DEFERRABLE;

ALTER TABLE EVALUACION 
    ADD CONSTRAINT FK_EVAL_MATRICULA FOREIGN KEY 
    ( 
     id_matricula
    ) 
    REFERENCES MATRICULA 
    ( 
     id_matricula
    ) 
    ON DELETE CASCADE 
    NOT DEFERRABLE;

ALTER TABLE EVALUACION 
    ADD CONSTRAINT FK_EVAL_TIPO FOREIGN KEY 
    ( 
     id_tipo_eval
    ) 
    REFERENCES TIPO_EVALUACION 
    ( 
     id_tipo_eval
    ) 
    NOT DEFERRABLE;

ALTER TABLE MATRICULA 
    ADD CONSTRAINT FK_MATRICULA_ESTUDIANTE FOREIGN KEY 
    ( 
     id_estudiante
    ) 
    REFERENCES ESTUDIANTE 
    ( 
     id_estudiante
    ) 
    NOT DEFERRABLE;

ALTER TABLE MATRICULA 
    ADD CONSTRAINT FK_MATRICULA_SECCION FOREIGN KEY 
    ( 
     id_seccion
    ) 
    REFERENCES SECCION 
    ( 
     id_seccion
    ) 
    NOT DEFERRABLE;

ALTER TABLE PAGO 
    ADD CONSTRAINT FK_PAGO_CONCEPTO FOREIGN KEY 
    ( 
     id_concepto
    ) 
    REFERENCES CONCEPTO_PAGO 
    ( 
     id_concepto
    ) 
    NOT DEFERRABLE;

ALTER TABLE PAGO 
    ADD CONSTRAINT FK_PAGO_MATRICULA FOREIGN KEY 
    ( 
     id_matricula
    ) 
    REFERENCES MATRICULA 
    ( 
     id_matricula
    ) 
    NOT DEFERRABLE;

ALTER TABLE SECCION 
    ADD CONSTRAINT FK_SECCION_CURSO FOREIGN KEY 
    ( 
     id_curso
    ) 
    REFERENCES CURSO 
    ( 
     id_curso
    ) 
    NOT DEFERRABLE;

ALTER TABLE SECCION 
    ADD CONSTRAINT FK_SECCION_DOCENTE FOREIGN KEY 
    ( 
     id_docente
    ) 
    REFERENCES DOCENTE 
    ( 
     id_docente
    ) 
    NOT DEFERRABLE;

ALTER TABLE SECCION 
    ADD CONSTRAINT FK_SECCION_PERIODO FOREIGN KEY 
    ( 
     id_periodo
    ) 
    REFERENCES PERIODO_ACADEMICO 
    ( 
     id_periodo
    ) 
    NOT DEFERRABLE;



-- Informe de Resumen de Oracle SQL Developer Data Modeler: 
-- 
-- CREATE TABLE                            11
-- CREATE INDEX                             0
-- ALTER TABLE                             53
-- CREATE VIEW                              0
-- ALTER VIEW                               0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           0
-- ALTER TRIGGER                            0
-- CREATE COLLECTION TYPE                   0
-- CREATE STRUCTURED TYPE                   0
-- CREATE STRUCTURED TYPE BODY              0
-- CREATE CLUSTER                           0
-- CREATE CONTEXT                           0
-- CREATE DATABASE                          0
-- CREATE DIMENSION                         0
-- CREATE DIRECTORY                         0
-- CREATE DISK GROUP                        0
-- CREATE ROLE                              0
-- CREATE ROLLBACK SEGMENT                  0
-- CREATE SEQUENCE                          0
-- CREATE MATERIALIZED VIEW                 0
-- CREATE MATERIALIZED VIEW LOG             0
-- CREATE SYNONYM                           0
-- CREATE TABLESPACE                        0
-- CREATE USER                              0
-- 
-- DROP TABLESPACE                          0
-- DROP DATABASE                            0
-- 
-- REDACTION POLICY                         0
-- 
-- ORDS DROP SCHEMA                         0
-- ORDS ENABLE SCHEMA                       0
-- ORDS ENABLE OBJECT                       0
-- 
-- ERRORS                                   0
-- WARNINGS                                 0
