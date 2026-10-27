package com.funeraria.backend.seguridad;

import com.funeraria.backend.usuario.Usuario;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.oauth2.jose.jws.MacAlgorithm;
import org.springframework.security.oauth2.jwt.JwsHeader;
import org.springframework.security.oauth2.jwt.JwtClaimsSet;
import org.springframework.security.oauth2.jwt.JwtEncoder;
import org.springframework.security.oauth2.jwt.JwtEncoderParameters;
import org.springframework.stereotype.Service;

import java.time.Instant;
import java.time.temporal.ChronoUnit;

/**
 * Genera el token (JWT) que recibe el usuario al hacer login.
 * El token lleva dentro: usuario, rol, nombre y cuándo caduca.
 */
@Service
public class TokenService {

    private final JwtEncoder encoder;
    private final long horasValidez;

    public TokenService(JwtEncoder encoder,
                        @Value("${app.jwt.expiracion-horas}") long horasValidez) {
        this.encoder = encoder;
        this.horasValidez = horasValidez;
    }

    public TokenGenerado generar(Usuario usuario) {
        Instant ahora = Instant.now();
        Instant expira = ahora.plus(horasValidez, ChronoUnit.HOURS);

        JwtClaimsSet claims = JwtClaimsSet.builder()
                .issuer("fuascen")
                .issuedAt(ahora)
                .expiresAt(expira)
                .subject(usuario.getUsername())
                .claim("uid", usuario.getId())
                .claim("rol", usuario.getRol().name())
                .claim("nombre", usuario.getNombreCompleto())
                .build();

        JwsHeader cabecera = JwsHeader.with(MacAlgorithm.HS256).build();
        String token = encoder.encode(JwtEncoderParameters.from(cabecera, claims)).getTokenValue();

        return new TokenGenerado(token, expira);
    }

    public record TokenGenerado(String token, Instant expiraEn) {}
}
