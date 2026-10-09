---
name: planning-with-beads
description: Use when writing any ticket, issue, PR description, or bug report. Mandatory when starting complex task (3+ steps), research, multi-session work, or any multi-agent handoff.
status: active
metadata:
  triggers: ticket, bug, complex task, research, beads, planning, multi-step, bd, task-id, persistence, context-reset, github issue, pr description, bug report, draft ticket, write pr, format issue
  category: technique
  version: 1.12.0
---

# Planning with Beads

Beads (`bd`) = structured memory on disk. Use for complex work.

> Self-sufficient copy: approval-gate and no-bundling rules below also live in CLAUDE.md (always-on authoritative). Duplication is intentional (load-scope) — do not dedup.

## 🛑 Ticket Structure Rules (READ FIRST)

Pick structure by audience. NEVER mix styles in one ticket.

| Audience | Structure | Section |
| :--- | :--- | :--- |
| **Internal** (Beads task, sub-agent, handoff) | **Self-sufficient 8-Section** | [Ticket Architecture Standards](#ticket-architecture-standards) |
| **External** (GitHub issue, PR description) | **What/Why/How** | [External Ticket Standards](#external-ticket-standards) |
| **Bug report** (external) | **What/Why/How** + Repro | [External Ticket Standards](#external-ticket-standards) |
| **GSD-synced** (created by gsd-beads `beads-sync`) | Exempt — PLAN.md is authority | [GSD-synced issues](#gsd-synced-issues-exempt) |

Conflict default: internal self-sufficient protocol wins.

## 🛑 MANDATORY: Create → Validate → Fix Loop

**No internal ticket is "created" until `scripts/validate-templates.sh <id>` exits 0.** Hard gate, not advice. A terse one-paragraph blob is an automatic FAIL — the standard is non-negotiable.

Run this loop for EVERY `bd create` / `bd update` of an internal task or epic:

**Preserve headers mechanically:** Copy the template and replace placeholders only; never retype headers or claim template/validator drift without an exact comparison.

1. **Read the template.** `templates/task_template.md` (task) or `templates/epic_template.md` (epic). EVERY call — "I remember it" = FAIL. Templates evolve.
2. **Fill ALL sections verbatim.** Task and epic = the 6 mandatory headers (`## 1. Goal`, `## 2. Context`, `## 3. Constraints`, `## 4. Tools`, `## 7. Verification`, `## 8. Definition of done`). Optional `## 5. Logic` / `## 6. Schema` (fenced ` ```toon ` block): keep when useful, else delete. Every section populated with real content; no placeholders left from the template.
3. **`bd create` / `bd update`** with that full body.
4. **Validate immediately:** `scripts/validate-templates.sh <id>`.
5. **FAIL or exit≠0 → STOP.** Rewrite body → `bd update <id> --description "$(...)"` → re-validate. Loop until green. Do NOT create the next ticket, announce completion, or enter plan-review-gate while any ticket is red.

**Batch creates:** validate EVERY id. One red ticket = the batch is unfinished.

### GSD-synced issues (exempt)
Issues created by gsd-beads `beads-sync` are exempt from this loop and the templates. A synced issue carries the `gsd-sync` label (gsd-beads ≥ 1.7.0; `validate-templates.sh` skips it automatically), or — for older unlabelled issues — is bound by a PLAN.md `<beads-id>` / `tracker-id="beads:<id>"`, or is a child of a sync-created phase epic. Its body (`## Read First`, `## Action`, `## Verify`, `## Done`, …) is machine-rendered from PLAN.md. gsd-core's executor parses that body back through `task resolve-content`. NEVER hand-edit or "fix" these bodies to the 8-section format: that breaks execution. Change the PLAN.md task and re-sync. Tickets you write yourself in a GSD project still follow this loop.

**Why?** Sub-agents have ephemeral context — state resets every ~50 turns. The **Self-sufficient Ticket** is the only way they get the logic, schema, and constraints to succeed without asking the orchestrator. The validate gate stops a summary blob from masquerading as a self-sufficient ticket.

## Core Rules

### 0. Self-sufficient Tickets (MANDATORY)
Ticket = self-sufficient environment. All logic, schema, constraints inside. Output A → Output B without orchestrator intervention.

### 1. Epic First
Complex task? Create Epic FIRST. Use `scripts/init-session.sh` scaffold. Update Epic body using `templates/epic_template.md`.

### 2. Single-purpose Tasks
One task = one single-purpose ticket. NO bundles.
Found bug? Create ticket NOW. Track every deviation.

### 3. Save Findings Every 2 Ops
After 2 view/browser/search ops: save to Beads (`bd comment`).

### 4. Refresh Context Before Decisions
Major decision? Run `bd prime` to reload project state. No stale goal.

### 5. Update After Act
Phase done? Update Beads. Log error. Note change file.

### 6. Verify Completion & Quality
- Create/Update Task or Epic? Run the [Create → Validate → Fix Loop](#-mandatory-create--validate--fix-loop). Ticket is not done until `validate-templates.sh <id>` exits 0.
- Close Epic? Run `scripts/check-complete.sh`.

### 7. Permanent Project Rules Only (`bd remember`)
Reserve `bd remember` strictly for permanent project-wide rules (environment setup, architectural constraints). NEVER use `bd remember` for task research, code snippets, debug output, or transient discoveries—use `bd comments add <id>` or task descriptions instead.

### 8. `active-plan.md` = ID Reference, Not Duplicate Text
`active-plan.md` carries ONLY a provenance header + epic/task IDs + exec order — NEVER restated ticket bodies; self-sufficient tickets are the sole source of WHAT/HOW. Keep the `status: in-progress` header so metaswarm recovery (orchestrated-execution:564) still fires. Recovery reload chain: active-plan.md IDs -> `bd prime --work-type recovery` + `bd show <ids>` re-derives full bodies from beads. This fills metaswarm's `:529` placeholder (WU decomposition = the ID list) — not an override of the frozen recovery reader.

## Ticket Architecture Standards

Internal tickets only. You = TPM & Architect. Every task MUST follow the 8 sections (6 mandatory) in `templates/task_template.md`.

| Section | Content | Requirement |
| :--- | :--- | :--- |
| **1. Goal** | [Core Outcome / Mission] 1 sentence In/Out. | Mandatory |
| **2. Context**| [Relevant Context / State / Inputs] Source and Format. | Mandatory |
| **3. Constraints**| [Hard Boundaries and Hacks/Alternatives to Avoid] Logic, Format, Boundary. | Mandatory |
| **4. Tools** | [Allowed or Preferred Tools / Libraries / APIs] | Mandatory |
| **5. Logic** | Numbered execution steps. | Optional |
| **6. Schema** | Strict key-value block. | Optional |
| **7. Verification** | [Spy/Mock/Test Strategy for Internal Logic] | Mandatory |
| **8. Definition of done** | [Acceptance Criteria / Deliverables] Verification checklist. | Mandatory |

## External Ticket Standards

GitHub issues, PR descriptions, bug reports. **SYSTEM DIRECTIVE:** STRICTLY enforce `What/Why/How`.

### Execution Rules
- **Structure**: Exclusively `## What`, `## Why`, `## How`.
- **Approval Gate**: Plan cannot be approved without `planning-with-beads` usage.
- **Tone (Neutrality)**: Factual, objective. ZERO marketing language or subjective superlatives.
- **Framing (Positive)**: Describe desired states, not just absence of errors.
- **Brevity**: Max 1-3 sentences per paragraph.
- **Formatting**: Bulleted lists for steps. References as Markdown links: `[#123](url)`.
- **Terse**: Drop articles (a/an/the) and filler. Keep technical terms exact.

### Template

#### ## What
* **Requirement**: 1-3 sentences stating exact subject. Link to related issues/PRs and docs.
* **Example**: Add dark mode support to web interface. Related to [#789](url). Reference: [CSS color-scheme](url).

#### ## Why
* **Requirement**: Context and motivation without subjective claims.
* **Example**: Users require low-light alternative to reduce eye strain. Aligns with accessibility standards.

#### ## How
* **Requirement**: Concrete implementation steps. No abstract goals.
* **Example**:
  - Add theme toggle component to navigation
  - Create CSS custom properties for color scheme
  - Implement system preference detection

## Command Reference

| Goal | Command |
|------|---------|
| **Setup Session** | `scripts/init-session.sh "Goal"` |
| Start Epic | `bd create "Title" --type epic --description "$(cat templates/epic_template.md)"` |
| Add Task | `bd create "Title" --parent <id> --description "$(cat templates/task_template.md)"` |
| Validate | `scripts/validate-templates.sh <id>` |
| Load/Refresh Context | `bd prime` |

## Rationalization Table

| Excuse | Reality |
|--------|---------|
| "Too small" | Task grow. 3+ step = Beads. |
| "I'll fill later" | Info volatile. Save NOW. |
| "Summary is enough" | **FAIL.** Sub-agent needs full context. READ template. |
| "I remember" | No you don't. Context compaction will eat your goals. |
| "External, skip Beads" | Plan still gated on `planning-with-beads`. |
| Internal task → What/Why/How | **WRONG.** Internal = Self-sufficient 8-Section. |
| External issue → 8-Section | **WRONG.** External = What/Why/How. |

## Red Flags - STOP

- **Mixing self-sufficient and What/Why/How styles in one ticket.**
- **Creating/Updating internal task WITHOUT reading `templates/task_template.md`.**
- **`bd create`/`bd update` for an internal ticket NOT immediately followed by `validate-templates.sh <id>`.** Auto-violation.
- **Proceeding (next ticket, completion claim, plan-review-gate) with any ticket where validate exits≠0.**
- 5+ call, no Beads task.
- **Rewriting a GSD-synced issue body to the 8-section template.**
- **Task description < 10 lines (Missing Constraints/Verification).**
- **Validation script fails.**
- Marketing fluff in external ticket ("beautiful", "fast", "powerful").
- Bundling multiple unrelated changes into one ticket.
- Missing Markdown links for references (external).
- **Using `bd remember` for task-level research, debug output, or transient findings (Use `bd comments add <id>`).**

## 5-Question Reboot

Lost context? Answer via `bd ready`, `bd prime`, `bd show <id>`.
