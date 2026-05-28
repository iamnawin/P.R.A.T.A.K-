-- ============================================================
-- 002_rls_policies.sql
-- Row-Level Security: every tenant sees only their own rows.
-- jwt() -> tenant_id is set by the auth middleware.
-- ============================================================

-- Helper: extract tenant_id from JWT claims
create or replace function auth.tenant_id() returns uuid as $$
  select (auth.jwt() ->> 'tenant_id')::uuid;
$$ language sql stable;

-- Enable RLS on all tenant-scoped tables
alter table tenants              enable row level security;
alter table centers              enable row level security;
alter table officers             enable row level security;
alter table batches              enable row level security;
alter table candidates           enable row level security;
alter table consent_records      enable row level security;
alter table placements           enable row level security;
alter table monthly_check_ins    enable row level security;
alter table salary_slips         enable row level security;
alter table employer_attestations enable row level security;
alter table evidence_packs       enable row level security;
alter table incentive_payments   enable row level security;
alter table audit_log            enable row level security;

-- ---- tenants ------------------------------------------------
create policy "Officers see own tenant"
  on tenants for select
  using (id = auth.tenant_id());

-- ---- centers ------------------------------------------------
create policy "Officers see own centers"
  on centers for all
  using (tenant_id = auth.tenant_id());

-- ---- officers -----------------------------------------------
create policy "Officers see own tenant officers"
  on officers for all
  using (tenant_id = auth.tenant_id());

-- ---- batches ------------------------------------------------
create policy "Officers see own batches"
  on batches for all
  using (tenant_id = auth.tenant_id());

-- ---- candidates ---------------------------------------------
create policy "Officers see own candidates"
  on candidates for all
  using (tenant_id = auth.tenant_id());

-- ---- consent_records ----------------------------------------
create policy "Officers see own consent records"
  on consent_records for all
  using (tenant_id = auth.tenant_id());

-- ---- placements ---------------------------------------------
create policy "Officers see own placements"
  on placements for all
  using (tenant_id = auth.tenant_id());

-- ---- monthly_check_ins --------------------------------------
create policy "Officers see own check-ins"
  on monthly_check_ins for all
  using (tenant_id = auth.tenant_id());

-- ---- salary_slips -------------------------------------------
create policy "Officers see own salary slips"
  on salary_slips for all
  using (tenant_id = auth.tenant_id());

-- ---- employer_attestations ----------------------------------
-- Public SELECT via token (employer link) handled in API layer, not RLS
create policy "Officers see own attestations"
  on employer_attestations for all
  using (tenant_id = auth.tenant_id());

-- ---- evidence_packs -----------------------------------------
create policy "Officers see own evidence packs"
  on evidence_packs for all
  using (tenant_id = auth.tenant_id());

-- ---- incentive_payments -------------------------------------
create policy "Officers see own incentive payments"
  on incentive_payments for all
  using (tenant_id = auth.tenant_id());

-- ---- audit_log ----------------------------------------------
create policy "Officers see own audit log"
  on audit_log for select
  using (tenant_id = auth.tenant_id());

-- audit_log INSERT is done by service_role only (no user policy needed)
