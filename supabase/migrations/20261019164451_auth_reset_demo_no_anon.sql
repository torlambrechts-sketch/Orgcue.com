-- Real accounts, part 3 of 4: only signed-in users may reset the demo.
revoke execute on function public.reset_demo() from public, anon;
grant execute on function public.reset_demo() to authenticated;
