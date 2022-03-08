--1. Obtener los nombres y salarios de los empleados con más de 1000 euros de salario por orden alfabético.
SELECT nombre, ape1, ape2, salario
FROM empleado
WHERE salario > 1000
ORDER BY nombre ASC;

--2. Obtener el nombre de los empleados cuya comisión es superior 
-- al 20% de su salario.
SELECT nombre, ape1, comision, salario
FROM empleado
WHERE comision > salario * 0.1; -- PROBAMOS 10% POR QUE CON 20 NO HAY

SELECT nombre, ape1, nvl(comision, 0), salario  -- Para ver los valores si comision es null sacamos 0 en el listado
FROM empleado
WHERE nvl(comision, 0) > salario * 0.1;
--3. Obtener el código de empleado, código de departamento, nombre y sueldo 
--total en pesetas de aquellos empleados cuyo sueldo total (salario más 
--comisión) supera los 1800 euros. Presentarlos ordenados por código de 
--departamento y dentro de éstos por orden alfabético.

select e1.codemple, e1.coddpto, e1.nombre, (e1.salario*166) as sueldoPtas from empleado e1 where (e1.salario+nvl(e1.comision,0))>'1800' order by e1.coddpto, e1.nombre asc;








select codemple, coddpto, nombre, 
       round((salario + nvl(comision, 0)) / 0.006, 2) AS sueldoTotalPesetas, -- mil pesetas 6 euros
       round((salario+nvl(comision,0))*166.386,2) SueldoTotalPesetas --1 euro, equivale a 166,386 pesetas
FROM empleado
WHERE salario + nvl(comision, 0) > 1800
ORDER BY coddpto, 
         nombre ASC;

--4. Obtener por orden alfabético los nombres de empleados cuyo salario 
--igualen o superen en más de un 5% al salario de la empleada ‘MARIA JAZMIN’.

select nombre, salario from empleado where salario >= (select salario*1.05 from empleado where nombre='MARIA' AND ape1='JAZMIN') ORDER BY NOMBRE;


SELECT nombre, ape1, salario
FROM empleado
WHERE salario >= ( SELECT salario * 1.05
                   FROM empleado
                   WHERE ape1 = 'JAZMIN'
                         AND nombre = 'MARIA'
                 )
ORDER BY 1, 2;







--5. Obtener un listado ordenado por años en la empresa con los nombres, y 
--apellidos de los empleados y los años de antigüedad en la empresa

select nombre, ape1, 
ape2, trunc(months_between(sysdate,fechaingreso)/12) as antiguedad 
from empleado;








SELECT nombre, ape1, ape2, round((sysdate - fechaingreso) / 365.20, 2)       AS "AntigÃ¼edad",
trunc(months_between(sysdate, fechaingreso) / 12) "Antiguedad"
FROM empleado
ORDER BY 5;

--6. Obtener el nombre de los empleados que trabajan en un departamento con 
--presupuesto superior a 50.000 euros. Hay que usar predicado cuantificado:

select nombre, ape1, presupuesto, denominacion from empleado join dpto on empleado.coddpto=dpto.coddpto where empleado.coddpto= some(select coddpto from dpto where presupuesto>50000);


SELECT nombre,ape1
FROM empleado
WHERE coddpto = SOME ( SELECT coddpto 
                       FROM dpto
                       WHERE presupuesto > 50000
                     );

SELECT nombre,ape1
FROM empleado 
WHERE coddpto IN ( SELECT coddpto
                   FROM dpto
                   WHERE presupuesto > 50000
                 );


--7. Obtener los nombres y apellidos de empleados que más cobran en la 
--empresa. Considerar el salario más la comisión
select nombre, ape1, ape2
FROM empleado
WHERE nvl(comision, 0) + salario >= ALL ( SELECT nvl(comision, 0) + salario
                                          FROM empleado
                                        );
SELECT nombre, ape1, ape2
FROM empleado
WHERE salario + nvl(comision, 0) = ( SELECT MAX(salario + nvl(comision, 0))
                                     FROM empleado
                                   );

--8. Obtener en orden alfabético los nombres de empleado cuyo salario es 
--inferior al mínimo de los empleados del departamento 1.

select ape1,nombre from empleado where salario < (select min(salario) from empleado where coddpto=1) order by ape1,nombre;



SELECT ape1, nombre
FROM empleado
WHERE salario < ( SELECT MIN(salario)
                  FROM empleado
                  WHERE coddpto = 1
                )
ORDER BY ape1, nombre;

SELECT ape1, nombre, salario
FROM empleado
WHERE salario < all ( SELECT salario
                  FROM empleado
                  WHERE coddpto = 1
                )
ORDER BY ape1, nombre;


SELECT ape1, nombre, nvl(comision, 0) + salario -- si condideramos sueldo total
FROM empleado
WHERE nvl(comision, 0) + salario <  ( SELECT min(nvl(comision, 0) + salario)
                                          FROM empleado
                                        );

--9. Obtener los nombre de empleados que trabajan en el departamento del 
--cuál es jefe el empleado con código 1.

Select nombre, ape1 from empleado where coddpto=(select coddpto from dpto where codemplejefe=1);





SELECT nombre, ape1
FROM empleado
WHERE coddpto = ( SELECT coddpto
                  FROM dpto
                  WHERE codemplejefe = 1
                );

--10. Obtener los nombres de los empleados cuyo primer apellido empiece por 
--las letras p, q, r, s.

select nombre, ape1 from empleado where ape1 LIKE 'P%' OR ape1 LIKE 'R%' OR ape1 LIKE 'Q%' OR ape1 LIKE 'S%';

SELECT nombre, ape1 FROM empleado WHERE ape1 LIKE 'S%' OR ape1 LIKE 'P%' OR ape1 LIKE 'Q%' OR ape1 LIKE 'R%';








SELECT nombre, ape1 FROM empleado WHERE lower(substr(ape1, 1, 1)) IN ( 'p', 'q', 'r', 's' ); 

SELECT ape1, lower(substr(ape1, 2, 2)) as minuscula FROM EMPLEADO;


-- también lower(ape1) like 'p%' or ... or lower(ape1) like 's%', aunque perdiese un poco de legibilidad

SELECT nombre,
       ape1
FROM empleado
WHERE substr(ape1, 1, 1) BETWEEN 'P' AND 'S'; -- esta a mí no se me hubiese ocurrido, obviamente vale porque son letras correlativas, mejor pasarle un lower o un apper para asegurar que no distinguimos entre minusculas y mayúsculas

--11. Obtener los empleados cuyo nombre de pila contenga el nombre JUAN.


SELECT nombre,
       ape1
FROM empleado
WHERE nombre LIKE 'JUAN'; 
-- empiece por, contenga o termine en, para que no tenga en cuenta JUANIN

SELECT *
FROM empleado
WHERE instr(nombre, 'JUAN') <> 0; -- otra opción 


--12. Obtener los nombres de los empleados que viven en ciudades en las que 
--hay algún centro de trabajo


SELECT e1.nombre, e1.localidad from empleado e1 join centro c1 on e1.localidad=c1.localidad where upper(e1.localidad) in upper(c1.localidad);
SELECT nombre,localidad FROM empleado WHERE upper (empleado.localidad) IN (SELECT upper (centro.localidad) FROM centro);

select nombre, localidad from empleado where upper(empleado.localidad) in (select upper (centro.localidad) from centro);












SELECT nombre, ape1
FROM empleado
WHERE upper(localidad) IN ( SELECT upper(localidad)
                     FROM centro
                   );

--13. Obtener el nombre del jefe de departamento que tiene mayor salario de 
--entre los jefes de departamento.


select nombre, ape1 from empleado where (salario+nvl(comision,0)) = (select max(salario+nvl(comision,0)) from empleado , dpto where codemple=codemplejefe);














SELECT nombre,ape1, salario
FROM empleado
WHERE codemple IN ( SELECT codemplejefe
                    FROM dpto
                  )
      AND salario >= ALL ( SELECT salario --salarios de todos los jefes de departamento
                     FROM empleado
                     WHERE codemple IN ( SELECT codemplejefe
                                         FROM dpto
                                       )
                         );

--14. Obtener en orden alfabético los salarios y nombres de los empleados cuyo 
--salario sea superior al 60% del máximo salario de la empresa.

select nombre, salario from empleado where salario>=(select max(salario)*0.6 from empleado)















SELECT nombre, ape1, salario
FROM empleado
WHERE salario > ( SELECT MAX(salario) * 0.6
                  FROM empleado
                )
ORDER BY 2, 1;
SELECT nombre, ape1, salario
FROM empleado
WHERE salario > 0.6*( SELECT MAX(salario) -- más eficiente
                  FROM empleado
                )
ORDER BY 2, 1;
--15. Obtener en cuántas ciudades distintas viven los empleados
SELECT COUNT(DISTINCT localidad)
FROM empleado;








select distinct localidad from empleado;








-- 16 El nombre y apellidos del empleado que más salario cobra

select nombre, ape1, ape2 from empleado where salario= (select max(salario) from empleado) order by 2;








SELECT nombre, ape1, ape2
FROM empleado
WHERE salario = ( SELECT MAX(salario)
                  FROM empleado
                );


--17. Obtener las localidades y número de empleados de aquellas en las que viven más 
--de 3 empleados

select localidad, count(*) as numempleados from empleado group by localidad having count(*)>1;





select localidad, count(*) as numempleados from empleado group by localidad having count(*)>3;

where count(*)=(select count(*) from empleados















SELECT localidad, count(*)
FROM empleado
group by localidad
HAVING count(*) > 3;


--18. Obtener para cada departamento cuántos empleados trabajan, la suma de sus 
--salarios y la suma de sus comisiones para aquellos departamentoS en los que hay 
--algún empleado cuyo salario es superior a 1700 euros.


select e1.coddpto, d1.denominacion,  sum(e1.salario), sum(e1.comision), count(e1.codemple) from empleado e1 join dpto d1 ON e1.coddpto=d1.coddpto group by e1.coddpto,d1.denominacion having e1.coddpto = SOME (select e2.coddpto from empleado e2 where e2.salario>1700)order by 3 desc;




SELECT * FROM DPTO;

-- si queremos listar el nombre del departamento combinamos con dpto
SELECT e1.coddpto,denominacion,  SUM(e1.salario), SUM(e1.comision), COUNT(e1.codemple)
FROM empleado e1 join dpto on e1.coddpto=dpto.coddpto
GROUP BY e1.coddpto, denominacion
HAVING e1.coddpto = SOME ( SELECT e2.coddpto
                        FROM empleado e2
                        WHERE salario > 1700
                      ) order by 3 desc;

--19. Obtener el departamento que más empleados tiene

SELECT DPTO.denominacion AS departamento, COUNT(*) FROM empleado 
INNER JOIN DPTO ON empleado.coddpto = DPTO.coddpto
GROUP BY DPTO.denominacion 
HAVING COUNT(*) = (SELECT MAX(count(*)) FROM empleado GROUP BY coddpto);
select * from empleado order by coddpto;


SELECT denominacion
FROM dpto, empleado
WHERE empleado.coddpto = dpto.coddpto
GROUP BY dpto.coddpto, denominacion
HAVING COUNT(empleado.codemple) = ( select max (conteo) from
                                        (SELECT COUNT(codemple)as conteo
                                         FROM empleado
                                         GROUP BY coddpto
                                       )
                                    );

SELECT denominacion, count(empleado.codemple)
FROM dpto, empleado
WHERE empleado.coddpto = dpto.coddpto
GROUP BY dpto.coddpto, denominacion
HAVING COUNT(empleado.codemple) >= ALL ( SELECT COUNT(codemple) -- si es mayor o igual que todos es mayor o igual que el máximo, yo prefiero la anterior pues es más legible y comparas sólo conun valor (eficiencia)
                                         FROM empleado
                                         GROUP BY coddpto
                                       );
SELECT dpto.coddpto,denominacion, count(*) NumEmpleados  -- Para comprobar la anterior
FROM empleado join dpto on empleado.coddpto=dpto.coddpto
GROUP BY dpto.coddpto, denominacion
order by 3 desc;
--20. Obtener los nombres de todos los centros y los departamentos que se ubican en 
--cada uno,así como aquellos centros que no tienen departamentos.
insert into centro values (04,'Gran Via','Vigo'); -- insertamos un nuevo centro para que se observe la diferencia entre outer e inner join
select * from dpto;
select * from centro;

SELECT c.codcentro, c.direccion, c.localidad, d.coddpto, d.denominacion
FROM centro c
LEFT JOIN dpto   d ON c.codcentro = d.codcentro; -- sintaxis del estándar

SELECT direccion, denominacion
FROM centro tc, dpto   td
WHERE tc.codcentro = td.codcentro (+)  -- sintaxis alternativa en oracle
ORDER BY 1, 2;

--21. Obtener el nombre del departamento de más alto nivel, es decir, aquel que no 
--depende de ningún otro.
select * from dpto;

select denominacion from dpto where coddptodepende is null;

--22. Obtener todos los departamentos existentes en la empresa y los empleados (si 
--los tiene) que pertenecen a él.
 insert into dpto values (08,'PRUEBAS',03,05,04,'F',40000);

SELECT denominacion, nombre, ape1, ape2
FROM dpto     td
LEFT JOIN empleado te ON td.coddpto = te.coddpto
ORDER BY 1;

--23. Obtener un listado en el que aparezcan todos los departamentos existentes y el 
--departamento del cual depende,si depende de alguno.
SELECT d1.coddpto, d1.denominacion, 
   d2.coddpto DependeDe, d2.denominacion nombredpto
FROM dpto d1  left JOIN dpto d2 ON d1.coddptodepende = d2.coddpto;
select * from dpto;

SELECT td.denominacion, a.denominacion
FROM dpto td, dpto a
WHERE a.coddpto (+) = td.coddptodepende;

--24. Obtener un listado ordenado alfabéticamente donde aparezcan los nombres de 
--los empleados y a continuación el literal "tiene comisión" si la tiene,y "no tiene 
--comisión" si no la tiene.
select nombre,ape1,ape2, comision,nvl2(comision,'tiene comisiÃ³n','no tiene comisiÃ³n') as comision -- la más sencilla con nvl2
from empleado
order by 1,2,3;

SELECT nombre, comision, decode(nvl(comision, 0), 0, 'No Tiene comisión', 'Tiene comisión') tieneComision
FROM empleado
ORDER BY nombre ASC;

SELECT nombre, ape1, ape2, 'tiene comision'
FROM empleado
WHERE comision IS NOT NULL
UNION
SELECT nombre, ape1, ape2, 'no tiene comision'
FROM empleado
WHERE comision IS NULL
ORDER BY 4, 2;



SELECT     -- esta también es sencilla y legible (legibilidad=facilidad para "leer" o entender el código)
    nombre,
    CASE
    WHEN comision IS NULL THEN
    'no tiene comision'
    ELSE
    'tiene comision'
    END comision
FROM
    empleado
ORDER BY
    nombre ASC;


--25. Obtener un listado de las localidades en las que hay centros 
--y no vive ningún  empleado, ordenado alfabéticamente.
SELECT localidad 
FROM centro c
WHERE upper(localidad) NOT IN ( SELECT DISTINCT localidad
                                FROM empleado
                              )
ORDER BY localidad ASC;

SELECT upper(tc.localidad)
FROM centro tc
MINUS
SELECT upper(te.localidad)
FROM empleado te
ORDER BY 1;


 SELECT   -- opción de alumnado,  no me chista, poco eficiente, menos legible, no la daría por buena 
    upper(
        centro.localidad
    ) "localidad del centro"
FROM
    centro
    LEFT JOIN empleado ON upper(
        empleado.localidad
    ) = upper(
        centro.localidad
    )
GROUP BY
    centro.localidad
HAVING
    COUNT(empleado.localidad) < 1
ORDER BY
    centro.localidad ASC;



--26. Obtener un listado de las localidades en las que hay centros 
-- y además vive al menos un empleado ordenado alfabéticamente.
SELECT localidad
FROM centro c
WHERE upper(localidad) IN ( SELECT DISTINCT localidad
                            FROM empleado
                          )
ORDER BY localidad ASC;

SELECT DISTINCT upper(localidad)
FROM centro
INTERSECT
SELECT DISTINCT upper(localidad)
FROM empleado
ORDER BY 1 ASC;

-- no me chista la siguiente
SELECT localidad
FROM centro c
WHERE upper(localidad) NOT IN ( SELECT DISTINCT localidad
                                FROM empleado
                              )
ORDER BY localidad ASC;

SELECT upper(tc.localidad)
FROM centro tc
MINUS
SELECT upper(te.localidad)
FROM empleado te
ORDER BY 1;

--27. Esta cuestión puntúa por 2. Se desea dar una gratificación por navidades en 
--función de la antigüedad en la empresa siguiendo estas pautas:
--1. Si lleva entre 1 y 5 años, se le dará 100 euros
--2. Si lleva entre 6 y 10 años, se le dará 50 euros por año
--3. Si lleva entre 11 y 20 años, se le dará 70 euros por año
--4. Si lleva más de 21 años, se le dará 100 euros por año
--28. Obtener un listado de los empleados,ordenado alfabéticamente,indicando 
--cuánto le corresponde de gratificación.
select nombre, ape1, ape2,TRUNC(MONTHS_BETWEEN(SYSDATE,FECHAINGRESO)/12) antiguedad from empleado; -- veamos la antiguedad

--28. Obtener un listado de los empleados,ordenado alfabéticamente,indicando 
--cuánto le corresponde de gratificación.
SELECT nombre, ape1, ape2, años_antiguedad, CASE
    WHEN años_antiguedad BETWEEN 1 AND 5   THEN
        100
    WHEN años_antiguedad BETWEEN 6 AND 10  THEN
        50 * años_antiguedad
    WHEN años_antiguedad BETWEEN 11 AND 20 THEN
        70 * años_antiguedad
    WHEN años_antiguedad >= 21             THEN
        100 * años_antiguedad
                                            END gratificacion
FROM ( SELECT nombre, ape1, ape2, trunc(months_between(sysdate, fechaingreso) / 12) años_antiguedad 
-- una subselect en la cláusula from me permite simplificar la expresión de la select externa, poniendo antiguedad en lugar de la expresión MONTHS_BETWEEN...

       FROM empleado
     )
ORDER BY nombre, ape2, ape2 ASC;


-- la union de consultas es otra opción, menos bonita que tampoco gana en eficiencia, pero arroja el mismo resultado
SELECT nombre, ape1, ape2,TRUNC(MONTHS_BETWEEN(SYSDATE,FECHAINGRESO)/12) antiguedad, 100 AS gratificacion
FROM empleado
WHERE TRUNC(MONTHS_BETWEEN(SYSDATE,FECHAINGRESO)/12) BETWEEN 1 AND 5

UNION

SELECT nombre, ape1, ape2, TRUNC(MONTHS_BETWEEN(SYSDATE,FECHAINGRESO)/12) antiguedad, 50 * TRUNC(MONTHS_BETWEEN(SYSDATE,FECHAINGRESO)/12)
FROM empleado
WHERE TRUNC(MONTHS_BETWEEN(SYSDATE,FECHAINGRESO)/12) BETWEEN 6 AND 10

UNION

SELECT nombre, ape1, ape2, TRUNC(MONTHS_BETWEEN(SYSDATE,FECHAINGRESO)/12) antiguedad,70 * TRUNC(MONTHS_BETWEEN(SYSDATE,FECHAINGRESO)/12)
FROM empleado
WHERE TRUNC(MONTHS_BETWEEN(SYSDATE,FECHAINGRESO)/12) BETWEEN 11 AND 20

UNION

SELECT nombre, ape1, ape2,TRUNC(MONTHS_BETWEEN(SYSDATE,FECHAINGRESO)/12) antiguedad, 100 * TRUNC(MONTHS_BETWEEN(SYSDATE,FECHAINGRESO)/12)
FROM empleado
WHERE TRUNC(MONTHS_BETWEEN(SYSDATE,FECHAINGRESO)/12) >= 21
ORDER BY 2, 3, 1;


/*28 Obtener un listado de los empleados,ordenado alfabéticamente,indicando cuánto le corresponde de gratificación.*/
SELECT
    nombre,
    ape1,
    ape2,fechaingreso,
    round(months_between( -- aquí podéis observar cómo se reptite la expresión round(months_between..... ,por eso lo de la subselect en la cláusula from me parece mejor opción
        sysdate, fechaingreso
    ) / 12) AS "años de antigüedad",
    CASE
    WHEN round(months_between(
        sysdate, fechaingreso
    ) / 12) BETWEEN 1 AND 5   THEN
    100
    WHEN round(months_between(
        sysdate, fechaingreso
    ) / 12) BETWEEN 6 AND 10  THEN
    ( round(months_between(
        sysdate, fechaingreso
    ) / 12) ) * 50
    WHEN round(months_between(
        sysdate, fechaingreso
    ) / 12) BETWEEN 11 AND 20 THEN
    ( round(months_between(
        sysdate, fechaingreso
    ) / 12) ) * 70
    ELSE
    round(months_between(
        sysdate, fechaingreso
    ) / 12) * 100
    END     gratificacion
FROM
    empleado
;



--29. Obtener a los nombres, apellidos de los empleados que no son jefes de 
--departamento.
SELECT nombre, ape1, ape2
FROM empleado
WHERE codemple NOT IN ( SELECT DISTINCT codemplejefe
                        FROM dpto
                      );
                      
                      
-- SUBCONSULTAS sencillas, NO CORRELACIONADAS
-- ---------------------------------------------
-- Hay consultas que se pueden resolver tanto con subconsultas como con combinaciones
-- En los casos de que se comprueba la existencia la combinación suele producir mejor rendimiento
-- Aquí las resolveremos preferentemente con subconsultas, que son los ejemplos que buscamos
-- El resultado de la consulta solo puede incluir las columnas que aparecen en la select externa 
-- Las consultas correlacionadas dependen de la consulta externa que les pasa valores a modo de "parámetro",
-- y por lo tanto deben ejecutarse más de una vez, es decir, por cada fila de la consulta externa deben 
-- de volver a ejecutarse.
-- Comenzaremos por las no correlacionadas que pueden ejecutarse por separado de la consulta externa
-- y realmente pueden ejecutarse una sóla vez (su resulado es el mismo, no depende de la consulta externa).

select * from dpto;
select * from centro;
select * from categoria;
select * from empleado;

-- Empleados que trabajan en el departamento de Fabiola Sanchez
SELECT *
FROM empleado  
where coddpto = (select coddpto from empleado where nombre='FABIOLA' and ape1='SANCHEZ');
-- Si la subconsulta nos puediese regresar un conjunto de valores podríamos emplear el operador "IN" o "= some"
-- En este ejemplo la subconsulta o será vacía (si no existe tal empleado),
--    o devuelve una fila si sólo existe una Fabiola Sanchez
--    o podría devolver más de una fila si hubiese más de una Fabiola Sanchez
SELECT *
FROM empleado
where coddpto in (select coddpto from empleado where nombre='FABIOLA' and ape1='SANCHEZ');

SELECT *
FROM empleado
where coddpto = some (select coddpto from empleado where nombre='FABIOLA' and ape1='SANCHEZ');

-- Empleados que trabajan el el departamento de Dirección
-- Podríamos resolverla con una combinación de tablas, pero vamos ahora a usar una subconsulta
SELECT *
from empleado
where coddpto=(select coddpto from dpto where denominacion='DIRECCIÓN');
-- Teniendo en cuenta que no puede haber dos departamentos con la misma denominación empleamos la igualdad

-- Departamentos que tienen más presupuesto que el de Administracion
select * from dpto
where presupuesto > (select presupuesto from dpto where denominacion='ADMINISTRACION');

-- Departamentos que dirige Ana Lopez
select *
from dpto
where codemplejefe=(select codemple from empleado where nombre='ANA' and ape1='LOPEZ');
select *
from dpto
where codemplejefe in (select codemple from empleado where nombre='ANA' and ape1='LOPEZ');

-- Empleados que trabajan en alguno de los departamentos que dirige el Ana Lopez
-- Con subconsultas
select *
from empleado
where coddpto in (select coddpto 
                  from dpto 
                  where  codemplejefe in (select codemple 
                                          from empleado 
                                          where nombre='ANA' and ape1='LOPEZ') 
                  );      
                  
-- Listado de empleados que viven en las ubicaciones de los departamentos 1 y 2
-- Listado de empleados que viven en las ubicaciones de los departamentos cuyo nombre comienza por la letra A
-- Departamentos que no existen en la tabla de empleados
-- Categorias que no existen en la tabla de empleados


                            
-- SUBCONSULTAS CORRELACIONADAS
-- ---------------------------------
-- El empleado que más cobra de cada localidad (localidad en que habitan)
select * from empleado;
select nombre, localidad, salario
from empleado e1
where e1.salario =(select max(e2.salario) from empleado e2 where e1.localidad=e2.localidad)
order by localidad;

-- MÁS EJEMPLOS similares
-- 

-- El empleado que más cobra de cada  departamento

-- El empleado que menos cobra de cada localidad

-- El empleado que menos cobra de caa departamento

-- El empleado que cobra más (o menos) que la media de su departamento (o localidad)

-- Los empleados que tienen más atiguedad de cada departamento/localidad

-- Los empleados que tienen más atiguedad que  la media de su departamento/localidad

-- Similares a las anteriore pero con el nombre de departamento o nombre de categoría
-- El empleado que más cobra de cada categoría: nombre de la categoria, nombre y salario del empleado 
select categoria.denom, e1.nombre, e1.ape1, e1. salario
from empleado e1 join categoria on e1.codcate=categoria.codcate
where e1.salario = (select max(e2.salario) from empleado e2 where e1.codcate=e2.codcate);
  
-- El empleado que más cobra de cada departamento: nombre departamento, nombre empleado, salario

-- MÁS EJEMPLOS
-- Lista de departamentos en los que hay empleados que cobran más que la media de la empresa

-- Lista de empleados que cobran más que la media de la empresa (salario total)
-- Lista de empleados cuyo salario es superior a la media de su departamento y además cobran comisión

-- Lista de empleados que no trabajan en departamentos ubicados en centros de Madrid
-- Lista de centros donde hay altos directivos
-- Lista de empleados que cobran más que el menor salario de un alto directivo


select * from empleado join categoria on empleado.codcate=categoria.codcate;



-- En Transact-SQL, una subconsulta se puede usar en el lugar en que se puede 
-- usar una expresión en las instrucciones SELECT, UPDATE, INSERT y DELETE,
-- excepto en una lista ORDER BY.
-- Nombre y salario de cada empleado, junto con el salario medio y 
-- la diferencia entre el salario del empleado y el salario medio
select nombre, salario, 
      (select avg(salario) from empleado) as SalarioMedio,
      salario - (select avg(salario) from empleado) as DiferenciaConSalarioMedio
from empleado;

-- Categoria con el salario medio de cada categoria, 
-- acompañado del salario medio de la empresa
-- y la diferencia entre el salario medio de la categoria y el salario medio de la empresa




-- SUBCONSULTAS, AGRUPAMIENTO Y MULTITABLA
/*Listado de empleados que cobran más que el salario  medio del departemento en el cual trabajan.*
Listar: Nombre del departamento, nombre y apellidos del empleado, salario del empleado, 
salario medio del departamento, diferencia entre el salario del empleado y el salario medio de su departamento*/   
/* VAMOS POR PARTES 
Listado de empleados acompañado del nombre de departamento.
Listar nombre del departamento, nombre y apellidos del empleado, salario del empleado*/
SELECT
    *
FROM
    empleado;

SELECT
    denominacion,
    nombre,
    ape1,
    salario
FROM
    empleado e1
    JOIN dpto ON e1.coddpto = dpto.coddpto;
/*Listado de empleados que cobran más que el salario  medio del departemento en el cual trabajan.*
Listar: Nombre del departamento, nombre y apellidos del empleado, salario del empleado*/
SELECT
    denominacion,
    nombre,
    ape1,
    salario
FROM
    empleado e1
    JOIN dpto ON e1.coddpto = dpto.coddpto
WHERE
    e1.salario > (
        SELECT
            AVG(salario)
        FROM
            empleado e2
        WHERE
            e2.coddpto = e1.coddpto
    );
    
    select * from empleado;
    
    
/*Listado de empleados que cobran más que el salario  medio del departemento en el cual trabajan.*
Listar: Nombre del departamento, nombre y apellidos del empleado, salario del empleado, 
salario medio del departamento, diferencia entre el salario del empleado y el salario medio de su departamento*/    
SELECT
    denominacion,
    nombre,
    ape1,
    salario, mediaDepartamento, salario-mediaDepartamento diferencia
FROM
    empleado e1
    JOIN dpto ON e1.coddpto = dpto.coddpto 
    join (select  e3.coddpto CODDEP, avg(e3.salario) as mediaDepartamento
          from empleado e3
          group by coddpto)  on e1.coddpto=CODDEP
WHERE
    e1.salario > (
        SELECT
            AVG(salario)
        FROM
            empleado e2
        WHERE
            e2.coddpto = e1.coddpto
    );
/*Listado con el nombre de departamento y el número de empleados que cobran más
que la media salarial del departamento*/

SELECT
    denominacion,
    count(*)
FROM
    empleado e1
    JOIN dpto ON e1.coddpto = dpto.coddpto
WHERE
    e1.salario > (
        SELECT
            AVG(salario)
        FROM
            empleado e2
        WHERE
            e2.coddpto = e1.coddpto
    )
group by denominacion;




-- REPASO CONSULTAS MULTITABLA
/* Comenzamos por el PRODUCTO CARTESIANO de dos tablas (empleado y dpto). 
Esto es lo que ocurre si no ponemos condición para combinar las tablas
*/
select * -- todas las columnas de ambas tablas
from empleado, dpto; -- Producto cartesiano, no hay condición de combinación
                    -- Aparecerá cada empleado junto a cada dpartamento

/*En esta base de datos hay un par derelaciones entre la tablas empleado y dpto
- Cada empleado trabaja en un departamento, la columna empleado.coddpto 
  es clave foránea que referencia a la columna dpto.coddpto
  
- Cada departamento tiene un empleado que es jefe de ese departamento, otra vez
  tenemos dpto.codemplejefe como clave foránea que referencia a empleado.codemple
  
Cuando queremos emplear varias tablas en una consulta lo normal es combinarlas 
adecuadamente en relación a la semántica expresada en los datos almacenados.
Por ejemplo, si pretendemos listar los datos de los empleados acompañados
de los datos del departemento en el cual trabajan; deberemos tener en cuenta
que la columna empleado.coddpto tiene el código de departamento (dpto.coddpto)
donde trabaja dicho empleado. */
-- Datos de los empleados junto con los datos del departamento en el que trabajan
select * 
from empleado, dpto  
where empleado.coddpto=dpto.coddpto; -- aquí vemos la condición del join.
/* Es necesario que el nombre de las columnas vaya precedido del nombre de la tabla 
para diferenciarlos, pues se llaman igual y sería ambiguo */


-- También se puede expresar con la siguiente sintaxis:
select * -- todas las columnas de ambas tablas
from empleado join dpto on empleado.coddpto=dpto.coddpto; -- misma condición, distinta sintaxis

-- Una vez combinadas ambas tablas podemos hacer cualquier operación sobre esos datos
-- Listar el nombre del empleado, el salario y el nombre del departamento en el cual trabaja
select nombre, salario, denominacion 
from empleado, dpto
where empleado.coddpto=dpto.coddpto; 
-- O incluso filtrar los datos y ordenar los resultados
-- Nombre, salario y departamento de los empleados cuyo salario es superior a 1500
-- En orden descendente por salario
select nombre, salario, denominacion  
from empleado, dpto
where empleado.coddpto=dpto.coddpto
  AND salario >1500
order by salario desc; 
-- Nombre, salario y departamento de los empleados cuyo sueldo total es superior a 1500
-- En orden descendente por salario 
-- El salario total es el salario + comision, si la comision es null sumamos cero
-- nvl(a,b) si a es diferente de null devuelve a y si es null devuelve b
select nombre, salario, comision, 
       salario+nvl(comision,0) AS sueldo,  -- sueldo es el alias de la columna, para que salga más bonito ;), el AS es opcional
       denominacion  nombreDepartamento -- nobmreDepartamento es el encabezado en el resultado
from empleado, dpto
where empleado.coddpto=dpto.coddpto
  AND  salario+nvl(comision,0)  >1500
order by salario desc; 

-- Otros ejemplOS de JOIN SENCILLOS
-- Listar los datos de los departamentos acompañador de los datos de la persona que lo dirige
select *
from dpto, empleado
where dpto.codemplejefe=empleado.codemple; -- jodemple jefe hace referencia a empleado.codemple
-- Listar cada departamento junto a los datos del centro en que está ubicado
select *
from dpto, centro
where dpto.codcentro=centro.codcentro;
-- Podemos usar alias de tabla para abreviar
select *
from dpto  d, centro c -- d es alias de dpto, c es alias de centro
where d.codcentro=c.codcentro;

-- Listar los datos de cada empleado junto con la categoría profesional
select *
from empleado, categoria
where empleado.codcate=categoria.codcate;
-- Todas tienen su equivalente con la sintaxis join en este caso:
select *
from empleado join categoria on empleado.codcate=categoria.codcate;

-- Listado con los nombres y apellidos de empleados que son administrativos
select nombre, ape1, ape2   -- Si añadimos la columna categoria.denom a la salida comprobaremos el filtrado
from empleado, categoria
where empleado.codcate=categoria.codcate
 AND categoria.denom='ADMINISTRATIVOS';


-- Ahora una igual de fácil (dos tablas) pero que a veces nos descoloca:
-- Listado de cada departamento junto con los datos del departamento del cual depende
-- depto.coddptodepende contiene el código del departamento del cual depende, 
-- vamos es clave foránea que referencia a la columna coddpto de la misma tabla (relación reflexiva, una tabla consigo misma)
select *
from dpto d, dpto dptoSuperior
where d.coddptodepende=dptoSuperior.coddpto; -- observar en el resultado los valores de las columnas que intervienen en la condición

-- Si sólo queremos un listado con el nombre de cada departamento  y el nombre del departamento superior:
select d.denominacion AS departamento, dptoSuperior.denominacion AS departamentoSuperior
from dpto d, dpto dptoSuperior
where d.coddptodepende=dptoSuperior.coddpto; 

-- Subimos el nivel de complejidad TRES TABLAS
-- Listado de empleados, con los datos del departamento en el que trabaja 
-- y también de los datos del centro donde se ubica dicho departamento
-- Aquí intervienen tres tablas, empleado.coddpto nos indica el departamento en el cual trabaja un empleado
-- y departamento.codcentro nos indica el centro donde se ubica dicho departamento
SELECT *
from empleado, dpto, centro
where empleado.coddpto=dpto.coddpto   -- empleado.coddpto referencia a la tabla dpto, en concreto a dpto.coddpto, las claves foráneas apuntan a claves primarias de otra tabla
  AND dpto.codcentro=centro.codcentro;  -- dpto.codcentro referencia a centro.codcentro
  
-- y si solo queremos listar el nombre y primer apellido de los empleados junto con la dirección del centro en el cual trabajan?
-- en ese caso tenemos igualmente que relacionar correctgamente las tablas, y sacamos los datos que necesitamos
-- Si observáis el diagrama de las tablas observaréis que para ir de empleado a centro necesitamos también la tabla dpto
SELECT empleado.nombre, empleado.ape1, centro.direccion
from empleado, dpto, centro
where empleado.coddpto=dpto.coddpto   
  AND dpto.codcentro=centro.codcentro;

-- Por cierto el orden en que aparecen listadas las tablas implicadas no es relevante
-- pero sí ayuda ponerlas en el orden lógico (de empleado vamos a dpto y luego a centro)
-- para no equivocarnos con las condiciones.
-- con JoinSERÍA, aquí debemos tener más cuidado al colocar orden lógico para no obtener el resultado deseado
SELECT empleado.nombre, empleado.ape1, centro.direccion
from empleado JOIN  dpto ON empleado.coddpto=dpto.coddpto  JOIN  centro ON dpto.codcentro=centro.codcentro;


-- OUTER JOIN
-- Qué son los outer join o combinaciones externas? En una combinación interna (las que hicimos hasta ahora)
--  la condición de igualdad implica que por ejemplo en un listado de empleados con los datows de los departamentos en que trabajan
--  solo saldría en el resultado aquellos departamentos que tienen algún empleado trabajando en el, en otro caso no se cumple la igualdad
-- Agreguemos un nuevo departamento para apreciar la diferencia
SELECT * FROM DPTO;
insert into dpto values (08,'PRUEBA',03,05,04,'F',40000); COMMIT;
-- Con inner join no saldría el nuevo departamento, pues coddpto=08 nunca aparece en la tabla empleados
SELECT NOMBRE, DENOMINACION
FROM EMPLEADO   JOIN DPTO ON EMPLEADO.CODDPTO=DPTO.CODDPTO 
order by denominacion;
-- Con outer join podemos forzar a que el resultado muestro todas las filas de la tabla de la izquierda (left), derecha (right) o ambas (full)
-- Si queremos un listado como el anterior en el que salgan todos los departamentos:
SELECT NOMBRE, DENOMINACION
-- RIGHT, SE INCLUYEN  TODAS LAS FILAS DE LA TABLA DE LA DERECHA (EMPLEADO) EN LA COMBINACIÓN
FROM EMPLEADO RIGHT OUTER JOIN DPTO ON EMPLEADO.CODDPTO=DPTO.CODDPTO
order by denominacion;
-- observamos que el nombre del empleado aparece null, pues no existe un empleado que trabaje en el departamento 08-prueba
-- Si invertimos el orden de aparición de las tablas tendríamos un left join

SELECT NOMBRE, DENOMINACION
FROM DPTO LEFT OUTER JOIN EMPLEADO ON EMPLEADO.CODDPTO=DPTO.CODDPTO
order by denominacion;

-- Una vez combinadas las tablas podemos filtrar las filas, agrupar, listar los campos que deseemos
-- Listado con el nombre y número de empleados de cada departamento

SELECT DENOMINACION, COUNT(*)-- /!\ERROR, exite una fila en la combinación con los datos del empleado a null, así que da 1 empleado en el departamento PRUEBA
FROM EMPLEADO RIGHT OUTER JOIN DPTO ON EMPLEADO.CODDPTO=DPTO.CODDPTO
GROUP BY DENOMINACION;

SELECT DENOMINACION, COUNT(EMPLEADO.CODDPTO)-- ASÍ SÍ, CORRECTO
FROM EMPLEADO RIGHT OUTER JOIN DPTO ON EMPLEADO.CODDPTO=DPTO.CODDPTO
GROUP BY DENOMINACION;



SELECT * FROM EMPLEADO ;


-- DEPARTAMENTO Y JEFE
SELECT *
FROM DPTO, EMPLEADO
WHERE DPTO.CODEMPLEJEFE=EMPLEADO.CODEMPLE;

-- EMPLEADO CURRITO - DEPARTAMENTO -- JEFE
-- nOMBRE JEFE Y NUMERO SUBORDINADOS
SELECT e2.CODEMPLE, E2.NOMBRE, count(*)
FROM EMPLEADO E1, DPTO, EMPLEADO E2
WHERE E1.CODDPTO=DPTO.CODDPTO   -- LIGO E1 CON DEPARTAMENTO EN QUE TRABAJA
  AND DPTO.CODEMPLEJEFE=E2.CODEMPLE -- LIGO AHORA ESE DEPARTAMENTO CON EL JEFE
 group by E2.codemple, E2.NOMBRE;
 
 --- NOMBRE CENTRO NUMERO DE EMPLEADOS
 
SELECT CENTRO.CODCENTRO,CENTRO.DIRECCION,  COUNT(*)
FROM CENTRO, DPTO, EMPLEADO
WHERE CENTRO.CODCENTRO=DPTO.CODCENTRO AND DPTO.CODDPTO=EMPLEADO.CODDPTO
AND SALARIO >2000 OR SALARIO=NULL
GROUP BY CENTRO.CODCENTRO, CENTRO.DIRECCION 
HAVING COUNT(*)>1
ORDER BY 2;











                      
                      
                      
                      

                      
