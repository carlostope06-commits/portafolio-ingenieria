# Exportación de los GRAFCET (SFC)

TwinCAT guarda los SFC como XML gráfico, que no se puede leer en GitHub. Este documento es una exportación **literal** de cada uno: declaración de variables, pasos con sus acciones (calificador IEC 61131-3 `N` = activa mientras el paso está activo), transiciones con su condición exacta, ramificaciones y saltos. Los diagramas y la explicación están en el [README del proyecto](../README.md#grafcet-uno-por-uno).

Leyenda: `PASO` = etapa · `── T:` = transición (receptividad) · `├─ RAMA ALTERNATIVA` = divergencia OR (gana la primera transición que se cumple, de izquierda a derecha) · `↪ SALTO` = salto a etapa · `[ENTRADA=…]` = acción ST ejecutada al entrar en la etapa.

---

## FB_EstacionDirector_SFC

Director: modos de la estación (reposo, restauración, preparación, producción, finalización).

<details><summary>Declaración de variables</summary>

```pascal
FUNCTION_BLOCK FB_EstacionDirector_SFC
VAR_IN_OUT
    ManiobrasPendientes: UINT;
END_VAR
VAR_INPUT
    // SFC-Flags
    SFCReset: BOOL;
    SFCPause: BOOL;

    // Indicadores de sincronizacion
    Execute: BOOL;
    Ack: BOOL := TRUE;

    // Entradas
    ManiobrasSolicitadas: UINT;

    SolicitudParada: BOOL;
      SolicitudRestauracion: BOOL;
    FinPreparacion: BOOL;
    FinProduccion: BOOL;
    FinFinalizacion: BOOL;
    FinCiclo: BOOL;
    FinRestauracion: BOOL;
END_VAR
VAR_OUTPUT
    // Indicadores de sincronizacion
    Ready: BOOL;
    Done: BOOL;

    // Salidas
     OrdenRestauracion:BOOL;
    OrdenPreparacion: BOOL;
    OrdenProduccion: BOOL;
    OrdenFinalizacion: BOOL;
    ParadaSolicitada: BOOL;
END_VAR
```

</details>

```text
PASO Initial [INICIAL]: N Ready   // Reposo
├─ RAMA ALTERNATIVA (Branch2)
  ├ rama 1:
      ── T: Execute
  ├ rama 2:
      ── T: SolicitudRestauracion
    PASO Step0: N OrdenRestauracion
      ── T: FinRestauracion
      ↪ SALTO a Initial
└─ fin rama
PASO S1: N OrdenPreparacion   // Preparación [ENTRADA=a_ManiobrasPendientes_Iniciar]
  ── T: FinPreparacion
PASO S2: N OrdenProduccion   // Producción
├─ RAMA ALTERNATIVA (Branch1)
  ├ rama 1:
      ── T: FinProduccion
    PASO S3: N OrdenFinalizacion   // Finalización
      ── T: FinFinalizacion
  ├ rama 2:
      ── T: SolicitudParada
    PASO S3a: N ParadaSolicitada
      ── T: FinCiclo
└─ fin rama
PASO End: N Done
  ── T: Ack
  ↪ SALTO a Initial
```

---

## FB_EstacionCoordinador_SFC

Coordinador: secuencia de un ciclo de producción y sincronización de tareas.

<details><summary>Declaración de variables</summary>

```pascal
FUNCTION_BLOCK FB_EstacionCoordinador_SFC
VAR_IN_OUT
    ManiobrasPendientes: UINT;
    ManiobrasRealizadas: UINT;
END_VAR
VAR_INPUT
    // SFC-Flags
    // SFC-Flags
    SFCReset: BOOL;
    SFCPause: BOOL;
    // Indicadores de sincronizacion
    Execute: BOOL;
    Ack: BOOL := TRUE;
    SolicitudMarcha :BOOL;

     Tiempo_rechazar      : TIME := T#1S;

    // Entradas
    RodamientoAlimentado: BOOL;
    FaltaMaterial: BOOL;
    RodamientoAceptado: BOOL;
    RodamientoRechazado:BOOL;
    RodamientoCargado: BOOL;
    CarroEvacuado: BOOL;
    CarroListo: BOOL;
    CarroNoListo:BOOL;
END_VAR
VAR_OUTPUT
    // Indicadores de sincronizacion
    Ready: BOOL;
    Done: BOOL;
    Done1: BOOL;
    Done2: BOOL;
    Done3: BOOL;
    // Salidas
    Alimentar: BOOL;
    Medir: BOOL;
    Descargar: BOOL;
    Carro:BOOL;
    FinCiclo: BOOL;

END_VAR
VAR
    //FinSecuencia: BOOL;// mirar que tiene que ver con fin cilclo

END_VAR
```

</details>

```text
PASO Init [INICIAL]: N Ready
  ── T: Execute
PASO Step0: N Alimentar; N Carro
├─ RAMA ALTERNATIVA (Branch1)
  ├ rama 1:
      ── T: RodamientoAlimentado
  ├ rama 2:
      ── T: FaltaMaterial
    PASO Step15: N Done2; N Carro
      ── T: SolicitudMarcha
      ↪ SALTO a Init
└─ fin rama
PASO Step1: N Medir; N Carro
├─ RAMA ALTERNATIVA (Branch0)
  ├ rama 1:
      ── T: RodamientoAceptado
    PASO Step16: N Carro
    ├─ RAMA ALTERNATIVA (Branch2)
      ├ rama 1:
          ── T: CarroListo
      ├ rama 2:
          ── T: CarroNoListo
        PASO Step17: N Done3; N Carro
          ── T: CarroListo
          ↪ SALTO a Step16
    └─ fin rama
    PASO Step4: N Descargar; N Carro
      ── T: RodamientoCargado
    PASO Step5: N Carro
      ── T: CarroEvacuado
    PASO Step13: N FinCiclo
      ── T: TRUE
    PASO Step12: N Done [ENTRADA=a_ManiobrasPendientes_Calcular]
      ── T: Ack
  ├ rama 2:
      ── T: RodamientoRechazado
    PASO Step2: N Done1
      ── T: Step2.t >= Tiempo_rechazar
      ↪ SALTO a Step0
└─ fin rama
  ↪ SALTO a Init
```

---

## FB_Alimentar_SFC

Tarea Alimentar: extraer un rodamiento del almacén y llevarlo al medidor.

<details><summary>Declaración de variables</summary>

```pascal
FUNCTION_BLOCK FB_Alimentar_SFC
VAR_INPUT

        // SFC-Flags
    Tiempo_alimentar    : TIME := T#2S;
    SFCReset: BOOL;
    SFCPause: BOOL;
    //Indicadores sincronizacion
    Execute: BOOL;
    Ack: BOOL:= TRUE;
    //Entradas
    AlimentadorDelante: BOOL;
    PresenciaRodamiento: BOOL;
    CargadorDetras: BOOL;
    CargadorMedio: BOOL;
    CargadorDelante: BOOL;

END_VAR
VAR_OUTPUT
    //Indicadores de sincronizacion
    Ready: BOOL;
    Done: BOOL;
    Done1: BOOL;

END_VAR
VAR

//Salida

    AlimentadorAvanza: BOOL;
    CargadorAvanza: BOOL;
    CargadorRetrocede: BOOL;
    CargadorAbre: BOOL;

END_VAR
```

</details>

```text
PASO Init [INICIAL]: N Ready
  ── T: Execute
PASO Step0: N AlimentadorAvanza; N CargadorAvanza
├─ RAMA ALTERNATIVA (Branch0)
  ├ rama 1:
      ── T: AlimentadorDelante AND PresenciaRodamiento AND CargadorDelante AND Step0.t >= Tiempo_alimentar
    PASO Step3: N CargadorAbre; N CargadorRetrocede
      ── T: CargadorDetras
    PASO Step5: N CargadorAvanza
      ── T: CargadorMedio
  ├ rama 2:
      ── T: AlimentadorDelante AND NOT Presenciarodamiento AND Step0.t >= Tiempo_alimentar
    PASO Step4: N CargadorRetrocede
      ── T: CargadorMedio
    PASO End1: N Done1
      ── T: Ack
      ↪ SALTO a Init
└─ fin rama
PASO End: N Done
  ── T: Ack
  ↪ SALTO a Init
```

---

## FB_Medir_SFC

Tarea Medir: medir el grosor con el palpador analógico y aceptar o rechazar.

<details><summary>Declaración de variables</summary>

```pascal
FUNCTION_BLOCK FB_Medir_SFC
VAR_INPUT
        // SFC-Flags
    SFCReset: BOOL;
    SFCPause: BOOL;
    //Indicadores sincronizacion
    Execute: BOOL;

    Ack: BOOL:= TRUE;
    Tiempo_Piston: TIME := T#500MS;
    Tiempo_Descartador: TIME := T#1S;
    //Entradas
    MedidorAbajo: BOOL;
    MedidorArriba: BOOL;
    MedidorValor: INT ;
    Ancha: BOOL;
    Estrecha:BOOL;

END_VAR
VAR_OUTPUT
        //Indicadores de sincronizacion
    Ready: BOOL;
    Done: BOOL;
    Done1:BOOL;
END_VAR
VAR

//Salidas
   MedidorSube: BOOL;
   MedidorBaja: BOOL;
   RechazadorAvanza: BOOL;
   CentradorBaja: BOOL;

END_VAR
```

</details>

```text
PASO Init [INICIAL]: N Ready
  ── T: Execute
PASO Step0: N MedidorSube
├─ RAMA ALTERNATIVA (Branch0)
  ├ rama 1:
      ── T: MedidorArriba AND((Estrecha AND MedidorValor < 10000) OR Ancha)
    PASO Step1: N MedidorBaja
      ── T: MedidorAbajo
    PASO End: N Done
      ── T: Ack
  ├ rama 2:
      ── T: MedidorArriba AND((Ancha AND MedidorValor < 10000) OR Estrecha)
    PASO Step2: N CentradorBaja; N MedidorBaja
      ── T: MedidorAbajo
    PASO Paso3: N CentradorBaja; N RechazadorAvanza
      ── T: Paso3.t >= Tiempo_Piston
    PASO Step4: N CentradorBaja
      ── T: Step4.t >= Tiempo_Descartador
    PASO End1: N Done1
      ── T: Ack
      ↪ SALTO a Init
└─ fin rama
  ↪ SALTO a Init
```

---

## FB_Descargar_SFC

Tarea Descargar: trasladar el rodamiento aceptado al palé.

<details><summary>Declaración de variables</summary>

```pascal
FUNCTION_BLOCK FB_Descargar_SFC
VAR_INPUT
        // SFC-Flags
    SFCReset: BOOL;
    SFCPause: BOOL;
        //Indicadores sincronizacion
    Execute: BOOL;

    Ack: BOOL:= TRUE;
     Tiempo_descargador    : TIME := T#500MS;
     //Entradas
    DescargadorArriba: BOOL;
    DescargadorAbajo: BOOL;
    DescargadorDetras: BOOL;
    DescargadorDelante: BOOL;
END_VAR
VAR_OUTPUT
        //Indicadores de sincronizacion
    Ready: BOOL;
    Done: BOOL;
END_VAR
VAR

    //Salidas

    DescargadorBaja: BOOL;
    DescargadorAvanza: BOOL;
    DescargadorAbre: BOOL;
    ElevadorSube: BOOL;

END_VAR
```

</details>

```text
PASO Init [INICIAL]: N Ready
  ── T: Execute
PASO Step0: N DescargadorAvanza
  ── T: DescargadorDelante
PASO Step1: N DescargadorAvanza; N DescargadorBaja
  ── T: DescargadorAbajo
PASO Step2: N DescargadorAvanza; N DescargadorAbre; N DescargadorBaja
  ── T: Step2.t >= Tiempo_descargador
PASO Step4: N DescargadorAbre
  ── T: DescargadorDetras
PASO Step5: N DescargadorAbre; N DescargadorBaja; N ElevadorSube
  ── T: DescargadorAbajo
PASO End: N Done
  ── T: Ack
  ↪ SALTO a Init
```

---

## FB_Carro_SFC

Tarea Carro: gestión de la cinta, identificación y evacuación del palé.

<details><summary>Declaración de variables</summary>

```pascal
FUNCTION_BLOCK FB_Carro_SFC
VAR_INPUT
        // SFC-Flags
    SFCReset: BOOL;
    SFCPause: BOOL;
        //Indicadores sincronizacion
    Execute: BOOL;
    Ack1: BOOL;
    Ack: BOOL:= TRUE;
     Tiempo_evacuar    : TIME := T#2S;
     Tiempo_carro      : TIME := T#3S;
     //Entradas
    PresenciaPale: BOOL;
    CodigoPaleBit0: BOOL;
    CodigoPaleBit1: BOOL;
    CodigoPaleBit2: BOOL;
END_VAR
VAR_OUTPUT
        //Indicadores de sincronizacion
    Ready: BOOL;
    Done: BOOL;
    Done1: BOOL;
    CarroPreparado:BOOL;

END_VAR
VAR

    //Salidas
    CintaActiva: BOOL;
    RetenedorBaja: BOOL;

END_VAR
```

</details>

```text
PASO Init [INICIAL]: N Ready
  ── T: Execute
PASO Step0: N CintaActiva
├─ RAMA ALTERNATIVA (Branch0)
  ├ rama 1:
      ── T: CodigoPaleBit1 OR CodigoPaleBit0 OR CodigoPaleBit2
  ├ rama 2:
      ── T: Step0.t >= Tiempo_carro
    PASO Step3: N Done1
      ── T: Ack1
      ↪ SALTO a Init
└─ fin rama
PASO Step1: N CarroPreparado
  ── T: NOT PresenciaPale
PASO Step2: N CintaActiva; N RetenedorBaja
  ── T: Step2.t >= Tiempo_evacuar
PASO End: N Done
  ── T: Ack
  ↪ SALTO a Init
```

---

## FB_EstacionRestaurar_SFC

Restaurar: devolver los actuadores a la condición inicial.

<details><summary>Declaración de variables</summary>

```pascal
FUNCTION_BLOCK FB_EstacionRestaurar_SFC
VAR_INPUT
    //Indicadores sincronizacion
        // SFC-Flags
    SFCReset: BOOL;
    SFCPause: BOOL;
    //Indicadores de sincronizacion
    Execute: BOOL;
    Ack: BOOL:= TRUE;
    //Entradas
    CargadorDetras: BOOL;
    CargadorDelante: BOOL;
    CargadorMedio: BOOL;
    MedidorAbajo: BOOL;

END_VAR

VAR_OUTPUT

    //Indicadores de sincronizacion
    Ready: BOOL;
    Done: BOOL;

    //Salidas
     CargadorAvanza: BOOL;
    MedidorBaja: BOOL;
    CargadorRetrocede: BOOL;

END_VAR
```

</details>

```text
PASO Init [INICIAL]: N Ready
  ── T: Execute
PASO Step4: N CargadorAvanza
  ── T: CargadorMedio OR CargadorDelante
PASO Step5: N CargadorRetrocede; N MedidorBaja
  ── T: CargadorMedio
PASO Step6: N MedidorBaja
  ── T: MedidorAbajo
PASO Step18: N Done
  ── T: Ack
  ↪ SALTO a Init
```

---

## FB_EstacionPreparar_SFC

Preparar: aviso sonoro previo al arranque.

<details><summary>Declaración de variables</summary>

```pascal
FUNCTION_BLOCK FB_EstacionPreparar_SFC
VAR_INPUT
    // SFC-Flags
    SFCReset: BOOL;
    SFCPause: BOOL;

    // Indicadores de sincronizacion
    Execute: BOOL;
    Ack: BOOL := TRUE;

    // Parametros
    TiempoPreparacion: TIME := T#3S;
END_VAR
VAR_OUTPUT
    // Indicadores de sincronizacion
    Ready: BOOL;
    Done: BOOL;

    // Salidas
    AvisadorSonoro: BOOL;
END_VAR
```

</details>

```text
PASO Initial [INICIAL]: N Ready
  ── T: Execute
PASO S1: N AvisadorSonoro
  ── T: S1.t > TiempoPreparacion
PASO End: N Done
  ── T: Ack
  ↪ SALTO a Initial
```

---

## FB_EstacionFinalizar_SFC

Finalizar: aviso sonoro de fin de lote.

<details><summary>Declaración de variables</summary>

```pascal
FUNCTION_BLOCK FB_EstacionFinalizar_SFC
VAR_INPUT
    // SFC-Flags
    SFCReset: BOOL;
    SFCPause: BOOL;

    // Indicadores de sincronizacion
    Execute: BOOL;
    Ack: BOOL := TRUE;

    // Parametros
    TiempoFinalizacion: TIME := T#1S;
END_VAR
VAR_OUTPUT
    // Indicadores de sincronizacion
    Ready: BOOL;
    Done: BOOL;

    // Salidas
    AvisadorSonoro: BOOL;
END_VAR
```

</details>

```text
PASO Initial [INICIAL]: N Ready
  ── T: Execute
PASO S1: N AvisadorSonoro
  ── T: S1.t > TiempoFinalizacion
PASO End: N Done
  ── T: Ack
  ↪ SALTO a Initial
```

---

## Acciones en ST asociadas a etapas

```pascal
// ---- FB_EstacionDirector_SFC.a_ManiobrasPendientes_Iniciar ----
IF ManiobrasPendientes = 0 THEN
    ManiobrasPendientes := ManiobrasSolicitadas;
END_IF;

// ---- FB_EstacionCoordinador_SFC.a_ManiobrasPendientes_Calcular ----
ManiobrasRealizadas := ManiobrasRealizadas + 1;

IF ManiobrasPendientes > 0 THEN
    ManiobrasPendientes := ManiobrasPendientes - 1;
END_IF;
```
