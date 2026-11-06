-- Ejecutar en Supabase > SQL Editor. Es seguro correrlo varias veces.

create table if not exists proveedor (
  id bigint generated always as identity primary key,
  nombre text not null,
  telefono text,
  tiempo_entrega int4 not null default 3
);

create table if not exists producto (
  id bigint generated always as identity primary key,
  nombre text not null,
  categoria text,
  precio numeric default 0,
  stock_inicial int4 default 0,
  stock_actual int4 default 0,
  stock_minimo int4 default 0,
  id_proveedor bigint references proveedor(id) on delete set null
);

create table if not exists venta (
  id bigint generated always as identity primary key,
  cantidad int4 not null,
  fecha date not null default current_date,
  id_producto bigint references producto(id) on delete cascade
);

-- Si tus tablas ya existían, esto agrega lo que falte (RF-04)
alter table producto add column if not exists stock_minimo int4 default 0;
alter table producto add column if not exists id_proveedor bigint references proveedor(id) on delete set null;
alter table venta add column if not exists hora time;
alter table venta add column if not exists precio_unitario numeric;
alter table venta add column if not exists total numeric;

-- Registra la venta y descuenta stock en un solo paso; nunca deja stock negativo (RNF-04)
create or replace function registrar_venta(p_producto bigint, p_cantidad int, p_fecha date, p_hora time)
returns void language plpgsql as $$
declare v_precio numeric;
begin
  update producto set stock_actual = stock_actual - p_cantidad
   where id = p_producto and stock_actual >= p_cantidad
   returning precio into v_precio;
  if not found then raise exception 'Stock insuficiente para registrar la venta'; end if;
  insert into venta(id_producto, cantidad, fecha, hora, precio_unitario, total)
  values (p_producto, p_cantidad, p_fecha, p_hora, v_precio, v_precio * p_cantidad);
end $$;

-- Permisos para el prototipo (acceso con la clave anon). En producción, agrega login.
alter table proveedor enable row level security;
alter table producto enable row level security;
alter table venta enable row level security;
drop policy if exists "proto_proveedor" on proveedor;
drop policy if exists "proto_producto" on producto;
drop policy if exists "proto_venta" on venta;
create policy "proto_proveedor" on proveedor for all to anon using (true) with check (true);
create policy "proto_producto" on producto for all to anon using (true) with check (true);
create policy "proto_venta" on venta for all to anon using (true) with check (true);