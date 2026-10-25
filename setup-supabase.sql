-- Run this once in Supabase Dashboard → SQL Editor.
create table if not exists public.life_record_data (
  user_id uuid primary key references auth.users(id) on delete cascade,
  data jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.life_record_data enable row level security;

drop policy if exists "Users can read their own life record" on public.life_record_data;
create policy "Users can read their own life record"
  on public.life_record_data for select to authenticated
  using (auth.uid() = user_id);

drop policy if exists "Users can insert their own life record" on public.life_record_data;
create policy "Users can insert their own life record"
  on public.life_record_data for insert to authenticated
  with check (auth.uid() = user_id);

drop policy if exists "Users can update their own life record" on public.life_record_data;
create policy "Users can update their own life record"
  on public.life_record_data for update to authenticated
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

grant select, insert, update on public.life_record_data to authenticated;

create or replace function public.set_life_record_updated_at()
returns trigger language plpgsql as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists life_record_updated_at on public.life_record_data;
create trigger life_record_updated_at
  before update on public.life_record_data
  for each row execute function public.set_life_record_updated_at();
