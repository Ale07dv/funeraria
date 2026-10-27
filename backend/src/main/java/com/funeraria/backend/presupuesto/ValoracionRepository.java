package com.funeraria.backend.presupuesto;

import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;

public interface ValoracionRepository extends JpaRepository<Valoracion, Long> {
    Optional<Valoracion> findByExpedienteId(Long expedienteId);
}
