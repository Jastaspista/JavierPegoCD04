


-- ========================================
-- PRACTICA EXAME 2
-- ==================================
-- ------------------------------
-- DISPARADOR AUDITORIA
-- ------------------------------
desc juegos;
-- Auditar cambios en datos de la tabla juegos
drop table juegos_auditoria;
create table juegos_auditoria(
  fecha date,
  ope varchar(15),
  cod_old varchar(15),  
  cod_new varchar(15),
  nom_old varchar(15),
  nom_new varchar(15),
  des_old varchar(200),
  des_new varchar(200)
);
  
create or replace trigger juegos_biud 
after insert or update or delete on juegos
FOR EACH ROW
begin
    if inserting then 
        insert into juegos_auditoria(fecha, ope, cod_new, nom_new,des_new) 
        values(sysdate,'INS', :new.codigo, :new.nombre, :new.descripcion);
    elsif updating then
        insert into juegos_auditoria values (sysdate,'UPD', :old.codigo, :new.codigo,
        :old.nombre, :new.nombre, :old.descripcion, :new.descripcion);
    elsif deleting then
        insert into juegos_auditoria(fecha,OPE, cod_old, nom_old,des_old) 
        values(sysdate, 'DEL', :old.codigo, :old.nombre, :old.descripcion);
    
    end if;
end;
/
select * from juegos_auditoria;

-- ------------------------------
-- DISPARADOR Mantener restricciones
-- ------------------------------
-- Disparador para mantener restriciones.
-- Asegurarse de que el número de usuarios por partida sea inferior a 10.
-- SOLUCIÓN 1 : ERROR TABLA MUTANTE, SOLUCIÓN NO VÁLIDA
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
-- PROBLEMA tabla mutante: estamos accesiendo desde el disparador a la tabla que lo lanza
select codigo_partida, count(*) from unen group by codigo_partida;
select * from unen;
select * from unen where codigo_partida=4;
select * from usuarios;
desc unen;
insert into unen values ('4','jesdie98');

update unen set codigo_partida='4'
where codigo_partida='3' and codigo_usuario='alecam89'; 
-- errror tabla mutante
  
-- SOLUCIÓN 2. 
-- Disparador a nivel de fila con volcado a tabla auxiliar de los datos modificados
-- Disparador a nivel de sentencia para revisar si los datos modificados inclumplen la restricción
DESC UNEN;
CREATE TABLE temp_unen(PARTIDA VARCHAR2 (15));

CREATE OR REPLACE TRIGGER UNEN_BIU
BEFORE INSERT OR UPDATE ON UNEN
FOR EACH ROW
BEGIN
  if :new.codigo_partida is not null then 
    INSERT INTO temp_unen VALUES(:new.codigo_partida);
  end if;
  
END;
/
create or replace trigger UNEN_AIU  
AFTER INSERT OR UPDATE ON UNEN
DECLARE
    num_participantes number;
    CURSOR c_temp_unen is select distinct partida from temp_unen;
BEGIN
    -- open c_temp_unen;
    FOR reg IN c_temp_unen LOOP
        select count(*) into num_participantes from unen where codigo_partida=reg.partida;
        if num_participantes>=10 
        then raise_application_error(-20000, 'la partida '||reg.partida||' supera el límite de jugadores');
        end if;
    END LOOP;
    -- close c_temp_unen;
    delete from temp_unen; -- limpiamos la tabla auxiliar
END;
/

select codigo_partida, count(*) from unen group by codigo_partida;
select * from unen;
select * from unen where codigo_partida=4;
select * from usuarios;
insert into unen values ('2','jesdie98');
insert into unen values ('4','jesdie98'); -- ORA-20000: la partida 4 supera el límite de jugadores

update unen set codigo_partida='2'
where codigo_partida='3' and codigo_usuario='alecam89'; 
update unen set codigo_partida='4' -- ORA-20000: la partida 4 supera el límite de jugadores
where codigo_partida='3' and codigo_usuario='alecam89'; 

-- Otras soluciones pasan por emplear disparadores compuestos, paquetes....



-- ------------------------------
-- DISPARADOR Reglas de negocio
-- ------------------------------
-- El creador de una partida será el primer usuario que se una a la misma.
-- Crea un disparador para unir automáticamente al creador de la partida:
-- cada vez que se cree una partida, su creador se una automáticamente a dicha partida
create or replace TRIGGER PARTIDAS_AI
AFTER INSERT ON partidas
FOR EACH ROW 
DECLARE
BEGIN
    INSERT INTO unen VALUES (:new.codigo, :new.cod_creador);

END;
/

-- ------------------------------
-- DISPARADOR Atributos derivados
-- ------------------------------
-- Añadimos atributo numparticipantes en la tabla partidas
-- Mantener el atributo ante inserciones, actualizaciones y borrados
     alter table partidas add num_usuarios number;

create or replace procedure calcular_participantes as
  vnum number;
  cursor c_partida is select * from partidas;
begin
     for reg in c_partida loop
        select count(*) into vnum from unen where codigo_partida=reg.codigo 
                                        and codigo_usuario=reg.cod_creador;
        if vnum=0 then 
            insert into unen values (reg.codigo, reg.cod_creador); 
        end if;
     end loop;
     update partidas set num_usuarios = (select count(*) from unen where codigo_partida=codigo);
end;
/
call calcular_participantes();
select * from partidas;
-- Podría ahora emplear el atributo derivado para controlar el máximo de usuarios por partida???
-- Tendría que añadir disparadores para mantener el atributo derivado
-- y al mismo tiempo al insertar/modificar fila si previamente se ha llegado
-- al límite (partidas.num_usuarios) ya se lanza el error.
-- Disparador lanzado sobre unen pero lee datos de partidas
-- habría que controlar también la modificación en cascada



-- ------------------------------
-- DISPARADOR RESTRICCIONES
-- ------------------------------
-- Nota: los hacemos a nivel educativo, siempre es mejor implementar las restricciones
-- que se a posible mediante constraints
-- En todo caso las restricciones o reglas de negocio que no se pueda implementar fácilmente con restricciones las podemos implementar con disparadores.

-- Disparador para asegurarse que todo usuario tiene login, la password no contenga el nombre de pila, que tenga fecha de nacimiento
-- y de paso ponga la fecha del sistema en el campo f_ing (en caso de que se pase valor nulo)






SELECT * FROM v$version;
select * from juegos;

select 'y' from juegos where codigo=1;

select count(*) from juegos where codigo=1;

select * from partidas;
desc partidas;

ç-- ------------------------------
-- DISPARADOR y secuencias
-- ------------------------------

-- SECUENCIAS
-- Crea una secuencia para el codigo de la partida en la tabla partidas
drop sequence partidas_seq;
create sequence partidas_codigo_seq  minvalue 100 increment by 1;
DESC PARTIDAS;

-- DISPARADOR Y SECUENCIA
create or replace trigger partidas_bi 
before insert on partidas
for each row
declare
    v_partida char(1);
begin
 -- asignamos fecha y hora actuales a las columnas fecha y hora de inicio de la partida
  if :new.fecha_inicio is null then :new.fecha_inicio:=sysdate; end if;
  if :new.hora_inicio is null then :new.hora_inicio:=sysdate; end if;
 -- asignamos valor por defecto a numero de usuarios, 
 -- con una restricción de valor por defecto estaría mejor
  :new.num_usuarios:=0;
-- localizamos si existe ese codigo de juego  
  select 'Y' into v_partida
    from juegos 
    where codigo=:new.cod_juego;

-- ANTERIORMENTE SELECT partidas_codigo_seq.NEXTVAL INTO :NEW.codigo FROM DUAL;
  :new.codigo:=partidas_codigo_seq.nextval;

EXCEPTION
    WHEN NO_DATA_FOUND THEN -- si no existe el juego 
        raise_application_error(20000,  ' Juego  NO EXISTE');
end;
/
INSERT INTO PARTIDAS(NOMBRE,ESTADO,COD_JUEGO) 
    VALUES('PRUEBA',0,1);
SELECT * FROM PARTIDAS;
