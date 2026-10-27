package com.funeraria.backend.usuario;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

/**
 * Acceso a la tabla "usuario". Spring genera las consultas a partir del nombre del método.
 */
public interface UsuarioRepository extends JpaRepository<Usuario, Long> {

    Optional<Usuario> findByUsername(String username);

    boolean existsByUsername(String username);

    boolean existsByRol(Rol rol);

    List<Usuario> findByActivoTrueOrderByNombreAsc();
}
