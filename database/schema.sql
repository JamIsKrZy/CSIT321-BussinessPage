-- ===================================================
-- Supabase Schema for Products Table
-- ===================================================

create table if not exists products (
    id bigint primary key generated always as identity,
    name text not null,
    price numeric not null default 0,
    deleted_at timestamp with time zone default null
);

-- Enable Row Level Security (RLS)
alter table products enable row level security;

-- Policy: Allow read access to anon
create policy "Allow select for anon"
    on products
    for select
    to anon
    using (true);

-- Policy: Allow insert access to anon
create policy "Allow insert for anon"
    on products
    for insert
    to anon
    with check (true);

-- Policy: Allow update access to anon (needed for price raise & soft delete)
create policy "Allow update for anon"
    on products
    for update
    to anon
    using (true)
    with check (true);
