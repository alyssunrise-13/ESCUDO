create table if not exists public."Postulantes" (
    id uuid default gen_random_uuid() primary key,
    created_at timestamptz default now()
);

alter table public."Postulantes"
    add column if not exists nombre text,
    add column if not exists correo text,
    add column if not exists celular text,
    add column if not exists carrera text,
    add column if not exists dni text,
    add column if not exists modalidad text,
    add column if not exists acepto_privacidad boolean,
    add column if not exists estado text default 'pendiente';

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

alter table public."Postulantes" enable row level security;

grant usage on schema public to anon;
revoke all on table public."Postulantes" from anon, authenticated;

grant insert (nombre, correo, celular, carrera, dni, modalidad, acepto_privacidad)
    on table public."Postulantes" to anon;

drop policy if exists "Permitir enviar solicitudes de postulacion ESCUDO" on public."Postulantes";

create policy "Permitir enviar solicitudes de postulacion ESCUDO"
    on public."Postulantes"
    for insert
    to anon
    with check (
        char_length(btrim(nombre)) between 2 and 120
        and correo = lower(btrim(correo))
        and correo ~ '^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$'
        and celular ~ '^\+?[0-9 ()-]{7,20}$'
        and char_length(regexp_replace(celular, '[^0-9]', '', 'g')) between 7 and 15
        and carrera in (
            'ciberseguridad',
            'software',
            'redes-datos',
            'frontend',
            'backend',
            'ia'
        )
        and dni ~ '^[0-9]{8}$'
        and modalidad in ('presencial', 'virtual')
        and acepto_privacidad is true
    );

drop policy if exists "Denegar lectura anonima" on public."Postulantes";
drop policy if exists "Denegar modificacion anonima" on public."Postulantes";
drop policy if exists "Denegar eliminacion anonima" on public."Postulantes";

create index if not exists idx_postulantes_dni
    on public."Postulantes" (dni);

create index if not exists idx_postulantes_created_at
    on public."Postulantes" (created_at desc);

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
