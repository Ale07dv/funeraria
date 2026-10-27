package com.funeraria.backend.usuario;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDateTime;

/**
 * Usuario de la aplicación (tabla "usuario" de V1__esquema_inicial.sql).
 * Cada operario es un usuario; el que hace un servicio queda asignado al expediente.
 */
@Entity
@Table(name = "usuario")
@Getter
@Setter
@NoArgsConstructor
public class Usuario {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true, length = 50)
    private String username;

    /** Contraseña cifrada con BCrypt. Nunca se guarda ni se devuelve en claro. */
    @Column(name = "password_hash", nullable = false, length = 100)
    private String passwordHash;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 10)
    private Rol rol;

    @Column(nullable = false, length = 100)
    private String nombre;

    @Column(nullable = false, length = 150)
    private String apellidos;

    @Column(unique = true, length = 15)
    private String dni;

    private String domicilio;

    /** Último número de servicio de este operario (para tnts_usuario_N_fecha). */
    @Column(name = "contador_servicios", nullable = false)
    private int contadorServicios = 0;

    /** "Borrar" un usuario = desactivarlo, para no perder el historial. */
    @Column(nullable = false)
    private boolean activo = true;

    @Column(name = "creado_en", nullable = false, updatable = false)
    private LocalDateTime creadoEn;

    @PrePersist
    void alCrear() {
        creadoEn = LocalDateTime.now();
    }

    /** Nombre completo, útil para los documentos ("Don ..."). */
    public String getNombreCompleto() {
        return nombre + " " + apellidos;
    }
}
