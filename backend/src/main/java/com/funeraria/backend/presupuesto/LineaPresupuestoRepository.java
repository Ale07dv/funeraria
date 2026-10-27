package com.funeraria.backend.presupuesto;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface LineaPresupuestoRepository extends JpaRepository<LineaPresupuesto, Long> {
    List<LineaPresupuesto> findByExpedienteIdOrderByOrdenAsc(Long expedienteId);
}