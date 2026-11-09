-- ====================================================================
-- INSTITUTO TECNOLÓGICO ESCUDO - ACTIVACIÓN TOTAL REST API (ORDS) EN APEX
-- Pega y corre este script completo en: 
-- Oracle APEX -> SQL Workshop -> SQL Commands
-- ====================================================================

-- 1. Habilitar ORDS en tu esquema con alias 'escudo'
BEGIN
  ORDS.ENABLE_SCHEMA(
    p_enabled             => TRUE,
    p_schema              => USER,
    p_url_mapping_type    => 'BASE_PATH',
    p_url_mapping_pattern => 'escudo',
    p_auto_rest_auth      => FALSE
  );
  COMMIT;
END;
/

-- 2. Publicar CARRERA
BEGIN
  ORDS.ENABLE_OBJECT(
    p_enabled        => TRUE,
    p_schema         => USER,
    p_object         => 'CARRERA',
    p_object_type    => 'TABLE',
    p_object_path    => 'carreras'
  );
  COMMIT;
END;
/

-- 3. Publicar PERIODO
BEGIN
  ORDS.ENABLE_OBJECT(
    p_enabled        => TRUE,
    p_schema         => USER,
    p_object         => 'PERIODO',
    p_object_type    => 'TABLE',
    p_object_path    => 'periodos'
  );
  COMMIT;
END;
/

-- 4. Publicar CONCEPTO
BEGIN
  ORDS.ENABLE_OBJECT(
    p_enabled        => TRUE,
    p_schema         => USER,
    p_object         => 'CONCEPTO',
    p_object_type    => 'TABLE',
    p_object_path    => 'conceptos'
  );
  COMMIT;
END;
/

-- 5. Publicar TIPO_EVALUACION
BEGIN
  ORDS.ENABLE_OBJECT(
    p_enabled        => TRUE,
    p_schema         => USER,
    p_object         => 'TIPO_EVALUACION',
    p_object_type    => 'TABLE',
    p_object_path    => 'tipos-evaluacion'
  );
  COMMIT;
END;
/

-- 6. Publicar DOCENTE
BEGIN
  ORDS.ENABLE_OBJECT(
    p_enabled        => TRUE,
    p_schema         => USER,
    p_object         => 'DOCENTE',
    p_object_type    => 'TABLE',
    p_object_path    => 'docentes'
  );
  COMMIT;
END;
/

-- 7. Publicar CURSO
BEGIN
  ORDS.ENABLE_OBJECT(
    p_enabled        => TRUE,
    p_schema         => USER,
    p_object         => 'CURSO',
    p_object_type    => 'TABLE',
    p_object_path    => 'cursos'
  );
  COMMIT;
END;
/

-- 8. Publicar SECCION
BEGIN
  ORDS.ENABLE_OBJECT(
    p_enabled        => TRUE,
    p_schema         => USER,
    p_object         => 'SECCION',
    p_object_type    => 'TABLE',
    p_object_path    => 'secciones'
  );
  COMMIT;
END;
/

-- 9. Publicar ESTUDIANTE
BEGIN
  ORDS.ENABLE_OBJECT(
    p_enabled        => TRUE,
    p_schema         => USER,
    p_object         => 'ESTUDIANTE',
    p_object_type    => 'TABLE',
    p_object_path    => 'estudiantes'
  );
  COMMIT;
END;
/

-- 10. Publicar MATRICULA
BEGIN
  ORDS.ENABLE_OBJECT(
    p_enabled        => TRUE,
    p_schema         => USER,
    p_object         => 'MATRICULA',
    p_object_type    => 'TABLE',
    p_object_path    => 'matriculas'
  );
  COMMIT;
END;
/

-- 11. Publicar EVALUACION
BEGIN
  ORDS.ENABLE_OBJECT(
    p_enabled        => TRUE,
    p_schema         => USER,
    p_object         => 'EVALUACION',
    p_object_type    => 'TABLE',
    p_object_path    => 'evaluaciones'
  );
  COMMIT;
END;
/

-- 12. Publicar PAGO
BEGIN
  ORDS.ENABLE_OBJECT(
    p_enabled        => TRUE,
    p_schema         => USER,
    p_object         => 'PAGO',
    p_object_type    => 'TABLE',
    p_object_path    => 'pagos'
  );
  COMMIT;
END;
/
