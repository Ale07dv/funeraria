# Plan de tareas — App de gestión FUASCEN

Lista completa de lo que hay que hacer hasta tener la app funcionando en la empresa, ordenada por fases.

## Cómo usar este documento

- Marcad cada tarea al terminarla, cambiando `- [ ]` por `- [x]`, y subidlo junto con el Pull Request de esa tarea.
- Cada tarea tiene un **código** (`ALE-03`, `EXP-05`…). Usadlo en los commits y en los PR: `git commit -m "EXP-05: numeración del expediente"`.
- **Depende de:** no empecéis una tarea hasta que lo que necesita esté en `main`.
- Las fases van más o menos en orden, pero las tres personas avanzan **en paralelo**.

### Responsables

| Código | Quién | Rama principal |
|---|---|---|
| **ALE** | Alejandro — login, usuarios, estructura, despliegue | `feature/login` |
| **EXP** | Compañero 2 — expedientes | `feature/expedientes` |
| **PRE** | Compañero 3 — presupuesto y documentos | `feature/presupuesto` |
| **TODOS** | Los tres juntos | — |

### Hitos

| Hito | Qué significa | Fases |
|---|---|---|
| 🏁 **H1** | Se puede entrar con usuario y contraseña | 0–2 |
| 🏁 **H2** | Se puede crear, buscar y editar un expediente completo | 3 |
| 🏁 **H3** | Cada expediente tiene su presupuesto con IVA y totales | 4 |
| 🏁 **H4** | Se descargan todos los papeles rellenos en PDF | 5 |
| 🏁 **H5** | Tu padre la prueba con datos inventados y da el visto bueno | 6–7 |
| 🏁 **H6** | La app está en el servidor y la empresa la usa a diario | 8–9 |

---

## Fase 0 — Preparación ✅

- [x] **ALE-00a** Instalar el entorno (Git, Java 21, Node, Angular CLI, Docker, IntelliJ, VS Code)
- [x] **ALE-00b** Crear los proyectos backend (Spring Boot) y frontend (Angular)
- [x] **ALE-00c** PostgreSQL con Docker (`docker-compose.yml`)
- [x] **ALE-00d** Repositorio privado en GitHub
- [x] **ALE-00e** Analizar los papeles de la empresa (`docs/analisis-documentos.md`)
- [x] **ALE-00f** Esquema de base de datos (`V1__esquema_inicial.sql`)
- [x] **ALE-00g** Entidad `Usuario`, `Rol`, `UsuarioRepository` y CORS
- [x] **ALE-00h** Guía del equipo (`docs/GUIA_EQUIPO.md`)
- [ ] **ALE-00i** Invitar a los compañeros al repositorio
- [ ] **ALE-00j** Proteger `main` (Pull Request obligatorio con 1 aprobación)
- [ ] **EXP-00** / **PRE-00** Instalar el entorno, clonar, crear rama y arrancar el proyecto

---

## Fase 1 — Base común del frontend

Hay que hacerla pronto, porque los demás la usan. El resto de tareas de cada uno no espera por ella: pueden empezar con sus entidades.

- [ ] **TODOS-01** Decidir la librería de componentes: **PrimeNG** (recomendada: tablas y calendarios muy completos) o Angular Material
- [ ] **ALE-01** Instalar la librería elegida y configurar tema, idioma español y formato de fecha `dd/MM/yyyy`
- [ ] **ALE-02** Crear `environment.ts` con `apiUrl = 'http://localhost:8080/api'`
- [ ] **ALE-03** Crear la estructura de carpetas de Angular: `auth/`, `layout/`, `usuarios/`, `expedientes/`, `presupuestos/`, `shared/`
- [ ] **ALE-04** Rutas vacías en `app.routes.ts`: `/login`, `/expedientes`, `/usuarios` (cada uno rellenará su página)
- [ ] **ALE-05** Manejo global de errores en el backend (`@RestControllerAdvice`): respuestas de error con el mismo formato y mensajes en español

---

## Fase 2 — Login y usuarios (ALE) → 🏁 H1

### Backend
- [ ] **ALE-10** Spring Security + JWT + login + creación del admin inicial *(en curso)*
- [ ] **ALE-11** API de gestión de usuarios (solo ADMIN):
  - [ ] `GET /api/usuarios` — listado (activos e inactivos)
  - [ ] `POST /api/usuarios` — alta (usuario en minúsculas, sin tildes ni espacios, único)
  - [ ] `PUT /api/usuarios/{id}` — editar nombre, apellidos, DNI, domicilio, rol
  - [ ] `PUT /api/usuarios/{id}/password` — el admin pone una contraseña nueva
  - [ ] `PATCH /api/usuarios/{id}/activo` — desactivar o reactivar ("borrar")
  - [ ] Reglas: el admin no puede desactivarse a sí mismo ni quitarse el rol ADMIN; contraseña mínima de 8 caracteres
- [ ] **ALE-12** `GET /api/operarios` — lista de operarios activos (nombre e id), accesible a cualquier usuario logueado. **La necesita EXP** para asignar el operario.
- [ ] **ALE-13** Rechazar los tokens de usuarios desactivados, aunque el token no haya caducado
- [ ] **ALE-14** Tests: login correcto, contraseña incorrecta, usuario desactivado, operario sin acceso a `/api/usuarios`

### Frontend
- [ ] **ALE-15** `AuthService`: login, logout, guardar el token, saber el rol del usuario
- [ ] **ALE-16** Interceptor HTTP que añade `Authorization: Bearer …` a cada petición y manda a `/login` si llega un 401
- [ ] **ALE-17** Guards: rutas solo para logueados y la ruta `/usuarios` solo para ADMIN
- [ ] **ALE-18** Pantalla de **login**
- [ ] **ALE-19** **Layout**: menú lateral, cabecera con el nombre del usuario y botón de cerrar sesión. La opción "Usuarios" solo se ve si eres ADMIN.
- [ ] **ALE-20** Pantalla de **gestión de usuarios**: tabla, alta, editar, cambiar contraseña, desactivar o reactivar

### Cierre
- [ ] **ALE-21** Unir `feature/login` a `main` y **avisar al equipo**: desde ese momento la API pide token. Explicarles cómo hacer login en Bruno/Postman.

---

## Fase 3 — Expedientes (EXP) → 🏁 H2

### Backend
- [ ] **EXP-01** Entidad `Aseguradora` + repositorio + `GET /api/aseguradoras` *(primera tarea, para aprender)*
- [ ] **EXP-02** Entidad `Expediente` con `@ManyToOne Usuario operario` y `autorizadoRegistro`
- [ ] **EXP-03** Entidades `Difunto`, `Declarante` y `Servicio` (relación 1 a 1 con `Expediente`)
- [ ] **EXP-04** DTOs: crear/editar expediente completo, detalle y resumen para el listado
- [ ] **EXP-05** **Numeración** al crear: `tnts_{usuario}_{yyyy-MM-dd}_{n}`, sumando 1 a `usuario.contador_servicios`. Hacerlo en una transacción con bloqueo, para que dos altas a la vez no den el mismo número.
- [ ] **EXP-06** `POST /api/expedientes` y `PUT /api/expedientes/{id}`
- [ ] **EXP-07** `GET /api/expedientes/{id}` — detalle completo
- [ ] **EXP-08** `GET /api/expedientes` — listado **paginado** con búsqueda por nombre, apellidos, DNI y número, y filtros por fecha, estado y operario
- [ ] **EXP-09** Cambiar estado: abierto → en curso → cerrado, o anulado
- [ ] **EXP-10** Validaciones: formato de DNI/NIE, fecha de defunción posterior a la de nacimiento, campos obligatorios mínimos para guardar un borrador
- [ ] **EXP-11** Tests del servicio (numeración, sobre todo) y del controlador

### Frontend
- [ ] **EXP-12** Listado de expedientes: tabla con número, fallecido, fecha, operario y estado, más buscador y filtros. Es la pantalla de inicio.
- [ ] **EXP-13** Formulario del expediente (Reactive Forms), con las mismas secciones que la hoja de papel:
  - [ ] Fallecido (nombre y apellidos por separado, sexo, DNI, nacimiento, padres, estado civil, cónyuge, hijos, domicilio)
  - [ ] Defunción (fecha, hora, lugar)
  - [ ] Declarante (datos, parentesco, teléfonos)
  - [ ] Servicio (velatorio, misa, inhumación o incineración, fechas y horas)
  - [ ] Seguro (desplegable de aseguradoras, póliza, siniestro, capital)
  - [ ] Registro Civil, marcapasos y observaciones
  - [ ] Operario asignado (desplegable que usa `GET /api/operarios`)
- [ ] **EXP-14** Alta rápida: poder guardar solo con los datos mínimos (nombre del fallecido y operario) y completar el resto después
- [ ] **EXP-15** Página de detalle del expediente con **pestañas**: Datos (EXP), Presupuesto (PRE), Documentos (PRE)

---

## Fase 4 — Presupuesto (PRE) → 🏁 H3

### Backend
- [ ] **PRE-01** Entidad `Concepto` + repositorio + `GET /api/conceptos` *(primera tarea, para aprender)*
- [ ] **PRE-02** Entidades `LineaPresupuesto`, `Corona` y `Valoracion`. Mientras el expediente no esté en `main`, usar `Long expedienteId`.
- [ ] **PRE-03** **Cálculo de totales** con `BigDecimal` y redondeo a 2 decimales (`HALF_UP`):
  - total suministrado, IVA 21 %, IVA 10 % (flores), suma, total suplidos (sin IVA) y **total presupuesto**
  - **Tests unitarios obligatorios**: es dinero
- [ ] **PRE-04** `GET /api/expedientes/{id}/presupuesto` — líneas, coronas y totales
- [ ] **PRE-05** `PUT /api/expedientes/{id}/presupuesto` — guardar las líneas (copiando nombre, tipo e IVA del concepto)
- [ ] **PRE-06** Coronas: crear, editar y borrar. Su suma alimenta automáticamente la línea "Coronas y ramos" (10 %).
- [ ] **PRE-07** Valoración: `GET/PUT /api/expedientes/{id}/valoracion`
- [ ] **PRE-08** Gestión del catálogo de conceptos (solo ADMIN): cambiar precios, activar o desactivar y añadir conceptos nuevos
- [ ] **PRE-09** Cuando EXP esté en `main`, cambiar `Long expedienteId` por la relación `@ManyToOne Expediente`

### Frontend
- [ ] **PRE-10** Pestaña **Presupuesto**: dos tablas (suministrados y suplidos) con importes editables y totales que se recalculan al escribir
- [ ] **PRE-11** Bloque de **coronas** (texto, proveedor, importe)
- [ ] **PRE-12** Formulario de la **encuesta de valoración**
- [ ] **PRE-13** Pantalla de catálogo de conceptos (solo ADMIN)

---

## Fase 5 — Documentos PDF (PRE, con ayuda de EXP) → 🏁 H4

Es la fase más larga. Cuando EXP termine la fase 3, se reparte: **EXP hace D3 y D4** y **PRE el resto**.

### Infraestructura
- [ ] **PRE-20** Añadir las dependencias: Thymeleaf, OpenHTMLtoPDF y Apache PDFBox
- [ ] **PRE-21** Utilidades comunes:
  - [ ] fecha en letra: "27 de octubre de 2026"
  - [ ] "D." o "Dña." y "fallecido" o "fallecida" según el sexo
  - [ ] edad a partir de las fechas de nacimiento y defunción
  - [ ] importe en letra (para el papel de Preventiva)
  - [ ] nombre completo a partir de nombre y apellidos
- [ ] **PRE-22** Reglas de **qué documentos se habilitan**:
  - siempre: D1, D2, D3 y D5
  - solo si el destino es incineración: D4
  - solo si la aseguradora es OCASO: D6
  - solo si la aseguradora es Preventiva: D7 y D8
- [ ] **PRE-23** `GET /api/expedientes/{id}/documentos` — lista de documentos habilitados
- [ ] **PRE-24** `GET /api/expedientes/{id}/documentos/{tipo}.pdf` — descarga el PDF relleno

### Documentos propios de FUASCEN (plantilla HTML → PDF)
- [ ] **PRE-25** D1 — Hoja de expediente
- [ ] **PRE-26** D2 — Presupuesto (costes del servicio)
- [ ] **EXP-20** D4 — Solicitud y autorización de incineración
- [ ] **PRE-27** D5 — Conformidad y valoración

### Documentos externos (escribir encima del formulario original con PDFBox)
- [ ] **TODOS-20** Conseguir los formularios **en blanco** y bien escaneados (o en PDF original) de D3, D6, D7 y D8
- [ ] **EXP-21** D3 — Cuestionario de declaración de defunción (Registro Civil). Ajustar las coordenadas imprimiendo pruebas sobre el impreso real.
- [ ] **PRE-28** D6 — Recibido y conforme póliza (OCASO), con la tabla de conceptos e importes
- [ ] **PRE-29** D7 — Autorización Avantia
- [ ] **PRE-30** D8 — Autorización Preventiva

### Frontend
- [ ] **PRE-31** Pestaña **Documentos**: un botón por cada documento habilitado (Ver / Descargar / Imprimir)
- [ ] **TODOS-21** Imprimir todos los documentos con un expediente de prueba y comparar con los papeles originales

---

## Fase 6 — Integración y pruebas → 🏁 H5

- [ ] **TODOS-30** Unir todas las ramas a `main` y repasar que las relaciones entre entidades están bien
- [ ] **TODOS-31** Prueba completa del flujo: login → crear expediente → asignar operario → presupuesto → descargar todos los PDFs → cerrar expediente
- [ ] **TODOS-32** Probar con usuario **operario**: no ve "Usuarios", no puede llamar a la API de usuarios ni cambiar el catálogo
- [ ] **TODOS-33** Repasar los mensajes de error y los textos de la interfaz (todo en español y claro)
- [ ] **TODOS-34** Probar en el ordenador y la pantalla de la oficina, y con la impresora de la oficina
- [ ] **TODOS-35** **Prueba piloto con tu padre** usando datos inventados: que haga un servicio entero en la app
- [ ] **TODOS-36** Apuntar lo que pida cambiar y arreglarlo
- [ ] **ALE-30** (Opcional, recomendable) GitHub Actions: compilar y pasar los tests automáticamente en cada Pull Request

---

## Fase 7 — Seguridad y protección de datos

- [ ] **ALE-40** Contraseñas: mínimo 8 caracteres y que el admin pueda forzar el cambio
- [ ] **ALE-41** Limitar intentos de login fallidos (por ejemplo, bloqueo de 5 minutos tras 5 fallos)
- [ ] **ALE-42** Guardar quién creó y quién modificó cada expediente, y cuándo
- [ ] **TODOS-40** Revisar que no hay datos reales, contraseñas ni secretos en el repositorio de GitHub
- [ ] **TODOS-41** Protección de datos (RGPD), **consultarlo con la gestoría o un asesor**:
  - [ ] cláusula informativa para las familias (qué datos se guardan y para qué)
  - [ ] registro de actividades de tratamiento
  - [ ] contrato de encargado del tratamiento con el proveedor del servidor
  - [ ] cuánto tiempo se guardan los expedientes
- [ ] **TODOS-42** No guardar datos que no hagan falta (por ejemplo, la causa de la muerte)

---

## Fase 8 — Despliegue en el servidor (ALE + TODOS)

- [ ] **ALE-50** Elegir el proveedor de VPS (**servidor en la UE**) y contratarlo; comprar el dominio
- [ ] **ALE-51** Seguridad básica del servidor: acceso SSH con clave (sin contraseña), cortafuegos (solo puertos 22, 80 y 443) y actualizaciones automáticas
- [ ] **ALE-52** `Dockerfile` del backend
- [ ] **ALE-53** `Dockerfile` del frontend (compilar Angular y servirlo con Nginx)
- [ ] **ALE-54** `docker-compose.prod.yml` (base de datos, backend y frontend)
- [ ] **ALE-55** Variables de entorno de producción en un archivo `.env` que **nunca se sube a Git**: `JWT_SECRET` largo y aleatorio, contraseña de la base de datos, `ADMIN_PASSWORD`
- [ ] **ALE-56** `environment.prod.ts` de Angular y CORS con el dominio real
- [ ] **ALE-57** Nginx: sirve Angular y redirige `/api` al backend
- [ ] **ALE-58** HTTPS con Let's Encrypt (y renovación automática)
- [ ] **ALE-59** **Copias de seguridad diarias** de la base de datos (`pg_dump`), guardadas **fuera del servidor**
- [ ] **ALE-60** **Probar a restaurar una copia de seguridad.** Una copia que no se ha probado no es una copia.
- [ ] **ALE-61** Escribir en `docs/DESPLIEGUE.md` cómo se actualiza la app en el servidor

---

## Fase 9 — Puesta en marcha → 🏁 H6

- [ ] **TODOS-50** Cargar los datos reales de partida: precios del catálogo, aseguradoras habituales y empleados
- [ ] **ALE-70** Entrar con el admin, **cambiar su contraseña** y crear los usuarios de los operarios
- [ ] **TODOS-51** Manual de uso breve para la oficina (`docs/MANUAL.md`, con capturas)
- [ ] **TODOS-52** Formación a tu padre y a los operarios (una sesión práctica)
- [ ] **TODOS-53** **Convivencia papel + app** durante 1–2 semanas, para comprobar que los PDFs salen bien en servicios reales
- [ ] **TODOS-54** Recoger los problemas y las peticiones de esas semanas y priorizarlos
- [ ] **TODOS-55** Dejar de usar el papel 🎉

---

## Pendiente de decidir

| # | Pregunta | A quién | Afecta a |
|---|---|---|---|
| 1 | ¿Los operarios ven **todos** los expedientes o solo los suyos? ¿Pueden editar los de otros? | Padre | EXP-08, EXP-06 |
| 2 | ¿Quién puede **anular** un expediente: cualquiera o solo el admin? | Padre | EXP-09 |
| 3 | En el Registro Civil, ¿el autorizado es siempre alguien de la funeraria? ¿Sigue siendo en papel? | Padre | EXP-21 |
| 4 | ¿Hay más aseguradoras habituales aparte de OCASO y Preventiva? | Padre | TODOS-50 |
| 5 | ¿PrimeNG o Angular Material? | Equipo | TODOS-01 |
| 6 | ¿Quién paga el servidor y el dominio, y a nombre de quién se contratan? | Padre | ALE-50 |

---

## Ideas para después (versión 2)

No entran ahora, pero apuntadlas aquí para no olvidarlas:

- Calendario de ocupación de salas de velatorio
- Estadísticas: servicios por mes, por operario, por aseguradora, y resultados de las encuestas
- Enviar los documentos por correo a la aseguradora o a la familia desde la app
- Firma en tableta en lugar de imprimir y firmar
- Conexión con el programa de facturación homologado (Verifactu)
- Versión adaptada al móvil para las guardias
