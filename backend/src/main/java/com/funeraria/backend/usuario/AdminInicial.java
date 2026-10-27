package com.funeraria.backend.usuario;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

/**
 * Al arrancar la app: si no existe ningún ADMIN, lo crea con los datos de
 * application.properties (app.admin.*). Solo ocurre la primera vez.
 */
@Component
public class AdminInicial implements ApplicationRunner {

    private static final Logger log = LoggerFactory.getLogger(AdminInicial.class);

    private final UsuarioRepository usuarios;
    private final PasswordEncoder passwordEncoder;
    private final String username;
    private final String password;
    private final String nombre;
    private final String apellidos;

    public AdminInicial(UsuarioRepository usuarios,
                        PasswordEncoder passwordEncoder,
                        @Value("${app.admin.username}") String username,
                        @Value("${app.admin.password}") String password,
                        @Value("${app.admin.nombre}") String nombre,
                        @Value("${app.admin.apellidos}") String apellidos) {
        this.usuarios = usuarios;
        this.passwordEncoder = passwordEncoder;
        this.username = username;
        this.password = password;
        this.nombre = nombre;
        this.apellidos = apellidos;
    }

    @Override
    public void run(ApplicationArguments args) {
        if (usuarios.existsByRol(Rol.ADMIN)) {
            return;
        }

        Usuario admin = new Usuario();
        admin.setUsername(username.trim().toLowerCase());
        admin.setPasswordHash(passwordEncoder.encode(password));
        admin.setRol(Rol.ADMIN);
        admin.setNombre(nombre);
        admin.setApellidos(apellidos);
        usuarios.save(admin);

        log.warn("Creado el usuario administrador '{}'. Cambia su contraseña cuanto antes.", admin.getUsername());
    }
}
