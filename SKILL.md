---
name: planning-with-beads
description: Use when start complex task (3+ steps), research, multi-session work.
metadata:
  triggers: complex task, research, beads, planning, multi-step, bd, task-id, persistence, context-reset
  category: technique
  version: 1.6.1
---

# Planning with Beads

Beads (`bd`) = structured memory on disk. Use for complex work.

## Core Rules

### 0. Hermetic Tickets (MANDATORY)
Ticket = hermetic env. Contain all logic, schema, constraints. Input A → Output B without orchestrator. Sub-agent has "Goldfish Memory".

### 1. Epic First
Complex task? Create Epic FIRST. No code without ID. Use `scripts/init-session.sh` scaffold fast.

### 2. Atomic Tasks
One task = one atomic ticket. No bundle unrelated change.
Found bug? Create ticket NOW. Track every deviation.

### 3. 2-Action Rule
After 2 view/browser/search ops: save to Beads.
`bd remember` (discovery) or `bd comment` (task).

### 4. Prime Before Decide
Major decision? Run `bd prime`. Refresh context. No stale goal.

### 5. Update After Act
Phase done? Update Beads. Log error. Note change file.

### 6. Verify Completion
Close Epic? Run `scripts/check-complete.sh`. No miss task.

## Ticket Architecture Standards

You = TPM & Architect. Every task MUST follow `templates/task_template.md`.

| Component | Purpose | Example |
| :--- | :--- | :--- |
| **Scope Anchor** | 1 sentence In/Out. | "CSV → JSON objects." |
| **Context Injection** | Data, URL, file snippets. | "API: https://api.ex.com/v1" |
| **I/O Schemas** | Strict JSON/MD struct. | "Output match schema.json." |
| **Execution Guards** | "Do Not" list + validation. | "Guard: Neg price → null." |
| **Definition of Done** | Self-validate checklist. | "[ ] Schema verify via ajv." |

## Command Reference

| Goal | Command |
|------|---------|
| **Setup Session** | `scripts/init-session.sh "Goal"` |
| Start Epic | `bd init && bd q "Goal" --type epic` |
| Add Task | `bd create "Title" --parent <epic_id>` |
| Log Finding | `bd remember "<content>"` |
| Status | `bd close <task_id> --reason "..."` |
| Log Decision | `bd comment <task_id> "Decision: ..."` |
| Load Context | `bd prime` |
| **Verify Epic** | `scripts/check-complete.sh <epic_id>` |

## Automation Scripts

### `scripts/init-session.sh "Goal"`
Start new complex task.
- Init Beads (`bd init`) if need.
- Create Epic for goal.
- Scaffold phases: Discovery, Planning, Implementation, Verification.

### `scripts/check-complete.sh [epic_id]`
Before end session or Epic "Done".
- Check `open`, `in_progress`, `blocked` tasks.
- Exit error (1) if task remain. Success (0) if all closed.

## Decision Matrix

| Situation | Action | Reason |
|-----------|--------|--------|
| Start new work | `init-session.sh` | Fast scaffold |
| Multi-step | Beads | Persist > Context |
| Multi-session | Beads | Context die, Beads stay |
| Visual info | `bd remember` | Screenshot die |
| Error found | `bd comment` | Track fail, no repeat |
| Stale context | `bd prime` | Read state |
| Finish work | `check-complete.sh` | Zero-gap done |

## Rationalization Table

| Excuse | Reality |
|--------|---------|
| "Too small" | Task grow. 3+ step = Beads. |
| "Slow update" | Lose context slower. `bd prime` = fast. |
| "I remember" | No you don't. 50 calls = goal lost. |
| "Add later" | Info volatile. Save NOW. |

## Red Flags - STOP

- 5+ call, no Beads task.
- 2+ browser op, no `bd remember`.
- Bug found, no ticket.
- Bundle 2+ unrelated change in 1 ticket.
- Repeat fail call without log.
- **Missing Guard/Schema in ticket body.**

## 5-Question Reboot

Answer via `bd`:
1. **Where am I?** → `bd ready` / claimed task.
2. **Next step?** → `bd children <epic_id>`.
3. **Goal?** → `bd show <epic_id>`.
4. **Learned?** → `bd memories`.
5. **Done?** → `bd status` / `bd history`.

## Files & Templates

- [reference.md](reference.md) - Manus Rules (Beads Edition)
- [examples.md](examples.md) - Workflow Examples
- [templates/epic_template.md](templates/epic_template.md)
- [templates/task_template.md](templates/task_template.md)
- [scripts/init-session.sh](scripts/init-session.sh)
- [scripts/check-complete.sh](scripts/check-complete.sh)
