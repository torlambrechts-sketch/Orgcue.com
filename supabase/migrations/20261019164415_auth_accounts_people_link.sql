-- Real accounts, part 1 of 4: Supabase Auth (email + password). Every signed-in user is a member of the shared
-- Lumio Inc. demo workspace. A new auth user gets a people row in the Lumio org.
alter table public.people add column if not exists user_id uuid unique references auth.users(id) on delete cascade;
alter table public.people add column if not exists email text;
alter table public.audit_events add column if not exists user_id uuid references auth.users(id) on delete set null;

create or replace function public.handle_new_user() returns trigger
language plpgsql security definer set search_path = public as $fn$
begin
  insert into public.people (id, org_id, name, title, org_role, project_role, function_group, authority_areas, channel, user_id, email)
  values ('u-' || left(replace(new.id::text, '-', ''), 12), 'lumio',
          coalesce(nullif(trim(new.raw_user_meta_data ->> 'full_name'), ''), split_part(new.email, '@', 1)),
          coalesce(new.raw_user_meta_data ->> 'title', ''), 'Member', '', '', '', 'Email', new.id, new.email)
  on conflict (user_id) do nothing;
  return new;
end;
$fn$;
create or replace trigger on_auth_user_created after insert on auth.users for each row execute function public.handle_new_user();
