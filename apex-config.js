// ====================================================================
// ESCUDO - CONFIGURACIÓN DE CONEXIÓN EN VIVO A ORACLE APEX (ORDS REST API)
// Configuración extraída directamente de Oracle Database Actions
// ====================================================================

window.ESCUDO_APEX = Object.freeze({
    // Base URL oficial de ORDS para el esquema escudo
    baseUrl: "https://oracleapex.com/ords/escudo/",
    schemaAlias: "escudo",
    endpoints: {
        carreras: "carrera/",
        periodos: "periodo_academico/",
        conceptos: "concepto_pago/",
        tiposEvaluacion: "tipo_evaluacion/",
        docentes: "docente/",
        cursos: "curso/",
        secciones: "seccion/",
        estudiantes: "estudiante/",
        matriculas: "matricula/",
        evaluaciones: "evaluacion/",
        pagos: "pago/"
    }
});
