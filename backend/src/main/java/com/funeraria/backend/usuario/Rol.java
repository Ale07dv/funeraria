package com.funeraria.backend.usuario;

/**
 * Roles de la aplicación.
 * ADMIN    → gestiona usuarios (alta, baja, contraseñas) y todo lo demás.
 * OPERARIO → trabaja con expedientes y presupuestos; no toca cuentas.
 */
public enum Rol {
    ADMIN,
    OPERARIO
}
