# JavierPegoCD04
Práctica 4 de Contornos de Desarrollo IES RODEIRA

**************PATRONES DE REFACTORIZACIÓN*******************

Algunos de los patrones más habituales de refactorización, que vienen ya integrados en la mayoría de los entornos de desarrollos, son los siguientes:
Renombrar. Cambiar el nombre de un paquete, clase, método o campo, por un nombre más significativo.
Encapsular campos. Crear métodos de asignación y de consulta (getters y setters) para los campos de la clase, que permitan un control sobre el acceso de estos campos, debiendo hacerse siempre mediante el uso de estos métodos.
Sustituir bloques de código por un método. En ocasiones se observa que un bloque de código puede constituir el cuerpo de un método, dado que implementa una función por si mismo o aparece repetido en múltiples sitios. De esta forma, cada vez que queramos acceder a ese bloque de código, bastaría con invocar al método.
Modificar la extensión del código. Hacer un código más extenso si se gana en claridad o menos extenso sólo  si con eso se gana eficiencia.
Reorganizar código condicional complejo. Patrón aplicable cuando existen varios if o condiciones anidadas o complejas.
Crear código común (en una clase o método) para evitar el código repetido.
Mover la clase. Mover una clase de un paquete a otro, o de un proyecto a otro. Esto implica la actualización en todo el código fuente de las referencias a la clase en su nueva localización.
Borrado seguro. Garantizar que cuando un elemento del código ya no es necesario, se borran todas la referencias a él que había en cualquier parte del proyecto.
Cambiar los parámetros del método. Permite añadir/modificar/eliminar los parámetros en un método y cambiar los modificadores de acceso.
Extraer la interfaz. Crea un nueva interfaz de los métodos public non-static seleccionados en una clase o interfaz.

*****************ANALIZADORES DE CÓDIGO*********************

Las principales funciones de los analizadores es encontrar partes del código que puedan reducir el rendimiento, provocar errores en el software, tener una excesiva complejidad, complicar el flujo de datos, crear problemas de seguridad.

****************TIPOS DE HERRAMIENTAS PARA EL CONTROL DE VERSIONES*******************

2.1.- Tipos de herramientas de control de versiones.
e acuerdo al modo de organizar la información, se pueden clasificar las herramienta de control de versiones como:

Sistemas locales: se trata del control de versiones donde la información se guarda en diferentes directorios en función de sus versiones. Toda la gestión recae sobre el responsable del proyecto y no se dispone de herramientas que automaticen el proceso. Es viable para pequeños proyectos donde el trabajo es desarrollado por un único programador.
Sistemas centralizados: responden a una arquitectura cliente-servidor. Un único equipo tiene todos los archivos en sus diferentes versiones, y los clientes replican esta información en sus entornos de trabajo locales. El principal inconveniente es que el servidor es un dispositivo crítico para el sistema ante posibles fallos.
 
Sistemas distribuidos: en este modelo cada sistema hace con una copia completa de los ficheros de trabajo y de todas sus versiones. El rol de todos los equipos es de igual a igual y los cambios se pueden sincronizar entre cada par de copias disponibles. Aunque técnicamente todos los repositorios tienen la posibilidad de actuar como punto de referencia; habitualmente funcionan siendo uno el repositorio principal y el resto asumiendo un papel de clientes sincronizando sus cambios con éste.

*******************************SISTEMA DE CONTROL DE VERSIONES*****************************************

El sistema de control de versiones está formado por un conjunto de componentes:

Repositorio: es el lugar de almacenamiento de los datos de los proyectos. Suele ser un directorio en algún ordenador.
Módulo: en un directorio especifico del repositorio. Puede identificar una parte del proyecto o ser el proyecto por completo.
Revisión: es cada una de las versiones parciales o cambios en los archivos o repositorio completo. La evolución del sistema se mide en revisiones. Cada cambio se considera incremental.
Etiqueta: información textual que se añada a un conjunto de archivos o a un módulo completo para indicar alguna información importante.
Rama: revisiones paralelas de un módulo para efectuar cambios sin tocar la evolución principal. Se suele emplear para pruebas o para mantener los cambios en versiones antiguas.
Algunos de los servicios que típicamente proporcionan son:

Creación de repositorios. Creación del esqueleto de un repositorio sin información inicial del proyecto.
Clonación de repositorios. La clonación crea un nuevo repositorio y vuelca la información de algún otro repositorio ya existente. Crea una réplica.
Descarga de la información del repositorio principal al local. Sincroniza la copia local con la información disponible en el repositorio principal.
Carga de información al repositorio principal desde el local. Actualiza los cambios realizados en la copia local en el repositorio principal.
Gestión de conflictos. En ocasiones, los cambios que se desean consolidar en el repositorio principal entran en conflicto con otros cambios que hayan sido subidos por algún otro desarrollador. Cuando se da esta situación, las herramientas de control de versiones tratan de combinar automáticamente todos los cambios. Si no es posible sin pérdida de información, muestra al programador los conflictos acontecidos para que sea éste el que tome la decisión de como combinarlos.
Gestión de ramas. Creación, eliminación , integración de diferencias entre ramas, selección de la rama de trabajo.
Información sobre registro de actualizaciones.
Comparativa de versiones. Genera información sobre las diferencias entre versiones del proyecto.


Las órdenes que se pueden ejecutar son:

checkout: obtiene un copia del trabajo para poder trabajar con ella.
Update: actualiza la copia con cambios recientes en el repositorio.
Commit: almacena la copia modificada en el repositorio.
Abort: abandona los cambios en la copia de trabajo.

******************************HERRAMIENTAS DE CONTROL DE VERSIONES***************************

SourceSafe: es una herramienta que forma parte del entorno de desarrollo Microsoft Visual Studio.
Visual Studio Team Foundation Server: es el sustituto de Source Safe. Es un productor que ofrece control de código fuente, recolección de datos, informes y seguimiento de proyectos, y está destinado a proyectos de colaboración de desarrollo de software.
Darcs: es un sistema de gestión de versiones distribuido. Algunas de sus características son: la posibilidad de hacer commits locales (sin conexión), cada repositorio es una rama en sí misma, independencia de un servidor central, posibilidad de renombrar ficheros, varios métodos de acceso como local, ssh, http y ftp, etc.
Git: esta herramienta de control de versiones, diseñada por Linus Torvalds.
Mercurial: esta herramienta funciona en Linux, Windows y Mac OS X, Es un programa de línea de comandos. Es una herramienta que permite que el desarrollo se haga distribuido, gestionando de forma robusta archivos de texto y binarios. Tiene capacidades avanzadas de ramificación e integración. Es una herramienta que incluye una interfaz web para su configuración y uso.

*******************PLANIFICACION Y GESTION DE CONFIGURACIONES***************
La planificación de las Gestión de Configuraciones del software, está regulado en el estándar IEEE 828.

Cuando se habla de la gestión de configuraciones, se está haciendo referencia a la evolución de todo un conjunto de elementos. Una configuración es una combinación de versiones particulares de los componentes que forman un sistema consistente. Desde el punto de vista de la evolución en el tiempo, es el conjunto de las versiones de los objetos componentes en un instante dado.

Una configuración puede cambiar porque se añaden, eliminan o se modifican elementos. También puede cambiar, debido a la reorganización de los componentes, sin que estos cambien.

Como consecuencia de lo expuesto, es necesario disponer de un método, que nos permita designar las diferentes configuraciones de manera sistemática y planificada. De esta forma se facilita el desarrollo de software de manera evolutiva, mediante cambios sucesivos aplicados a partir de una configuración inicial hasta llegar a una versión final aceptable del producto.

La Gestión de Configuraciones de Software se va a componer de cuatro tareas básicas:

Identificación. Se trata de establecer estándares de documentación y un esquema de identificación de documentos.
Control de cambios. Consiste en la evaluación y registro de todos los cambios que se hagan de la configuración software.
Auditorías de configuraciones. Sirven, junto con las revisiones técnicas formales para garantizar que el cambio se ha implementado correctamente.
Generación de informes. El sistema software está compuesto por un conjunto de elementos, que evolucionan de manera individual, por consiguiente, se debe garantizar la consistencia del conjunto del sistema.

******************DOCUMENTACIÓN DEL CÓDIGO*******************

El proceso de documentación de código, es uno de los aspectos más importantes de la labor de un programador. Documentar el código nos sirve para explicar su funcionamiento, punto por punto, de forma que cualquier persona que lea el comentario, puede entender la finalidad del código.
En la actualidad, el desarrollo rápido de aplicaciones, en muchos casos, va en detrimento de una buena documentación del código. Si el código no está documentado, puede resultar bastante difícil de entender, y por tanto de solucionar errores y de mantenerlo.

La labor de documentación es fundamental para la detección de errores y para su mantenimiento posterior, que en muchos casos, es realizado por personas diferentes a las que intervinieron en su creación. Hay que tener en cuenta que todos los programas tienen errores y todos los programas sufren modificaciones a los largo de su vida.

La documentación añade explicaciones de la función del código, de las características de un método, etc. Debe tratar de explicar todo lo que no resulta evidente. Su objetivo no es repetir lo que hace el código, sino explicar por qué se hace.

La documentación explicará cuál es la finalidad de un clase, de un paquete, qué hace un método, para qué sirve una variable, qué se espera del uso de una variable, qué algoritmo se usa, por qué hemos implementado de una manera y no de otra, qué se podría mejorar en el futuro, etc.
