// =====================================================================
// FB_Estacion: bloque principal de la estación FMS-202 (TwinCAT 3, ST)
// Exportado del proyecto AIM_TC3_G07 sin modificar el código
// =====================================================================

FUNCTION_BLOCK FB_Estacion
VAR_INPUT


	 //Parametros de Control
	 ReiniciaEstado: BOOL;
	 ManiobrasSolicitadas: UINT :=1;
	PausaEstado: BOOL;
	ProduccionPorLotes: BOOL;
	PausaTrasCiclo: BOOL;
	//Tiempos
	Tiempo_alimentar    : TIME := T#2S;
	Tiempo_rechazar      : TIME := T#1S;
	Tiempo_evacuar    : TIME := T#2S;
 	Tiempo_carro      : TIME := T#3S;
	Tiempo_descargador    : TIME := T#500MS;
	Tiempo_Piston: TIME := T#500MS;
	Tiempo_Descartador: TIME := T#1S;
	TiempoPreparacion: TIME := T#3S;
	TiempoFinalizacion: TIME := T#1S;
END_VAR

VAR_OUTPUT
    //Estado de la Estación


	//Estado de la tarea
	ManiobrasPendientes : UINT;
	ManiobrasRealizadas: UINT;
	//Estado del Sistema
	CondicionInicial: BOOL;
	CondicionMarcha:  BOOL;

     //########seleccion anchas, estrechas tiene pinta no funcionara
	Ancha: BOOL;
	Estrecha:BOOL;
	Medidormm:INT;

END_VAR

VAR


	SistemaEnReposo: BOOL;
	SistemaEnEspera: BOOL;
	SistemaEnMarcha: BOOL;


// Utilidades generales
    FlancoPulsadorMarcha: R_TRIG;
    FlancoPulsadorParada: R_TRIG;
    Intermitencia: FB_Blink;






    //ENTRADAS DIGITALES (Módulos EL1008)
    i_PulsadorEmergencia   AT %I* : BOOL;
    i_SelectorManual       AT %I* : BOOL;
    i_PulsadorMarcha       AT %I* : BOOL;
    i_PulsadorParada       AT %I* : BOOL;
    i_EstacionConectada    AT %I* : BOOL;
    i_PresenciaPale        AT %I* : BOOL;
    i_CodigoPaleBit0       AT %I* : BOOL;
    i_CodigoPaleBit1       AT %I* : BOOL;
    i_CodigoPaleBit2       AT %I* : BOOL;

    i_AlimentadorDelante   AT %I* : BOOL;
    i_CargadorDetras       AT %I* : BOOL;
    i_CargadorMedio        AT %I* : BOOL;
    i_CargadorDelante      AT %I* : BOOL;
    i_MedidorAbajo         AT %I* : BOOL;
    i_MedidorArriba        AT %I* : BOOL;
    i_DescargadorArriba    AT %I* : BOOL;
    i_DescargadorAbajo     AT %I* : BOOL;
    i_DescargadorDetras    AT %I* : BOOL;
    i_DescargadorDelante   AT %I* : BOOL;
    i_PresenciaRodamiento  AT %I* : BOOL;

    //ENTRADA ANALÓGICA (Módulo EL3061)
    i_MedidorValor         AT %I* : INT ;

    //SALIDAS DIGITALES (Módulos EL2008)
    o_DesconectaEstacion   AT %Q* : BOOL;
    o_LamparaAlarma        AT %Q* : BOOL;
    o_LamparaMarcha        AT %Q* : BOOL;
    o_LamparaMaterial      AT %Q* : BOOL;
    o_CintaActiva          AT %Q* : BOOL;
    o_CintaInvierte        AT %Q* : BOOL;
    o_RetenedorBaja        AT %Q* : BOOL;
    o_SeparadorSube        AT %Q* : BOOL;
    o_AvisadorSonoro       AT %Q* : BOOL;

    o_AlimentadorAvanza    AT %Q* : BOOL;
    o_CargadorAvanza       AT %Q* : BOOL;
    o_CargadorRetrocede    AT %Q* : BOOL;
    o_CargadorAbre         AT %Q* : BOOL;
    o_MedidorSube          AT %Q* : BOOL;
    o_MedidorBaja          AT %Q* : BOOL;
    o_RechazadorAvanza     AT %Q* : BOOL;
    o_CentradorBaja        AT %Q* : BOOL;
    o_DescargadorBaja      AT %Q* : BOOL;
    o_DescargadorAvanza    AT %Q* : BOOL;
    o_DescargadorAbre      AT %Q* : BOOL;
    o_ElevadorSube         AT %Q* : BOOL;




	OrdenPausa: BOOL;
	ModoAutomatico:BOOL;
	SolicitudMarcha: BOOL;
	SolicitudParada: BOOL;
	SolicitudProduccion: BOOL;
	SolicitudRestauracion:BOOL;
	DemandaProduccion: BOOL;
	MarchaAutorizada: BOOL;
	ContinuacionAutorizada: BOOL;
	TareaFinalizada: BOOL;
	ParadaSolicitada: BOOL;
	stopvisus: BOOL;
	marchavisus: BOOL;
	Emergenciavisus: BOOL;

	Director: FB_EstacionDirector_SFC;
	Coordinador: FB_EstacionCoordinador_SFC;
	Alimentar: FB_Alimentar_SFC;
    Medir: FB_Medir_SFC;
    Descargar: FB_Descargar_SFC;
	Carro: FB_Carro_SFC;
	Restaurar: FB_EstacionRestaurar_SFC;
	Preparar: FB_EstacionPreparar_SFC;
	Finalizar: FB_EstacionFinalizar_SFC;

END_VAR

// ---------------- Cuerpo ----------------
m_GestorEntradas(); // Acondicionamiento de señales
m_GestorModo(); // Toma de decisiones de nivel superior

// Ejecución de la lógica de control en modo automático
IF ModoAutomatico THEN
    m_GestorTareas(); // Procesamiento del estado
    m_GestorPanel(); // Gestión de la señalización
    m_GestorAcciones(); // Procesamiento de las acciones
END_IF;
END_FUNCTION_BLOCK


// ---------------- Method: m_GestorAcciones ----------------
METHOD PRIVATE m_GestorAcciones
  o_DesconectaEstacion:= FALSE;
  o_CintaActiva:= NOT OrdenPausa AND (Carro.CintaActiva);
  //o_CintaInvierte:= NOT OrdenPausa AND (); No se usa en modo automático.
  o_RetenedorBaja:=Carro.RetenedorBaja;
//    o_SeparadorSube:=  ESTA ROTO.
  o_AlimentadorAvanza:= Alimentar.AlimentadorAvanza;
    o_CargadorAvanza:= NOT OrdenPausa AND (Alimentar.CargadorAvanza OR Restaurar.CargadorAvanza);
  o_CargadorRetrocede:= NOT OrdenPausa AND (Alimentar.CargadorRetrocede OR Restaurar.CargadorRetrocede);
    o_CargadorAbre:= Alimentar.CargadorAbre;
    o_MedidorSube:= NOT OrdenPausa AND (Medir.MedidorSube);
     o_MedidorBaja:= NOT OrdenPausa AND (Medir.MedidorBaja OR Restaurar.MedidorBaja);
    o_RechazadorAvanza:=  Medir.RechazadorAvanza;
   o_CentradorBaja:= Medir.CentradorBaja;
   o_DescargadorBaja:= Descargar.DescargadorBaja;
    o_DescargadorAvanza:= Descargar.DescargadorAvanza;
  o_DescargadorAbre:= Descargar.DescargadorAbre;
   o_ElevadorSube:= Descargar.ElevadorSube;
   
END_METHOD


// ---------------- Method: m_GestorEntradas ----------------
METHOD PRIVATE m_GestorEntradas
OrdenPausa :=  (NOT ReiniciaEstado AND PausaEstado);
PausaEstado := i_PulsadorEmergencia OR Emergenciavisus;
// Procesamiento de las entradas
FlancoPulsadorMarcha(CLK := i_PulsadorMarcha);
FlancoPulsadorParada(CLK := NOT i_PulsadorParada);
ModoAutomatico := NOT i_SelectorManual;

SolicitudMarcha := FlancoPulsadorMarcha.Q  OR marchavisus;
SolicitudParada := FlancoPulsadorParada.Q OR stopvisus;

CondicionInicial := i_EstacionConectada
AND i_CargadorMedio
AND i_MedidorAbajo;


Medidormm := i_MedidorValor/1000;
END_METHOD


// ---------------- Method: m_GestorModo ----------------
METHOD PRIVATE m_GestorModo
DemandaProduccion :=  (NOT ProduccionPorLotes OR (ManiobrasSolicitadas > 0) AND (Ancha OR Estrecha));
//CondicionMarcha := DemandaProduccion;
//not produccion por lotes = modo continuo
SolicitudProduccion := CondicionInicial AND DemandaProduccion AND SolicitudMarcha;
SolicitudRestauracion := NOT CondicionInicial AND SolicitudMarcha;

TareaFinalizada := ProduccionPorLotes AND (ManiobrasPendientes = 0);

Director(
    ManiobrasSolicitadas := ManiobrasSolicitadas,
    ManiobrasPendientes := ManiobrasPendientes,
    SFCReset := ReiniciaEstado,
    Execute := SolicitudProduccion,
    Ack := TRUE,
    SolicitudRestauracion := SolicitudRestauracion,
    SolicitudParada := SolicitudParada,
    FinRestauracion := Restaurar.Done,
    FinPreparacion := Preparar.Done,
    FinProduccion := TareaFinalizada,
    FinFinalizacion := Finalizar.Done,
    FinCiclo := Coordinador.Done
);
END_METHOD


// ---------------- Method: m_GestorPanel ----------------
METHOD PRIVATE m_GestorPanel
Intermitencia(Enable := TRUE);

MarchaAutorizada := CondicionInicial AND DemandaProduccion;

SistemaEnEspera := SistemaEnReposo
    OR Coordinador.Done
    OR Coordinador.Done3
	OR Coordinador.Done2;



;
SistemaEnMarcha := Director.OrdenProduccion
    AND NOT SistemaEnEspera;

o_AvisadorSonoro := Finalizar.AvisadorSonoro
    OR ((Preparar.AvisadorSonoro  OR Coordinador.Done1 OR Coordinador.Done2 OR Coordinador.Done3)
        AND Intermitencia.Q);

o_LamparaAlarma := ((SistemaEnReposo AND NOT MarchaAutorizada AND Intermitencia.Q)OR Director.OrdenRestauracion
	OR  SolicitudParada ) AND ( Intermitencia.Q);

o_LamparaMarcha := i_EstacionConectada
    AND (SistemaEnMarcha OR (SistemaEnEspera AND Intermitencia.Q));


o_LamparaMaterial := (Coordinador.Done2 OR Coordinador.Done3) AND Intermitencia.Q;
END_METHOD


// ---------------- Method: m_GestorTareas ----------------
METHOD PRIVATE m_GestorTareas
Coordinador(
	ManiobrasPendientes := ManiobrasPendientes,
	ManiobrasRealizadas := ManiobrasRealizadas,
	SFCReset := ReiniciaEstado,
  	SFCPause := OrdenPausa,
   	Execute := Director.OrdenProduccion,
   	Ack := ContinuacionAutorizada,
   	RodamientoAlimentado := Alimentar.Done,
   SolicitudMarcha := SolicitudMarcha,
   FaltaMaterial := Alimentar.Done1,
    RodamientoAceptado := Medir.Done,
 RodamientoRechazado := Medir.Done1,
  RodamientoCargado := Descargar.Done,
	  CarroEvacuado := Carro.Done,
	  CarroListo := Carro.CarroPreparado,
	  CarroNoListo := Carro.Done1

);
Preparar(
    SFCReset := ReiniciaEstado,
    SFCPause := OrdenPausa,
    Execute := Director.OrdenPreparacion,
    Ack := NOT Director.OrdenPreparacion,
    TiempoPreparacion := TiempoPreparacion
);

Finalizar(
    SFCReset := ReiniciaEstado,
    SFCPause := OrdenPausa,
    Execute := Director.OrdenFinalizacion,
    Ack := NOT Director.OrdenFinalizacion,
    TiempoFinalizacion := TiempoFinalizacion
);

Restaurar(
    SFCReset := ReiniciaEstado,
    SFCPause := OrdenPausa,
    Execute := Director.OrdenRestauracion,
    Ack := NOT Director.OrdenRestauracion,
	 CargadorDetras:= i_CargadorDetras,
	CargadorDelante:= i_CargadorDelante,
	CargadorMedio:= i_CargadorMedio,
    MedidorAbajo:= i_MedidorAbajo,
	  );

 Alimentar(
	 SFCReset := ReiniciaEstado,
	 SFCPause:= OrdenPausa,
	 Execute := Coordinador.Alimentar,
	Ack := NOT Coordinador.Alimentar,
	PresenciaRodamiento:= i_PresenciaRodamiento,
	AlimentadorDelante:= i_AlimentadorDelante,
	CargadorDetras:= i_CargadorDetras,
    CargadorMedio:= i_CargadorMedio,
    CargadorDelante:= i_CargadorDelante,
	  );

Carro(
	 SFCReset := ReiniciaEstado,
	 SFCPause:= OrdenPausa,
	 Execute := Coordinador.Carro,
	Ack := NOT Coordinador.Carro,
	Ack1 := SolicitudMarcha,
	PresenciaPale:= i_PresenciaPale,
	 Tiempo_evacuar:= Tiempo_evacuar,
 	 Tiempo_carro:= Tiempo_carro,
	PresenciaPale:= i_PresenciaPale,
    CodigoPaleBit0:= i_CodigoPaleBit0,
    CodigoPaleBit1:= i_CodigoPaleBit1,
	CodigoPaleBit2:= i_CodigoPaleBit2,

	  );
Descargar(
	 SFCReset := ReiniciaEstado,
	 SFCPause:= OrdenPausa,
	 Execute := Coordinador.Descargar,
	 Ack := NOT Coordinador.Descargar,
	 Tiempo_descargador := Tiempo_descargador,
    DescargadorArriba:= i_DescargadorArriba,
    DescargadorAbajo:= i_DescargadorAbajo,
    DescargadorDetras:= i_DescargadorDetras,
    DescargadorDelante:= i_DescargadorDelante,
	  );
 Medir(
	 SFCReset := ReiniciaEstado,
	 SFCPause:= OrdenPausa,
	 Execute := Coordinador.Medir,
	 Ack := NOT Coordinador.Medir,
	Tiempo_Piston:= Tiempo_Piston,
	Tiempo_Descartador:= Tiempo_Descartador,
  MedidorAbajo:= i_MedidorAbajo,
    MedidorArriba:= i_MedidorArriba,
	MedidorValor:= i_MedidorValor,
	Ancha:= Ancha,
	Estrecha:= Estrecha,

	  );

      ParadaSolicitada := Director.ParadaSolicitada;

	  ContinuacionAutorizada := NOT PausaTrasCiclo OR SolicitudMarcha;

	  SistemaEnReposo := Coordinador.Ready
    AND Restaurar.Ready
    AND Alimentar.Ready
    AND Carro.Ready
    AND Descargar.Ready
	AND Medir.Ready;
END_METHOD
