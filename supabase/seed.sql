-- Seed data for local development only. Never run on production.
-- Run after: npx supabase db reset

insert into tenants (id, name, slug) values
  ('00000000-0000-0000-0000-000000000001', 'Pilot PIA Hyderabad', 'pilot-hyd');

insert into centers (id, tenant_id, name, district, state) values
  ('00000000-0000-0000-0000-000000000010', '00000000-0000-0000-0000-000000000001', 'Center A', 'Hyderabad', 'Telangana');

insert into batches (id, tenant_id, center_id, name, scheme, job_role, start_date, end_date) values
  ('00000000-0000-0000-0000-000000000020', '00000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000010',
   'Customer Support Batch 1', 'DDU-GKY', 'Customer Service Associate', '2026-02-01', '2026-04-30');
