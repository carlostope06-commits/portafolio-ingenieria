// Generador de intermitencia para la señalización del panel
FUNCTION_BLOCK FB_Blink
VAR_INPUT
		Enable: BOOL := TRUE;
		TimeOn: TIME := T#500MS;
		TimeOff: TIME := T#500MS;
END_VAR
VAR_OUTPUT
	Q: BOOL;
END_VAR
VAR

	Timer: TON;
	ToggleEdge: R_TRIG;
	PhaseDuration: TIME;

END_VAR

IF NOT Enable THEN
	Q := FALSE;
	Timer ( IN := FALSE);
	ToggleEdge(CLK := FALSE) ;
	RETURN;
	END_IF;
	IF Q THEN
		PhaseDuration := TimeOn;
		ELSE
			PhaseDuration := TimeOff;

		END_IF
Timer (
	IN := TRUE,
	PT:= PhaseDuration);
	ToggleEdge (CLK := Timer.Q);
	IF ToggleEdge.Q THEN
		Q := NOT Q;
		Timer ( IN := FALSE);

	END_IF;

	
END_FUNCTION_BLOCK
