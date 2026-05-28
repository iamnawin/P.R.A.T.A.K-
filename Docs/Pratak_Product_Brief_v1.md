# Pratak — Product Brief v1.0

> **Placement proof, in 60 seconds.**
>
> A ZeroOrigins AI product. The outcome intelligence layer for India's skilling ecosystem.

---

**Document status:** Canonical · Supersedes all prior strategy documents
**Version:** 1.0 · May 2026
**Owner:** Naveen / ZeroOrigins AI Pvt Ltd
**Audience:** Founders, employees, investors, government stakeholders, pilot partners

---

## Table of Contents

1. The 60-second pitch
2. Why now — the timing window
3. What we are building
4. What we are not building
5. The users (designed for these humans)
6. The 11-step Pratak journey
7. The five product modules
8. The Job Readiness Score
9. Gap analysis vs. existing ecosystem
10. Business model & pricing
11. Sample pilot outcome report
12. Brand & naming
13. Architecture & tech decisions
14. Compliance, privacy, and trust
15. Build phases & exit criteria
16. The pilot plan (next 90 days)
17. Risks & honest unknowns
18. The strategic statement

---

## 1. The 60-second pitch

India runs the world's largest skill-development program. The Skill India Mission has trained over 1.64 crore people. PMKVY is the flagship — ₹8,800 crore Cabinet-approved outlay through 2026.

It has a problem.

**PMKVY 4.0 achieved only 15% of its training target.** The CAG's December 2025 Performance Audit Report found that 87% of attendance records, 94% of bank account records, and 41% of placement claims could not be verified. The government has publicly stated that **PMKVY 5.0 will be designed around outcome tracking, skill outcome bonds, and APAAR-linked identity**.

The existing systems (SIDH, SDMS, NSDC monitoring, AEBAS) solved the *workflow* layer — enrollment, attendance, certification, disbursement. They did not solve the *trust* layer — verified employment, retention, real salary, real employer.

**Pratak is the verification and outcome-intelligence platform that fills that gap.** We sit beside SIDH, not against it. PIAs pay us in Year 1 because we unlock their trapped placement tranches. State Missions license us in Year 2 because we solve the exact problems CAG flagged. Outcome-bond financiers and CSR corporates buy our data in Year 3 because we make their instruments bankable.

We are not building another LMS. We are not building another attendance system. We are building **the outcome intelligence layer that PMKVY 5.0 will require — before it requires it**.

---

## 2. Why now — the timing window

Four facts, in this exact order, define the window:

1. **PMKVY 4.0 missed its target by 85%.** Of a 30 lakh certification target for FY 2025-26, only 2.87 lakh were certified.
2. **CAG Performance Audit Report No. 20 of 2025** publicly flagged systemic verification failures: 87% missing attendance, 94% bad bank records, 41% placement rate, ghost trainees, reused photos across states.
3. **PMKVY 5.0 is in active design.** Official MSDE documents confirm new features including post-training outcome tracking, skill vouchers, skill outcome bonds, skill loans, and APAAR-linked unique skill identity.
4. **In PMKVY 4.0, placements were officially delinked from disbursement.** The pendulum is now swinging hard the other way for 5.0.

**This is a 18–24 month window** before the government either builds the verification layer themselves, partners with a single national vendor, or a large staffing company (Quess, TeamLease) builds it. Pratak's job is to be the proven, trusted player when that decision happens.

---

## 3. What we are building

Pratak is a multi-tenant SaaS platform with three core surfaces:

- **Officer mobile app (PWA)** — used daily by Placement Officers at PIAs to track candidates from training completion through 90-day retention
- **Owner web dashboard** — used weekly by PIA owners and project directors to see tranches recovered, center performance, and red flags
- **Employer mobile-web attestation** — single-page, no-signup verification used once per candidate by hiring MSMEs

Underneath these surfaces, the platform runs:

- A **WhatsApp Business API** layer for all candidate communication (candidates never install an app)
- An **AI extraction pipeline** (Claude Sonnet for documents, Haiku for classification, IndicTrans/Whisper for Telugu/Hindi voice)
- An **evidence locker** with tamper-evident audit packs, SIDH-compatible exports, and DDU-GKY form generators
- A **payouts engine** for ₹100–500 candidate incentives via Razorpay → UPI/Phonepe
- A **state-mission analytics layer** (Year 2) for SRLM/SSDM dashboards

The product converts skill-development programs from **activity-based** ("the candidate attended") to **outcome-driven** ("the candidate joined, stayed 90 days, earned ₹14,500, and is still in role at month 6").

---

## 4. What we are not building

This list matters as much as the previous one. Discipline.

- ❌ Not an institute, hostel, or physical training provider (that's IgnAIte, a separate brand)
- ❌ Not a replacement for SIDH, SDMS, NSDC monitoring, or AEBAS
- ❌ Not an LMS or course content authoring tool
- ❌ Not an assessment/certification engine (NSDC, SSCs own this)
- ❌ Not a B2C candidate-facing app — candidates only interact via WhatsApp
- ❌ Not an attendance-capture system — we don't compete with AEBAS in Year 1
- ❌ Not a government MIS or compliance reporting replacement
- ❌ Not a marketplace for course discovery
- ❌ Not a native mobile app at launch — PWA only until proven need
- ❌ Not building for non-Skill-India schemes (corporate L&D, CSR-only) in Year 1
- ❌ Not building autonomous AI agents on candidates — every action flows through a human officer

---

## 5. The users (designed for these humans)

### Ramesh — Placement Officer (the hero, daily user)
35–45, in-the-trenches operations at a TG/AP PIA. Telugu/Hindi native, basic English reader. Android phone, lives in WhatsApp and Excel. Manages 100–200 candidates across 3–5 active batches. Today: chases salary slips by phone, dies in Excel reconciliation. Tomorrow: opens Pratak first thing Monday to see rupees at risk. **Every UI choice optimizes for Ramesh.**

### Mr. Reddy — PIA Owner (the cheque-signer)
50s, first-generation entrepreneur, runs 3–15 centers. Signs English contracts, decides in Telugu/Hindi. Cares about ONE number: tranches recovered this quarter. Opens dashboard on Sunday evenings before Monday's review.

### Lakshmi — Candidate (passive participant, WhatsApp-only)
19–28, rural background, training graduate. Android phone with WhatsApp/YouTube/Phonepe. **Never installs the Pratak app.** Sees messages "from Ramesh sir," not "from Pratak." Receives ₹100–500 Phonepe incentives at verification checkpoints.

### Suresh — Employer (one-time, 30 seconds)
MSME manager at the company that hired our candidate. Spends 30 seconds on a single mobile-web verification link. No signup, no login.

### Joint Director, State Skill Mission — Year 2 buyer
SRLM/SSDM official. Cares about CAG-defensibility, ghost-trainee detection, cross-PIA visibility. Buys at ₹50L–₹2 crore annual SaaS license per state.

### Trainer, CSR program manager, Sector Skill Council reviewer — Year 2-3 extensions
Defined when we get there. Don't pre-build.

---

## 6. The 11-step Pratak journey

Every batch the platform touches follows this sequence. It is the spine of the product.

| # | Step | What Pratak does | When |
|---|---|---|---|
| 1 | **Candidate registration** | Tenant uploads candidate CSV from SIDH/internal records | Day 0 of batch |
| 2 | **Background profile** | Telugu-language profile capture: education, mobility, salary expectation, language fluency | Days 1–7 |
| 3 | **Day-1 consent** | Digital consent via DigiLocker e-sign + selfie — authorizes 12-month tracking | Day 1 (once) |
| 4 | **Training engagement** | Weekly WhatsApp coach: AI mock interview, attendance leaderboard, voice-tip drills (free, value-giving — not extractive) | Days 7–80 |
| 5 | **Resume generation** | AI-built resume from training records — Telugu and English versions | Day 80 |
| 6 | **Job readiness scoring** | Five-tier classification (Not Ready / Needs Support / Interview Ready / Placement Ready / High Potential) | Day 85 |
| 7 | **Employer matching** | Officer triggers shortlist; MSME marketplace (Module D) suggests matches | Day 85–90 |
| 8 | **Interview tracking** | Officer logs interview status; candidate prep via WhatsApp the night before | Days 90–110 |
| 9 | **Offer & joining** | Employer e-sign attestation of offer letter and joining date | Day 110+ |
| 10 | **30/60/90-day retention** | Monthly WhatsApp check-ins; salary slip OCR; incentivized at ₹100–500/checkpoint | Months 1–3 |
| 11 | **Impact report** | One-click batch outcome report: SIDH-ready PDF + sales asset PDF for the PIA owner | Day 180 |

This sequence is **identical whether the candidate is DDU-GKY, PMKVY 4.0, NAPS, or a state scheme**. The platform abstracts the scheme; the journey is universal. This is also what makes the product portable across schemes — and is exactly the cross-scheme outcome visibility PMKVY 5.0 is being designed to enable.

---

## 7. The five product modules

Build in this order. Ship one before starting the next.

### Module A — Placement Verification Engine (MVP, Phase 1)
The wedge. Replaces officer's Excel + WhatsApp + paper chase.
- WhatsApp nudge automation (from officer's verified number)
- Salary slip OCR via Claude Sonnet
- Bank credit verification (Account Aggregator, Phase 2)
- Employer mobile-web attestation
- 12-month retention check-ins in Telugu/Hindi
- Audit-grade evidence locker with PDF generator (60-second SIDH-compatible packs)

### Module B — AI Readiness Coach
Closes the readiness gap before placement. Built after Module A is proven.
- AI mock interview in Telugu/Hindi (voice-first via WhatsApp)
- Resume auto-generation from training data
- Job Readiness Score (5-tier — see Section 8)
- Weekly progress nudges
- Top-5 attendance leaderboards (gamification)

### Module C — Trust & Compliance Layer
Unlocks State Mission as a second buyer. Year 1.5 / Year 2.
- AEBAS+ wrapper: liveness, geo-tagged class selfies (catches ghost trainees)
- Photo de-duplication across centers and states
- Trainer's view: attendance, daily feedback, struggling-candidate flagging
- Tamper-evident hash chain on all evidence
- SRLM/SSDM red-flag dashboards

### Module D — MSME Employer Marketplace
The hire-side revenue engine. Solves the "same 10 employers" bottleneck.
- 30-second MSME signup (GST or Udyam)
- Free job posting
- AI-matched candidate shortlist with verified training data
- One-tap WhatsApp interview request
- E-signed offer letter generation
- Pay-per-hire model (₹2,000–5,000 per successful placement)

### Module E — Outcome Data Intelligence
Year 2-3. Sold to NITI Aayog, MUDRA banks, CSR corporates, outcome-bond financiers.
- Anonymized skill–employment heatmaps
- District-wise placement reality vs. claimed
- Sector-wise outcome benchmarking
- CAG-defensible export packs
- Pre-qualification data for MUDRA, Skill Loans

---

## 8. The Job Readiness Score

A 5-tier readiness band, calculated once per candidate at Day 85 and re-scored monthly post-placement. This is the **strongest single productized concept** in Pratak — it is easy to explain to non-technical buyers and becomes a contract-bound metric.

### Score components

| Signal | Weight | Source |
|---|---|---|
| Training attendance | 15% | Imported from AEBAS / manual upload |
| Assessment scores | 15% | Imported from NSDC certification |
| Resume completion | 10% | Pratak resume builder |
| Mock interview score | 20% | AI evaluation via Module B |
| Communication rating | 10% | Trainer + AI scoring |
| Trainer narrative feedback | 10% | Officer/trainer input |
| Mobility readiness | 10% | Self-declared in profile + behavioral signals |
| Employer-fit alignment | 10% | Skill–role match vs. local demand |
| **Total** | **100%** | |

### The 5 tiers

| Tier | Score range | What it means | Action |
|---|---|---|---|
| **Not Ready** | 0–35 | Multiple gaps, dropout risk | Extended support, retraining recommendation |
| **Needs Support** | 36–55 | Core skills present, soft skills weak | Targeted communication + interview coaching |
| **Interview Ready** | 56–75 | Can attend interviews, may need conversion help | Active placement pipeline |
| **Placement Ready** | 76–90 | High likelihood of selection and joining | Priority for employer matching |
| **High Potential** | 91–100 | Top tier candidates, often premium roles | Showcase candidates for CSR/government reports |

**Why this matters as a product asset:**
- PIA owners can finally answer the question *"how ready is my batch?"* with a number
- CSR funders get a pre-placement leading indicator, not a post-placement lagging one
- Government dashboards get cross-PIA readiness comparisons
- The score is contractable — outcome bonds and pay-for-success programs can reference it directly

---

## 9. Gap analysis vs. existing ecosystem

| Area | Existing coverage | Remaining gap | Pratak's wedge |
|---|---|---|---|
| Candidate registration | SIDH, Kaushal Panjee, state portals | Profiles aren't useful for *employer matching* or *outcome scoring* | Candidate Skill Passport with verified outcome history |
| Attendance | AEBAS (mandatory since 2018) | Attendance doesn't prove employability | Use as one signal in Job Readiness Score |
| Certification | NSDC, NCVET, SSCs | Certificate ≠ Job | Outcome verification beyond certification |
| Disbursement | SDMS, PFMS, DBT | Disbursement unlocked but tranches blocked when placement unverifiable | One-click audit pack → tranche unlock |
| Placement tracking | Basic entry in SDMS | No verification, no retention, no salary truth | OCR + AA + employer e-sign + 12-month checks |
| Government MIS | SIDH dashboards | Aggregate workflow, not outcome quality | Outcome intelligence + CAG-defensible exports |
| Employer connection | Fragmented job boards | Employers can't trust training quality | Verified training data attached to every candidate |
| CSR impact reporting | Manual PDFs from NGOs | Funders can't verify reported impact | Live, audit-grade outcome dashboards |
| Career guidance | Weak in rural areas | Candidates need personalized Telugu/Hindi support | AI WhatsApp coach in regional languages |
| Dropout management | Reactive | Risk not predicted | Readiness score surfaces risk early |
| Cross-scheme visibility | None (each scheme is siloed) | A candidate trained under DDU-GKY 2022 has no identity in PMKVY 2025 | APAAR-aligned candidate ledger — what PMKVY 5.0 wants |

**The strategic principle:** Don't compete where the government has built; complement what it hasn't. Every row in column 3 is Pratak's territory.

---

## 10. Business model & pricing

Five revenue streams, four buyers. Pricing reflects realistic PIA economics (per-trainee government payout ~₹35–55K, PIA margin ~10–15%).

| # | Stream | Buyer | Pricing | Y1 plan | Y3 potential |
|---|---|---|---|---|---|
| 1 | **Outcome-linked pilot** | PIA | 10% of unlocked placement tranche, ₹0 upfront | 3 PIAs, ₹10–15L | — |
| 2 | **Per-batch SaaS** | PIA | ₹500/candidate (~₹15k per 30-batch) post-pilot | 50 batches = ₹7.5L | 2,000 batches = ₹3cr |
| 3 | **MSME hiring fee** | MSME/gig platforms | ₹2,000–5,000 per successful hire | 500 hires = ₹15L | 10,000 hires = ₹3cr |
| 4 | **State mission license** | SRLM / SSDM | ₹50L – ₹2cr per state per year | 1 state (TG) = ₹50L | 5 states = ₹5cr |
| 5 | **CSR / Outcome bond data** | Corporates, financiers, NITI Aayog | ₹5–10L per project; data-licensing deals | 5 projects = ₹30L | 30 projects = ₹2cr |
| | **Total revenue (illustrative)** | | | **~₹1cr Y1** | **~₹13cr Y3** |

### Pricing principles

- **No revenue from candidates ever.** They have no money. Ethical, scalable.
- **No revenue from government in Year 1.** Avoid the empanelment trap. Sell to government only in Year 2 with proof points.
- **Year 1 is outcome-linked.** Eliminates buyer objection ("show me it works first"). Aligns incentives. ₹0 setup fees in pilot.
- **Year 2 switches to per-candidate flat.** Once value is proven, locked subscriptions stabilize revenue.
- **Streams 3 and 4 have network effects.** More employers → more hires → more PIAs want us → more verified placements → more states notice.

---

## 11. Sample pilot outcome report

This is what Pratak generates at Day 180 of a pilot batch. **This single document is your most powerful sales asset** — every future PIA you pitch will see this report and ask "can you do this for my batch?"

---

### Batch Outcome Report — Pratak by ZeroOrigins

**Batch:** Customer Support — Vijayawada
**Duration:** 90 days training + 90-day retention tracking
**Scheme:** DDU-GKY
**PIA:** [Pilot Partner Name]

#### Funnel

| Stage | Count | % of enrolled |
|---|---|---|
| Enrolled | 150 | 100% |
| Completed training | 134 | 89% |
| Resumes generated | 126 | 84% |
| Mock interviews completed | 118 | 79% |
| Reached Interview Ready (Score 56+) | 92 | 61% |
| Reached Placement Ready (Score 76+) | 48 | 32% |
| Interview scheduled | 86 | 57% |
| Interview attended | 79 | 53% |
| Selected | 63 | 42% |
| Joined | 58 | 39% |
| Retained 30 days | 52 | 35% |
| Retained 60 days | 47 | 31% |
| **Retained 90 days** | **41** | **27%** |

#### Salary

- Average starting salary: ₹14,500/month
- Highest: ₹22,000/month
- Lowest: ₹10,500/month
- Median: ₹13,200/month

#### Tranche impact for PIA

- Verified placements unlocked: 41 (vs. 18 in previous batch without Pratak)
- Final tranche unlocked: ₹6.15L additional
- Officer time saved: ~120 hours
- Net return after Pratak fee: ₹5.4L

#### Key insights (AI-generated)

- Candidates with 3+ mock interview attempts had 2.3x higher selection rate
- Top rejection reason: weak English communication (38% of rejections)
- Top dropout reason: unwillingness to relocate (44% of dropouts)
- Strongest employer conversion: local BPO roles (Convergys, Concentrix)
- Weakest training module: spoken English (avg readiness contribution 4.2/10)
- **Recommendation:** Add 20 hours of spoken English + 10 hours local job mapping in next batch

---

This is what the PIA owner shows his board, the government auditor, and the CSR funder. **One report. Three buyers convinced.**

---

## 12. Brand & naming

### Architecture (locked)

```
ZeroOrigins AI Pvt Ltd        ← parent company (tech-modern, global)
       ├── Pratak              ← this product (regional-trusted, operational)
       ├── IgnAIte             ← AI education institute (separate brand)
       ├── AIwithNoBrain       ← creator-economy content brand
       └── (future products)
```

### The name — Pratak

**Spelling:** Pratak (capital P, lowercase rest). Never PRATAK. Never pratak in body copy.
**Lockup:** `Pratak — by ZeroOrigins`
**Tagline:** *"Placement proof, in 60 seconds."*
**Domains:** `pratak.in` (Year 1) + `pratak.com` (acquired)

### Why Pratak — strategic justification

- **Phonosemantic strength:** 50% plosive density (P, T, K) — same trust-and-precision architecture as BlackBerry, Pentium, Kodak
- **Indian phonetic kinship:** The Pra- prefix maps subconsciously to pramana (proof), pragati (progress), pratha (tradition), prabhu — feels "ours" without being literal
- **Tension zone:** First-time readers pause for half a second (Lexicon's signature for memorable names)
- **Bureaucratic compatibility:** Sanskrit-rooted, photographs well on MoUs and government dashboards
- **Cultural arbitrage:** Distinct from Bay Area SaaS aesthetics — plays its own game in a market where "this is ours" beats "this is global"
- **Domain reality:** .com and .in both secured — rare double-hit

### Internal-use backronym (NEVER use on homepage or pitch deck)

P.R.A.T.A.K = **P**roof · **R**ecord · **A**udit · **T**rack · **A**lign · **K**indle

Use in: team onboarding, "About" page, founder notes, internal docs. Do not use on the homepage hero. Backronyms read amateur on B2B pitch decks.

### Visual identity

- **Primary color:** Deep indigo `#1E3A8A` (trust)
- **Accent:** Terracotta `#D97706` (warmth, Indian)
- **Typography:** Inter for English; Noto Sans Telugu + Noto Sans Devanagari for Indic scripts
- **No gradients, glassmorphism, or AI-sparkle aesthetics.** Pratak should look more like a bank than a Bay Area SaaS.

---

## 13. Architecture & tech decisions

Locked. Not negotiable without team review.

### Stack

| Layer | Choice | Rationale |
|---|---|---|
| Frontend (officer PWA + owner web) | Next.js 14+ (App Router), TypeScript strict, Tailwind, shadcn/ui | PWA-first, fast iteration |
| Backend (CRUD) | Next.js API routes | Same repo, fewer ops surfaces in MVP |
| Backend (AI pipeline) | FastAPI (Python) | Better Python AI ecosystem for OCR + LLM orchestration |
| Database + Auth + Storage | Supabase (Postgres + RLS) | India region, RLS for multi-tenancy out of the box |
| AI model — extraction | Anthropic Claude Sonnet | Best document understanding accuracy |
| AI model — classification | Anthropic Claude Haiku | Cost-efficient high-volume tasks |
| Voice-to-text (Telugu/Hindi) | IndicTrans + Whisper | Best Indic language coverage |
| OCR fallback | Tesseract | For low-confidence Claude cases |
| WhatsApp Business API | Gupshup or Wati (BSP) | India-localized, approved templates |
| Payouts | Razorpay | Native UPI/Phonepe, instant transfers |
| Hosting | Vercel (Next.js) + Railway (FastAPI) + Supabase Cloud (India) | Low-ops, India-resident data |
| Error tracking | Sentry | Standard |
| Product analytics | PostHog (self-hosted on Hetzner) | DPDP-compliant data residency |

### Multi-tenancy

Pratak is multi-tenant from Day 1. Every PIA is a tenant.
- Row-level security (RLS) is mandatory on every table
- Every query filters by `tenant_id` at the database layer
- Storage paths prefixed with `tenant_id/`
- Tenant isolation tested on every PR

### Service build order

1. Auth + multi-tenant DB foundation
2. Officer mobile app (PWA)
3. WhatsApp Business API integration
4. OCR + AI extraction pipeline
5. Evidence Locker + PDF generator
6. Owner web dashboard
7. Employer mobile-web attestation
8. SIDH API adapter (Phase 2)
9. State Mission dashboard (Year 2)

**Discipline: ship vertical slices.** Build one feature end-to-end, put it in front of Ramesh, iterate. Never "all backend, then all frontend."

---

## 14. Compliance, privacy, and trust

### DPDP Act 2023 (mandatory)
Pratak is a **Data Fiduciary**. Every candidate gives explicit, recorded consent at Day 1.
- Consent stored with timestamp, IP, device fingerprint, selfie hash — 7-year retention
- Purpose limitation: salary data used only for verification, never resold without separate consent
- Right to erasure within 30 days of request
- Privacy Notice in 8 regional languages

### Aadhaar handling (post-2019 SC + DPDP)
- **Never** store raw Aadhaar numbers
- Use **DigiLocker** for ID verification (legal)
- Use **Aadhaar eSign** for digital signatures (legal)
- AEBAS itself is government-only — we wrap it, never replace

### Account Aggregator (Year 2)
Bank statement verification via RBI's AA framework — register as Financial Information User (FIU) or partner with Finvu/OneMoney/Anumati.

### Audit trail
Every data write logged: who, what, when, from where. Tamper-evident hash chain for evidence documents.

### Government data handling
- SIDH integration via official MSDE-published APIs only
- DDU-GKY SF 7.1B, PMKVY tranche templates maintained as version-controlled export formats
- All financial data encrypted at rest (AES-256)

---

## 15. Build phases & exit criteria

Hard exit criteria. Don't move to next phase until previous is met.

### Phase 0 — Setup (Week 1)
- Repo, CI/CD, branch protection
- Supabase project + base schema + RLS policies
- Next.js scaffolding + FastAPI scaffolding
- WhatsApp BSP sandbox account
- Anthropic API wired

### Phase 1 — Officer Workflow MVP (Weeks 2–5)
**Exit:** Real placement officer (at pilot PIA) uses it daily for one batch's verification cycle. PIA owner signs an LOI.
- Officer signup + OTP login
- Batch creation via CSV upload
- Placement entry per candidate
- WhatsApp nudge from officer's verified number
- Salary slip OCR via Claude Sonnet
- Officer accept/reject flow
- Basic candidate timeline view

### Phase 2 — Evidence Pack (Weeks 6–7)
**Exit:** Real audit pack generated for 30 candidates. PIA compliance team accepts it.
- Per-candidate PDF generator
- Batch evidence bundle (SIDH-compatible)
- DDU-GKY SF 7.1B export
- Signed URLs + tamper-evident hash chain

### Phase 3 — Owner Dashboard (Weeks 8–9)
**Exit:** Mr. Reddy uses it weekly and signs first invoice.
- Multi-batch overview with rupee metrics
- Center-wise drill-down
- Red flags surface
- Weekly email digest

### Phase 4 — Candidate Loyalty Loop (Weeks 10–12)
- Razorpay payout integration (₹100–500 incentives)
- Telugu/Hindi AI interview coach via WhatsApp
- AI-generated resume from training records
- Monthly retention check-ins

### Phase 5 — Employer Attestation (Weeks 13–14)
- One-page mobile web flow
- Selfie + geo + timestamp
- Officer-shareable verification links

### Phase 6 — Second PIA + Hardening (Weeks 15+)
- Onboard second tenant
- WhatsApp rate limit handling
- OCR confidence threshold tuning
- First pricing experiment

---

## 16. The pilot plan (next 90 days)

### Days 1–15: Validation
- Sign LOI with friend's PIA for free 60-day pilot
- Define ONE scope: WhatsApp salary-slip OCR + audit pack for ONE batch already in placement phase
- Skip everything else (no attendance, no readiness scoring, no employer marketplace yet)
- The wedge is the wedge

### Days 16–60: Pilot
- Run the verification cycle for the chosen batch
- Capture every metric: time saved, docs collected, tranche unlocked
- Get 1 written PIA testimonial with rupee numbers
- Get 5 candidate WhatsApp screenshots in Telugu
- Generate the sample outcome report (Section 11)

### Days 61–90: Productize + Lead Gen
- Build audit-pack PDF generator (the wow moment in sales meetings)
- Cold-pitch 20 PIAs in TG/AP using the case study
- Book 1 exploratory meeting with TASK / SRLM-TG
- Convert 3 paid pilots

### The ONE question to ask the pilot PIA

*"In your last batch, how many placements failed verification, and how much money did your PIA lose because of it?"*

That rupee number is your wedge. If ₹2-5L per batch, you have a business. If ₹20,000, you don't.

---

## 17. Risks & honest unknowns

| Risk | Why it matters | Mitigation |
|---|---|---|
| SIDH adds these features themselves | Government can absorb the workflow layer | Build the *employer marketplace* — government won't build B2B |
| Account Aggregator approval slow (3–6 months) | Bank statement pull blocked early | Start with photo OCR; layer AA in once revenue exists |
| PIAs distrust software | Excel-and-paper culture | Free 60-day pilot, ROI in rupees not features |
| Some pilot PIAs may be among CAG-blacklisted 178 | Reputational risk | Vet PIAs before onboarding |
| Talent risk | This is fintech-grade engineering + GTM grind | Hire one ex-NSDC/SRLM domain expert before any LWC/Salesforce engineer |
| Honest PIA market may be smaller than total PIA market | If most PIAs prefer fake placements, our buyer set shrinks | Test with 5 PIAs; abandon segment if signal is bad |
| Competitor pivot (Quess, TeamLease) | Staffing companies have employer + data advantage | Move fast on TG/AP MSME network — that's the moat |
| Self-employment outcome capture is hard | 30–40% of "placements" are not formal jobs | Build two tracks: wage employment + self-employment (UPI/voice-based) |

### Honest unknowns (can't answer without real data)
- What % of placement docs are forgeable today? (If high, only honest PIAs are buyers — smaller TAM)
- Is "tranche unlock" actually the biggest pain, or is it something more boring? (Need pilot data)
- How tech-comfortable are placement officers, really? (UX may need to be simpler than imagined)
- What cheque size will a PIA actually write per month? (₹5K / ₹50K / ₹5L — changes the entire model)

**These get answered by Day 30 of the pilot. Not by more research.**

---

## 18. The strategic statement

**ZeroOrigins is not entering as an institute. We are building the AI and data backbone that helps skill-development programs prove real employment outcomes.**

The market has solved enrollment, attendance, certification, and disbursement at the workflow level. It has not solved the trust layer — verified employment, retention, real salary, real employer. PMKVY 4.0 hit only 15% of target partly because of this gap. PMKVY 5.0 is being publicly designed around exactly this gap.

**Pratak is the outcome intelligence layer that PMKVY 5.0 will require — before it requires it.**

We don't compete with SIDH, NSDC, or any state portal. We sit beside them and feed them verified outcome data. PIAs pay us because we unlock their trapped tranches. State Missions license us because we solve CAG findings. Outcome-bond financiers and CSR corporates buy our data because we make their instruments bankable.

This is not another LMS or attendance system. This is the layer that turns activity-based skilling into outcome-driven skilling.

The window is 18–24 months. The plan is concrete. The first PIA pilot starts now.

---

*Pratak — by ZeroOrigins AI · Placement proof, in 60 seconds*
*v1.0 · May 2026 · This document supersedes all prior strategy drafts.*
