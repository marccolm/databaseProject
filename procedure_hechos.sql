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


/* H_VENTAS_CLIENTE */

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

/* H_COMPRAS_VENDEDOR */

create or replace PROCEDURE ACTUALIZA_H_COMPRAS_VENDEDOR
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
select dt.id, dm.id, dc.id, sum(cvp.cantidad), sum(cvp.cantidad * cvp.precio)
from cataologo_compras cc, d_cliente_ventas_cliente dc, d_medicamento_compras_prov dm, d_tiempo dt, catalogo_ventas cv
where cvp.venta_id = cv.id 
AND cv.fecha between fecha_inicial and fecha_final
and cv.cliente_id = dc.cliente_id
and trunc(cv.fecha) = trunc(dt.fecha)
and cc.id = dm.compra_id
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
  open c_compras;
  LOOP
    /*Operación de inserción de registros*/
    fetch c_compras into v_d_medicamento_id, v_d_tiempo_id, v_d_proveedor_id, v_cantidad, v_costo;
    exit when c_compras%NOTFOUND;
    insert into h_compras_vendedor  (id, d_medicamento_id, d_tiempo_id, d_proveedor_id , cantidad, costo)
    values (seq_h_compras_proveedor.nextval, v_d_medicamento_id, v_d_tiempo_id, v_d_proveedor_id, v_cantidad, v_costo);
    commit;
  END LOOP;
  close c_compras;
END ACTUALIZA_H_COMPRAS_VENDEDOR;


