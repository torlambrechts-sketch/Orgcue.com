-- Removes the row left by the beta-list permission check on 21 Oct 2026. The first migration applied by
-- .github/workflows/supabase-migrations.yml rather than by hand.
delete from public.beta_signups where email = 'beta-check@orgcue.test' and source = 'test';
