# Reference: Manus Context Engineering w/ Beads

Adapt Manus principles to **Beads (`bd`)**.

## 6 Manus Principles (Beads Edition)

### 1. KV-Cache Design
Beads keep context stable. `bd prime` deterministic output. No ad-hoc file reads.

### 2. Mask, Don't Remove
N/A.

### 3. Beads = External Memory
"Beads = working memory on disk."
Formula:
- Context Window = RAM (volatile, limited)
- Beads DB = Disk (persistent, structured)

Structured graph > raw markdown. Precise context injection.

### 4. Attention Manipulation via Recitation
Recite goals/findings via `bd prime`. Push global plan into recent attention.
Run `bd prime` before major decisions.

### 5. Keep Wrong Stuff In
Leave wrong turns in context.
Log error/fail via `bd comment` or `bd note`. Remember what didn't work.

### 6. No Few-Shotting
N/A.

---

## 3 Context Strategies (Beads Edition)

### 1. Context Reduction
Semantic compaction. `bd compact` summarize old issues. Keep facts in knowledge base.

### 2. Context Isolation (Multi-Agent)
Built for multi-agent. Each agent (orchestrator/coder/reviewer) prime relevant subgraph.

### 3. Context Offloading
Store research in `bd knowledge` (memories). Use `bd recall` when needed.

---

## Beads Agent Loop

1. **BOOT:** Run `scripts/init-session.sh "Goal"`.
2. **ANALYZE:** Run `bd ready` + `bd prime`.
3. **THINK:** Pick unblocked task.
4. **CLAIM:** `bd update <id> --claim`.
5. **EXECUTE:** Work.
6. **LOG:** `bd comment` discovery/error.
7. **CLOSE:** `bd update <id> --status closed`.
8. **VERIFY:** Run `scripts/check-complete.sh`.
9. **ITERATE:** Next task or end session.

---

## File vs Beads Comparison

| Filesystem | Beads |
|------------|-------|
| `task_plan.md` | `bd epic` + child tasks |
| `findings.md` | `bd remember` (Knowledge) |
| `progress.md` | `bd stats` + Task history |
| `scripts/init-session.sh` | `bd init` |

---

## Source
https://manus.im/blog/Context-Engineering-for-AI-Agents-Lessons-from-Building-Manus
