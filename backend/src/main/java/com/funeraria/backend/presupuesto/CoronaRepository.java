package com.funeraria.backend.presupuesto;

import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface CoronaRepository extends JpaRepository<Corona, Long> {
    List<Corona> findByExpedienteId(Long expedienteId);
}