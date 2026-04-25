---
name: planning-with-beads
description: Use when starting complex multi-step tasks (3+ steps), research, or work spanning multiple sessions/tool calls.
metadata:
  triggers: complex task, research, beads, planning, multi-step, bd, task-id, persistence, context-reset
  category: technique
  version: 1.4.0
---

# Planning with Beads

Beads (`bd`) = structured memory on disk. Use for complex work.

## Core Rules

### 1. Epic First
Complex task? Create Beads Epic FIRST. No code without ID. Use `scripts/init-session.sh` to scaffold quickly.

### 2. Atomic Tasks
One task = one atomic ticket. Don't bundle unrelated changes.
Found bug? Create ticket NOW. Track every deviation.

### 3. 2-Action Rule
After 2 view/browser/search ops: save findings to Beads.
Use `bd remember` (topic/discovery) or `bd comment` (task-specific).

### 4. Prime Before Decide
Major decision? Run `bd prime`. Refresh context. No stale goals.

### 5. Update After Act
Phase done? Update Beads. Log errors. Note changed files.

### 6. Verify Completion
Before closing an Epic or ending a session, use `scripts/check-complete.sh` to ensure no tasks were missed.

## Command Reference

| Goal | Command |
|------|---------|
| **Setup Session** | `scripts/init-session.sh "Goal"` |
| Start Epic | `bd init` && `bd create --type epic` |
| Add Task | `bd create --parent <epic_id>` |
| Log Finding | `bd remember --topic <topic> "<content>"` |
| Status | `bd update <task_id> --status closed --reason "..."` |
| Log Decision | `bd comment <task_id> --body "Decision: ..."` |
| Load Context | `bd prime` |
| **Verify Epic** | `scripts/check-complete.sh <epic_id>` |

## Automation Scripts

### `scripts/init-session.sh "Goal"`
Use at the start of any new complex task.
- Initializes Beads (`bd init`) if needed.
- Creates a top-level **Epic** for the goal.
- Scaffolds default phases: Discovery, Planning, Implementation, Verification.

### `scripts/check-complete.sh [epic_id]`
Use before ending a session or declaring an Epic "Done".
- Checks for any `open`, `in_progress`, or `blocked` tasks under the Epic.
- Exits with error (1) if tasks remain, or success (0) if all are closed.
- Automatically finds the latest Epic if ID is omitted.

## Decision Matrix

| Situation | Action | Reason |
|-----------|--------|--------|
| Starting new work | `init-session.sh` | Rapid scaffolding |
| Multi-step work | Beads | Persistence > Context |
| Multi-session | Beads | Context lost, Beads stay |
| Visual info | `bd remember` | Screenshots don't persist |
| Error found | `bd comment` | Track attempts, don't repeat |
| Stale context | `bd prime` | Read actual state |
| Finishing work | `check-complete.sh` | Ensure zero-gap completion |

## Rationalization Table

| Excuse | Reality |
|--------|---------|
| "Too small" | Small tasks grow. 3+ steps = Beads. |
| "Updating slow" | Lose context slower. `bd prime` = 10x speed. |
| "I remember" | You don't. 50 calls → Goal lost. |
| "Add later" | Info volatile. Save NOW. |

## Red Flags - STOP

- 5+ calls, no Beads task.
- 2+ browser ops, no `bd remember`.
- Bug found, no ticket.
- Bundle 2+ unrelated changes in one ticket.
- Repeat failed call without log.

## 5-Question Reboot

Answer via `bd`:
1. **Where am I?** → `bd ready` / claimed task.
2. **Next step?** → `bd children <epic_id>`.
3. **Goal?** → `bd show <epic_id>`.
4. **Learned?** → `bd memories`.
5. **Done?** → `bd stats` / `bd history`.

## Files & Templates

- [reference.md](reference.md) - Manus Rules (Beads Edition)
- [examples.md](examples.md) - Workflow Examples
- [templates/epic_template.md](templates/epic_template.md)
- [templates/task_template.md](templates/task_template.md)
- [scripts/init-session.sh](scripts/init-session.sh)
- [scripts/check-complete.sh](scripts/check-complete.sh)
