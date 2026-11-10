-- OrgCue access, RM73: presence — who else is looking at the same page, and who is editing the same record.
--
-- Each shared (team) workspace has one private Supabase Realtime channel, topic 'orgcue-presence:<workspace id>'.
-- The page tracks {name, person, page, what it is editing} there and reads everyone else's. Nothing is stored.
-- Only members of that workspace (guests included) may join: these policies on realtime.messages let a signed-in user
-- read (receive) and write (track) presence on a topic only when orgcue_presence_ok() says they are a member.
-- Demo sessions (sandbox), the demo company and product content never get a channel.
-- Realtime must enforce private channels: in the dashboard, Realtime settings, turn off "Allow public access".

create or replace function public.orgcue_presence_ok(p_topic text)
returns boolean
language plpgsql
stable
security definer
set search_path = ''
as $$
declare
  v_ws uuid;
begin
  if auth.uid() is null or p_topic is null or p_topic !~ '^orgcue-presence:[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$' then
    return false;
  end if;
  v_ws := substr(p_topic, length('orgcue-presence:') + 1)::uuid;
  return exists (select 1 from public.workspaces w where w.id = v_ws and w.kind = 'team')
     and public.workspace_role(v_ws) is not null;
end;
$$;
revoke all on function public.orgcue_presence_ok(text) from public, anon;
grant execute on function public.orgcue_presence_ok(text) to authenticated;

drop policy if exists "orgcue members receive presence" on realtime.messages;
create policy "orgcue members receive presence" on realtime.messages
  for select to authenticated
  using (realtime.messages.extension = 'presence' and public.orgcue_presence_ok((select realtime.topic())));

drop policy if exists "orgcue members share presence" on realtime.messages;
create policy "orgcue members share presence" on realtime.messages
  for insert to authenticated
  with check (realtime.messages.extension = 'presence' and public.orgcue_presence_ok((select realtime.topic())));
