-- ============================================================
-- 001_init_schema.sql
-- Core schema for Pratak — Phase 1 (Officer Workflow MVP)
-- Every table is tenant-scoped. RLS is in 002_rls_policies.sql
-- ============================================================

-- PIAs (Project Implementing Agencies) — one row per tenant
create table tenants (
  id          uuid primary key default gen_random_uuid(),
  name        text not null,
  slug        text unique not null,
  created_at  timestamptz not null default now()
);

-- Physical training centres under a tenant
create table centers (
  id          uuid primary key default gen_random_uuid(),
  tenant_id   uuid not null references tenants(id) on delete cascade,
  name        text not null,
  district    text,
  state       text,
  created_at  timestamptz not null default now()
);

-- Placement officers and admins
create table officers (
  id          uuid primary key default gen_random_uuid(),
  tenant_id   uuid not null references tenants(id) on delete cascade,
  center_id   uuid references centers(id),
  user_id     uuid not null references auth.users(id) on delete cascade,
  name        text not null,
  phone       text,
  role        text not null default 'officer' check (role in ('officer', 'admin', 'superadmin')),
  created_at  timestamptz not null default now()
);

-- Candidate cohorts (one batch = one training cohort under one scheme)
create table batches (
  id          uuid primary key default gen_random_uuid(),
  tenant_id   uuid not null references tenants(id) on delete cascade,
  center_id   uuid not null references centers(id),
  name        text not null,
  scheme      text not null check (scheme in ('PMKVY', 'DDU-GKY', 'NAPS', 'STATE', 'OTHER')),
  job_role    text,
  qp_code     text,
  start_date  date,
  end_date    date,
  created_at  timestamptz not null default now()
);

-- Candidates (trainees)
create table candidates (
  id            uuid primary key default gen_random_uuid(),
  tenant_id     uuid not null references tenants(id) on delete cascade,
  batch_id      uuid not null references batches(id),
  name          text not null,
  phone         text not null,
  preferred_lang text not null default 'te' check (preferred_lang in ('te', 'hi', 'en', 'ta', 'kn', 'mr')),
  aadhaar_hash  text,                       -- SHA-256 of Aadhaar; NEVER store raw
  whatsapp_opted_in boolean not null default false,
  created_at    timestamptz not null default now()
);

-- Day-1 digital consent records (DPDP Act 2023)
create table consent_records (
  id              uuid primary key default gen_random_uuid(),
  tenant_id       uuid not null references tenants(id) on delete cascade,
  candidate_id    uuid not null references candidates(id) on delete cascade,
  consented_at    timestamptz not null default now(),
  ip_address      inet,
  device_fingerprint text,
  selfie_hash     text,
  consent_text_version text not null
);

-- Placement records — one per candidate once they join a job
create table placements (
  id              uuid primary key default gen_random_uuid(),
  tenant_id       uuid not null references tenants(id) on delete cascade,
  candidate_id    uuid not null references candidates(id),
  employer_name   text not null,
  employer_phone  text,
  job_role        text not null,
  join_date       date,
  monthly_salary  numeric(10,2),
  status          text not null default 'pending_verification'
                    check (status in ('pending_verification', 'verified', 'rejected', 'dropped_out')),
  created_at      timestamptz not null default now()
);

-- Monthly check-ins (m1–m12 post-placement)
create table monthly_check_ins (
  id              uuid primary key default gen_random_uuid(),
  tenant_id       uuid not null references tenants(id) on delete cascade,
  placement_id    uuid not null references placements(id) on delete cascade,
  month_number    smallint not null check (month_number between 1 and 12),
  status          text not null default 'pending'
                    check (status in ('pending', 'verified', 'unresponsive', 'left_job')),
  created_at      timestamptz not null default now(),
  unique (placement_id, month_number)
);

-- Salary slips submitted by candidates (via WhatsApp)
create table salary_slips (
  id                  uuid primary key default gen_random_uuid(),
  tenant_id           uuid not null references tenants(id) on delete cascade,
  check_in_id         uuid not null references monthly_check_ins(id) on delete cascade,
  storage_path        text not null,              -- supabase storage path: tenant_id/...
  employer_name       text,
  employee_name       text,
  slip_month          text,
  slip_year           smallint,
  gross_salary        numeric(10,2),
  net_salary          numeric(10,2),
  bank_account_last4  text,
  ocr_confidence      numeric(4,3),
  needs_officer_review boolean not null default false,
  raw_ocr_response    text,
  officer_accepted    boolean,
  reviewed_at         timestamptz,
  created_at          timestamptz not null default now()
);

-- Employer attestations (mobile-web, one-time, no login)
create table employer_attestations (
  id              uuid primary key default gen_random_uuid(),
  tenant_id       uuid not null references tenants(id) on delete cascade,
  placement_id    uuid not null references placements(id) on delete cascade,
  token           text unique not null,           -- short-lived link token
  selfie_path     text,
  geo_lat         numeric(9,6),
  geo_lng         numeric(9,6),
  attested_at     timestamptz,
  expires_at      timestamptz not null,
  created_at      timestamptz not null default now()
);

-- Evidence packs (generated PDFs)
create table evidence_packs (
  id              uuid primary key default gen_random_uuid(),
  tenant_id       uuid not null references tenants(id) on delete cascade,
  placement_id    uuid references placements(id),
  batch_id        uuid references batches(id),
  pack_type       text not null check (pack_type in ('candidate', 'batch', 'ddugky_sf71b')),
  storage_path    text not null,
  file_hash       text not null,                  -- SHA-256, tamper-evident
  generated_at    timestamptz not null default now()
);

-- Razorpay payout records for candidate incentives
create table incentive_payments (
  id              uuid primary key default gen_random_uuid(),
  tenant_id       uuid not null references tenants(id) on delete cascade,
  candidate_id    uuid not null references candidates(id),
  check_in_id     uuid references monthly_check_ins(id),
  amount_paise    integer not null,               -- amount in paise (₹100 = 10000)
  razorpay_payout_id text unique,
  status          text not null default 'pending'
                    check (status in ('pending', 'processed', 'failed')),
  created_at      timestamptz not null default now()
);

-- Audit log — every write tracked for CAG defensibility
create table audit_log (
  id          bigserial primary key,
  tenant_id   uuid,
  user_id     uuid,
  table_name  text not null,
  row_id      uuid not null,
  action      text not null check (action in ('INSERT', 'UPDATE', 'DELETE')),
  old_data    jsonb,
  new_data    jsonb,
  ip_address  inet,
  created_at  timestamptz not null default now()
);

-- Indexes
create index idx_candidates_tenant   on candidates(tenant_id);
create index idx_candidates_batch    on candidates(batch_id);
create index idx_placements_candidate on placements(candidate_id);
create index idx_salary_slips_checkin on salary_slips(check_in_id);
create index idx_audit_log_tenant    on audit_log(tenant_id);
create index idx_audit_log_row       on audit_log(table_name, row_id);
