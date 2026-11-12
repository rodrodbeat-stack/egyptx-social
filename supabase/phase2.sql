-- EGYPTX SOCIAL // PHASE 02
-- Run after supabase/schema.sql in Supabase SQL Editor.
create table if not exists public.reels (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  caption text not null default '',
  media_url text not null,
  created_at timestamptz not null default now()
);
create index if not exists reels_created_at_idx on public.reels(created_at desc);

create table if not exists public.messages (
  id uuid primary key default gen_random_uuid(),
  sender_id uuid not null references public.profiles(id) on delete cascade,
  recipient_id uuid not null references public.profiles(id) on delete cascade,
  content text not null check (char_length(content) between 1 and 4000),
  created_at timestamptz not null default now(),
  read_at timestamptz,
  constraint messages_no_self check (sender_id <> recipient_id)
);
create index if not exists messages_thread_idx
  on public.messages(sender_id, recipient_id, created_at desc);

create table if not exists public.notifications (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  actor_id uuid references public.profiles(id) on delete set null,
  kind text not null check (kind in ('like','comment','follow','message')),
  post_id uuid references public.posts(id) on delete cascade,
  message text not null default '',
  created_at timestamptz not null default now(),
  read_at timestamptz
);
create index if not exists notifications_user_created_idx
  on public.notifications(user_id, created_at desc);

alter table public.reels enable row level security;
alter table public.messages enable row level security;
alter table public.notifications enable row level security;

drop policy if exists "Reels are public" on public.reels;
create policy "Reels are public" on public.reels for select using (true);
drop policy if exists "Users publish own reels" on public.reels;
create policy "Users publish own reels" on public.reels for insert to authenticated with check (auth.uid() = user_id);
drop policy if exists "Users delete own reels" on public.reels;
create policy "Users delete own reels" on public.reels for delete to authenticated using (auth.uid() = user_id);

drop policy if exists "Participants read messages" on public.messages;
create policy "Participants read messages" on public.messages for select to authenticated
using (auth.uid() = sender_id or auth.uid() = recipient_id);
drop policy if exists "Users send messages as themselves" on public.messages;
create policy "Users send messages as themselves" on public.messages for insert to authenticated
with check (auth.uid() = sender_id and sender_id <> recipient_id);
drop policy if exists "Recipients mark messages read" on public.messages;
create policy "Recipients mark messages read" on public.messages for update to authenticated
using (auth.uid() = recipient_id) with check (auth.uid() = recipient_id);

drop policy if exists "Users read own notifications" on public.notifications;
create policy "Users read own notifications" on public.notifications for select to authenticated
using (auth.uid() = user_id);
drop policy if exists "Users update own notifications" on public.notifications;
create policy "Users update own notifications" on public.notifications for update to authenticated
using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- Enable realtime safely when the publication exists and tables are not already included.
do $$
begin
  if exists (select 1 from pg_publication where pubname = 'supabase_realtime') then
    begin alter publication supabase_realtime add table public.reels; exception when duplicate_object then null; end;
    begin alter publication supabase_realtime add table public.messages; exception when duplicate_object then null; end;
    begin alter publication supabase_realtime add table public.notifications; exception when duplicate_object then null; end;
  end if;
end $$;
