/**
 * ============================================================================
 * ESCUDO - LÓGICA PRINCIPAL Y CONSOLA DE OPERACIONES (SOC)
 * ============================================================================
 * Este archivo orquesta la experiencia interactiva, la seguridad defensiva y
 * la accesibilidad del sitio web. Está estructurado en módulos independientes
 * fáciles de explicar:
 * 1. Accesibilidad y preferencias de movimiento (prefers-reduced-motion)
 * 2. Animaciones de entrada (GSAP) y red de partículas (particles.js)
 * 3. Reloj del SOC en tiempo real y menú responsive
 * 4. Navegación activa y revelación con IntersectionObserver
 * 5. Carrusel de testimonios y selector de carreras
 * 6. Formulario seguro: Honeypot, sanitización XSS y cliente Supabase
 * 7. Terminal táctica interactiva: comandos CLI, accesibilidad ARIA y Easter Egg
 * ============================================================================
 */

// 1. Accesibilidad: Respeta si el usuario prefiere movimiento reducido (TDAH/vértigo)
const movimientoReducido = window.matchMedia("(prefers-reduced-motion: reduce)").matches;

// 2. Animación de entrada inicial con GSAP
function animarInicio() {
    if (!window.gsap || movimientoReducido) return;

    window.gsap.from(".hero-texto .etiqueta", {
        opacity: 0,
        y: 12,
        duration: 0.55,
        delay: 0.1
    });

    window.gsap.from(".hero h1", {
        opacity: 0,
        y: 24,
        filter: "blur(5px)",
        duration: 1.1,
        delay: 0.22,
        ease: "power3.out"
    });

    window.gsap.from(".hero-acciones .boton", {
        opacity: 0,
        scale: 0.92,
        duration: 0.7,
        delay: 0.65,
        ease: "back.out(1.7)"
    });
}

function crearParticulas() {
    const zonaParticulas = document.getElementById("particulas-escudo");
    if (!zonaParticulas || !window.particlesJS || movimientoReducido) return;

    window.particlesJS("particulas-escudo", {
        particles: {
            number: { value: 64, density: { enable: true, value_area: 850 } },
            color: { value: "#00ff41" },
            shape: { type: "circle" },
            opacity: { value: 0.55, random: true },
            size: { value: 2, random: true },
            line_linked: {
                enable: true,
                distance: 125,
                color: "#00ff41",
                opacity: 0.25,
                width: 1
            },
            move: {
                enable: true,
                speed: 1.2,
                direction: "none",
                random: true,
                straight: false,
                out_mode: "out"
            }
        },
        interactivity: {
            detect_on: "canvas",
            events: {
                onhover: { enable: true, mode: "grab" },
                onclick: { enable: false },
                resize: true
            },
            modes: {
                grab: { distance: 145, line_linked: { opacity: 0.55 } }
            }
        },
        retina_detect: true
    });
}

function iniciarReloj() {
    const reloj = document.getElementById("reloj-neon");
    if (!reloj) return;

    function mostrarHora() {
        reloj.textContent = new Date().toLocaleTimeString("es-PE", {
            hour: "2-digit",
            minute: "2-digit",
            second: "2-digit"
        });
    }

    mostrarHora();
    window.setInterval(mostrarHora, 1000);
}

function iniciarMenu() {
    const botonMenu = document.querySelector(".menu-boton");
    const menu = document.getElementById("menu-principal");
    if (!botonMenu || !menu) return;

    function cerrarMenu() {
        menu.classList.remove("abierto");
        botonMenu.setAttribute("aria-expanded", "false");
        botonMenu.setAttribute("aria-label", "Abrir menú principal");
    }

    botonMenu.addEventListener("click", () => {
        const menuAbierto = botonMenu.getAttribute("aria-expanded") === "true";
        botonMenu.setAttribute("aria-expanded", String(!menuAbierto));
        botonMenu.setAttribute("aria-label", menuAbierto ? "Abrir menú principal" : "Cerrar menú principal");
        menu.classList.toggle("abierto", !menuAbierto);
    });

    menu.querySelectorAll("a").forEach((enlace) => {
        enlace.addEventListener("click", cerrarMenu);
    });

    // Accesibilidad WCAG 2.1: Permitir cerrar el menú con tecla Escape y devolver foco al botón
    document.addEventListener("keydown", (e) => {
        if (e.key === "Escape" && menu.classList.contains("abierto")) {
            cerrarMenu();
            botonMenu.focus();
        }
    });

    // Cerrar al hacer clic fuera del menú
    document.addEventListener("click", (e) => {
        if (menu.classList.contains("abierto") && !menu.contains(e.target) && !botonMenu.contains(e.target)) {
            cerrarMenu();
        }
    });
}

function iniciarNavegacionActiva() {
    const enlacesMenu = document.querySelectorAll('.menu-enlace[href^="#"]');
    const secciones = document.querySelectorAll("main section[id]");
    if (!("IntersectionObserver" in window) || enlacesMenu.length === 0) return;

    const observadorSecciones = new IntersectionObserver((entradas) => {
        entradas.forEach((entrada) => {
            if (!entrada.isIntersecting) return;

            const idDestino = `#${entrada.target.id}`;
            const enlaceActivo = [...enlacesMenu].find((enlace) => enlace.getAttribute("href") === idDestino);
            if (!enlaceActivo) return;

            enlacesMenu.forEach((enlace) => {
                enlace.classList.remove("activo");
                enlace.removeAttribute("aria-current");
            });
            enlaceActivo.classList.add("activo");
            enlaceActivo.setAttribute("aria-current", "location");
        });
    }, { rootMargin: "-35% 0px -55% 0px" });

    secciones.forEach((seccion) => observadorSecciones.observe(seccion));
}

function revelarAlDesplazarse() {
    const elementos = document.querySelectorAll(".revelar");
    if (elementos.length === 0) return;

    if (!("IntersectionObserver" in window)) {
        elementos.forEach((elemento) => elemento.classList.add("visible"));
        return;
    }

    document.body.classList.add("js-activo");

    const observador = new IntersectionObserver((entradas, observadorActual) => {
        entradas.forEach((entrada) => {
            if (!entrada.isIntersecting) return;

            entrada.target.classList.add("visible");
            observadorActual.unobserve(entrada.target);
        });
    }, { threshold: 0.12 });

    elementos.forEach((elemento) => observador.observe(elemento));
}

function seleccionarCarrera() {
    const selectorCarrera = document.getElementById("carrera");
    if (!selectorCarrera) return;

    function cambiarCarrera(carrera) {
        const opcionDisponible = [...selectorCarrera.options]
            .some((opcion) => opcion.value === carrera);

        if (opcionDisponible) selectorCarrera.value = carrera;
    }

    const carreraEnlace = new URLSearchParams(window.location.search).get("carrera");
    if (carreraEnlace) cambiarCarrera(carreraEnlace);

    document.querySelectorAll("[data-programa]").forEach((enlace) => {
        enlace.addEventListener("click", () => {
            cambiarCarrera(enlace.dataset.programa);
        });
    });
}

const resenas = [
    {
        texto: "“En ESCUDO aprendes haciendo: cada proyecto te ayuda a convertir tus ideas en habilidades para el mundo digital.”",
        autor: "Comunidad ESCUDO",
        imagen: "imagenes/reseñas.jpg"
    },
    {
        texto: "“Aquí la curiosidad se vuelve una fortaleza: exploras, colaboras y encuentras nuevas formas de resolver retos.”",
        autor: "Comunidad ESCUDO",
        imagen: "imagenes/reseñas 1.jpg"
    },
    {
        texto: "“La tecnología tiene más sentido cuando la creas con propósito y aprendes a proteger lo que importa.”",
        autor: "Comunidad ESCUDO",
        imagen: "imagenes/reseñas 2.jpg"
    }
];

function iniciarResenas() {
    const textoResena = document.getElementById("texto-resena");
    const autorResena = document.getElementById("autor-resena");
    const fotoResena = document.querySelector(".resena-foto");
    if (!textoResena || !autorResena || !fotoResena) return;

    let indiceResena = 0;

    document.querySelectorAll(".resena-flecha").forEach((boton) => {
        boton.addEventListener("click", () => {
            const direccion = Number(boton.dataset.direccion);
            indiceResena = (indiceResena + direccion + resenas.length) % resenas.length;

            const resena = resenas[indiceResena];
            textoResena.textContent = resena.texto;
            autorResena.textContent = resena.autor;
            fotoResena.src = resena.imagen;
        });
    });
}

function validarFormulario() {
    const formulario = document.getElementById("formulario-escudo");
    const mensaje = document.getElementById("mensaje-sistema");
    if (!formulario || !mensaje) return;

    const botonEnviar = formulario.querySelector('button[type="submit"]');

    // Función de saneamiento preventivo (Defensa en profundidad)
    function sanitizarEntrada(texto, maxLen = 120) {
        if (typeof texto !== "string") return "";
        return texto
            .replace(/[\u0000-\u001F\u007F-\u009F]/g, "") // Remueve caracteres de control invisibles
            .replace(/[<>]/g, "")                         // Neutraliza etiquetas HTML/inyecciones
            .trim()
            .slice(0, maxLen);
    }

    formulario.addEventListener("submit", async (evento) => {
        evento.preventDefault();

        const datosFormulario = new FormData(formulario);
        const trampaBot = datosFormulario.get("_hp_security_check");
        if (trampaBot) {
            console.warn("[ESCUDO-AUDITOR] Petición automatizada neutralizada mediante trampa honeypot.");
            formulario.reset();
            mensaje.textContent = "¡Gracias! Tu solicitud ha sido recibida.";
            mensaje.classList.remove("error");
            mensaje.classList.add("visible");
            return;
        }

        const ahora = Date.now();
        const ultimoEnvio = Number(sessionStorage.getItem("escudo_ultimo_envio") || "0");
        if (ahora - ultimoEnvio < 8000) {
            mensaje.textContent = "Por favor espera unos segundos antes de enviar otra solicitud.";
            mensaje.classList.add("visible", "error");
            return;
        }

        if (!formulario.reportValidity()) return;

        const nombreLimpio = sanitizarEntrada(datosFormulario.get("nombre") || "", 120);
        const correoLimpio = sanitizarEntrada(datosFormulario.get("correo") || "", 254).toLowerCase();
        const celularLimpio = sanitizarEntrada(datosFormulario.get("celular") || "", 20);
        const dniLimpio = sanitizarEntrada(datosFormulario.get("dni") || "", 8);
        const carrera = datosFormulario.get("carrera");
        const modalidad = datosFormulario.get("modalidad");
        const aceptoPrivacidad = datosFormulario.get("acepto_privacidad") === "true";

        const carrerasValidas = ["ciberseguridad", "software", "redes-datos", "frontend", "backend", "ia"];
        const modalidadesValidas = ["presencial", "virtual"];

        if (!/^[A-Za-zÀ-ÿ\s'.]{2,120}$/.test(nombreLimpio)) {
            mensaje.textContent = "Por favor ingresa un nombre válido (solo letras, espacios o signos válidos).";
            mensaje.classList.add("visible", "error");
            return;
        }

        if (!/^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$/.test(correoLimpio)) {
            mensaje.textContent = "Por favor ingresa un correo electrónico válido.";
            mensaje.classList.add("visible", "error");
            return;
        }

        const digitosCelular = celularLimpio.replace(/[^0-9]/g, "");
        if (digitosCelular.length < 7 || digitosCelular.length > 15) {
            mensaje.textContent = "Por favor ingresa un número de celular válido (entre 7 y 15 dígitos).";
            mensaje.classList.add("visible", "error");
            return;
        }

        if (!/^[0-9]{8}$/.test(dniLimpio)) {
            mensaje.textContent = "El DNI debe contener exactamente 8 dígitos numéricos.";
            mensaje.classList.add("visible", "error");
            return;
        }

        if (!carrerasValidas.includes(carrera)) {
            mensaje.textContent = "La carrera seleccionada no es válida.";
            mensaje.classList.add("visible", "error");
            return;
        }

        if (!modalidadesValidas.includes(modalidad)) {
            mensaje.textContent = "La modalidad seleccionada no es válida.";
            mensaje.classList.add("visible", "error");
            return;
        }

        if (!aceptoPrivacidad) {
            mensaje.textContent = "Debes aceptar los términos de privacidad para continuar.";
            mensaje.classList.add("visible", "error");
            return;
        }


        const configuracion = window.ESCUDO_SUPABASE;
        const urlProyecto = configuracion?.url?.trim();
        const clavePublica = configuracion?.publicKey?.trim();

        if (
            !urlProyecto ||
            !clavePublica ||
            clavePublica.includes("YOUR_SUPABASE_PUBLIC_KEY") ||
            clavePublica.startsWith("sb_secret_")
        ) {
            console.error("[ESCUDO-AUDITOR] Configura una clave publishable o anon pública; nunca uses sb_secret o service_role en el navegador.");
            mensaje.textContent = "No se pudo enviar la solicitud. Revisa la configuración de Supabase.";
            mensaje.classList.add("visible", "error");
            return;
        }

        const segmentoClave = clavePublica.split(".")[1];
        if (segmentoClave) {
            let permisosClave;
            try {
                const base64 = segmentoClave.replace(/-/g, "+").replace(/_/g, "/");
                const padded = base64.padEnd(base64.length + ((4 - (base64.length % 4)) % 4), "=");
                permisosClave = JSON.parse(atob(padded));
            } catch (error) {
                console.error("[ESCUDO-AUDITOR] No se pudo validar la clave JWT de Supabase.", error);
                mensaje.textContent = "No se pudo enviar la solicitud. Revisa la configuración pública de Supabase.";
                mensaje.classList.add("visible", "error");
                return;
            }

            if (!permisosClave || typeof permisosClave !== "object" || Array.isArray(permisosClave)) {
                console.error("[ESCUDO-AUDITOR] La clave JWT de Supabase no contiene permisos válidos.");
                mensaje.textContent = "No se pudo enviar la solicitud. Revisa la configuración pública de Supabase.";
                mensaje.classList.add("visible", "error");
                return;
            }

            if (permisosClave.role === "service_role" || permisosClave.role === "supabase_admin") {
                console.error("[ESCUDO-AUDITOR] Alerta Crítica: Clave administrativa detectada en cliente. Usa únicamente la clave pública anon.");
                mensaje.textContent = "No se pudo enviar la solicitud por motivos de seguridad.";
                mensaje.classList.add("visible", "error");
                return;
            }
        }

        let direccionApi;
        try {
            const url = new URL(urlProyecto);
            if (url.protocol !== "https:" && url.hostname !== "localhost" && url.hostname !== "127.0.0.1") {
                throw new Error("La URL de Supabase debe usar HTTPS obligatoriamente.");
            }
            direccionApi = `${url.origin}/rest/v1/Postulantes`;
        } catch (error) {
            console.error("[ESCUDO-AUDITOR] La URL configurada para Supabase no es válida.", error);
            mensaje.textContent = "No se pudo enviar la solicitud. Inténtalo nuevamente más tarde.";
            mensaje.classList.add("visible", "error");
            return;
        }

        const solicitud = {
            nombre: nombreLimpio,
            correo: correoLimpio,
            celular: celularLimpio,
            carrera: carrera,
            dni: dniLimpio,
            modalidad: modalidad,
            acepto_privacidad: aceptoPrivacidad
        };

        mensaje.classList.remove("error");
        mensaje.textContent = "Enviando tu solicitud de forma segura…";
        mensaje.classList.add("visible");

        if (botonEnviar) {
            botonEnviar.disabled = true;
            botonEnviar.setAttribute("aria-busy", "true");
        }

        const abortCtrl = new AbortController();
        const timeoutId = setTimeout(() => abortCtrl.abort(), 9000);

        try {
            const encabezados = {
                apikey: clavePublica,
                Authorization: `Bearer ${clavePublica}`,
                "Content-Type": "application/json",
                Prefer: "return=minimal"
            };

            const respuesta = await fetch(direccionApi, {
                method: "POST",
                headers: encabezados,
                body: JSON.stringify(solicitud),
                signal: abortCtrl.signal
            });

            clearTimeout(timeoutId);

            if (!respuesta.ok) {
                const detalle = await respuesta.text();
                throw new Error(`Supabase respondió ${respuesta.status}: ${detalle}`);
            }

            sessionStorage.setItem("escudo_ultimo_envio", String(Date.now()));

            formulario.reset();
            mensaje.textContent = "¡Gracias! Recibimos tu solicitud y pronto nos comunicaremos contigo.";
        } catch (error) {
            clearTimeout(timeoutId);
            if (error.name === "AbortError") {
                console.error("[ESCUDO-AUDITOR] Petición abortada por tiempo de espera agotado.");
                mensaje.textContent = "La solicitud tardó demasiado en responder. Revisa tu conexión.";
            } else {
                console.error("[ESCUDO-AUDITOR] No se pudo guardar la solicitud en Supabase.", error);
                mensaje.textContent = "No se pudo enviar la solicitud. Revisa tu conexión e inténtalo nuevamente.";
            }
            mensaje.classList.add("error");
        } finally {
            if (botonEnviar) {
                botonEnviar.disabled = false;
                botonEnviar.removeAttribute("aria-busy");
            }
        }
    });
}

function animarCifra(elemento) {
    const resultado = elemento.dataset.scramble;
    const caracteres = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789%";

    if (movimientoReducido) {
        elemento.textContent = resultado;
        return;
    }

    const inicio = performance.now();
    const duracion = 1500;

    function actualizar(ahora) {
        const progreso = Math.min((ahora - inicio) / duracion, 1);
        const caracteresFinales = Math.floor(progreso * resultado.length);
        let cifraVisible = resultado.slice(0, caracteresFinales);

        for (let indice = caracteresFinales; indice < resultado.length; indice += 1) {
            const indiceAleatorio = Math.floor(Math.random() * caracteres.length);
            cifraVisible += caracteres[indiceAleatorio];
        }

        elemento.textContent = progreso === 1 ? resultado : cifraVisible;
        if (progreso < 1) window.requestAnimationFrame(actualizar);
    }

    window.requestAnimationFrame(actualizar);
}

function iniciarContadores() {
    const cifras = document.querySelectorAll("[data-scramble]");
    if (cifras.length === 0) return;

    if (!("IntersectionObserver" in window)) {
        cifras.forEach(animarCifra);
        return;
    }

    const observador = new IntersectionObserver((entradas, observadorActual) => {
        entradas.forEach((entrada) => {
            if (!entrada.isIntersecting) return;

            animarCifra(entrada.target);
            observadorActual.unobserve(entrada.target);
        });
    }, { threshold: 0.65 });

    cifras.forEach((cifra) => observador.observe(cifra));
}

function iniciarTerminalSOC() {
    const ventanaLog = document.getElementById("soc-log-ventana");
    const formulario = document.getElementById("soc-terminal-form");
    const entradaTexto = document.getElementById("soc-cli-input");
    const contadorAmenazas = document.getElementById("soc-contador-amenazas");
    const etiquetaLatencia = document.getElementById("soc-latencia");
    const contenedorConsola = document.querySelector(".soc-terminal-contenedor");
    if (!ventanaLog) return;

    let totalAmenazas = 14892;

    function agregarLinea(etiqueta, mensaje, clase = "soc-log-sys") {
        const linea = document.createElement("div");
        linea.className = `soc-log-linea ${clase}`;

        const promptSpan = document.createElement("span");
        promptSpan.className = "soc-prompt";
        promptSpan.textContent = etiqueta;

        const msgSpan = document.createElement("span");
        msgSpan.className = "soc-msg";
        msgSpan.textContent = mensaje;

        linea.appendChild(promptSpan);
        linea.appendChild(msgSpan);
        ventanaLog.appendChild(linea);

        while (ventanaLog.children.length > 20) {
            ventanaLog.removeChild(ventanaLog.firstElementChild);
        }

        ventanaLog.scrollTo({
            top: ventanaLog.scrollHeight,
            behavior: "smooth"
        });
    }

    function dispararEasterEgg() {
        if (contenedorConsola) {
            contenedorConsola.classList.add("modo-easteregg");
            setTimeout(() => contenedorConsola.classList.remove("modo-easteregg"), 6500);
        }

        try {
            const AudioCtx = window.AudioContext || window.webkitAudioContext;
            if (AudioCtx) {
                const ctx = new AudioCtx();
                const osc = ctx.createOscillator();
                const gain = ctx.createGain();
                osc.type = "sawtooth";
                osc.frequency.setValueAtTime(523.25, ctx.currentTime);
                osc.frequency.exponentialRampToValueAtTime(783.99, ctx.currentTime + 0.12);
                osc.frequency.exponentialRampToValueAtTime(1046.50, ctx.currentTime + 0.28);
                gain.gain.setValueAtTime(0.06, ctx.currentTime);
                gain.gain.exponentialRampToValueAtTime(0.001, ctx.currentTime + 0.45);
                osc.connect(gain);
                gain.connect(ctx.destination);
                osc.start();
                osc.stop(ctx.currentTime + 0.45);
            }
        } catch (_) {}

        agregarLinea("[★ PROTOCOLO HACKER ★]", "¡EASTER EGG DESBLOQUEADO // ACCESO ALUMNO ÉLITE!", "soc-log-ok");
        agregarLinea("[MANIFIESTO]", "'Un verdadero hacker no destruye: adquiere el poder para crear y defender.'", "soc-log-sys");
        agregarLinea("[BENEFICIO EXCLUSIVO]", "Beca de mérito activa: Asesoría vocacional y prueba de aptitud prioritaria.", "soc-log-ok");
        agregarLinea("[CÓDIGO DE ADMISIÓN]", "Menciona el código #HACKER-ESCUDO-2026 al postular para atención VIP. 🕶️⚡", "soc-log-sec");
    }

    function ejecutarComando(comandoRaw) {
        if (typeof comandoRaw !== "string") return;
        const comandoLimpio = comandoRaw
            .replace(/[\u0000-\u001F\u007F-\u009F]/g, "")
            .trim()
            .slice(0, 60);
        const cmd = comandoLimpio.toLowerCase().replace(/[-_\s]/g, "");
        if (!cmd) return;

        agregarLinea("[ESTUDIANTE@CLI]", `> ${comandoLimpio}`, "soc-log-net");

        if (
            cmd === "hack" ||
            cmd === "hackear" ||
            cmd === "matrix" ||
            cmd === "sudo" ||
            cmd === "1337" ||
            cmd === "easteregg" ||
            cmd === "root" ||
            cmd === "escudo"
        ) {
            dispararEasterEgg();
            return;
        }


        if (cmd === "queaprendere" || cmd === "aprendere" || cmd === "plan" || cmd === "temario" || cmd === "estudio") {
            agregarLinea("[PLAN FORMATIVO]", "Aprenderás: Hacking Ético, Defensa de Redes, Criptografía, Cloud Security e IA.", "soc-log-sys");
            setTimeout(() => {
                agregarLinea("[CASOS REALES]", "Auditorías de código, análisis de malware y respuesta a incidentes en vivo.", "soc-log-sys");
                setTimeout(() => {
                    agregarLinea("[TU PORTAFOLIO]", "Egresas con proyectos defensivos reales listos para presentar a empresas tech.", "soc-log-ok");
                }, 300);
            }, 300);
        } else if (cmd === "retospracticos" || cmd === "laboratoriosctf" || cmd === "ctf" || cmd === "laboratorios" || cmd === "practica") {
            agregarLinea("[METODOLOGÍA CTF]", "0% teoría pasiva: 100% práctica en laboratorios de simulación cibernética.", "soc-log-sec");
            setTimeout(() => {
                agregarLinea("[ENTORNOS VIVOS]", "Retos tipo Capture The Flag: criptoanálisis, esteganografía y mitigación de exploits.", "soc-log-sys");
                setTimeout(() => {
                    agregarLinea("[CRITERIO TÁCTICO]", "Desarrollas el instinto y la rapidez de un defensor de seguridad senior.", "soc-log-ok");
                }, 300);
            }, 300);
        } else if (cmd === "carreras" || cmd === "especialidades" || cmd === "vercarreras" || cmd === "cursos") {
            agregarLinea("[ESPECIALIDADES]", "6 rutas formativas: Ciberseguridad, Software, Redes, Frontend, Backend, IA.", "soc-log-sys");
            agregarLinea("[ORIENTACIÓN]", "Navegando a la sección de Carreras para que conozcas los programas...", "soc-log-ok");
            const seccionCarreras = document.getElementById("carreras");
            if (seccionCarreras) {
                setTimeout(() => seccionCarreras.scrollIntoView({ behavior: "smooth" }), 350);
            }
        } else if (cmd === "admision" || cmd === "postular" || cmd === "admision2026" || cmd === "beca" || cmd === "inscripcion") {
            agregarLinea("[CONVOCATORIA 2026]", "Admisiones abiertas en modalidad Presencial y Virtual.", "soc-log-sys");
            agregarLinea("[ASESORÍA]", "Prueba de aptitud técnica y evaluación de perfil vocacional sin costo.", "soc-log-ok");
            agregarLinea("[DIRECCIONANDO]", "Llevándote al formulario de postulación...", "soc-log-ok");
            const seccionAdmision = document.getElementById("admision");
            if (seccionAdmision) {
                setTimeout(() => {
                    seccionAdmision.scrollIntoView({ behavior: "smooth" });
                    const campoNombre = document.getElementById("nombre");
                    if (campoNombre) campoNombre.focus();
                }, 400);
            }
        } else if (cmd === "limpiar" || cmd === "clear" || cmd === "cls") {
            ventanaLog.replaceChildren();
            agregarLinea("[ESCUDO-SOC]", "Consola reiniciada. Elige una acción rápida o escribe un comando:", "soc-log-sys");
        } else if (cmd === "escanear" || cmd === "scan") {
            agregarLinea("[DIAGNÓSTICO VOCACIONAL]", "Analizando compatibilidad con el mundo tech...", "soc-log-sys");
            setTimeout(() => {
                agregarLinea("[PERFIL IDENTIFICADO]", "Curiosidad analítica alta: apto para Ciberseguridad o Desarrollo de Software.", "soc-log-ok");
            }, 400);
        } else if (cmd === "ayuda" || cmd === "help") {
            agregarLinea("[COMANDOS FORMATIVOS]", "'que_aprendere', 'retos_practicos', 'carreras', 'admision', 'limpiar'.", "soc-log-sys");
            agregarLinea("[PISTA SECRETA]", "Prueba comandos de desarrollador como 'hack', 'matrix' o 'sudo' para sorpresas. 🕶️", "soc-log-sec");
        } else {
            agregarLinea("[AVISO]", `Comando no reconocido: "${comandoLimpio}". Escribe 'ayuda' o pulsa un botón arriba.`, "soc-log-err");
        }
    }

    if (formulario && entradaTexto) {
        formulario.addEventListener("submit", (evento) => {
            evento.preventDefault();
            const valor = entradaTexto.value;
            if (valor.trim()) {
                ejecutarComando(valor);
                entradaTexto.value = "";
            }
        });
    }

    document.querySelectorAll(".soc-chip[data-cmd]").forEach((boton) => {
        boton.addEventListener("click", () => {
            const cmd = boton.dataset.cmd;
            ejecutarComando(cmd);
        });
    });

    if (contadorAmenazas) {
        window.setInterval(() => {
            totalAmenazas += 1;
            contadorAmenazas.textContent = totalAmenazas.toLocaleString("es-PE");
        }, 5500);
    }

    if (etiquetaLatencia) {
        window.setInterval(() => {
            const msAleatorio = Math.floor(Math.random() * 5) + 11;
            etiquetaLatencia.textContent = `${msAleatorio}ms`;
        }, 4200);
    }
}

function iniciarEscalaProporcional() {
    if (typeof window.autoEscalar === "function") {
        window.autoEscalar();
    }
}

function actualizarAnio() {
    const anio = document.getElementById("anio");
    if (anio) anio.textContent = new Date().getFullYear();
}

iniciarEscalaProporcional();
animarInicio();
crearParticulas();
iniciarReloj();
iniciarMenu();
iniciarNavegacionActiva();
revelarAlDesplazarse();
seleccionarCarrera();
iniciarResenas();
validarFormulario();
iniciarContadores();
iniciarTerminalSOC();
actualizarAnio();

