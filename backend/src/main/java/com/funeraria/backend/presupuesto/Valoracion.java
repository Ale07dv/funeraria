package com.funeraria.backend.presupuesto;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDate;

@Entity
@Table(name = "valoracion")
@Getter
@Setter
@NoArgsConstructor

public class Valoracion {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "expediente_id", nullable = false, unique = true)
    private Long expedienteId;

    // 1 = Mal, 2 = Regular, 3 = Bien, 4 = Muy bien
    private Short puntualidad;

    @Column(name = "trato_personal")
    private Short tratoPersonal;

    private Short profesionalidad;

    private Short asesoramiento;

    @Column(columnDefinition = "text")
    private String observaciones;

    @Column(nullable = false)
    private LocalDate fecha = LocalDate.now();
}
