-- =====================================================================
-- V1 · Esquema inicial de la app de gestión de FUASCEN
-- Ubicación: backend/src/main/resources/db/migration/V1__esquema_inicial.sql
-- Flyway lo ejecuta automáticamente al arrancar Spring Boot.
-- Mientras estemos desarrollando (sin datos reales) se puede reescribir y
-- resetear la base de datos. En producción NUNCA: los cambios irán en V2, V3...
-- =====================================================================

-- ---------------------------------------------------------------------
-- Usuarios (login)
--   ADMIN    = tú: das de alta, desactivas y cambias contraseñas.
--   OPERARIO = empleados: solo trabajan con expedientes, no tocan cuentas.
-- El primer ADMIN lo crea la app al arrancar (no se guardan contraseñas aquí).
-- ---------------------------------------------------------------------

CREATE TABLE usuario (
    id                  BIGSERIAL PRIMARY KEY,
    username            VARCHAR(50)  NOT NULL UNIQUE,    -- con lo que inicia sesión, ej: "maria"
    password_hash       VARCHAR(100) NOT NULL,           -- contraseña cifrada con BCrypt, nunca en claro
    rol                 VARCHAR(10)  NOT NULL CHECK (rol IN ('ADMIN', 'OPERARIO')),
    nombre              VARCHAR(100) NOT NULL,
    apellidos           VARCHAR(150) NOT NULL,
    dni                 VARCHAR(15)  UNIQUE,             -- para el Registro Civil (autorizado)
    domicilio           VARCHAR(255),
    contador_servicios  INTEGER      NOT NULL DEFAULT 0, -- último nº de servicio de este operario
    activo              BOOLEAN      NOT NULL DEFAULT TRUE,  -- "borrar" = desactivar (ver nota)
    creado_en           TIMESTAMP    NOT NULL DEFAULT now()
);
-- Nota: un usuario con expedientes no se borra físicamente (se perdería quién
-- hizo cada servicio). Se desactiva: ya no puede entrar, pero el historial queda.

-- ---------------------------------------------------------------------
-- Catálogos
-- ---------------------------------------------------------------------

CREATE TABLE aseguradora (
    id                      BIGSERIAL PRIMARY KEY,
    nombre                  VARCHAR(150) NOT NULL UNIQUE,
    cif                     VARCHAR(20),
    -- Qué formulario de autorización se imprime para esta aseguradora
    plantilla_autorizacion  VARCHAR(20)
        CHECK (plantilla_autorizacion IN ('OCASO', 'PREVENTIVA', 'AVANTIA')),
    activa                  BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE concepto (
    id          BIGSERIAL PRIMARY KEY,
    nombre      VARCHAR(100) NOT NULL,
    tipo        VARCHAR(15)  NOT NULL CHECK (tipo IN ('SUMINISTRADO', 'SUPLIDO')),
    tipo_iva    NUMERIC(4,2) NOT NULL DEFAULT 21,   -- flores 10, resto 21, suplidos 0
    precio_base NUMERIC(10,2),                       -- precio orientativo, editable en cada expediente
    orden       SMALLINT     NOT NULL DEFAULT 0,     -- orden en la hoja de presupuesto
    activo      BOOLEAN      NOT NULL DEFAULT TRUE,
    UNIQUE (nombre, tipo)                            -- "Incineración" existe como suministrado y como suplido
);

-- ---------------------------------------------------------------------
-- Expediente (documento maestro = hoja D1)
-- ---------------------------------------------------------------------

CREATE TABLE expediente (
    id                      BIGSERIAL PRIMARY KEY,

    -- Numeración: se guarda el código ya formado (ej: tnts_maria_15_2026-10-27)
    -- y también sus piezas, para poder buscar y ordenar.
    numero                  VARCHAR(80)  NOT NULL UNIQUE,
    operario_id             BIGINT       NOT NULL REFERENCES usuario(id),  -- quien hace el servicio
    secuencia_operario      INTEGER      NOT NULL,                         -- nº de servicio de ese operario
    UNIQUE (operario_id, secuencia_operario),

    lugar_apertura          VARCHAR(100) NOT NULL DEFAULT 'Sevilla',
    fecha_apertura          DATE         NOT NULL DEFAULT CURRENT_DATE,
    estado                  VARCHAR(20)  NOT NULL DEFAULT 'ABIERTO'
        CHECK (estado IN ('ABIERTO', 'EN_CURSO', 'CERRADO', 'ANULADO')),

    -- Seguro
    aseguradora_id          BIGINT REFERENCES aseguradora(id),
    numero_poliza           VARCHAR(50),
    numero_siniestro        VARCHAR(50),
    capital_poliza          NUMERIC(10,2),

    -- Registro Civil (D3)
    registro_civil          VARCHAR(150),            -- "Al encargado del Registro Civil de..."
    autorizado_registro_id  BIGINT REFERENCES usuario(id),  -- quien presenta el parte

    marcapasos              BOOLEAN,
    observaciones           TEXT,
    observaciones_presupuesto TEXT,

    creado_por_id           BIGINT    NOT NULL REFERENCES usuario(id),
    creado_en               TIMESTAMP NOT NULL DEFAULT now(),
    actualizado_en          TIMESTAMP NOT NULL DEFAULT now()
);

CREATE TABLE difunto (
    id                      BIGSERIAL PRIMARY KEY,
    expediente_id           BIGINT NOT NULL UNIQUE REFERENCES expediente(id) ON DELETE CASCADE,

    -- Identidad (separado porque el Registro Civil lo pide así)
    nombre                  VARCHAR(100) NOT NULL,
    primer_apellido         VARCHAR(100) NOT NULL,
    segundo_apellido        VARCHAR(100),
    sexo                    CHAR(1) CHECK (sexo IN ('H', 'M')),   -- para "D./Dña.", "fallecido/a"
    dni                     VARCHAR(15),
    nacionalidad            VARCHAR(60) DEFAULT 'Española',

    -- Nacimiento
    fecha_nacimiento        DATE,
    municipio_nacimiento    VARCHAR(100),
    provincia_nacimiento    VARCHAR(100),            -- o país, si nació en el extranjero
    inscripcion_nacimiento  VARCHAR(150),            -- tomo / página o folio (Libro de Familia)

    -- Familia
    nombre_padre            VARCHAR(100),            -- "Hijo de..."
    nombre_madre            VARCHAR(100),            -- "...y de"
    estado_civil            VARCHAR(20)
        CHECK (estado_civil IN ('SOLTERO', 'CASADO', 'VIUDO', 'DIVORCIADO', 'SEPARADO')),
    nombre_conyuge          VARCHAR(200),
    numero_hijos            SMALLINT CHECK (numero_hijos >= 0),
    nombres_hijos           TEXT,

    -- Último domicilio
    domicilio               VARCHAR(255),
    codigo_postal           VARCHAR(10),
    localidad               VARCHAR(100),
    provincia               VARCHAR(100),

    -- Defunción
    fecha_defuncion         DATE,
    hora_defuncion          TIME,
    lugar_defuncion         VARCHAR(255),
    localidad_defuncion     VARCHAR(100),

    -- Registro Civil
    origen_datos            TEXT,                    -- "Los anteriores datos se conocen..." (nota 7)
    otros_datos             TEXT
);

CREATE TABLE declarante (
    id                      BIGSERIAL PRIMARY KEY,
    expediente_id           BIGINT NOT NULL UNIQUE REFERENCES expediente(id) ON DELETE CASCADE,
    nombre                  VARCHAR(100) NOT NULL,
    apellidos               VARCHAR(200) NOT NULL,
    dni                     VARCHAR(15),
    parentesco              VARCHAR(50),             -- "en calidad de"
    domicilio               VARCHAR(255),
    codigo_postal           VARCHAR(10),
    localidad               VARCHAR(100),
    provincia               VARCHAR(100),
    telefono                VARCHAR(30),
    telefono_alternativo    VARCHAR(30)
);

CREATE TABLE servicio (
    id                      BIGSERIAL PRIMARY KEY,
    expediente_id           BIGINT NOT NULL UNIQUE REFERENCES expediente(id) ON DELETE CASCADE,

    lugar_velatorio         VARCHAR(150),

    lugar_misa              VARCHAR(150),            -- misa o responso
    fecha_misa              DATE,
    hora_misa               TIME,

    tipo_destino            VARCHAR(15) CHECK (tipo_destino IN ('INHUMACION', 'INCINERACION')),
    lugar_destino           VARCHAR(150),            -- cementerio o crematorio
    localidad_destino       VARCHAR(100),
    fecha_destino           DATE,
    hora_destino            TIME,

    -- Solo cremación (D4)
    numero_cremacion        VARCHAR(20),
    cenizas_al_crematorio   BOOLEAN NOT NULL DEFAULT FALSE
);

-- ---------------------------------------------------------------------
-- Presupuesto (hoja D2) y coronas
-- ---------------------------------------------------------------------

CREATE TABLE linea_presupuesto (
    id              BIGSERIAL PRIMARY KEY,
    expediente_id   BIGINT NOT NULL REFERENCES expediente(id) ON DELETE CASCADE,
    concepto_id     BIGINT REFERENCES concepto(id),  -- NULL si es una fila libre
    -- Copias del concepto en el momento de añadirlo (histórico)
    descripcion     VARCHAR(200)  NOT NULL,
    tipo            VARCHAR(15)   NOT NULL CHECK (tipo IN ('SUMINISTRADO', 'SUPLIDO')),
    tipo_iva        NUMERIC(4,2)  NOT NULL DEFAULT 0,
    importe         NUMERIC(10,2) NOT NULL CHECK (importe >= 0),   -- base imponible, sin IVA
    orden           SMALLINT      NOT NULL DEFAULT 0
);

CREATE TABLE corona (
    id              BIGSERIAL PRIMARY KEY,
    expediente_id   BIGINT NOT NULL REFERENCES expediente(id) ON DELETE CASCADE,
    texto           VARCHAR(255) NOT NULL,
    proveedor       VARCHAR(100),
    importe         NUMERIC(10,2) CHECK (importe >= 0)   -- su suma va a "Coronas y ramos" (10 %)
);

-- ---------------------------------------------------------------------
-- Encuesta de valoración (D5)
-- ---------------------------------------------------------------------

CREATE TABLE valoracion (
    id                  BIGSERIAL PRIMARY KEY,
    expediente_id       BIGINT NOT NULL UNIQUE REFERENCES expediente(id) ON DELETE CASCADE,
    -- 1 = Mal, 2 = Regular, 3 = Bien, 4 = Muy bien
    puntualidad         SMALLINT CHECK (puntualidad BETWEEN 1 AND 4),
    trato_personal      SMALLINT CHECK (trato_personal BETWEEN 1 AND 4),
    profesionalidad     SMALLINT CHECK (profesionalidad BETWEEN 1 AND 4),
    asesoramiento       SMALLINT CHECK (asesoramiento BETWEEN 1 AND 4),
    observaciones       TEXT,
    fecha               DATE NOT NULL DEFAULT CURRENT_DATE
);

-- ---------------------------------------------------------------------
-- Índices para las búsquedas habituales
-- ---------------------------------------------------------------------

CREATE INDEX idx_expediente_fecha     ON expediente (fecha_apertura);
CREATE INDEX idx_expediente_estado    ON expediente (estado);
CREATE INDEX idx_expediente_operario  ON expediente (operario_id);
CREATE INDEX idx_difunto_apellidos    ON difunto (primer_apellido, segundo_apellido);
CREATE INDEX idx_difunto_dni          ON difunto (dni);
CREATE INDEX idx_linea_expediente     ON linea_presupuesto (expediente_id);
CREATE INDEX idx_corona_expediente    ON corona (expediente_id);

-- ---------------------------------------------------------------------
-- Datos iniciales
-- ---------------------------------------------------------------------

INSERT INTO aseguradora (nombre, cif, plantilla_autorizacion) VALUES
    ('OCASO, S.A.', 'A28016608', 'OCASO'),
    ('Preventiva Seguros', NULL, 'PREVENTIVA');
-- Las aseguradoras gestionadas por Avantia se añadirán con plantilla 'AVANTIA'

-- Conceptos del presupuesto (en el orden del papel).
-- IVA: flores (coronas y ramos) 10 %, resto de suministrados 21 %, suplidos sin IVA.
INSERT INTO concepto (nombre, tipo, tipo_iva, orden) VALUES
    ('Féretro',                              'SUMINISTRADO', 21,  1),
    ('Agenciado y documentación',            'SUMINISTRADO', 21,  2),
    ('Mandato de féretro',                   'SUMINISTRADO', 21,  3),
    ('Auto fúnebre',                         'SUMINISTRADO', 21,  4),
    ('Personal realización sepelio',         'SUMINISTRADO', 21,  5),
    ('Sudario',                              'SUMINISTRADO', 21,  6),
    ('Urna para cenizas',                    'SUMINISTRADO', 21,  7),
    ('Coronas y ramos',                      'SUMINISTRADO', 10,  8),
    ('Certificado médico',                   'SUMINISTRADO', 21,  9),
    ('Médico firma certificado',             'SUMINISTRADO', 21, 10),
    ('Agenciado y documentación traslado',   'SUMINISTRADO', 21, 11),
    ('Sala velatorio/tanatorio',             'SUMINISTRADO', 21, 12),
    ('Incineración',                         'SUMINISTRADO', 21, 13),
    ('Vaso interior de zinc',                'SUMINISTRADO', 21, 14),
    ('Cierre, sellado hermético y precinto', 'SUMINISTRADO', 21, 15),
    ('Productos químicos',                   'SUMINISTRADO', 21, 16),
    ('Filtro depurador de gases',            'SUMINISTRADO', 21, 17),
    ('Funda de transporte aéreo',            'SUMINISTRADO', 21, 18),
    ('Kilometraje',                          'SUMINISTRADO', 21, 19),
    ('Dietas',                               'SUMINISTRADO', 21, 20),
    ('Servicio de aeropuerto',               'SUMINISTRADO', 21, 21),
    ('Lápida',                               'SUMINISTRADO', 21, 22),
    ('Embalsamamiento o preparación',        'SUMINISTRADO', 21, 23),
    ('Esquela',                              'SUMINISTRADO', 21, 24),
    ('Sepultura',                            'SUPLIDO',       0,  1),
    ('Incineración',                         'SUPLIDO',       0,  2),
    ('Sepulturero',                          'SUPLIDO',       0,  3),
    ('Taxis',                                'SUPLIDO',       0,  4),
    ('Derechos parroquiales',                'SUPLIDO',       0,  5),
    ('Tasas de sanidad',                     'SUPLIDO',       0,  6);
