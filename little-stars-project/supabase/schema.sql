create extension if not exists pgcrypto;
create table if not exists public.user_roles(user_id uuid references auth.users(id) on delete cascade,role text check(role in('admin','customer')) not null,primary key(user_id,role));
create table if not exists public.products(id uuid primary key default gen_random_uuid(),name text not null,description text,category text not null,price numeric(10,2) not null check(price>=0),stock int not null default 0 check(stock>=0),image_url text,is_active boolean not null default true,created_at timestamptz default now());
create table if not exists public.orders(id uuid primary key default gen_random_uuid(),user_id uuid references auth.users(id),customer_name text not null,phone text not null,total numeric(10,2) not null,status text default 'placed',created_at timestamptz default now());
create table if not exists public.order_items(id uuid primary key default gen_random_uuid(),order_id uuid references public.orders(id) on delete cascade,product_id uuid references public.products(id),quantity int not null,unit_price numeric(10,2) not null);
create or replace function public.is_admin() returns boolean language sql stable security definer set search_path=public as $$ select exists(select 1 from public.user_roles where user_id=auth.uid() and role='admin') $$;
alter table public.user_roles enable row level security;alter table public.products enable row level security;alter table public.orders enable row level security;alter table public.order_items enable row level security;
create policy "read own role" on public.user_roles for select using(user_id=auth.uid() or public.is_admin());
create policy "public active products" on public.products for select using(is_active or public.is_admin());
create policy "admin insert products" on public.products for insert with check(public.is_admin());create policy "admin update products" on public.products for update using(public.is_admin()) with check(public.is_admin());create policy "admin delete products" on public.products for delete using(public.is_admin());
create policy "customer reads own orders" on public.orders for select using(user_id=auth.uid() or public.is_admin());create policy "customer creates own order" on public.orders for insert with check(user_id=auth.uid());create policy "admin updates orders" on public.orders for update using(public.is_admin()) with check(public.is_admin());
create policy "read own order items" on public.order_items for select using(exists(select 1 from public.orders o where o.id=order_id and (o.user_id=auth.uid() or public.is_admin())));
create policy "insert own order items" on public.order_items for insert with check(exists(select 1 from public.orders o where o.id=order_id and o.user_id=auth.uid()));
-- After registering your own account, grant admin with:
-- insert into public.user_roles(user_id,role) select id,'admin' from auth.users where email='YOUR_EMAIL';
