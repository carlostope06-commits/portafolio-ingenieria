// Programa principal (PlcTask, ciclo 10 ms)
PROGRAM MAIN
VAR
	Estacion: FB_Estacion;
END_VAR

Estacion();
(*
Automatización Industrial, GIERM,Grupo 07
Estación utilizada: FMS-202
Estructurado

 Carlos Torregrosa Pérez y dos compañeros

 -El programa implemeta un sistema de carga de rodamientos hacia un palé en función del grosor de estos
  seleccionado y la cantidad de piezas requeridas.
 -Gestiona la falta de material, tanto para la falta de rodamientos como la ausencia de palé.
 -Permite el procesamiento por lotes,  modo manual y  modo continuo.
 -Permite solicitar la parada a final de cilclo, conservando las maniobras pendientes en cualquiera de
   los dos modos automáticos o reiniciarlas si se desea. También cuenta con una parada de emergencia en caso necesario que
   pausa el funcionamiento de la máquina.
 -Incorpora una visualización la cual permite accionar cualquiera de las salidas y visualizar cualquiera de las entradas.
  La visualización también permite visualizar el modo de actuación y seleccionarlo. Los ciclos que se desean realizar
   también se seleccionan desde la visualización así como seleccionar si queremos alimentar el palé con piezas anchas o estrechas.

 - Para la falta de material del carro se llega a un punto en el medidor en el que la máquina no  permite continuar hasta que se
   detecte la presencia del carro, este permanece activo en la mayor parte del coordinador para funcionar en paralelo con las demás
   acciones y agilizar así el proceso.

 - El valor del palpador ha sido traducido a milimetros en la visualizacion.
*)
END_PROGRAM
