-- ===================================================
-- Supabase Schema & Security Policies for Products Table
-- ===================================================

create table if not exists public.products (
  id bigint generated always as identity primary key,
  name text not null,
  price numeric(10,2) not null default 0 check (price >= 0),
  deleted_at timestamptz,                         -- for soft delete
  created_at timestamptz not null default now()
);

-- Index on name for fast lookups (habit 1)
create index if not exists products_name_idx on public.products (name);

-- Grant privileges to anon role (lock 1)
grant select, insert, update, delete on public.products to anon;

-- Enable Row Level Security (lock 2)
alter table public.products enable row level security;

-- 1. READ POLICY: Allow anon to read products
drop policy if exists "read_all" on public.products;
create policy "read_all" on public.products
  for select
  to anon
  using (true);

-- 2. INSERT POLICY: Allow anon to insert new products (Required for Add)
drop policy if exists "insert_all" on public.products;
create policy "insert_all" on public.products
  for insert
  to anon
  with check (true);

-- 3. UPDATE POLICY: Allow anon to update products (Required for +10 and Soft Delete)
drop policy if exists "update_all" on public.products;
create policy "update_all" on public.products
  for update
  to anon
  using (true)
  with check (true);

-- 4. DELETE POLICY: Allow anon to delete products
drop policy if exists "delete_all" on public.products;
create policy "delete_all" on public.products
  for delete
  to anon
  using (true);
