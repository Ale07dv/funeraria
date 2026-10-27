package com.funeraria.backend.presupuesto;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;

@Entity
@Table(name = "concepto")
@Getter
@Setter
@NoArgsConstructor

public class Concepto {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 100)
    private String nombre;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 15)
    private TipoConcepto tipo;

    @Column(name = "tipo_iva", nullable = false, precision = 4, scale = 2)
    private BigDecimal tipoIva;

    @Column(name = "precio_base", precision = 10, scale = 2)
    private BigDecimal precioBase;

    @Column(nullable = false)
    private Short orden;

    @Column(nullable = false)
    private Boolean activo;
}
