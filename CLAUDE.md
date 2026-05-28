# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

> **Pratak — A ZeroOrigins AI product. The outcome intelligence layer for India's skilling ecosystem.**

Read this fully before writing or modifying any code. When in doubt, re-read this file.

---

## Current Status

**Phase 0 — Scaffolding complete.** Core skeleton is in place. No feature screens yet — `web/src/app/page.tsx` is still the Next.js default landing page. Phase 1 (Officer Workflow MVP) is next.

**What's scaffolded:**
- `web/` — Next.js 16 app with Tailwind v4, shadcn/ui, Supabase SSR client, core TypeScript types, DB query helpers, AI service client, PWA manifest + service worker
- `services/ai/` — FastAPI app with three routers (`/ocr`, `/extraction`, `/pdf`), Claude-powered salary slip extraction, Pydantic models
- `supabase/migrations/` — Full 13-table schema (`001_init_schema.sql`) and RLS policies (`002_rls_policies.sql`); `seed.sql` present
- CI/CD pipeline in `.github/workflows/ci.yml`

---

## Development Commands

### Next.js frontend (officer PWA + owner dashboard)
```bash
cd web
pnpm install
pnpm dev             # dev server on http://localhost:3000
pnpm build           # production build
pnpm lint            # ESLint
pnpm type-check      # tsc --noEmit
```

### FastAPI Python service (OCR + AI pipeline)
```bash
cd services/ai
python -m venv .venv && source .venv/bin/activate   # Windows: .venv\Scripts\activate
pip install -r requirements.txt
uvicorn main:app --reload --port 8000
pytest                      # run all tests
pytest tests/test_ocr.py    # run a single test file
```

FastAPI reads config from `services/ai/.env` (not `.env.local`). Required vars: `ANTHROPIC_API_KEY`, `SUPABASE_URL`, `SUPABASE_SERVICE_ROLE_KEY`. Optional: `OCR_CONFIDENCE_THRESHOLD` (default 0.85).

### Testing
```bash
# Unit tests (Vitest — not yet configured; add vitest to web/ before writing tests)
pnpm test                    # watch mode
pnpm test:run                # CI mode

# E2E (Playwright — not yet configured; add @playwright/test to web/ first)
pnpm exec playwright test

# Supabase local stack
pnpm exec supabase start           # starts local Postgres + Auth + Storage
pnpm exec supabase db reset        # re-apply migrations and seed
pnpm exec supabase migration new <name>   # create a new migration
```

### Critical: Next.js 16 breaking changes
This project uses **Next.js 16.2.6** — not 14. APIs, conventions, and file structure differ from training data. Before writing any Next.js code, check `web/node_modules/next/dist/docs/` for the relevant guide. See `web/AGENTS.md` for the same warning.

---

---

## 0. Identity

- **Product name:** Pratak (always written as "Pratak" — capital P, lowercase rest. Never PRATAK, never pratak unless in URL/code.)
- **Parent company:** ZeroOrigins AI Pvt Ltd
- **Lockup in marketing:** `Pratak — by ZeroOrigins`
- **Internal acronym (don't expose publicly):** Proof. Record. Audit. Track. Align. Kindle.
- **Tagline:** *"Placement proof, in 60 seconds."*
- **Category:** Skilling Outcome Intelligence (a category we are creating, not entering)
- **Primary URL:** `pratak.in` (Year 1), `pratak.com` (Year 2+)

---

## 1. What we are building

Pratak is a verification and outcome-intelligence platform that sits **beside** the Government of India's Skill India Digital Hub (SIDH), not against it.

The system helps Project Implementing Agencies (PIAs) under PMKVY, DDU-GKY, NAPS, and state skill schemes:

1. Verify placements with audit-grade evidence (salary slips, bank credits, employer attestations)
2. Track 12-month placement retention via WhatsApp
3. Unlock trapped government tranches faster
4. Feed clean outcome data into SIDH and state mission dashboards

**What we are NOT building:**
- Another LMS or course delivery platform
- A replacement for SIDH (mandatory government portal)
- A replacement for AEBAS (biometric attendance)
- An assessment/certification engine (NSDC/SSCs own this)
- A B2C app for candidates (candidates only interact via WhatsApp)

---

## 2. The buyers and the users (always design for these)

### Primary user — Placement Officer "Ramesh"
- 35–45 years old, in-the-trenches operations
- Speaks Telugu/Hindi natively, reads basic English
- Uses Android phone, lives in WhatsApp and Excel
- Manages 100–200 candidates across 3–5 active batches
- Today: chases candidates by phone for salary slips, dies in Excel reconciliation
- Tomorrow: opens Pratak first thing Monday morning to see rupees at risk
- **Hero of the product. Every UI choice optimizes for this user.**

### Cheque-signer — PIA Owner "Mr. Reddy"
- 50s, first-generation entrepreneur, runs 3–15 centers
- Signs English contracts, decides in Telugu/Hindi
- Cares about ONE number: tranches recovered this quarter
- Uses laptop, opens dashboard weekly on Sunday evenings
- Doesn't read feature lists — reads outcomes

### Passive user — Candidate "Lakshmi"
- 19–28 years old, rural background, training graduate
- Owns Android phone, uses WhatsApp/YouTube/Phonepe
- NEVER installs the Pratak app — only interacts via WhatsApp
- Sees messages "from Ramesh sir," not "from Pratak"
- Receives ₹100–500 Phonepe incentives at verification checkpoints

### One-time user — Employer "Suresh"
- MSME manager, hired our candidate through the PIA
- Spends 30 seconds on a single mobile-web verification link
- Never logs in, never signs up

### Year-2 buyer — State Mission Official
- SRLM/SSDM Joint Director or equivalent
- Cares about CAG-defensibility and ghost-trainee detection
- Buys at ₹50L–₹2 crore annual SaaS license per state

---

## 3. Architecture (high-level)

```
┌────────────────────────────────────────────────────────────────┐
│                      PRATAK SYSTEM                              │
├────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌──────────────┐    ┌──────────────┐    ┌──────────────┐     │
│  │ Officer App  │    │ Owner Web    │    │ Employer Web │     │
│  │ (mobile)     │    │ Dashboard    │    │ (one-page)   │     │
│  └──────┬───────┘    └──────┬───────┘    └──────┬───────┘     │
│         │                   │                    │             │
│         └───────────────────┼────────────────────┘             │
│                             │                                   │
│                  ┌──────────▼──────────┐                       │
│                  │   API Gateway        │                       │
│                  │  (Next.js / FastAPI) │                       │
│                  └──────────┬──────────┘                       │
│                             │                                   │
│   ┌─────────────┬───────────┼────────────┬────────────┐        │
│   │             │           │            │            │        │
│ ┌─▼──┐    ┌────▼─────┐ ┌───▼────┐  ┌────▼────┐  ┌────▼────┐  │
│ │Auth│    │WhatsApp  │ │OCR &   │  │Evidence │  │SIDH     │  │
│ │    │    │Business  │ │AI      │  │Locker   │  │Sync     │  │
│ │    │    │API       │ │Pipeline│  │(S3)     │  │Adapter  │  │
│ └────┘    └──────────┘ └────────┘  └─────────┘  └─────────┘  │
│                                                                 │
│                  ┌──────────────────────┐                       │
│                  │  Postgres + Supabase │                       │
│                  │  (multi-tenant)      │                       │
│                  └──────────────────────┘                       │
│                                                                 │
└────────────────────────────────────────────────────────────────┘
```

### Service boundaries (build in this order, ship one at a time)

| # | Service | Why first/later |
|---|---|---|
| 1 | **Auth & multi-tenant DB** | Foundation. Every PIA is a tenant. |
| 2 | **Officer mobile app (PWA initially)** | The hero use case. Build before anything else. |
| 3 | **WhatsApp Business API integration** | Officer-to-candidate bridge. No candidate flow without this. |
| 4 | **OCR + AI extraction pipeline** | Salary slip parsing. This is the wow moment. |
| 5 | **Evidence Locker + PDF generator** | The cheque-signing moment for Mr. Reddy. |
| 6 | **Owner web dashboard** | After officer flow is real. Don't build empty dashboards. |
| 7 | **Employer mobile-web attestation** | Single-page, no auth. Build late. |
| 8 | **SIDH API adapter** | Once we have proof of value and a real PIA partner. |
| 9 | **State Mission dashboard** | Year 2 only. Don't pre-build. |

**Discipline: ship vertical slices, not horizontal layers.** Don't build "all the backend then all the frontend." Build one feature end-to-end and put it in front of Ramesh.

---

## 4. Tech stack (chosen, not negotiable without discussion)

### Frontend
- **Next.js 16.2.6 (App Router)** — not 14. Has breaking changes from training data; read `web/node_modules/next/dist/docs/` before using Next.js APIs.
- **TypeScript** everywhere. No JavaScript files in the codebase.
- **Tailwind CSS v4** + **shadcn/ui v4** + **`@base-ui/react`** for component primitives. Tailwind v4 config is in `postcss.config.mjs` — no `tailwind.config.ts` in v4.
- **React 19.2.4**, **React Hook Form v7** + **Zod v4** for all forms. Note: Zod v4 has a different API from v3 (e.g., `.parse()`, `.safeParse()` are compatible but some methods changed).
- **TanStack Query v5** for server state (installed, not yet wired up in `app/layout.tsx`)
- **PWA-first for the officer app** — `web/public/sw.js` (service worker) and `web/src/app/manifest.ts` are scaffolded
- Supabase client: `@supabase/ssr` package. Use `web/src/lib/utils/supabase.ts` for browser client, `web/src/lib/utils/supabase-server.ts` for Server Components and Route Handlers.

### Backend
- **Next.js API routes** for simple CRUD (Phase 1)
- **FastAPI (Python)** as a separate service for: OCR pipeline, AI extraction, PDF generation, document processing
- **Supabase** for: Postgres, auth, storage, realtime subscriptions, row-level security (RLS)
- **Why Supabase:** multi-tenant RLS out of the box, India-friendly pricing, fast to ship MVP

### AI / OCR
- **Anthropic Claude API** for the document understanding pipeline (salary slip OCR, employer attestation parsing, candidate intent classification)
- **Sonnet 4 for primary extraction, Haiku for high-volume classification**
- Fallback OCR via **Tesseract** for low-confidence cases
- **Voice-to-text in Telugu/Hindi:** AI4Bharat IndicTrans + Whisper (multilingual)

### Messaging
- **WhatsApp Business API** via **Gupshup** or **Wati** (India-localized BSPs)
- All candidate-facing messages must be approved templates (WhatsApp policy)
- Officer-initiated messages flow through the officer's verified business number

### Payments
- **Razorpay Payouts** for candidate incentives (₹100–500 Phonepe/UPI transfers)
- Razorpay for any PIA-side billing (subscription + outcome-linked)

### Storage
- **Supabase Storage** for salary slips, attestations, evidence PDFs
- All documents encrypted at rest, signed URLs for retrieval
- **7-year retention** (audit requirement under DDU-GKY guidelines)

### Hosting
- **Vercel** for Next.js apps
- **Railway** or **AWS ECS** for the FastAPI Python service
- **Supabase Cloud** (India region) for the database
- **CloudFront/Bunny CDN** for static assets

### Observability
- **Sentry** for error tracking
- **PostHog** for product analytics (self-hosted on Hetzner for DPDP compliance)
- **Better Stack / Uptime Kuma** for uptime

---

## 5. Data model (core entities)

These are the canonical names. Use them everywhere in code, DB, API, and UI.

```
Tenant (PIA)
  ├── Centers (1-many physical training locations)
  ├── Officers (placement staff, trainers, admins)
  ├── Batches (cohorts of candidates, scheme-tagged)
  │     ├── Scheme (PMKVY 4.0, DDU-GKY, NAPS, state schemes)
  │     ├── JobRole (NSQF-aligned QP code)
  │     └── Candidates (1-many)
  │           ├── ConsentRecord (Day 1 digital consent)
  │           ├── TrainingRecords (attendance, assessments)
  │           ├── Placement (employer, role, salary, start date)
  │           │     ├── Employer (entity, contact, GST/Udyam)
  │           │     ├── OfferLetter (document + e-sign trace)
  │           │     ├── MonthlyCheckIns (m1-m12)
  │           │     │     ├── SalarySlips (OCR-extracted)
  │           │     │     ├── BankCredits (AA-pulled, Y2+)
  │           │     │     └── EmployerAttestations
  │           │     └── EvidencePacks (generated PDFs)
  │           └── IncentivePayments (Razorpay payout records)
  └── Subscription (billing, plan, outcome-linked fees)
```

### Naming rules (enforce in PR review)
- DB tables: `snake_case`, plural (`candidates`, `salary_slips`)
- TypeScript types: `PascalCase`, singular (`Candidate`, `SalarySlip`)
- API routes: `kebab-case` (`/api/salary-slips/:id`)
- Components: `PascalCase` (`SalarySlipCard.tsx`)
- Indian-context entities use Indian names (`Tenant` not `Organization`, `Center` not `Branch`, `Officer` not `Staff`)

---

## 6. Multi-tenancy (critical, read carefully)

Pratak is multi-tenant from Day 1. Every PIA is a `Tenant`.

- **Row-level security (RLS) is mandatory** on every table that holds tenant data
- **Every query must filter by `tenant_id`** — enforced at the database level, not at the application level
- **No "admin sees all" shortcut** — even ZeroOrigins internal staff use a special `superadmin_role` with audit logging
- **Test:** the first test for any new table is "User from Tenant A cannot read/write Tenant B's rows"

### Tenant isolation checklist
- [ ] Every table has a `tenant_id` foreign key
- [ ] RLS policies enforce `tenant_id = auth.jwt() -> tenant_id`
- [ ] Storage paths prefixed with `tenant_id/`
- [ ] WhatsApp templates scoped per tenant
- [ ] Background jobs (queues) tagged with `tenant_id`
- [ ] Logs and analytics events carry `tenant_id`

---

## 7. Language & UX (the part most US-built tools get wrong)

### Languages supported
- **English** — admin/officer UI default
- **Telugu** — first regional language (TG/AP launch market)
- **Hindi** — second priority
- **Tamil, Kannada, Marathi** — Phase 2

### UX principles
1. **Candidate-side is voice-first.** Voice notes, voice-to-text, audio AI replies. Many rural candidates struggle with typing.
2. **Officer-side is one-tap.** Every common action ("Nudge all", "Generate pack", "Verify") is one tap from home.
3. **Money in headlines.** Every screen the officer or owner sees leads with ₹ numbers, not feature names.
4. **No emoji theater.** This is government-adjacent software. Use emoji sparingly (notification icons OK, decorative no).
5. **No "AI" branding.** "AI-powered" is not a selling point for Mr. Reddy. The product just works.
6. **Telugu first in WhatsApp templates.** Even for users marked as Hindi-preferred, default to Telugu in TG/AP.
7. **Loading states show progress, not spinners.** "Reading slip... extracting employer... checking salary..." beats a circle.

### Typography & visual
- **Inter** for English UI
- **Noto Sans Telugu, Noto Sans Devanagari** for Indic scripts (always pair with the corresponding English font for mixed text)
- **Primary color:** Deep indigo `#1E3A8A` (trust)
- **Accent:** Terracotta `#D97706` (warmth, distinctly Indian)
- **Success:** `#22C55E` Danger: `#DC2626` Warning: `#F59E0B`
- **No gradients, no glassmorphism, no AI-sparkle.** Pratak should look more like a bank than a Bay Area SaaS.

---

## 8. Compliance & legal (do not skip)

### DPDP Act 2023 (mandatory)
- Pratak is a **Data Fiduciary** under DPDP
- Every candidate must give **explicit, recorded consent** at Day 1 of training
- Consent stored with: timestamp, IP, device fingerprint, selfie hash, retained 7 years
- **Purpose limitation:** salary data used only for verification, never resold without separate consent
- **Right to erasure:** must support data deletion within 30 days of request
- Maintain a **Privacy Notice in 8 regional languages**

### Aadhaar use
- NEVER store raw Aadhaar numbers in our database
- Use **DigiLocker** for ID verification
- Use **Aadhaar eSign** for consent (legally valid digital signature)
- Use **Account Aggregator framework** (RBI-regulated) for bank data — Year 2

### Government data handling
- SIDH integration uses official MSDE-published APIs only
- All government-format exports (DDU-GKY SF 7.1B, PMKVY tranche templates) maintained as version-controlled templates
- Audit trail: every data write logged with `who, what, when, from where`

### Financial data
- Salary slips encrypted at rest (AES-256)
- Bank statement data (AA): RBI-mandated retention rules
- Razorpay payout records: 7-year retention

---

## 9. Build phases (with hard exit criteria)

### Phase 0 — Setup (Week 1)
- [ ] Repo, CI/CD, branch protection
- [ ] Supabase project, base schema, RLS policies
- [ ] Next.js + Tailwind + shadcn scaffolding
- [ ] FastAPI scaffolding for AI/OCR service
- [ ] WhatsApp BSP sandbox account (Gupshup/Wati)
- [ ] Anthropic API key wired

### Phase 1 — Officer Workflow MVP (Weeks 2–5)
**Exit criteria:** Ramesh (real placement officer at friend's PIA) uses it daily for one batch's verification cycle and signs an LOI.

- [ ] Officer signup + OTP login
- [ ] Batch creation (manual CSV upload of candidates)
- [ ] Placement entry (1 candidate at a time)
- [ ] WhatsApp nudge from officer's number (preview + send)
- [ ] Salary slip receipt via WhatsApp webhook
- [ ] OCR extraction via Claude Sonnet (employer, month, gross, net, bank)
- [ ] Officer accept/reject flow
- [ ] Basic candidate timeline view

### Phase 2 — Evidence Pack (Weeks 6–7)
**Exit criteria:** A real audit pack generated for 30 candidates, accepted by PIA's compliance team.

- [ ] PDF generator (per-candidate evidence)
- [ ] Batch evidence bundle (SIDH-compatible format)
- [ ] DDU-GKY SF 7.1B export
- [ ] Storage with signed URLs
- [ ] Tamper-evident hash chain

### Phase 3 — Owner Dashboard (Weeks 8–9)
**Exit criteria:** Mr. Reddy uses it once a week and writes the first invoice.

- [ ] Multi-batch overview
- [ ] Tranches recovered metric
- [ ] Center-wise drill-down
- [ ] Red flags surface
- [ ] Weekly email digest

### Phase 4 — Candidate Loyalty Loop (Weeks 10–12)
- [ ] Razorpay payout integration (₹100/500 incentives)
- [ ] Telugu/Hindi AI interview coach via WhatsApp
- [ ] AI-generated resume from training records
- [ ] Monthly retention check-ins

### Phase 5 — Employer Attestation (Weeks 13–14)
- [ ] One-page mobile web attestation
- [ ] Selfie + geo + timestamp capture
- [ ] Officer-shareable links

### Phase 6 — Second PIA + Scale Hardening (Weeks 15+)
- [ ] Second tenant onboarded
- [ ] WhatsApp message rate limits handled
- [ ] OCR confidence threshold tuning
- [ ] Cost/candidate analysis
- [ ] First pricing experiment

---

## 10. Coding conventions

- **TypeScript strict mode** — no `any` without comment justification
- **Server components by default** in Next.js App Router
- **Zod v4 schemas** are the source of truth for data shape — derive TS types with `z.infer<typeof schema>`. Note: currently `web/src/types/index.ts` has hand-written types; migrate them to Zod schemas as features are built.
- **`Result<T>` pattern** is already defined in `web/src/types/index.ts` — use it for all DB and AI service calls. Never throw raw errors to the UI.
- **DB queries go through `web/src/lib/db/`** — never call Supabase directly from a component. Two files exist: `candidates.ts`, `placements.ts`. Add new entity files here.
- **AI calls go through `web/src/lib/ai/`** — `extract-salary-slip.ts` calls `AI_SERVICE_URL/ocr/salary-slip`. Add other AI client functions alongside it.
- **Tests:** Vitest for unit, Playwright for E2E. Neither is configured yet — add `vitest` and `@playwright/test` to `web/` before writing tests.
- **Logging:** Pino in Node, structured JSON. Include `tenant_id`, `user_id`, `request_id` on every log.
- **Secrets:** All in env vars. Copy `.env.example` → `.env.local` for `web/`; copy to `services/ai/.env` for FastAPI.
- **Git:** Conventional commits (`feat:`, `fix:`, `chore:`). PR template includes "Tenant isolation tested?" checkbox.

---

## 11. AI prompting conventions (for the OCR/extraction pipeline)

When extracting structured data from documents using Claude, follow this pattern:

```python
# Always provide:
# 1. The document image
# 2. A Zod-like schema as the expected output format
# 3. Confidence scoring instructions
# 4. Fallback handling for low-confidence cases

# Always parse output as JSON with a strict schema
# Always store the raw model response alongside parsed data
# Never auto-accept extractions below 85% confidence
# Below 85% → flag for officer review
```

System prompt template for salary slip extraction lives in `services/ai/prompts/salary_slip.md`. Versioned. Reviewed quarterly.

---

## 12. What "done" looks like for a feature

A feature is not done until:
- [ ] It works for Tenant A and not for Tenant B (RLS verified)
- [ ] It has an automated test
- [ ] It has been used by a real user (officer or owner) at least once
- [ ] It logs the right events for analytics
- [ ] It has error states designed (not just happy path)
- [ ] It has a Telugu and English version of any user-facing text
- [ ] It is documented in the in-app help OR officer onboarding sheet

---

## 13. Things we explicitly say NO to (until evidence)

- ❌ Native mobile apps (iOS/Android) — PWA first, native only if PWA fails
- ❌ Blockchain for evidence (just hash chains + audit logs)
- ❌ Direct candidate-facing app — WhatsApp is the channel
- ❌ Course content authoring — we're not an LMS
- ❌ Assessment/exam features — NSDC/SSCs own this
- ❌ Marketing automation tooling for PIAs — not our category
- ❌ AI "agents" doing autonomous actions on candidates — every action through an officer
- ❌ Building for non-Skill-India schemes in Year 1 (CSR, corporate L&D) — focus

---

## 14. Strategic context (re-read when prioritizing)

- PMKVY 4.0 achieved 15% of target. PMKVY 5.0 is being designed around outcome tracking, skill outcome bonds, APAAR ID.
- CAG Report No. 20 of 2025 flagged 87% missing attendance, 94% bad bank data, 41% placement rate.
- DDU-GKY 12-month tracking is mandatory but largely uncollected.
- SIDH exists; it solves workflow, not trust.
- Our window: 18–24 months before government or a big staffing player builds this themselves.
- Year 1 buyer: PIA (₹500/candidate or 10% tranche unlock)
- Year 2 buyer: State Mission (₹50L–₹2cr/year SaaS)
- Year 3+: outcome bond financiers, CSR corporates, MSME marketplace hire fees

When facing any prioritization trade-off, ask: *"Does this move us closer to the first paid PIA pilot, or further?"* If further, defer.

---

## 15. Who maintains this file

- **Naveen** (founder) — final say on product direction, brand voice, strategic priority
- **Tech lead** (TBD) — final say on architecture and engineering quality
- This file is updated at the start of each phase. Version-controlled, reviewed in PRs.
- If you (the AI assistant) find this file out of date, flag it before writing code.

---

## 16. Environment variables

Copy `.env.example` to `.env.local` (for `web/`) and `services/ai/.env` (for FastAPI). All vars:

```
# Supabase
NEXT_PUBLIC_SUPABASE_URL=
NEXT_PUBLIC_SUPABASE_ANON_KEY=
SUPABASE_SERVICE_ROLE_KEY=

# Anthropic (used by FastAPI, not Next.js directly)
ANTHROPIC_API_KEY=

# WhatsApp BSP
WHATSAPP_API_URL=
WHATSAPP_API_KEY=
WHATSAPP_SENDER_NUMBER=

# Razorpay
RAZORPAY_KEY_ID=
RAZORPAY_KEY_SECRET=
RAZORPAY_ACCOUNT_NUMBER=

# Resend
RESEND_API_KEY=

# AI Service (FastAPI → called from Next.js)
AI_SERVICE_URL=http://localhost:8000
AI_SERVICE_API_KEY=

# Analytics
NEXT_PUBLIC_POSTHOG_KEY=
NEXT_PUBLIC_POSTHOG_HOST=
```

---

*Last updated: May 2026 · v1.1 · Naveen / ZeroOrigins AI*
