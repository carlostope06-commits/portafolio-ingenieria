# Laboratorio de electrónica analógica y circuitos

**Asignaturas:** Fundamentos de Electrónica y Teoría de Circuitos · Grado en Ingeniería Electrónica, Robótica y Mecatrónica (UMA), curso 2025-26 · Prácticas en pareja
**Instrumentación y software:** multímetro, osciloscopio, generador de señal, Digilent Analog Discovery + WaveForms, simulación SPICE (Bias Point, Time Domain, AC Sweep)

Resumen de las prácticas de laboratorio en las que diseñé, monté, medí y comparé circuitos con simulación. En todas se sigue el mismo método: **cálculo teórico → simulación → montaje → medida → análisis de la dispersión**.

## Fundamentos de Electrónica

| # | Práctica | Lo más destacado |
|---|---|---|
| 1 | **Instrumentación básica** | Divisor de tensión (R1 = 557 Ω, R2 = 1173 Ω): V_R1 = 3,22 V, V_R2 = 6,80 V; la suma (10,02 V) cumple la 2ª ley de Kirchhoff. Caracterización con osciloscopio de señales senoidales, triangulares y cuadradas de 100 Hz a 10 kHz |
| 2 | **Simulación de circuitos DC + AC** | Red con fuentes de continua, alterna y de corriente, y condensadores. *Bias Point* (en continua el condensador es un circuito abierto), *Time Domain* (amplitud en el nodo D = 7,51 V; desfase calculado a partir del retardo medido, ≈ 20º) y *AC Sweep* de 1 Hz a 100 MHz |
| 3 | **Medida de impedancias** | Barrido en frecuencia de una impedancia: parte real (de 1,99 kΩ a 10 Hz a 897 Ω a 91 kHz) e imaginaria, módulo y fase, factor de calidad (máx. ≈ 0,4 a 3 kHz) y diagrama de Nyquist |
| 4 | **Diodos** | Curvas de transferencia y características I-V del diodo Zener 1N4728 y del LED HLMP-3401. El LED necesita una tensión de despegue de ≈ 1,8-2,2 V, frente a los ≈ 0,6-0,7 V de un diodo de silicio |
| 5 | **Amplificador con transistor BJT** | Red de polarización: zona activa verificada (V_BE = 0,78 V), con una dispersión frente al simulador de **< 3,3 %** en las tensiones de base, colector y emisor. Amplificador: A_v ≈ 0,75 medida frente a 0,906 simulada; Z_out = 3,5 Ω frente a 2,77 Ω. **Análisis de la discrepancia** por la dependencia de r_e con la corriente de emisor, la tolerancia de las resistencias y la impedancia del generador |
| 6 | **Amplificador operacional** | Inversor: A_v = 2,21 (teórica 2,2; dispersión 0,45 %), offset de 10,03 mV dentro de los márgenes calculados, ancho de banda ≈ 128 kHz y THD de 0,13-0,84 %. No inversor: A_v = 3,18 (teórica 3,2; 0,63 %), ancho de banda ≈ 50 kHz. Diferencial: ganancias en modo común y en modo diferencial, y CMRR |

## Teoría de Circuitos

| # | Práctica | Contenido |
|---|---|---|
| 1-2 | **Medidas eléctricas** | Código de colores y tolerancias; resistencias equivalentes serie/paralelo, divisores, comparación teórica frente a medida (p. ej., R_eq = 1010 Ω teórica frente a 993 Ω medida) |
| 3 | **Corriente alterna y factor de potencia** | Potencia activa, reactiva y aparente de una carga RL (P = 40 W, S = 115 VA, Q = 107,8 var, fp = 0,348 inductivo) y reparto de potencias entre elementos |
| 4 | **Circuitos trifásicos** | Lámparas incandescentes como cargas de un sistema trifásico: magnitudes nominales y efecto de la tensión de alimentación sobre la potencia (lámpara de 100 W a 230 V → 75,6 W a 200 V) |

## Competencias que demuestran

- Manejo de la instrumentación de laboratorio y de la Analog Discovery/WaveForms.
- Simulación SPICE como herramienta de diseño y verificación.
- Análisis crítico de resultados: cuantificar la dispersión entre teoría, simulación y medida, y explicar sus causas físicas.
- Electrónica analógica básica: polarización, amplificadores con BJT y con AO, respuesta en frecuencia y distorsión.

> Las hojas de resultados originales (PDF con fotos de los montajes y capturas de WaveForms) no se publican en el repositorio porque contienen datos personales.
