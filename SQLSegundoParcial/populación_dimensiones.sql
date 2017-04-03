/* PROCEDURES PARA LLENAR LAS DIMENSIONES */

execute actualiza_cliente_ventas_cli
execute actualiza_empleado_ventas_emp
execute actualiza_med_compras_prov
execute actualiza_medicamento_inv
execute actualiza_medicamento_ventas
execute actualiza_prov_compras_prov
execute pdimtiempo(to_date('01/01/2014 10:06:32 PM','MM/DD/YYYY HH:MI:SS AM'), to_date('12/31/2016 10:06:32 PM','MM/DD/YYYY HH:MI:SS AM'));
execute actualiza_h_compras_proveedor(to_date('01/01/2014 10:06:32 PM','MM/DD/YYYY HH:MI:SS AM'), to_date('12/31/2016 10:06:32 PM','MM/DD/YYYY HH:MI:SS AM'));
execute actualiza_h_inventario(to_date('01/01/2014 10:06:32 PM','MM/DD/YYYY HH:MI:SS AM'), to_date('12/31/2016 10:06:32 PM','MM/DD/YYYY HH:MI:SS AM'));
execute actualiza_h_ventas_cli(to_date('01/01/2014 10:06:32 PM','MM/DD/YYYY HH:MI:SS AM'), to_date('12/31/2016 10:06:32 PM','MM/DD/YYYY HH:MI:SS AM'));
execute actualiza_h_ventas_emp(to_date('01/01/2014 10:06:32 PM','MM/DD/YYYY HH:MI:SS AM'), to_date('12/31/2016 10:06:32 PM','MM/DD/YYYY HH:MI:SS AM'));

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



/* H_INVENTARIO */
create or replace PROCEDURE ACTUALIZA_H_INVENTARIO 
(
  FECHAINICIAL IN DATE 
, FECHAFINAL IN DATE 
) AS 
fecha_inicial date;
fecha_final   date;
v_d_tiempo_id  number;
v_d_medicamento_id       number;
v_d_caducidad    date;
    
cursor c_tiempo is
select id from d_tiempo where fecha between fecha_inicial and fecha_final;

cursor c_inventario is
select dm.id, dt.id, ci.fecha_caducidad
from d_medicamento_inventario dm, d_tiempo dt, catalogo_inventario ci
where ci.medicamento_id = dm.medicamento_id
and trunc(ci.fecha_caducidad) < trunc(dt.fecha)
group by dt.id, dm.id, ci.fecha_caducidad
order by 1,2,3;

BEGIN
  fecha_inicial := FECHAINICIAL;
  fecha_final  := FECHAFINAL;
  
  open c_tiempo;
  LOOP
    /* Ejecucion del borrado de registros*/
    fetch c_tiempo into v_d_tiempo_id;
    exit when c_tiempo%NOTFOUND;
    delete from h_inventario where d_tiempo_id = v_d_tiempo_id ;
    commit;
  END LOOP;
  close c_tiempo;
  open c_inventario;
  LOOP
    /*Operación de inserción de registros*/
    fetch c_inventario into v_d_medicamento_id, v_d_tiempo_id, v_d_caducidad;
    exit when c_inventario%NOTFOUND;
    insert into h_inventario  (id, d_medicamento_id, d_tiempo_id, caducidad)
    values (seq_h_inventario.nextval, v_d_tiempo_id, v_d_medicamento_id, v_d_caducidad);
    commit;
  END LOOP;
  close c_inventario;
END ACTUALIZA_H_INVENTARIO;

/* H_VENTAS_CLI */

create or replace PROCEDURE ACTUALIZA_H_VENTAS_CLI 
(
  FECHAINICIAL IN DATE 
, FECHAFINAL IN DATE 
) AS 
fecha_inicial date;
fecha_final   date;
v_d_tiempo_id  number;
v_d_cliente_id    number;
v_d_medicamento_id       number;
v_cantidad    number;
v_costo number;
    
cursor c_tiempo is
select id from d_tiempo where fecha between fecha_inicial and fecha_final;

cursor c_ventas is
select dt.id, dm.id, dc.id, sum(cvp.cantidad), sum(cvp.cantidad * cvp.precio)
from catalogo_ventas_partidas cvp, d_cliente_ventas_cliente dc, d_medicamento_ventas dm, d_tiempo dt, catalogo_ventas cv
where cvp.venta_id = cv.id 
AND cv.fecha between fecha_inicial and fecha_final
and cv.cliente_id = dc.cliente_id
and trunc(cv.fecha) = trunc(dt.fecha)
and cv.id = dm.venta_id
group by dt.id, dm.id, dc.id
order by 1,2,3;

BEGIN
  fecha_inicial := FECHAINICIAL;
  fecha_final  := FECHAFINAL;
  
  open c_tiempo;
  LOOP
    /* Ejecucion del borrado de registros*/
    fetch c_tiempo into v_d_tiempo_id;
    exit when c_tiempo%NOTFOUND;
    delete from h_ventas_cliente where d_tiempo_id = v_d_tiempo_id ;
    commit;
  END LOOP;
  close c_tiempo;
  open c_ventas;
  LOOP
    /*Operación de inserción de registros*/
    fetch c_ventas into v_d_tiempo_id, v_d_medicamento_id, v_d_cliente_id, v_cantidad, v_costo;
    exit when c_ventas%NOTFOUND;
    insert into h_ventas_cliente  (id, d_tiempo_id, d_medicamento_id, d_cliente_id , cantidad, costo)
    values (seq_h_ventas_cliente.nextval, v_d_tiempo_id, v_d_medicamento_id, v_d_cliente_id, v_cantidad, v_costo);
    commit;
  END LOOP;
  close c_ventas;
END ACTUALIZA_H_VENTAS_CLI;

/* H_VENTAS_EMPLEADO */

create or replace PROCEDURE ACTUALIZA_H_VENTAS_EMP 
(
  FECHAINICIAL IN DATE 
, FECHAFINAL IN DATE 
) AS 
fecha_inicial date;
fecha_final   date;
v_d_tiempo_id  number;
v_d_empleado_id    number;
v_d_medicamento_id       number;
v_cantidad    number;
v_costo number;
    
cursor c_tiempo is
select id from d_tiempo where fecha between fecha_inicial and fecha_final;

cursor c_ventas is
select dt.id, dm.id, de.id, sum(cvp.cantidad), sum(cvp.cantidad * cvp.precio)
from catalogo_ventas_partidas cvp, d_empleado_ventas_empleado de, d_medicamento_ventas dm, d_tiempo dt, catalogo_ventas cv
where cvp.venta_id = cv.id 
AND cv.fecha between fecha_inicial and fecha_final
and cv.empleado_id = de.empleado_id
and trunc(cv.fecha) = trunc(dt.fecha)
and cv.id = dm.venta_id
group by dt.id, dm.id, de.id
order by 1,2,3;

BEGIN
  fecha_inicial := FECHAINICIAL;
  fecha_final  := FECHAFINAL;
  
  open c_tiempo;
  LOOP
    /* Ejecucion del borrado de registros*/
    fetch c_tiempo into v_d_tiempo_id;
    exit when c_tiempo%NOTFOUND;
    delete from h_ventas_empleado where d_tiempo_id = v_d_tiempo_id ;
    commit;
  END LOOP;
  close c_tiempo;
  open c_ventas;
  LOOP
    /*Operación de inserción de registros*/
    fetch c_ventas into v_d_tiempo_id, v_d_medicamento_id, v_d_empleado_id, v_cantidad, v_costo;
    exit when c_ventas%NOTFOUND;
    insert into h_ventas_empleado  (id, d_tiempo_id, d_medicamento_id, d_empleado_id, cantidad, costo)
    values (seq_h_ventas_empleado.nextval, v_d_tiempo_id, v_d_medicamento_id, v_d_empleado_id, v_cantidad, v_costo);
    commit;
  END LOOP;
  close c_ventas;
END ACTUALIZA_H_VENTAS_EMP;

/* H_COMPRAS_PROVEEDOR */

create or replace PROCEDURE ACTUALIZA_H_COMPRAS_PROVEEDOR
(
  FECHAINICIAL IN DATE 
, FECHAFINAL IN DATE 
) AS 
fecha_inicial date;
fecha_final   date;
v_d_medicamento_id       number;
v_d_tiempo_id  number;
v_d_proveedor_id    number;
v_cantidad    number;
v_costo number;
    
cursor c_tiempo is
select id from d_tiempo where fecha between fecha_inicial and fecha_final;

cursor c_compras is
select dm.id, dt.id, pc.id, sum(cc.cantidad), sum(cc.cantidad * cc.precio)
from catalogo_compras cc, d_medicamento_compras_prov dm, d_tiempo dt, d_proveedor_compras_prov pc
where cc.proveedor_id = pc.proveedor_id 
AND cc.fecha between fecha_inicial and fecha_final
and trunc(cc.fecha) = trunc(dt.fecha)
and cc.id = dm.compra_id
group by dm.id,dt.id, pc.id
order by 1,2,3;

BEGIN
  fecha_inicial := FECHAINICIAL;
  fecha_final  := FECHAFINAL;
  
  open c_tiempo;
  LOOP
    /* Ejecucion del borrado de registros*/
    fetch c_tiempo into v_d_tiempo_id;
    exit when c_tiempo%NOTFOUND;
    delete from h_ventas_cliente where d_tiempo_id = v_d_tiempo_id ;
    commit;
  END LOOP;
  close c_tiempo;
  open c_compras;
  LOOP
    /*Operación de inserción de registros*/
    fetch c_compras into v_d_medicamento_id, v_d_tiempo_id, v_d_proveedor_id, v_cantidad, v_costo;
    exit when c_compras%NOTFOUND;
    insert into h_compras_proveedor  (id, d_medicamento_id, d_tiempo_id, d_proveedor_id , cantidad, costo)
    values (seq_h_compras_proveedor.nextval, v_d_medicamento_id, v_d_tiempo_id, v_d_proveedor_id, v_cantidad, v_costo);
    commit;
  END LOOP;
  close c_compras;
END ACTUALIZA_H_COMPRAS_PROVEEDOR;

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
 select seq_d_empleado_ventas_empleado.nextval, ce.id, ce.nombre, ce.apellidos
 from catalogo_empleados ce, catalogo_punto_de_venta cpv
 where cpv.id = ce.punto_de_venta_id;
END ACTUALIZA_EMPLEADO_VENTAS_EMP;

/* D_CLIENTE_VENTAS_CLIENTE */

create or replace PROCEDURE ACTUALIZA_CLIENTE_VENTAS_CLI AS
BEGIN
 insert into D_CLIENTE_VENTAS_CLIENTE
 select seq_d_cliente_ventas_cliente.nextval, cc.id, cc.nombre, cc.apellidos, cc.colonia, cc.fecha_alta
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


/* H_VENTAS_EMPLEADO */

create or replace PROCEDURE ACTUALIZA_H_VENTAS_EMP 
(
  FECHAINICIAL IN DATE 
, FECHAFINAL IN DATE 
) AS 
fecha_inicial date;
fecha_final   date;
v_d_tiempo_id  number;
v_d_empleado_id    number;
v_d_medicamento_id       number;
v_cantidad    number;
v_costo number;
    
cursor c_tiempo is
select id from d_tiempo where fecha between fecha_inicial and fecha_final;

cursor c_ventas is
select dt.id, dm.id, de.id, sum(cvp.cantidad), sum(cvp.cantidad * cvp.precio)
from catalogo_ventas_partidas cvp, d_empleado_ventas_empleado de, d_medicamento_ventas dm, d_tiempo dt, catalogo_ventas cv
where cvp.venta_id = cv.id 
AND cv.fecha between fecha_inicial and fecha_final
and cv.empleado_id = de.empleado_id
and trunc(dt.fecha) = trunc(cv.fecha)
group by dt.id, dm.id, de.id
order by 1,2,3;


BEGIN
  fecha_inicial := FECHAINICIAL;
  fecha_final  := FECHAFINAL;
  
  open c_tiempo;
  LOOP
    /* Ejecucion del borrado de registros*/
    fetch c_tiempo into v_d_tiempo_id;
    exit when c_tiempo%NOTFOUND;
    delete from h_ventas_empleado where d_tiempo_id = v_d_tiempo_id ;
    commit;
  END LOOP;
  close c_tiempo;
  
  open c_ventas;
  LOOP
    /*Operación de inserción de registros*/
    fetch c_ventas into v_d_tiempo_id, v_d_medicamento_id, v_d_empleado_id, v_cantidad, v_costo;
    exit when c_ventas%NOTFOUND;
    insert into h_ventas_empleado  (id, d_tiempo_id, d_medicamento_id, d_empleado_id, cantidad, costo)
    values (seq_h_ventas_empleado.nextval, v_d_tiempo_id, v_d_medicamento_id, v_d_empleado_id, v_cantidad, v_costo);
    commit;
  END LOOP;
  close c_ventas;
END ACTUALIZA_H_VENTAS_EMP;
