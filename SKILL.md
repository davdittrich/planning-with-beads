---
name: planning-with-beads
description: Use when start complex task (3+ steps), research, multi-session work. MANDATORY for all multi-agent handoffs.
status: active
metadata:
  triggers: complex task, research, beads, planning, multi-step, bd, task-id, persistence, context-reset
  category: technique
  version: 1.7.1
---

# Planning with Beads

Beads (`bd`) = structured memory on disk. Use for complex work.

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

You = TPM & Architect. Every task MUST follow the 6 sections in `templates/task_template.md`.

| Section | Content | Requirement |
| :--- | :--- | :--- |
| **I. Objective** | 1 sentence In/Out. | Mandatory |
| **II. Input** | Source and Format. | Mandatory |
| **III. Guards** | Logic, Format, Boundary. | Mandatory |
| **IV. Logic** | Numbered execution steps. | Mandatory |
| **V. Schema** | **Strict TOON block.** | Mandatory |
| **VI. DoD** | Verification checklist. | Mandatory |

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

## Red Flags - STOP

- **Creating/Updating task WITHOUT reading `templates/task_template.md`.**
- 5+ call, no Beads task.
- 2+ browser op, no `bd remember`.
- **Task description < 10 lines (Missing Schema/Guards).**
- **Validation script fails.**

## 5-Question Reboot

Answer via `bd ready`, `bd prime`, `bd show <id>`.
