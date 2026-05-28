// Canonical entity types — derived from Zod schemas in lib/validators/
// DB tables: snake_case. TS types: PascalCase. API routes: kebab-case.

export type Scheme = "PMKVY" | "DDU-GKY" | "NAPS" | "STATE" | "OTHER";
export type Lang = "te" | "hi" | "en" | "ta" | "kn" | "mr";
export type OfficerRole = "officer" | "admin" | "superadmin";
export type PlacementStatus =
  | "pending_verification"
  | "verified"
  | "rejected"
  | "dropped_out";
export type CheckInStatus = "pending" | "verified" | "unresponsive" | "left_job";
export type PaymentStatus = "pending" | "processed" | "failed";

export interface Tenant {
  id: string;
  name: string;
  slug: string;
  created_at: string;
}

export interface Center {
  id: string;
  tenant_id: string;
  name: string;
  district: string | null;
  state: string | null;
  created_at: string;
}

export interface Officer {
  id: string;
  tenant_id: string;
  center_id: string | null;
  user_id: string;
  name: string;
  phone: string | null;
  role: OfficerRole;
  created_at: string;
}

export interface Batch {
  id: string;
  tenant_id: string;
  center_id: string;
  name: string;
  scheme: Scheme;
  job_role: string | null;
  qp_code: string | null;
  start_date: string | null;
  end_date: string | null;
  created_at: string;
}

export interface Candidate {
  id: string;
  tenant_id: string;
  batch_id: string;
  name: string;
  phone: string;
  preferred_lang: Lang;
  whatsapp_opted_in: boolean;
  created_at: string;
}

export interface Placement {
  id: string;
  tenant_id: string;
  candidate_id: string;
  employer_name: string;
  employer_phone: string | null;
  job_role: string;
  join_date: string | null;
  monthly_salary: number | null;
  status: PlacementStatus;
  created_at: string;
}

export interface SalarySlip {
  id: string;
  tenant_id: string;
  check_in_id: string;
  storage_path: string;
  employer_name: string | null;
  employee_name: string | null;
  slip_month: string | null;
  slip_year: number | null;
  gross_salary: number | null;
  net_salary: number | null;
  bank_account_last4: string | null;
  ocr_confidence: number | null;
  needs_officer_review: boolean;
  officer_accepted: boolean | null;
  reviewed_at: string | null;
  created_at: string;
}

export interface MonthlyCheckIn {
  id: string;
  tenant_id: string;
  placement_id: string;
  month_number: number;
  status: CheckInStatus;
  created_at: string;
}

// API response wrapper — never throw raw errors to the UI
export type Result<T> =
  | { success: true; data: T }
  | { success: false; error: string };
