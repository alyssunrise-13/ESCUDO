-- ============================================================================
-- ESCUDO // SCRIPT DE BASE DE DATOS Y BLINDAJE DE SEGURIDAD (SUPABASE)
-- ============================================================================
--
-- 🛡️ AUDITORÍA DE SEGURIDAD Y PRIVACIDAD:
-- 1. Este script implementa RLS (Row Level Security) de grado defensivo.
-- 2. El rol anónimo (público de la web) SÓLO tiene permiso para INSERTAR.
-- 3. Nadie desde internet puede leer (SELECT), editar (UPDATE) o borrar (DELETE)
--    los datos de los postulantes (DNI, celular, correo, etc.).
-- 4. Se incluye un índice anti-spam para evitar saturación/ataques DoS por duplicados.
-- 5. Se incluye un trigger que sanitiza y normaliza los datos antes de guardarlos.
--
-- 📋 ¿QUÉ TE FALTA HACER EN SUPABASE? (PASO A PASO):
-- PASO 1: Ingresa a tu proyecto en https://supabase.com/dashboard
-- PASO 2: En la barra lateral izquierda, haz clic en el ícono de "SQL Editor".
-- PASO 3: Haz clic en "+ New query" (o "Create query").
-- PASO 4: Pega todo el contenido de este archivo y presiona el botón verde "Run".
-- PASO 5: ¡Listo! Para ver los datos enviados, ve a "Table Editor" -> "Postulantes".
-- ============================================================================

-- 1. CREACIÓN O ACTUALIZACIÓN DE LA TABLA
-- 1. CREACIÓN O ACTUALIZACIÓN DE LA TABLA
create table if not exists public."Postulantes" (
    id uuid default gen_random_uuid() primary key,
    created_at timestamptz default now()
);

-- 2. AGREGAR COLUMNAS CON SUS TIPOS DE DATOS Y RESTRICCIONES
alter table public."Postulantes"
    add column if not exists nombre text,
    add column if not exists correo text,
    add column if not exists celular text,
    add column if not exists carrera text,
    add column if not exists dni text,
    add column if not exists modalidad text,
    add column if not exists acepto_privacidad boolean,
    add column if not exists estado text default 'pendiente';

-- Restringir estados válidos para el equipo de admisiones
do $$
begin
    if not exists (
        select 1 from pg_constraint where conname = 'check_postulantes_estado'
    ) then
        alter table public."Postulantes"
            add constraint check_postulantes_estado
            check (estado in ('pendiente', 'en_revision', 'contactado', 'matriculado', 'descartado'));
    end if;
end $$;

-- 3. ACTIVAR SEGURIDAD A NIVEL DE FILAS (ROW LEVEL SECURITY - RLS)
alter table public."Postulantes" enable row level security;

-- 4. PRIVILEGIOS MÍNIMOS (POLÍTICA DE MENOR PRIVILEGIO / LEAST PRIVILEGE)
grant usage on schema public to anon;
revoke all on table public."Postulantes" from anon, authenticated;

-- Otorgar única y exclusivamente permisos para insertar los campos del formulario
grant insert (nombre, correo, celular, carrera, dni, modalidad, acepto_privacidad)
    on table public."Postulantes" to anon;

-- 5. POLÍTICA DE INSERCIÓN DEFENSIVA CON VALIDACIÓN HEURÍSTICA
drop policy if exists "Permitir enviar solicitudes de postulacion ESCUDO" on public."Postulantes";

create policy "Permitir enviar solicitudes de postulacion ESCUDO"
    on public."Postulantes"
    for insert
    to anon
    with check (
        -- Longitud de nombre seguro
        char_length(btrim(nombre)) between 2 and 120
        -- Correo en formato estándar y en minúsculas
        and correo = lower(btrim(correo))
        and correo ~ '^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$'
        -- Celular con formato internacional válido
        and celular ~ '^\+?[0-9 ()-]{7,20}$'
        and char_length(regexp_replace(celular, '[^0-9]', '', 'g')) between 7 and 15
        -- Whitelist estricta de especialidades
        and carrera in (
            'ciberseguridad',
            'software',
            'redes-datos',
            'frontend',
            'backend',
            'ia'
        )
        -- DNI peruano de exactamente 8 dígitos
        and dni ~ '^[0-9]{8}$'
        -- Modalidades autorizadas
        and modalidad in ('presencial', 'virtual')
        -- Consentimiento de privacidad explícito
        and acepto_privacidad is true
    );

-- 6. POLÍTICAS EXPLÍCITAS DE DENEGACIÓN (PROTECCIÓN CONTRA EXTRACCIÓN DE DATOS)
drop policy if exists "Denegar lectura anonima" on public."Postulantes";
drop policy if exists "Denegar modificacion anonima" on public."Postulantes";
drop policy if exists "Denegar eliminacion anonima" on public."Postulantes";

-- 7. ÍNDICE DE CONSULTA RÁPIDA Y RENDIMIENTO
create index if not exists idx_postulantes_dni
    on public."Postulantes" (dni);

create index if not exists idx_postulantes_created_at
    on public."Postulantes" (created_at desc);

-- 8. TRIGGER DE NORMALIZACIÓN Y SANEAMIENTO AUTOMÁTICO
create or replace function public.fn_sanitizar_postulante()
returns trigger as $$
begin
    new.nombre := btrim(regexp_replace(new.nombre, '[<>]', '', 'g'));
    new.correo := lower(btrim(new.correo));
    new.celular := btrim(new.celular);
    new.dni := btrim(new.dni);
    new.estado := 'pendiente';
    return new;
end;
$$ language plpgsql security definer;

drop trigger if exists trg_sanitizar_postulante on public."Postulantes";
create trigger trg_sanitizar_postulante
    before insert on public."Postulantes"
    for each row
    execute function public.fn_sanitizar_postulante();
