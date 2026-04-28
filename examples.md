# Beads Planning Examples

## Example: Proper Task Creation

### 1. Load Template
```bash
cat templates/task_template.md
```

### 2. Create Task with Full Body
```bash
bd create "Research Auth Flow" --parent bd-1 --description "
# bd-1.5: Research Auth Flow
**Status:** READY_FOR_EXECUTION

## I. Context & Objective
* **Objective:** Map OIDC flow for the client app.
* **Why:** Foundation for login implementation.
* **Reference Data:** https://auth0.com/docs/flows
* **Philosophy:** Sub-agent = Goldfish Memory.

## II. Input Specification
* **Expected Input:** OIDC Config JSON.
* **Format:** Object.

## III. Constraints & Guards
| Guard Type | Constraint |
| :--- | :--- |
| **Logic Guard** | Must support PKCE. |
| **Format Guard** | Output sequence diagram in Mermaid. |

## IV. Step-by-Step Logic
1. Read Auth0 docs.
2. Trace /authorize call.
3. Trace /token call.

## V. Output Schema (Strict)
\`\`\`json
{
  \"flow\": \"oidc-pkce\",
  \"endpoints\": { ... }
}
\`\`\`

## VI. Definition of Done
- [ ] Diagram included.
- [ ] Schema valid.
"
```

## Example: Multi-Agent Handoff

When one agent finishes a task, it ensures the *next* task in Beads is ready with the template filled.

1. **Agent A** finishes Research.
2. **Agent A** reads `templates/task_template.md`.
3. **Agent A** runs `bd update bd-1.2 --body "..."` to prepare implementation task for **Agent B**.
4. **Agent B** runs `bd show bd-1.2` and has everything needed.

## Example: Hermetic Ticket Checklist

- [ ] I read `templates/task_template.md` this session.
- [ ] My ticket has sections I through VI.
- [ ] I included a `Constraints & Guards` table.
- [ ] I defined a `Strict JSON` output schema.
- [ ] I assume the next person to read this has **Goldfish Memory**.
