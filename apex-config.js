// ====================================================================
// ESCUDO - CONFIGURACIÓN DE CONEXIÓN EN VIVO A ORACLE APEX (ORDS REST API)
// ====================================================================

window.ESCUDO_APEX = Object.freeze({
    // Base URL de los servicios REST oficiales de Oracle APEX
    baseUrl: "https://apex.oracle.com/pls/apex/escudo/",
    schemaAlias: "escudo",
    endpoints: {
        carreras: "carreras/",
        periodos: "periodos/",
        conceptos: "conceptos/",
        tiposEvaluacion: "tipos-evaluacion/",
        docentes: "docentes/",
        cursos: "cursos/",
        secciones: "secciones/",
        estudiantes: "estudiantes/",
        matriculas: "matriculas/",
        evaluaciones: "evaluaciones/",
        pagos: "pagos/"
    }
});
