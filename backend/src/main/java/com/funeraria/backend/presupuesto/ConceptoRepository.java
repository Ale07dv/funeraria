package com.funeraria.backend.presupuesto;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface ConceptoRepository extends JpaRepository<Concepto, Long> {
    List<Concepto> findByActivoTrueOrderByOrdenAsc();
}
