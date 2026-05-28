---
name: planning-with-beads
description: Use when writing any ticket, issue, PR description, or bug report. Mandatory when starting complex task (3+ steps), research, multi-session work, or any multi-agent handoff.
status: active
metadata:
  triggers: ticket, bug, complex task, research, beads, planning, multi-step, bd, task-id, persistence, context-reset, github issue, pr description, bug report, draft ticket, write pr, format issue
  category: technique
  version: 1.8.0
---

# Planning with Beads

Beads (`bd`) = structured memory on disk. Use for complex work.

## 🛑 Audience Router (READ FIRST)

Pick structure by audience. NEVER mix styles in one ticket.

| Audience | Structure | Section |
| :--- | :--- | :--- |
| **Internal** (Beads task, sub-agent, handoff) | **Hermetic 6-Section** | [Ticket Architecture Standards](#ticket-architecture-standards) |
| **External** (GitHub issue, PR description) | **What/Why/How** | [External Ticket Standards](#external-ticket-standards) |
| **Bug report** (external) | **What/Why/How** + Repro | [External Ticket Standards](#external-ticket-standards) |

Conflict default: internal Hermetic protocol wins.

## 🛑 MANDATORY: Template Protocol
**You MUST read the template files before every `bd create` or `bd update` call.**
- Tasks: `templates/task_template.md`
- Epics: `templates/epic_template.md`

**Why?** Sub-agents have "Goldfish Memory". They lose context every ~50 turns. The **Hermetic Ticket** is the only way to ensure they have the logic, schema, and constraints needed to succeed without asking for help.

## Core Rules

### 0. Hermetic Tickets (MANDATORY)
Ticket = hermetic env. All logic, schema, constraints inside. Output A → Output B without orchestrator intervention.

### 1. Epic First
Complex task? Create Epic FIRST. Use `scripts/init-session.sh` scaffold. Update Epic body using `templates/epic_template.md`.

### 2. Atomic Tasks
One task = one atomic ticket. NO bundles.
Found bug? Create ticket NOW. Track every deviation.

### 3. 2-Action Rule
After 2 view/browser/search ops: save to Beads.
`bd remember` (discovery) or `bd comment` (task).

### 4. Prime Before Decide
Major decision? Run `bd prime`. Refresh context. No stale goal.

### 5. Update After Act
Phase done? Update Beads. Log error. Note change file.

### 6. Verify Completion & Quality
- Close Epic? Run `scripts/check-complete.sh`.
- Create/Update Task? Run `scripts/validate-templates.sh <id>`.

## Ticket Architecture Standards

Internal tickets only. You = TPM & Architect. Every task MUST follow the 6 sections in `templates/task_template.md`.

| Section | Content | Requirement |
| :--- | :--- | :--- |
| **I. Objective** | 1 sentence In/Out. | Mandatory |
| **II. Input** | Source and Format. | Mandatory |
| **III. Guards** | Logic, Format, Boundary. | Mandatory |
| **IV. Logic** | Numbered execution steps. | Mandatory |
| **V. Schema** | **Strict TOON block.** | Mandatory |
| **VI. DoD** | Verification checklist. | Mandatory |

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
| Log Finding | `bd remember "<content>"` |
| Load Context | `bd prime` |

## Rationalization Table

| Excuse | Reality |
|--------|---------|
| "Too small" | Task grow. 3+ step = Beads. |
| "I'll fill later" | Info volatile. Save NOW. |
| "Summary is enough" | **FAIL.** Sub-agent needs full context. READ template. |
| "I remember" | No you don't. Context compaction will eat your goals. |
| "External, skip Beads" | Plan still gated on `planning-with-beads`. |
| Internal task → What/Why/How | **WRONG.** Internal = Hermetic 6-Section. |
| External issue → 6-Section | **WRONG.** External = What/Why/How. |

## Red Flags - STOP

- **Mixing Hermetic and What/Why/How styles in one ticket.**
- **Creating/Updating internal task WITHOUT reading `templates/task_template.md`.**
- 5+ call, no Beads task.
- 2+ browser op, no `bd remember`.
- **Task description < 10 lines (Missing Schema/Guards).**
- **Validation script fails.**
- Marketing fluff in external ticket ("beautiful", "fast", "powerful").
- Bundling multiple unrelated changes into one ticket.
- Missing Markdown links for references (external).

## 5-Question Reboot

Lost context? Answer via `bd ready`, `bd prime`, `bd show <id>`.
