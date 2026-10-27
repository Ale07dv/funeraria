package com.funeraria.backend.presupuesto;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;

@Entity
@Table(name = "linea_presupuesto")
@Getter
@Setter
@NoArgsConstructor

public class LineaPresupuesto {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "expediente_id", nullable = false)
    private Long expedienteId;

    @Column(name = "concepto_id")
    private Long conceptoId;   // null si es una fila libre

    @Column(nullable = false, length = 200)
    private String descripcion;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 15)
    private TipoConcepto tipo;

    @Column(name = "tipo_iva", nullable = false, precision = 4, scale = 2)
    private BigDecimal tipoIva;

    @Column(nullable = false, precision = 10, scale = 2)
    private BigDecimal importe;   // base imponible, sin IVA

    @Column(nullable = false)
    private Short orden;
}