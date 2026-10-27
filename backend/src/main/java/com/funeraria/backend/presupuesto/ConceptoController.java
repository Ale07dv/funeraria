package com.funeraria.backend.presupuesto;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.i18n.FixedLocaleResolver;

import java.util.List;

@RestController
@RequestMapping("/api/conceptos")



public class ConceptoController {

    private final ConceptoRepository repo;

    public ConceptoController(ConceptoRepository repo) {
        this.repo = repo;
    }

    @GetMapping
    public List<Concepto> listar() {
        return repo.findByActivoTrueOrderByOrdenAsc();
    }

}
