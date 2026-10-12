/**
 * ============================================================================
 * ESCUDO - CONFIGURACIÓN DEL CLIENTE SUPABASE
 * ============================================================================
 *
 * ⚠️ INSTRUCCIONES DE SEGURIDAD (AUDITORÍA DEFENSIVA):
 * 1. Usa ÚNICAMENTE tu clave pública 'anon' o 'publishable' (sb_publishable_... o eyJ...).
 * 2. NUNCA coloques aquí la clave 'service_role' ni 'sb_secret_...', ya que
 *    ésta tiene permisos totales de administración y NUNCA debe estar en el cliente.
 * 3. La base de datos está protegida con RLS (Row Level Security), por lo que
 *    esta clave pública solo tiene permiso para INSERTAR solicitudes,
 *    imposibilitando que nadie pueda leer, modificar o borrar datos de postulantes.
 *
 * 📌 ¿QUÉ TE FALTA HACER AQUÍ?
 * 1. Si los datos actuales de 'url' y 'publicKey' corresponden a tu proyecto activo,
 *    ¡ya está listo para conectar!
 * 2. Si necesitas cambiarlos:
 *    - Ve a tu panel de Supabase: Project Settings -> API.
 *    - Copia 'Project URL' y actualiza el campo 'url'.
 *    - Copia 'anon public key' y actualiza el campo 'publicKey'.
 * 3. Dirígete a Supabase -> SQL Editor y corre el script 'supabase/schema.sql'.
 */

window.ESCUDO_SUPABASE = Object.freeze({
    // URL de tu proyecto en Supabase (protocolo https:// obligatorio)
    url: "https://gzevinchuigsogyevbyz.supabase.co",

    // Clave anónima pública del proyecto (anon / publishable key)
    publicKey: "sb_publishable_q_LiEKORb-ePcndU9aPtzw_OIaa6nmh"
});
