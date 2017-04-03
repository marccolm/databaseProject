
 /* COMRPRAS PROVEEDOR AL MES */
 
  CREATE OR REPLACE FORCE VIEW COMPRAS_PROVEEDOR_MES AS 
  select dp.proveedor_id, dp.nombre, dm.medicamento_id, dm.nombre_medicamento, dt.mes, dt.anio as Año, sum(cantidad) as Cantidad, costo/cantidad as Precio_UNITARIO
from d_proveedor_compras_prov dp, d_medicamento_compras_prov dm, h_compras_proveedor hcp, d_tiempo dt
where hcp.d_proveedor_id = dp.id and hcp.d_medicamento_id = dm.id and hcp.d_tiempo_id = dt.id
group by dp.proveedor_id, dp.nombre, dm.medicamento_id, dm.nombre_medicamento, dt.mes, dt.anio, costo/cantidad
order by dt.anio;

 /* MEDICAMENTOS MÁS VENDIDOS AL MES */
 

  CREATE OR REPLACE FORCE VIEW "EQUIPO6DWH"."MEDICAMENTOS_MAS_VENDIDOS_MES" ("IDMEDICAMENTO", "NOMBRE", "INGREDIENTEACTIVO", "MES", "AÑO", "CANTIDAD", "INGRESOS") AS 
  select dm.medicamento_id as IDMedicamento, dm.nombre as Nombre, dm.ingrediente_activo as IngredienteActivo, dt.mes, dt.anio as Año, count(cantidad) as Cantidad, sum(hve.costo) as Ingresos
from h_ventas_empleado hve, d_tiempo dt, d_medicamento_ventas dm
where hve.d_tiempo_id = dt.id AND hve.d_medicamento_id = dm.id 
group by dm.medicamento_id, dm.nombre, dm.ingrediente_activo, dt.mes, dt.anio
order by cantidad desc;

/* CLIENTES QUE NO HAN COMPRADO EN EL AÑO ACTUAL */

  CREATE OR REPLACE FORCE VIEW "EQUIPO6DWH"."NO_VENTAS_CLIENTES_AÑO" ("NOMBRE", "APELLIDOS", "SUCURSAL") AS 
  select dc.nombre, dc.apellidos, dm.nombre_punto_de_venta as Sucursal
from d_cliente_ventas_cliente dc, d_medicamento_ventas dm, h_ventas_cliente hvc
where dc.id not in (select hvc.d_cliente_id from h_ventas_cliente hvc, d_tiempo dt where hvc.d_tiempo_id = dt.id
and dt.ANIO not in (select to_char(sysdate, 'YYYY') from dual));

/* CLIENTES QUE MÁS COMPRAN */


  CREATE OR REPLACE FORCE VIEW "EQUIPO6DWH"."VENTAS_CLIENTES_MES" ("IDCLIENTE", "NOMBRE", "APELLIDOS", "COLONIA", "SUCURSAL", "MES", "AÑO", "NUMCOMPRAS", "INGRESOS") AS 
  select dc.cliente_id as IDCLIENTE, dc.nombre, dc.apellidos, dc.colonia, dm.nombre_punto_de_venta as Sucursal, dt.mes, dt.anio as Año, count(*) as NumCompras, sum(hvc.costo) as Ingresos
from h_ventas_cliente hvc, d_tiempo dt, d_cliente_ventas_cliente dc, d_medicamento_ventas dm
where hvc.d_tiempo_id = dt.id AND hvc.d_cliente_id = dc.id AND hvc.d_medicamento_id = dm.id 
group by dc.cliente_id, dc.nombre, dc.apellidos, dc.colonia, dm.nombre_punto_de_venta, dt.mes, dt.anio
order by count(*) desc;

 /* EMPLEADOS QUE MÁS VENDEN */
 
 
  CREATE OR REPLACE FORCE VIEW "EQUIPO6DWH"."VENTAS_EMPLEADO_MES" ("NOMBRE", "APELLIDOS", "SUCURSAL", "MES", "AÑO", "NUMVENTAS", "INGRESOS") AS 
  select de.nombre, de.apellidos, dm.nombre_punto_de_venta as Sucursal, dt.mes, dt.anio as Año, count(*) as NumVentas, sum(hve.costo) as Ingresos
from h_ventas_empleado hve, d_tiempo dt, d_empleado_ventas_empleado de, d_medicamento_ventas dm
where hve.d_tiempo_id = dt.id AND hve.d_empleado_id = de.id AND hve.d_medicamento_id = dm.id 
group by de.nombre, de.apellidos, dm.nombre_punto_de_venta, dt.mes, dt.anio
order by dt.anio, dt.mes;

/* MEDICAMENTOS MÁS VENDIDOS Y MARCAS MÁS VENDIDAS*/

CREATE OR REPLACE FORCE VIEW "EQUIPO6DWH"."VENTAS_MEDICAMENTO_AÑO" ("IDMEDICAMENTO", "NOMBRE", "INGREDIENTEACTIVO", "AÑO", "CANTIDAD", "INGRESOS") AS 
  select dm.medicamento_id as IDMedicamento, dm.nombre as Nombre, dm.ingrediente_activo as IngredienteActivo, dt.anio as Año, count(cantidad) as Cantidad, sum(hve.costo) as Ingresos
from h_ventas_empleado hve, d_tiempo dt, d_medicamento_ventas dm
where hve.d_tiempo_id = dt.id AND hve.d_medicamento_id = dm.id 
group by dm.medicamento_id, dm.nombre, dm.ingrediente_activo, dt.anio
order by dt.anio;

/* VENTAS NETAS SUCURSAL 1 AL MES */

  CREATE OR REPLACE FORCE VIEW "EQUIPO6DWH"."VENTAS_SUCURSAL1_MES" ("MES", "ANIO", "NUMVENTAS", "INGRESOS") AS 
  select dt.mes, dt.anio, count(*) as NumVentas, sum(hve.costo) as Ingresos 
from h_ventas_empleado hve, d_tiempo dt, d_empleado_ventas_empleado de, d_medicamento_ventas dm
where hve.d_tiempo_id = dt.id AND hve.d_empleado_id = de.id AND hve.d_medicamento_id = dm.id AND dm.punto_de_venta_id = 1
group by dt.mes, dt.anio
order by dt.mes, dt.anio;

/* VENTASNETAS SUCURSAL 2 AL MES */


  CREATE OR REPLACE FORCE VIEW "EQUIPO6DWH"."VENTAS_SUCURSAL2_MES" ("MES", "ANIO", "NUMVENTAS", "INGRESOS") AS 
  select dt.mes, dt.anio, count(*) as NumVentas, sum(hve.costo) as Ingresos 
from h_ventas_empleado hve, d_tiempo dt, d_empleado_ventas_empleado de, d_medicamento_ventas dm
where hve.d_tiempo_id = dt.id AND hve.d_empleado_id = de.id AND hve.d_medicamento_id = dm.id AND dm.punto_de_venta_id = 2
group by dt.mes, dt.anio
order by dt.mes, dt.anio;

