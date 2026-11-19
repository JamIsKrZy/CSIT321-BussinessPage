# JusRight Hydro - Product Management with Supabase

This project integrates a Blazor application with Supabase for real-time cloud database storage, CRUD operations, and soft-delete persistence.

---

## 1. Where to See Displayed Items

### A. In the Web Application (Browser)
1. Run the project:
   ```bash
   dotnet run --project Activity-BussinesPage
   ```
2. Open your browser and navigate to:
   - **Local URL**: `http://localhost:5249/products` (or `https://localhost:7150/products`)
   - Or click **"Products"** / **"Shop Greens"** directly in the top navigation bar.
3. You will see:
   - The product entry form (input fields for Name and Price with an **Add** button).
   - The live list of active products showing `@Name · @Price`.
   - Action buttons for each product: **`+10`** (raises price by 10) and **`Delete`** (soft-deletes the row).

### B. In the Supabase Dashboard
1. Go to your Supabase Project: [https://supabase.com/dashboard](https://supabase.com/dashboard)
2. Navigate to **Table Editor** in the left sidebar.
3. Select the **`products`** table:
   - All rows (including soft-deleted rows with timestamps in `deleted_at`) can be viewed here in real time.
   - When you click **Add**, a new row is created.
   - When you click **`+10`**, the `price` column increments.
   - When you click **Delete**, the `deleted_at` column gets populated with the current UTC timestamp, and the row disappears from the active list on your page.

---

## 2. Storage Pattern: Soft Delete (And Why)

In this project, we implement the **Soft Delete** pattern:
- **How it works**: Instead of executing an SQL `DELETE` statement that destroys data permanently from the table, deleting a product updates the row by setting `deleted_at = DateTime.UtcNow`.
- **Query filtering**: The client app queries rows with `.Where(p => p.DeletedAt == null)`, ensuring soft-deleted rows are excluded from the user interface.

### Why Soft Delete?
1. **Audit Trail & Data Preservation**: Accidental deletions can be easily restored without data recovery from backups.
2. **Referential Integrity**: Other tables (such as orders, invoices, or analytics) that reference the `id` of a product will not suffer foreign key constraint violations or broken historical records.
3. **Analytics**: Retains full historical performance and price progression data for business intelligence.

---

## 3. Database Schema

The database table can be created or verified using `database/schema.sql`:

```sql
create table if not exists products (
    id bigint primary key generated always as identity,
    name text not null,
    price numeric not null default 0,
    deleted_at timestamp with time zone default null
);

-- Row Level Security (RLS)
alter table products enable row level security;

create policy "Allow select for anon" on products for select to anon using (true);
create policy "Allow insert for anon" on products for insert to anon with check (true);
create policy "Allow update for anon" on products for update to anon using (true) with check (true);
```
