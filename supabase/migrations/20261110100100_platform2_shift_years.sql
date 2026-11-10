-- OrgCue platform2, RM67: live demo dates.
--
-- The demo company is stored as of one date (settings row core.as_of, 2024-09-16). A new demo session, a reset demo
-- session and a team workspace copied straight from the demo are moved forward by whole years N, where N makes the
-- as-of date the latest same day of the year that is not after today (on 10 Nov 2026: N = 2, as-of 16 Sep 2026).
-- The demo workspace itself never changes.
--
-- orgcue_shift_years(p_ws, p_years) moves every workspace-scope row of one workspace (product content never moves):
--   - date columns and ISO dates (YYYY-MM-DD) anywhere in text, jsonb and ids: + N years (29 Feb becomes 28 Feb)
--   - week keys (columns week_start and week_id, columns ending in _week, and the id of a table that has one):
--     + N years, then back to the same weekday (at most 3 days), so a week that started on a Monday still does
--   - four-digit years 2000–2099 in text and jsonb, unless part of a longer number or a decimal (T-2010.000)
--   - two-digit years after a typographic apostrophe (Q2 ’23)
--   - weekday names written with a date (Monday, October 14 / Monday 14 October), recalculated for the new year
--   - whole-number columns named year or ending in _year, and jsonb object keys (target years such as {"2024": 45})
-- The page's test tool shift.js (platform2 module) applies exactly the same rules; keep the two in step.

-- whole years from an as-of date to today: the latest same day of the year that is not after today
create or replace function public.orgcue_years_to_today(p_as_of date, p_today date default current_date)
returns integer
language plpgsql
stable
set search_path = ''
as $$
declare
  n integer;
begin
  if p_as_of is null then
    return 0;
  end if;
  n := extract(year from p_today)::integer - extract(year from p_as_of)::integer;
  if (p_as_of + make_interval(years => n))::date > p_today then
    n := n - 1;
  end if;
  return n;
end;
$$;

-- a date in a given year and month, with the day kept inside the month (29 Feb -> 28 Feb)
create or replace function public.orgcue_ymd(p_y integer, p_m integer, p_d integer)
returns date
language sql
immutable
set search_path = ''
as $$
  select make_date(p_y, p_m, least(p_d, extract(day from (make_date(p_y, p_m, 1) + interval '1 month - 1 day'))::integer))
$$;

-- a date moved by whole years; a week key goes back to the same weekday
create or replace function public.orgcue_shift_date(p_d date, p_n integer, p_week boolean default false)
returns date
language plpgsql
immutable
set search_path = ''
as $$
declare
  d2 date;
  k integer;
begin
  if p_d is null or p_n = 0 then
    return p_d;
  end if;
  d2 := (p_d + make_interval(years => p_n))::date;
  if p_week then
    k := ((extract(dow from p_d)::integer - extract(dow from d2)::integer) % 7 + 7) % 7;
    if k > 3 then
      k := k - 7;
    end if;
    d2 := d2 + k;
  end if;
  return d2;
end;
$$;

-- one matched piece of text (see orgcue_shift_text), moved by whole years
create or replace function public.orgcue_shift_token(p_tok text, p_n integer, p_ref integer, p_week boolean)
returns text
language plpgsql
immutable
set search_path = ''
as $$
declare
  wd constant text[] := array['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
  mn constant text[] := array['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
  d date;
  v_w text;
  v_mon integer;
  v_day integer;
  v_y integer;
  y0 integer;
  c integer;
  res text;
begin
  if p_tok ~ '^[0-9]{4}-[0-9]{2}-[0-9]{2}$' then
    begin
      d := p_tok::date;
    exception when others then
      return p_tok;
    end;
    return to_char(public.orgcue_shift_date(d, p_n, p_week), 'YYYY-MM-DD');
  elsif p_tok ~ '^[0-9]{4}$' then
    return (p_tok::integer + p_n)::text;
  elsif p_tok ~ '^[0-9]{2}$' then
    return lpad((((p_tok::integer + p_n) % 100 + 100) % 100)::text, 2, '0');
  end if;
  -- a weekday written with a date: Monday, October 14[, 2024] or Monday[,] 14 October[ 2024]
  v_w := substring(p_tok from '^([A-Za-z]+)');
  v_mon := array_position(mn, substring(p_tok from '(January|February|March|April|May|June|July|August|September|October|November|December)'));
  v_day := substring(substr(p_tok, length(v_w) + 1) from '(?:^|[ ,])([0-9]{1,2})(?:[ ,]|$)')::integer;
  v_y := substring(p_tok from '(20[0-9]{2})$')::integer;
  if v_mon is null or v_day is null or array_position(wd, v_w) is null then
    return p_tok;
  end if;
  y0 := v_y;
  if y0 is null then
    foreach c in array array[p_ref, p_ref + 1, p_ref - 1] loop
      if extract(dow from public.orgcue_ymd(c, v_mon, v_day))::integer = array_position(wd, v_w) - 1 then
        y0 := c;
        exit;
      end if;
    end loop;
  end if;
  res := p_tok;
  if y0 is not null then
    res := wd[extract(dow from public.orgcue_ymd(y0 + p_n, v_mon, v_day))::integer + 1] || substr(p_tok, length(v_w) + 1);
  end if;
  if v_y is not null then
    res := left(res, length(res) - 4) || (v_y + p_n)::text;
  end if;
  return res;
end;
$$;

-- text with every date and year in it moved by whole years (p_ref: the year of the as-of date, to place weekday dates
-- written without a year; p_week: ISO dates are week keys)
create or replace function public.orgcue_shift_text(p_s text, p_n integer, p_ref integer, p_week boolean default false)
returns text
language plpgsql
immutable
set search_path = ''
as $$
declare
  wdr constant text := 'Monday|Tuesday|Wednesday|Thursday|Friday|Saturday|Sunday';
  mnr constant text := 'January|February|March|April|May|June|July|August|September|October|November|December';
  pat text;
  toks text[];
  parts text[];
  res text;
  i integer;
begin
  if p_s is null or p_n is null or p_n = 0 or p_s !~ '[0-9]' then
    return p_s;
  end if;
  pat := '(?:' || wdr || '), (?:' || mnr || ') [0-9]{1,2}(?:, 20[0-9]{2})?(?![0-9])'
      || '|(?:' || wdr || '),? [0-9]{1,2} (?:' || mnr || ')(?: 20[0-9]{2})?(?![0-9])'
      || '|(?<![0-9])[0-9]{4}-[0-9]{2}-[0-9]{2}(?![0-9])'
      || '|(?<![0-9.,£$€])20[0-9]{2}(?![0-9])(?!\.[0-9])(?!-[0-9]{2}-[0-9])'
      || '|(?<=[[:space:]][’‘])[0-9]{2}(?![0-9])';
  select coalesce(array_agg(m[1] order by o), '{}') into toks
    from regexp_matches(p_s, '(' || pat || ')', 'g') with ordinality as t(m, o);
  if coalesce(array_length(toks, 1), 0) = 0 then
    return p_s;
  end if;
  parts := regexp_split_to_array(p_s, pat);
  res := parts[1];
  for i in 1 .. array_length(toks, 1) loop
    res := res || public.orgcue_shift_token(toks[i], p_n, p_ref, p_week) || coalesce(parts[i + 1], '');
  end loop;
  return res;
end;
$$;

-- jsonb with every string and object key moved (numbers are left alone)
create or replace function public.orgcue_shift_jsonb(p_j jsonb, p_n integer, p_ref integer)
returns jsonb
language plpgsql
immutable
set search_path = ''
as $$
begin
  case jsonb_typeof(p_j)
    when 'string' then
      return to_jsonb(public.orgcue_shift_text(p_j #>> '{}', p_n, p_ref, false));
    when 'array' then
      return coalesce((select jsonb_agg(public.orgcue_shift_jsonb(e, p_n, p_ref) order by o) from jsonb_array_elements(p_j) with ordinality as t(e, o)), '[]'::jsonb);
    when 'object' then
      return coalesce((select jsonb_object_agg(public.orgcue_shift_text(k, p_n, p_ref, false), public.orgcue_shift_jsonb(v, p_n, p_ref)) from jsonb_each(p_j) as t(k, v)), '{}'::jsonb);
    else
      return p_j;
  end case;
end;
$$;

-- moves every workspace-scope row of a workspace by whole years (see the top of this file)
create or replace function public.orgcue_shift_years(p_ws uuid, p_years integer)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  t record;
  c record;
  sets text[];
  v_ref integer;
  v_week boolean;
  v_isweek boolean;
begin
  if p_years is null or p_years = 0 then
    return;
  end if;
  select extract(year from (s.value #>> '{}')::date)::integer into v_ref
    from public.settings s
   where s.workspace_id = p_ws and s.id = 'core.as_of' and (s.value #>> '{}') ~ '^[0-9]{4}-[0-9]{2}-[0-9]{2}$';
  v_ref := coalesce(v_ref, extract(year from current_date)::integer);
  set constraints all deferred;
  for t in select name from public.orgcue_tables where scope = 'workspace' order by sort loop
    sets := '{}';
    select exists (select 1 from information_schema.columns ic
                    where ic.table_schema = 'public' and ic.table_name = t.name
                      and (ic.column_name in ('week_start', 'week_id') or ic.column_name like '%\_week'))
      into v_week;
    for c in select ic.column_name::text as name, ic.data_type::text as type
               from information_schema.columns ic
              where ic.table_schema = 'public' and ic.table_name = t.name
                and ic.column_name not in ('workspace_id', 'updated_at', 'sort', 'id')
              order by ic.ordinal_position loop
      v_isweek := c.name in ('week_start', 'week_id') or c.name like '%\_week';
      if c.type = 'date' then
        sets := sets || format('%1$I = public.orgcue_shift_date(%1$I, $2, %2$L::boolean)', c.name, v_isweek);
      elsif c.type = 'text' then
        sets := sets || format('%1$I = public.orgcue_shift_text(%1$I, $2, $3, %2$L::boolean)', c.name, v_isweek);
      elsif c.type = 'jsonb' then
        sets := sets || format('%1$I = public.orgcue_shift_jsonb(%1$I, $2, $3)', c.name);
      elsif c.type in ('integer', 'bigint', 'smallint') and (c.name = 'year' or c.name like '%\_year') then
        sets := sets || format('%1$I = %1$I + $2', c.name);
      end if;
    end loop;
    -- ids move in two steps (through a prefix), so a new id never meets an old one that has not moved yet
    sets := sets || format('id = case when public.orgcue_shift_text(id, $2, $3, %1$L::boolean) <> id then chr(1) || public.orgcue_shift_text(id, $2, $3, %1$L::boolean) else id end', v_week);
    execute format('update public.%I set %s where workspace_id = $1', t.name, array_to_string(sets, ', '))
      using p_ws, p_years, v_ref;
    execute format('update public.%I set id = substr(id, 2) where workspace_id = $1 and left(id, 1) = chr(1)', t.name)
      using p_ws;
  end loop;
  update public.workspaces set version = version + 1, updated_at = now() where id = p_ws;
end;
$$;

-- how many years the demo moves today
create or replace function public.orgcue_demo_years()
returns integer
language sql
stable
security definer
set search_path = ''
as $$
  select coalesce((select public.orgcue_years_to_today((s.value #>> '{}')::date)
                     from public.settings s
                    where s.workspace_id = '00000000-0000-4000-8000-000000000001' and s.id = 'core.as_of'
                      and (s.value #>> '{}') ~ '^[0-9]{4}-[0-9]{2}-[0-9]{2}$'), 0)
$$;

-- a private copy of the demo for a visitor without an account, with its dates moved to follow today
create or replace function public.orgcue_new_sandbox()
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_id uuid := gen_random_uuid();
  v_token text := encode(extensions.gen_random_bytes(24), 'hex');
  n integer;
begin
  delete from public.workspaces where kind = 'sandbox' and expires_at < now();
  select count(*) into n from public.workspaces where kind = 'sandbox' and created_at > now() - interval '1 hour';
  if n >= 500 then
    raise exception 'Too many demo sessions right now. Try again in a few minutes.' using errcode = 'P0004';
  end if;
  insert into public.workspaces (id, name, kind, token_hash, expires_at, data)
  select v_id, d.name, 'sandbox', encode(extensions.digest(v_token, 'sha256'), 'hex'), now() + interval '14 days', '{}'::jsonb
    from public.workspaces d where d.id = '00000000-0000-4000-8000-000000000001';
  perform public.orgcue_copy_rows('00000000-0000-4000-8000-000000000001', v_id);
  perform public.orgcue_shift_years(v_id, public.orgcue_demo_years());
  return jsonb_build_object('id', v_id, 'token', v_token);
end;
$$;

create or replace function public.orgcue_reset_sandbox(p_ws uuid, p_token text)
returns integer
language plpgsql
security definer
set search_path = ''
as $$
declare
  v integer;
begin
  perform public.orgcue_access(p_ws, p_token, true);
  if (select kind from public.workspaces where id = p_ws) <> 'sandbox' then
    raise exception 'Only a demo session can be reset' using errcode = '42501';
  end if;
  perform public.orgcue_clear_rows(p_ws);
  perform public.orgcue_copy_rows('00000000-0000-4000-8000-000000000001', p_ws);
  perform public.orgcue_shift_years(p_ws, public.orgcue_demo_years());
  update public.workspaces set version = version + 1, updated_at = now() where id = p_ws returning version into v;
  return v;
end;
$$;

-- a new team workspace for the signed-in user, copied from a workspace they can read (copied straight from the demo:
-- its dates move to follow today). The creator is linked to the person they were in the copied data (settings row
-- work.me), or to a new person (RM60, see 20261110100000_platform2_member_people.sql).
create or replace function public.orgcue_create_workspace(p_name text, p_from uuid, p_token text default null)
returns uuid
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_id uuid := gen_random_uuid();
  v_email text;
  v_name text;
  v_person text;
begin
  if auth.uid() is null then
    raise exception 'Sign in first' using errcode = '42501';
  end if;
  if p_from is not null then
    perform public.orgcue_access(p_from, p_token, false);
  end if;
  select u.email, coalesce(u.raw_user_meta_data ->> 'name', split_part(u.email, '@', 1)) into v_email, v_name
    from auth.users u where u.id = auth.uid();
  insert into public.workspaces (id, name, kind, created_by, data) values (v_id, btrim(p_name), 'team', auth.uid(), '{}'::jsonb);
  if p_from is not null then
    perform public.orgcue_copy_rows(p_from, v_id);
    if p_from = '00000000-0000-4000-8000-000000000001' then
      perform public.orgcue_shift_years(v_id, public.orgcue_demo_years());
    end if;
  end if;
  select s.value ->> 'person' into v_person from public.settings s where s.workspace_id = v_id and s.id = 'work.me';
  if v_person is null or not exists (select 1 from public.people p where p.workspace_id = v_id and p.id = v_person) then
    v_person := public.orgcue_new_person(v_id, v_name);
  end if;
  insert into public.workspace_members (workspace_id, user_id, email, name, role, person_id)
  values (v_id, auth.uid(), lower(v_email), v_name, 'admin', v_person);
  return v_id;
end;
$$;

revoke all on function public.orgcue_years_to_today(date, date), public.orgcue_ymd(integer, integer, integer),
  public.orgcue_shift_date(date, integer, boolean), public.orgcue_shift_token(text, integer, integer, boolean),
  public.orgcue_shift_text(text, integer, integer, boolean), public.orgcue_shift_jsonb(jsonb, integer, integer),
  public.orgcue_shift_years(uuid, integer), public.orgcue_demo_years() from public, anon, authenticated;
revoke all on function public.orgcue_new_sandbox(), public.orgcue_reset_sandbox(uuid, text), public.orgcue_create_workspace(text, uuid, text) from public;
grant execute on function public.orgcue_new_sandbox(), public.orgcue_reset_sandbox(uuid, text) to anon, authenticated;
grant execute on function public.orgcue_create_workspace(text, uuid, text) to authenticated;
