-- Real accounts, part 4 of 4: trigger functions are not an API, so nobody calls handle_new_user over /rest/v1/rpc.
revoke execute on function public.handle_new_user() from public, anon, authenticated;
