package com.funeraria.backend.presupuesto;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;

@Entity
@Table(name = "corona")
@Getter
@Setter
@NoArgsConstructor

public class Corona {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "expediente_id", nullable = false)
    private Long expedienteId;

    @Column(nullable = false, length = 255)
    private String texto;

    @Column(length = 100)
    private String proveedor;

    @Column(precision = 10, scale = 2)
    private BigDecimal importe;

}
