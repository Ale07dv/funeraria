# Análisis de los documentos de FUASCEN

Documentos analizados (escaneos del 27/10/2026):

| # | Documento | Lo rellena | Va dirigido a |
|---|-----------|------------|---------------|
| D1 | Hoja de expediente (anverso) | Funeraria + declarante (firma) | Interno — **es el documento maestro** |
| D2 | Costes del servicio (reverso de D1) | Funeraria | Interno / familia |
| D3 | Cuestionario para la declaración de defunción (2 págs.) | Funeraria + declarante (firma) | Registro Civil |
| D4 | Solicitud y autorización de incineración | Funeraria + familiar (firma) | Crematorio |
| D5 | Documento de conformidad y valoración | Funeraria + familiar (firma y encuesta) | Interno |
| D6 | Recibido y conforme póliza (OCASO) | Funeraria + familiar (firma) | Aseguradora OCASO |
| D7 | Autorización Avantia | Funeraria + familiar (firma) | Avantia (gestora de Preventiva) |
| D8 | Autorización Preventiva Seguros | Funeraria + familiar (firma) | Preventiva Seguros |

D6 solo se usa si la aseguradora es OCASO; D7 y D8, solo si es Preventiva.

**Conclusión principal:** la hoja de expediente (D1) ya recoge casi todo lo que piden los demás. Si la app tiene un formulario basado en D1, los otros 7 documentos se generan solos.

---

## 1. Datos que se repiten (matriz de reutilización)

✔ = el dato aparece en ese documento

| Dato | D1 | D2 | D3 | D4 | D5 | D6 | D7 | D8 |
|------|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|
| Nº de expediente | ✔ | ✔ | | | | | | |
| **Nombre y apellidos del fallecido** | ✔ | ✔ | ✔ | ✔ | ✔ | ✔ | ✔ | ✔ |
| **DNI del fallecido** | ✔ | | ✔ | ✔ | ✔ | | ✔ | |
| **Fecha de fallecimiento** | ✔ | | ✔ | ✔ | ✔ | ✔ | | ✔ |
| Hora de fallecimiento | ✔ | | ✔ | ✔ | | | | |
| Lugar / localidad de fallecimiento | ✔ | | ✔ | | ✔ | | | ✔ |
| Fecha de nacimiento (y edad) | ✔ | | ✔ | ✔ | | | | |
| Lugar de nacimiento | ✔ | | ✔ | ✔ | | | | |
| Hijo de … y de … (padres) | ✔ | | ✔ | ✔ | | | | |
| Estado civil | ✔ | | ✔ | ✔ | | | | |
| Domicilio del fallecido | ✔ | | ✔ | ✔ | | | | |
| **Declarante: nombre, DNI, parentesco** | ✔ | | ✔ | ✔ | ✔ | ✔ | ✔ | ✔ |
| Declarante: domicilio | ✔ | | ✔ | ✔ | | | | |
| Teléfono de contacto | ✔ | | | ✔ | | | | |
| **Aseguradora y nº de póliza** | ✔ | | | | ✔ | ✔ | ✔ | ✔ |
| Capital de la póliza | ✔ | | | | | | | ✔ |
| Nº de siniestro | | | | | | ✔ | | |
| Velatorio / tanatorio | ✔ | | | | | | | ✔ |
| Lugar de inhumación o incineración | ✔ | | ✔ | | | | | ✔ |
| Fecha y hora de cremación | ✔ | | | ✔ | | | | |
| Marcapasos | ✔ | | | ✔ | | | | |
| Conceptos e importes del servicio | | ✔ | | | | ✔ | | |
| Lugar y fecha del documento ("En Sevilla, a…") | ✔ | | ✔ | ✔ | ✔ | ✔ | ✔ | |
| Datos de la funeraria (nombre, CIF) | | | | | ✔ | ✔ | ✔ | ✔ |

Los datos en **negrita** aparecen en 5 documentos o más: son los que más tiempo le ahorran a tu padre.

---

## 2. Campos por documento

### D1 — Hoja de expediente (documento maestro)
- **Cabecera:** nº de expediente, lugar ("En"), fecha.
- **Fallecido:** nombre completo, DNI, lugar de fallecimiento, hora, día, natural de, fecha de nacimiento, hijo de, y de, estado civil, nombre del cónyuge, nº de hijos, nombre de los hijos, domicilio, C.P., localidad, provincia.
- **Seguro:** compañía aseguradora, nº de póliza, capital.
- **Servicio:** lugar del velatorio; lugar de la misa o responso, hora y día; lugar de inhumación o incineración, hora y día; teléfonos de contacto.
- **Declarante:** nombre y apellidos, DNI, parentesco, domicilio, C.P., localidad, provincia.
- **Coronas:** hasta 3 filas con texto, proveedor e importe.
- **Otros:** firma del declarante, observaciones y marcapasos (Sí/No).

### D2 — Costes del servicio (reverso)
- **Cabecera:** nº de expediente y nombre del fallecido.
- **Suministrados (llevan IVA):** Féretro, Agenciado y documentación, Mandato de féretro, Auto fúnebre, Personal realización sepelio, Sudario, Urna para cenizas, Coronas y ramos, Certificado médico, Médico firma cdo., Agenciado y doc. traslado, Sala velatorio/tanatorio, Incineración, Vaso interior de zinc, Cierre, sellado hermético y precinto, Producto químicos, Filtro depurador de gases, Funda de transporte aéreo, Kilometraje, Dietas, Servicio de aeropuerto, Lápida, Embalsamiento o preparación, Esquela, y filas libres.
- **Suplidos (sin IVA, se repercuten tal cual):** Sepultura, Incineración, Sepulturero, Taxis, Derechos parroquiales, Tasas de sanidad, y filas libres.
- **Totales:** total suministrado, IVA 21 %, IVA 10 %, suma, total suplidos y **total factura**. Todos se calculan, no hay que guardarlos.
- **Observaciones.**

### D3 — Cuestionario de declaración de defunción (Registro Civil)
- Encargado del Registro Civil de… (municipio).
- **Difunto:** nombre, **primer apellido** y **segundo apellido** por separado, hijo de / y de, estado, nacionalidad, fecha de nacimiento, lugar de nacimiento, DNI, inscrito al tomo (página o folio, del Libro de Familia), domicilio último y cómo se conocen los datos (nota 7).
- **Defunción:** día, mes, año, hora, lugar, lugar de enterramiento y otros datos.
- **Declarante:** nombre, domicilio, DNI y "en calidad de" (parentesco).
- **Autorizado** para presentar el parte: nombre, DNI y domicilio. Normalmente será un empleado de la funeraria (confirmar).
- Lugar y fecha.
- Las diligencias las rellena el Registro, no la app.

### D4 — Solicitud y autorización de incineración
- Nº de cremación, lugar y fecha.
- **Fallecido:** fecha y hora de fallecimiento, fecha y hora de cremación, nombre, DNI, lugar y fecha de nacimiento, **edad** (se calcula), estado civil, padres y domicilio.
- **Solicitante:** nombre, DNI, domicilio, localidad, provincia, "en calidad de" y teléfono.
- Casilla opcional para entregar las cenizas al crematorio y que las esparza.

### D5 — Conformidad y valoración
- Lugar y fecha.
- **Familiar:** nombre, DNI y "en calidad de".
- **Fallecido:** nombre, DNI, lugar y fecha de fallecimiento.
- Aseguradora y nº de póliza.
- **Encuesta:** puntualidad, trato personal, profesionalidad y asesoramiento (Mal / Regular / Bien / Muy bien), más observaciones. Se rellena **después** del servicio y vale la pena guardarla para tener estadísticas.

### D6 — Recibido y conforme póliza (OCASO)
- Nº de póliza, **nº de siniestro**, nombre del fallecido y fecha de fallecimiento.
- **Familiar:** nombre, DNI y parentesco.
- **Funeraria:** nombre y CIF.
- Cantidad en euros.
- **Tabla de conceptos e importes y total**, que sale de las líneas de D2.
- Lugar y fecha, nombre y NIF del firmante.

### D7 — Autorización Avantia
- **Familiar:** nombre y DNI.
- **Fallecido:** nombre y DNI.
- Nº de póliza y aseguradora.
- Lugar y fecha.
- Avantia no es una aseguradora: es la **gestora de Preventiva**. Este papel solo se usa si la aseguradora es Preventiva, y siempre junto con D8.

### D8 — Autorización Preventiva Seguros
- Nombre de la funeraria.
- **Familiar:** nombre, NIF y "en calidad de".
- Nombre del asegurado (fallecido), nº de póliza y capital (en letra y en número).
- Fecha y localidad de fallecimiento, tanatorio y localidad de inhumación o incineración.

---

## 3. Decisiones de diseño que salen de aquí

1. **Nombre y apellidos por separado.** D1 usa un solo campo, pero el Registro Civil (D3) pide nombre, primer apellido y segundo apellido. Guardándolos separados, la app puede juntarlos donde haga falta.
2. **Fecha y hora por separado.** Los formularios las piden en casillas distintas y a veces la hora no se sabe.
3. **La edad no se guarda**: se calcula a partir de la fecha de nacimiento y la de fallecimiento.
4. **Los totales no se guardan**: se calculan a partir de las líneas.
5. **Catálogo de conceptos** con tipo (suministrado o suplido) y tipo de IVA. Cada línea del expediente **copia** el nombre, el IVA y el importe, para que cambiar un precio del catálogo no altere los expedientes antiguos.
6. **Los documentos de aseguradora dependen de la aseguradora del expediente** (ver "Decisiones tomadas", punto 6). En la tabla `aseguradora`, el campo `plantilla_autorizacion` vale `OCASO` o `PREVENTIVA`; el valor `AVANTIA` existe en la base de datos pero no se usa.
7. **Los datos fijos de la funeraria** (FUASCEN S.L.U., CIF, domicilio social) van en la configuración de la app, no en cada expediente.
8. **Coronas**: son líneas propias (texto, proveedor e importe). Su suma puede alimentar automáticamente la línea "Coronas y ramos" de D2.

## 4. Cómo generar cada PDF

| Documento | Estrategia |
|-----------|------------|
| D1, D2, D4, D5 (propios de FUASCEN) | Plantilla HTML (Thymeleaf) → PDF con OpenHTMLtoPDF. Se pueden rediseñar libremente. |
| D3 (Registro Civil, impreso numerado) | Imprimir solo el texto en la posición exacta, sobre el impreso oficial en papel, o sobre su escaneo en blanco con PDFBox. |
| D6, D7, D8 (aseguradoras) | Escanear o pedir el formulario original en blanco y escribir encima con PDFBox. **No recrear sus logos ni su diseño**: los documentos son suyos. |

## 5. Decisiones tomadas

1. **Numeración del expediente:** `tnts_{usuario}_{fecha de creación}_{nº}`, donde el número es un contador **propio de cada operario** que sube en 1 con cada servicio.
   - Ejemplo: `tnts_maria_2026-10-27_15` = servicio nº 15 de María, creado el 27/10/2026.
   - Se usa el **nombre de usuario** (sin tildes ni espacios), no el nombre real.
2. **Cada expediente tiene un operario asignado**, que es quien hace el servicio.
3. **IVA:** flores (coronas y ramos) al **10 %**, el resto de suministrados al **21 %** y los suplidos **sin IVA**.
4. **La hoja de costes (D2) es un presupuesto**, no la factura. La factura se emite aparte, con software homologado (Verifactu).
5. **Login obligatorio.** Solo el administrador da de alta, desactiva y cambia contraseñas. Los operarios no pueden tocar su cuenta.
6. **Documentos según la aseguradora** — solo se habilitan los que corresponden:

   | Aseguradora del expediente | Documentos que se habilitan |
   |---|---|
   | **OCASO** | D6 — Recibido y conforme póliza (OCASO) |
   | **Preventiva Seguros** | D7 — Autorización Avantia **y** D8 — Autorización Preventiva |
   | Otra aseguradora o sin seguro | Ninguno de estos tres |

   Avantia es la gestora de Preventiva, por eso sus dos papeles van juntos. En el papel de Avantia, el campo "Aseguradora" se rellena con "Preventiva Seguros".

   El resto de documentos (D1 a D5) se habilitan siempre, salvo D4 (incineración), que solo se habilita si el destino es **incineración**.

## 6. Preguntas pendientes para tu padre

1. En el Registro Civil, ¿el "autorizado" que presenta el parte es siempre alguien de la funeraria? ¿Siguen usando este impreso en papel o ya va por vía electrónica?
2. ¿Hay más aseguradoras habituales aparte de OCASO y Preventiva? (Para tenerlas en la lista, aunque no lleven papel propio).
