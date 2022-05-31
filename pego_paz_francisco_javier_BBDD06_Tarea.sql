--Actividad 1.

--Creo la funcion para comprobar si la familia es válida
CREATE OR REPLACE FUNCTION isValidIdFamilia(idFamilia NUMBER)
RETURN VARCHAR2
IS
    RESPUESTA VARCHAR2(5);
    COUNTER NUMBER;
    RAISE_APPLICATION_ERROR EXCEPTION;
BEGIN
    SELECT COUNT(*) INTO COUNTER FROM FAMILIAS WHERE identificador = idFamilia;
    IF COUNTER = 0 THEN  
        RAISE RAISE_APPLICATION_ERROR;
    ELSE RETURN 'TRUE';
    END IF; 
EXCEPTION
    WHEN RAISE_APPLICATION_ERROR THEN
        DBMS_OUTPUT.PUT_LINE('(' || idFamilia || ') ES UN IDENTIFICADOR DE FAMILIA INVÁLIDO');
        RETURN 'FALSE';
END isValidIdFamilia;

--Creo el procedimiento que cambia los agentes entre familias

CREATE OR REPLACE PROCEDURE CambiarAgentesFamilia( id_FamiliaOrigen IN NUMBER, id_FamiliaDestino IN NUMBER)
IS    
    RAISE_APPLICATION_ERROR EXCEPTION;
    COUNTER NUMBER;
    ID1 VARCHAR(5);
    ID2 VARCHAR(5);
BEGIN
    IF id_FamiliaOrigen = id_FamiliaDestino THEN
        RAISE RAISE_APPLICATION_ERROR;
    ELSE
        ID1 := isValidIdFamilia(id_FamiliaOrigen);
        ID2 := isValidIdFamilia(id_FamiliaDestino);
        if ID1='TRUE' and ID2='TRUE' then
            SELECT count(*) INTO COUNTER FROM AGENTES WHERE familia=id_FamiliaOrigen;
            IF COUNTER > 0 THEN 
                UPDATE AGENTES SET FAMILIA=id_FamiliaDestino WHERE FAMILIA=id_FamiliaOrigen;
            END IF;
            DBMS_OUTPUT.PUT_LINE('Se han trasladado ' || COUNTER || ' agentes de la familia  ' || id_FamiliaOrigen || ' a la familia ' || id_FamiliaDestino);
        END IF;
    END IF;
EXCEPTION
    WHEN RAISE_APPLICATION_ERROR THEN
        DBMS_OUTPUT.PUT_LINE('Ids inválidos, SON IGUALES');
END;



--Actividad 2.


CREATE OR REPLACE TRIGGER restricciones_agentes
BEFORE INSERT OR UPDATE ON agentes
FOR EACH ROW
DECLARE
	mensaje VARCHAR2(200);
	fallo	BOOLEAN;
BEGIN
	mensaje := '';
	fallo   := false;
	IF ((length(:new.clave) < 6)) THEN
		mensaje := mensaje || '{La longitud de la clave de un agente no puede ser inferior a 6.}';
		fallo   := true;
	END IF;
	IF (:new.habilidad < 0 or :new.habilidad > 9) THEN
		mensaje := mensaje || '{La habilidad de un agente debe estar comprendida entre 0 y 9 (ambos inclusive)}';
		fallo   := true;
	END IF;
	IF (:new.categoria < 0 or :new.categoria > 2) THEN
		mensaje := mensaje || '{La categoría de un agente sólo puede ser igual a 0, 1 o 2}';
		fallo   := true;
	END IF;
	IF (:new.oficina is not null and :new.categoria != 2) THEN
		mensaje := mensaje || '{Si un agente pertenece a una oficina directamente, su categoría debe ser igual 2}';
		fallo   := true;
	END IF;
	IF (:new.categoria = 2 and :new.familia is not null and :new.oficina is null) THEN
		mensaje := mensaje || '{Si un agente tiene categoría 2 no puede pertenecer a ninguna familia y debe pertenecer a una oficina. }';
		fallo   := true;
	END IF;
	IF (:new.categoria = 1 and :new.oficina is not null and :new.familia is null) THEN
		mensaje := mensaje || '{Si un agente tiene categoría 1 no puede pertenecer a ninguna oficina y debe pertenecer  a una familia.}';
		fallo   := true;
	END IF;
	IF (:new.oficina is not null and :new.familia is not null) THEN
		mensaje := mensaje || '{Todos los agentes deben pertenecer  a una oficina o a una familia pero nunca a ambas a la vez.}';
		fallo   := true;
	END IF;
	IF (fallo = true) THEN
		RAISE_APPLICATION_ERROR(-20201, mensaje);
	END IF;
END;
/