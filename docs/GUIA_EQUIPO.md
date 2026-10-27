# Guía del equipo — App de gestión FUASCEN

Bienvenidos 👋 Esta guía explica cómo poner el proyecto en marcha y cómo trabajamos los tres sin pisarnos.

---

## 1. Preparar el ordenador (solo la primera vez)

Instalad, en este orden:

| Herramienta | Dónde | Notas |
|---|---|---|
| Git | git-scm.com | Opciones por defecto |
| Java 21 (Temurin) | adoptium.net → **21 - LTS** → .msi | Marcar **Añadir al PATH** y **Establecer la variable JAVA_HOME** |
| Node.js | nodejs.org → versión **LTS** | No marcar "Tools for Native Modules" |
| Angular CLI | `npm install -g @angular/cli` | Si PowerShell da error de permisos: `Set-ExecutionPolicy -Scope CurrentUser RemoteSigned` |
| Docker Desktop | docker.com | Si pide WSL: PowerShell como admin → `wsl --install` y reiniciar |
| IntelliJ IDEA (gratuito) | jetbrains.com/idea | Para el backend |
| VS Code | code.visualstudio.com | Para Angular. Instalar la extensión **Angular Language Service** |

Comprobad en una terminal **nueva**:
```
git --version
java -version      (debe salir 21)
node -v
ng version
docker run hello-world
```

Configurad Git con vuestro nombre:
```
git config --global user.name "Tu Nombre"
git config --global user.email "tu@email.com"
```

---

## 2. Descargar el proyecto y arrancarlo

1. Aceptad la invitación al repositorio que os llega por correo (es **privado**).
2. Clonad y cread vuestra rama:
   ```
   cd $HOME
   git clone https://github.com/Ale07dv/funeraria.git
   cd funeraria
   git checkout -b feature/TU-RAMA
   git push -u origin feature/TU-RAMA
   ```
3. **Base de datos** (con Docker Desktop abierto):
   ```
   docker compose up -d
   ```
4. **Backend**: abrid la carpeta `funeraria\backend` en IntelliJ (File → Open), esperad a que descargue dependencias y ejecutad `BackendApplication` (▶ verde).
   - Si Lombok sale en rojo: Settings → Build, Execution, Deployment → Compiler → Annotation Processors → **Enable annotation processing**.
   - Debe salir: `Successfully applied 1 migration` y `Started BackendApplication`.
5. **Frontend**: en otra terminal:
   ```
   cd $HOME\funeraria\frontend
   npm install
   ng serve
   ```
   Abrid http://localhost:4200.

Cada día, para arrancar: Docker Desktop → `docker compose up -d` → backend en IntelliJ → `ng serve`.

---

## 3. Quién hace qué

| | Rama | Paquete Java (`com.funeraria.backend.…`) | Carpeta Angular (`src/app/…`) |
|---|---|---|---|
| **Alejandro** | `feature/login` | `usuario`, `config`, `seguridad` | `auth`, `usuarios`, `layout` |
| **Compañero 2** | `feature/expedientes` | `expediente` | `expedientes` |
| **Compañero 3** | `feature/presupuesto` | `presupuesto`, `documento` | `presupuestos` |

### Compañero 2 — Expedientes
Tablas: `expediente`, `difunto`, `declarante`, `servicio`, `aseguradora`.
1. Entidad **Aseguradora** + repositorio + `GET /api/aseguradoras` (la más fácil, para empezar).
2. Entidades **Expediente**, **Difunto**, **Declarante**, **Servicio**.
   - El operario ya se puede enlazar: la clase `Usuario` está en `main` → `@ManyToOne Usuario operario`.
3. API: `GET /api/expedientes` (listado + búsqueda), `GET /api/expedientes/{id}`, `POST`, `PUT`.
4. Generar el número al crear: `tnts_{username}_{yyyy-MM-dd}_{contador}` (ej: `tnts_maria_2026-10-27_15` = servicio nº 15 de María, creado el 27/10/2026), sumando 1 a `usuario.contador_servicios`.
5. Angular: listado de expedientes y formulario (puede empezarse con datos de mentira).

### Compañero 3 — Presupuesto y documentos
Tablas: `concepto`, `linea_presupuesto`, `corona`, `valoracion`.
1. Entidad **Concepto** + repositorio + `GET /api/conceptos` (catálogo).
2. Entidades **LineaPresupuesto**, **Corona**, **Valoracion**.
   - Mientras el expediente no esté en `main`, guardad solo el id: `@Column(name = "expediente_id") private Long expedienteId;`
3. Servicio que calcule totales: total suministrado, IVA 21 %, IVA 10 % (flores), suma, total suplidos (sin IVA) y **total presupuesto**. Hacedle tests.
4. PDF de la hoja de presupuesto con datos inventados (Thymeleaf + OpenHTMLtoPDF).
5. Angular: pantalla de presupuesto (puede empezarse con datos de mentira).
6. Más adelante, los PDFs del resto de papeles y la regla de **qué documentos se habilitan**:
   - Siempre: hoja de expediente, presupuesto, Registro Civil, conformidad y valoración.
   - Solo si el destino es **incineración**: autorización de incineración.
   - Solo si la aseguradora es **OCASO**: recibido y conforme póliza.
   - Solo si la aseguradora es **Preventiva**: autorización Avantia + autorización Preventiva.

**El análisis de los papeles** (qué campo va en qué documento) está en `docs/analisis-documentos.md`. Leedlo antes de empezar.

---

## 4. Normas del código

**Backend** — dentro de vuestro paquete, una clase por tipo:
```
expediente/
├── Expediente.java              ← entidad (@Entity)
├── ExpedienteRepository.java    ← interface JpaRepository
├── ExpedienteService.java       ← lógica
├── ExpedienteController.java    ← @RestController, rutas /api/...
└── dto/                         ← lo que entra y sale por la API
```
- Todas las rutas empiezan por **`/api/`** (ej: `/api/expedientes`).
- La API **no devuelve entidades directamente**, sino DTOs (evita bucles y datos de más).
- En entidades usad `@Getter @Setter @NoArgsConstructor`, **no `@Data`**.
- La base de datos está en modo `validate`: la entidad tiene que coincidir con la tabla. Si no, el backend no arranca y el error dice qué columna falla.

**Frontend**
- Cada uno trabaja dentro de su carpeta de `src/app/`.
- La URL del backend es `http://localhost:8080/api`.

---

## 5. Normas de Git

1. **Nunca trabajar en `main`.** Siempre en vuestra rama.
2. **Cada día, antes de empezar**, traed lo nuevo:
   ```
   git checkout main
   git pull
   git checkout feature/TU-RAMA
   git merge main
   ```
3. **Commits pequeños** con mensajes claros: `git commit -m "Entidad Aseguradora y endpoint de listado"`.
4. **Pull Request cada 1–2 días** con lo que funcione, aunque no esté terminado. Otro compañero lo revisa y lo aprueba.
5. **Antes de abrir un PR**, comprobad que el backend arranca sin errores.

---

## 6. ⚠️ Archivos compartidos — avisar en el grupo antes de tocarlos

| Archivo | Regla |
|---|---|
| `backend/pom.xml` | Añadid solo vuestra dependencia. Avisad. |
| `frontend/src/app/app.routes.ts` | Añadid solo **vuestra línea** de ruta. |
| `backend/src/main/resources/application.properties` | Avisad antes de cambiar nada. |
| **Migraciones de base de datos** | Ver abajo. |

### Migraciones (lo más delicado)
- **Nunca modificar** `V1__esquema_inicial.sql` ni ninguna migración que ya esté en `main`.
- Para cambiar una tabla, se crea un archivo nuevo en `backend/src/main/resources/db/migration/` con **fecha y hora** en el nombre, para que no coincidan:
  ```
  V20261028_1030__anadir_campo_x_a_difunto.sql
  ```
- Avisad en el grupo cuando unáis una migración a `main`.
- Si la base de datos local se queda en mal estado (solo en vuestro ordenador):
  ```
  docker compose down -v
  docker compose up -d
  ```

---

## 7. Datos personales

- **Nunca** uséis datos reales de familias, ni para probar ni en capturas.
- **Nunca** subáis a GitHub contraseñas reales, documentos escaneados con datos o copias de la base de datos.
- Para probar, inventad nombres y DNIs (ej: `Prueba Pérez, 00000000T`).
