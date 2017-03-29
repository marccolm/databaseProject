/* Creación link de la base de datos */
create database link qro connect to a1203445 identified by e3UwrqXd using 'qro';
/* Creación vistas para facilitar carga de datos */
create view catalogo_medicamentos as select * from MEDICAMENTO@qro;
create view catalogo_ventas as select * from venta@qro;
create view catalogo_ventas_partidas as select * from venta_partida@qro;
create view catalogo_empleados as select * from empleado@qro;
create view catalogo_clientes as select * from cliente@qro;

/* Creación y llenado dimensión tiempo */

CREATE TABLE D_TIEMPO(
    ID NUMBER PRIMARY KEY, 
    FECHA DATE, 
    ANIO VARCHAR2(4), 
    MES VARCHAR2(30), 
    DIA NUMBER(10), 
    NOMBRE_DIA VARCHAR2(20)
);

create or replace PROCEDURE PDIMTIEMPO (
  fecha_inicial IN DATE,
  fecha_final IN DATE 
) AS 
fecha DATE;
v_anio VARCHAR2(4);
v_mes VARCHAR2(10);
v_dia NUMBER;
v_nombre_dia VARCHAR2(10);
BEGIN
  fecha := fecha_inicial;
  WHILE fecha <= fecha_final LOOP
    v_anio := TO_CHAR(fecha, 'YYYY');
    v_mes := TO_CHAR(fecha, 'MONTH');
    v_dia := TO_NUMBER(TO_CHAR(fecha, 'DD'));
    v_nombre_dia := TO_CHAR(fecha, 'YYYY');
    
    INSERT INTO D_TIEMPO values(
      lab5_seq_dimtiempo.nextval,
      fecha,
      v_anio,
      v_mes,
      v_dia,
      v_nombre_dia
    );
    commit;
    fecha := fecha + 1;
  END LOOP;
END PDIMTIEMPO;
execute pdimtiempo(to_date('01/01/2015 10:06:32 PM','MM/DD/YYYY HH:MI:SS AM'), to_date('12/31/2016 10:06:32 PM','MM/DD/YYYY HH:MI:SS AM'));


/* Creación de dimensión empleado */

CREATE TABLE D_EMPLEADO(
    ID NUMBER PRIMARY KEY, 
    EMPLEADO_ID NUMBER, 
    PUNTO_DE_VENTA_ID NUMBER,
    NOMBRE VARCHAR2(255),
    NOMBRE_PUNTO_DE_VENTA VARCHAR2(255)
);

/* Creación de dimensión medicamento */

CREATE TABLE D_MEDICAMENTO(
    ID NUMBER PRIMARY KEY, 
    VENTA_PARTIDA_ID NUMBER, 
    VENTA_ID NUMBER,
    MEDICAMENTO_ID NUMBER,
    NOMBRE VARCHAR2(255),
    INGREDIENTE_ACTIVO VARCHAR2(255)
);

/* Creación de dimensisón de cliente */

CREATE TABLE D_CLIENTE(
    ID NUMBER PRIMARY KEY, 
    CLIENTE_ID NUMBER, 
    NOMBRE VARCHAR2(255),
    COLONIA VARCHAR2(255),
    FECHA_ALTA DATE
);

/* Creación tabla hechos */

CREATE TABLE H_VENTAS(
    ID NUMBER PRIMARY KEY,
    D_TIEMPO_ID NUMBER,
    D_MEDICAMENTO_ID NUMBER, 
    D_CLIENTE_ID NUMBER,
    D_EMPLEADO_ID NUMBER,
    CANTIDAD NUMBER,
    CONSTRAINT D_TIEMPO_FK FOREIGN KEY(D_TIEMPO_ID) REFERENCES D_TIEMPO(ID),
    CONSTRAINT D_MEDICAMENTO_FK FOREIGN KEY(D_MEDICAMENTO_ID) REFERENCES D_MEDICAMENTO(ID),
    CONSTRAINT D_CLIENTE_FK FOREIGN KEY(D_CLIENTE_ID) REFERENCES D_CLIENTE(ID),
    CONSTRAINT D_EMPLEADO_FK FOREIGN KEY(D_EMPLEADO_ID) REFERENCES D_EMPLEADO(ID)
);

