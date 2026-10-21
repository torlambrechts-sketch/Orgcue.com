-- Removes the row left by the beta-list permission check on 21 Oct 2026. The first migration applied with
-- `node scripts/db.mjs migrate` rather than by hand.
delete from public.beta_signups where email = 'beta-check@orgcue.test' and source = 'test';
