/* PROCEDURES PARA LLENAR LAS DIMENSIONES */

/* D_TIEMPO */

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
      seq_d_tiempo.nextval,
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

/* D_MEDICAMENTO_VENTAS */

create or replace PROCEDURE ACTUALIZA_MEDICAMENTO_VENTAS AS
BEGIN
 insert into D_MEDICAMENTO_VENTAS
 select seq_d_medicamento_ventas.nextval, cvp.id, cvp.venta_id, ci.medicamento_id, cm.nombre, cm.ingrediente_activo, cv.punto_de_venta_id, cpv.nombre
 from catalogo_ventas_partidas cvp, catalogo_inventario ci, catalogo_medicamentos cm, catalogo_ventas cv, catalogo_punto_de_venta cpv
 where cvp.inventario_id = ci.id AND ci.medicamento_id = cm.id AND cvp.venta_id = cv.id AND cv.punto_de_venta_id = cpv.id;
END ACTUALIZA_MEDICAMENTO_VENTAS;

/* D_EMPLEADO_VENTAS_EMPLEADO */

create or replace PROCEDURE ACTUALIZA_EMPLEADO_VENTAS_EMP AS
BEGIN
 insert into D_EMPLEADO_VENTAS_EMPLEADO
 select seq_d_empleado_ventas_empleado.nextval, ce.id, ce.nombre, ce.apellidos, ce.punto_de_venta_id, cpv.nombre
 from catalogo_empleados ce, catalogo_punto_de_venta cpv
 where cpv.id = ce.punto_de_venta_id;
END ACTUALIZA_EMPLEADO_VENTAS_EMP;

/* D_CLIENTE_VENTAS_CLIENTE */

create or replace PROCEDURE ACTUALIZA_CLIENTE_VENTAS_CLI AS
BEGIN
 insert into D_CLIENTE_VENTAS_CLIENTE
 select seq_d_cliente_ventas_cliente.nextval, cc.id, cc.nombre, cc.apellidos, cc.colonia
 from catalogo_clientes cc;
END ACTUALIZA_CLIENTE_VENTAS_CLI;

/* D_MEDICAMENTO_COMPRAS_PROVEEDOR */

create or replace PROCEDURE ACTUALIZA_MED_COMPRAS_PROV AS
BEGIN
 insert into D_MEDICAMENTO_COMPRAS_PROV
 select seq_d_medicamento_compras_prov.nextval, cc.id, cc.medicamento_id, cm.nombre, cc.punto_de_venta_id, cpv.nombre
 from catalogo_compras cc, catalogo_medicamentos cm, catalogo_punto_de_venta cpv
 where cc.medicamento_id = cm.id AND cc.punto_de_venta_id = cpv.id;
END ACTUALIZA_MED_COMPRAS_PROV;

/* D_MEDICAMENTO_INVENTARIO */

create or replace PROCEDURE ACTUALIZA_MEDICAMENTO_INV AS
BEGIN
 insert into D_MEDICAMENTO_INVENTARIO
 select seq_d_medicamento_inventario.nextval, ci.medicamento_id, cm.nombre, ci.punto_de_venta_id, cpv.nombre
 from catalogo_inventario ci, catalogo_medicamentos cm, catalogo_punto_de_venta cpv
 where ci.medicamento_id = cm.id AND ci.punto_de_venta_id = cpv.id;
END ACTUALIZA_MEDICAMENTO_INV;

/* D_MEDICAMENTO_PROVEEDOR_COMPRAS_PROV */

create or replace PROCEDURE ACTUALIZA_PROV_COMPRAS_PROV AS
BEGIN
 insert into D_PROVEEDOR_COMPRAS_PROV
 select seq_d_proveedor_compras_prov.nextval, cp.id, cp.nombre
 from catalogo_proveedores cp;
END ACTUALIZA_PROV_COMPRAS_PROV;