-- Examen: normalmente 4 tareas que incluyan estos tres tipos (funciones, procedimientos y disparadores),
-- y empleo de cursores en alguno de ellos al menos.

--1
-- FUNCIÓN DE RECUPERACIÓN DE DATOS
-- Función que devuelva el número de usuarios de una provincia dada.
-- Entradas: Nombre de la provincia
-- Salida: Número de usuarios que residen en esa provincia
-- Excepciones: si el usuario no existe devuelva -1
CREATE OR REPLACE FUNCTION USUARIOSPROV (PROV VARCHAR2)
RETURN INTEGER
IS 
CANTIDAD INTEGER;
BEGIN
     SELECT COUNT(*) INTO CANTIDAD FROM USUARIOS WHERE PROVINCIA = PROV;
     RETURN CANTIDAD;
     EXCEPTION WHEN NO_DATA_FOUND THEN RETURN -1;
END;
/
-- Función que dado el nombre y apellidos de un usuario nos devuelva el login de dicho usuario
-- Entrada: nombre, apellidos
-- Salida: login
-- Excepciones: que no exista, en ese caso devuelva ...
-- que haya más de uno
CREATE OR REPLACE FUNCTION GETLOGIN (NOME VARCHAR, APELS VARCHAR)
RETURN VARCHAR
IS
LOGI CHAR(33);
BEGIN
    SELECT LOGIN INTO LOGI FROM USUARIOS WHERE NOMBRE=NOME AND APELLIDOS=APELS;
    RETURN LOGI;
    EXCEPTION 
        WHEN NO_DATA_FOUND 
			THEN RETURN('Sen coincidencias') ;
			-- THEN RAISE_APPLICATION_ERROR(-20001, 'Sen coincidencias') ;
        WHEN TOO_MANY_ROWS 
			THEN  RETURN ('Demasiadas coincidencias');
			--TOO_MANY_ROWS THEN RAISE_APPLICATION_ERROR(-20001, 'Demasiadas coincidencias');
        -- when others then RAISE_APPLICATION_ERROR(-20001, 'Erro en funcion getlogin') ;
END;
/
SELECT GETLOGIN('JESUS', 'DIEZ GIL') FROM dual;
select * from usuarios;

-- Procedimiento para inserción de datos.
-- Procedimiento que inserte una nueva fila en la tabla juegos
-- Entradas: codido, nombre, descripción
-- Excepciones: clave duplicada, ....
CREATE OR REPLACE PROCEDURE INSERTJUEGOS (COD VARCHAR2, NOMBRE VARCHAR2, DESCRIPCION VARCHAR2)
AS
BEGIN
    INSERT INTO JUEGOS VALUES (COD, NOMBRE, DESCRIPCION);
EXCEPTION when dup_val_on_index then DBMS_OUTPUT.PUT_LINE('Clave Duplicada en procedimiento insertjuegos');
-- RAISE_APPLICATION_ERROR(-20001, 'CLAVE DUPLICADA') ;

-- en este tipo de procedimientos podemos tratar las excepciones que puedan surgir como clave duplicada
              
END;
/

CALL INSERTJUEGOS (13, 'SUBASTADO', 'UNA PARTIDA DE TUTE SUBASTADO');

--2
-- PROCEDIMIENTO CON CURSOR
-- Sacar un listado por DBMS con datos de las partidas que se han creado hace más de 1 año/ el mes en cursor.
-- codigopartida, nombre, estado, creador, fecha inicio

CREATE OR REPLACE PROCEDURE PARTIDASANO
AS
    CURSOR DATOSGAMES IS
        SELECT CODIGO COD , NOMBRE NOME , ESTADO EST , COD_CREADOR CR, FECHA_INICIO DAT  FROM PARTIDAS WHERE MONTHS_BETWEEN(SYSDATE, FECHA_INICIO)>12;
    COD partidas.codigo%TYPE;
    NOME partidas.nombre%TYPE;
    EST partidas.estado%TYPE;
    CR partidas.cod_creador%TYPE;
    DAT partidas.fecha_inicio%TYPE;
    CONTA NUMBER:=0;
BEGIN
     --OPEN DATOSGAMES;
    /*
    LOOP
        FETCH DATOSGAMES INTO COD, NOME, EST, CR, DAT;
        EXIT WHEN DATOSGAMES%NOTFOUND;
        CONTA:=CONTA+1;
        DBMS_OUTPUT.PUT_LINE('['||CONTA||'] NOME PARTIDA '||NOME||' - '||COD||' - '||EST||' - '||CR||' - '||DAT);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('SE HAN PROCESADO '||CONTA||' REGISTROS');
    CLOSE DATOSGAMES;*/
     
    FOR REG IN DATOSGAMES LOOP
        DBMS_OUTPUT.PUT_LINE('NOME PARTIDA '  ||REG.NOME||' - '||REG.COD||' - '||REG.EST||' - '||REG.CR||' - '||REG.DAT);
    END LOOP;
END;
/
CALL PARTIDASANO();
SELECT CODIGO, NOMBRE, ESTADO, COD_CREADOR, FECHA_INICIO 
FROM PARTIDAS
WHERE MONTHS_BETWEEN(SYSDATE, FECHA_INICIO)>12;

-- Procedimiento con cursor para listar por DBMS los datos de las partidas de un usuario cuyo login se pasa como parámetro
-- Formato Listado: codigoPartida, nombre, estado,
-- Pie de listado (info estadística): el número de partidas, la más antigua y la más reciente
CREATE OR REPLACE PROCEDURE PARTIDASUSUARIO (USUARIO VARCHAR)
AS
    CURSOR GAMESUSER IS
        SELECT CODIGO, NOMBRE, ESTADO, COD_CREADOR, FECHA_INICIO FROM PARTIDAS WHERE COD_CREADOR=USUARIO ORDER BY FECHA_INICIO;
    COD partidas.codigo%TYPE;
    NOME partidas.nombre%TYPE;
    EST partidas.estado%TYPE;
    CR partidas.cod_creador%TYPE;
    DAT partidas.fecha_inicio%TYPE;
    CONTA NUMBER:=0;
    VMASANTIGUA DATE := SYSDATE;
    VMASRECIENTE DATE :=TO_DATE('1930-01-01','YYYY-MM-DD');
BEGIN
    OPEN GAMESUSER;
    
    LOOP
        FETCH GAMESUSER INTO COD, NOME, EST, CR, DAT;
        EXIT WHEN GAMESUSER%NOTFOUND;
        CONTA:=CONTA+1;
        IF DAT<VMASANTIGUA THEN VMASANTIGUA:=DAT; END IF;
        IF DAT>VMASRECIENTE THEN VMASRECIENTE:=DAT; END IF;
        DBMS_OUTPUT.PUT_LINE('['||CONTA||'] NOME PARTIDA '||NOME||' - '||COD||' - '||EST||' - '||CR||' - '||DAT);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('PARTIDAS EN TOTAL: '||CONTA);
    DBMS_OUTPUT.PUT_LINE('FECHA MÁS ANTIGUA: '||TO_CHAR(VMASANTIGUA, 'DD/MM/YYYY') );
    CLOSE GAMESUSER;
END;
/
CALL PARTIDASUSUARIO ('alibar52');


--3
-- DISPARADORES

-- Disparador para mantener restriciones. 
-- Asegurarse de que el número de usuarios por partida sea inferior a 10. PENDIENTE LIDIAR TABLA MUTANTE
create or replace TRIGGER UNEN_BI_BU BEFORE INSERT OR UPDATE ON UNEN
FOR EACH ROW
DECLARE
    VNPARTIDAS NUMBER;
BEGIN
    SELECT COUNT (*) INTO VNPARTIDAS FROM UNEN WHERE CODIGO_PARTIDA=:NEW.CODIGO_PARTIDA;
    IF VNPARTIDAS>=4 THEN RAISE_APPLICATION_ERROR(-20001,'LA PARTIDA SUPERA EL LÍMITE DE PARTICIPANTES');-- NO AÑADE LA QUINTA
    END IF;

END;
/

-- Asegurarse de que el login de un usuario/password no coincida con el nombre
CREATE OR REPLACE TRIGGER USUARIOS_BI BEFORE INSERT OR UPDATE ON USUARIOS
FOR EACH ROW
BEGIN
    IF (:NEW.LOGIN = :NEW.NOMBRE) THEN 
        RAISE_APPLICATION_ERROR(-20001,'EL NOMBRE NO PUEDE COINCIDIR CON EL NICK');
    END IF;
END;
/
 SELECT * FROM USUARIOS;
 UPDATE USUARIOS SET NOMBRE='ANA' where login='anamat56';


-- DISPARADOR PARA MANTENER ATRIBUTOS DERIVADOS.
-- Fecha de última partida creada en la tabla usuarios.
ALTER TABLE USUARIOS ADD F_ULTIMA_PARTIDA DATE;

CREATE OR REPLACE TRIGGER PARTIDAS_AI AFTER INSERT ON PARTIDAS
    FOR EACH ROW
DECLARE
 VULTIMA DATE;
BEGIN
    SELECT F_ULTIMA_PARTIDA INTO VULTIMA 
        FROM USUARIOS WHERE LOGIN=:NEW.COD_CREADOR;
    IF :NEW.FECHA_INICIO > VULTIMA  OR VULTIMA IS NULL
    THEN    
        UPDATE  USUARIOS SET F_ULTIMA_PARTIDA=:NEW.FECHA_INICIO 
            where login=:new.cod_creador;
    END IF;
END;
/
SELECT * FROM PARTIDAS;
desc partidas;
INSERT INTO PARTIDAS VALUES ('12', 'Proba2','0','1',sysdate-1,sysdate,'migarc93');
select * from usuarios where login='migarc93';


-- DISPARADOR AUDITAR CAMBIOS EN LA INFORMACIÓN ALMACENADA
-- Teniendo una tabla de auditoría CAMBIOS_CRETIDO (sellotiempo, login, creditoanterior, creditonuevo)
-- Queremos que cada vez que se produzca un cambio en el crédito de un usuario se añada una fila a la tabla de auditoría
-- cada vez que el crédito se ponga a cero
-- cada vez que el crédito aumente en más de 100
CREATE OR REPLACE TRIGGER CAMBIOS AFTER UPDATE ON USUARIOS
FOR EACH ROW
DECLARE
    CREDITANT NUMBER:=:OLD.CREDITO;
    CREDITNEW NUMBER:=:NEW.CREDITO;
    SELLO DATE:=SYSDATE;
BEGIN
    IF (CREDITNEW-CREDITANT >= 100) THEN 
        INSERT INTO CAMBIOS_CREDITO VALUES (SELLO, :NEW.LOGIN, CREDITANT, CREDITNEW);
    ELSIF (CREDITNEW=0) THEN
        INSERT INTO CAMBIOS_CREDITO VALUES (SELLO, :NEW.LOGIN, CREDITANT, CREDITNEW);
    ELSIF (CREDITNEW<>CREDITANT) THEN
        INSERT INTO CAMBIOS_CREDITO VALUES (SELLO, :NEW.LOGIN, CREDITANT, CREDITNEW);
    END IF;
END;
/
