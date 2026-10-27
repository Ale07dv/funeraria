package com.funeraria.backend.seguridad;

import com.funeraria.backend.usuario.Rol;
import com.funeraria.backend.usuario.Usuario;
import com.funeraria.backend.usuario.UsuarioRepository;
import jakarta.validation.Valid;
import jakarta.validation.constraints.NotBlank;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import java.time.Instant;

/**
 * POST /api/auth/login → comprueba usuario y contraseña y devuelve un token.
 * GET  /api/auth/yo    → devuelve quién es el usuario del token (para Angular).
 */
@RestController
@RequestMapping("/api/auth")
public class AuthController {

    private final UsuarioRepository usuarios;
    private final PasswordEncoder passwordEncoder;
    private final TokenService tokenService;

    public AuthController(UsuarioRepository usuarios,
                          PasswordEncoder passwordEncoder,
                          TokenService tokenService) {
        this.usuarios = usuarios;
        this.passwordEncoder = passwordEncoder;
        this.tokenService = tokenService;
    }

    @PostMapping("/login")
    public LoginResponse login(@Valid @RequestBody LoginRequest peticion) {
        Usuario usuario = usuarios.findByUsername(peticion.username().trim().toLowerCase())
                .filter(Usuario::isActivo)
                .filter(u -> passwordEncoder.matches(peticion.password(), u.getPasswordHash()))
                // Mismo mensaje en todos los casos: no damos pistas de qué ha fallado
                .orElseThrow(() -> new ResponseStatusException(
                        HttpStatus.UNAUTHORIZED, "Usuario o contraseña incorrectos"));

        TokenService.TokenGenerado token = tokenService.generar(usuario);

        return new LoginResponse(
                token.token(),
                token.expiraEn(),
                usuario.getUsername(),
                usuario.getNombreCompleto(),
                usuario.getRol());
    }

    @GetMapping("/yo")
    public UsuarioActual yo(@AuthenticationPrincipal Jwt jwt) {
        return new UsuarioActual(
                jwt.getSubject(),
                jwt.getClaimAsString("nombre"),
                jwt.getClaimAsString("rol"));
    }

    // ---- Lo que entra y sale por la API ----

    public record LoginRequest(
            @NotBlank String username,
            @NotBlank String password) {}

    public record LoginResponse(
            String token,
            Instant expiraEn,
            String username,
            String nombre,
            Rol rol) {}

    public record UsuarioActual(
            String username,
            String nombre,
            String rol) {}
}
