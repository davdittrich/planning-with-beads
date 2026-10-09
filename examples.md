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
## 1. Goal
OIDC config JSON in -> Mermaid sequence diagram of client-app PKCE flow out.
## 2. Context
* **Why:** Foundation for login implementation (bd-1.6).
* **Inputs:** OIDC config JSON; https://auth0.com/docs/flows
## 3. Constraints
* **Must:** Support PKCE. Diagram in Mermaid.
* **Avoid:** Implicit flow (deprecated, token in URL).
* **Lock:** Research [Auth0 docs] ! [guessing endpoints]
## 4. Tools
WebFetch, Mermaid.
## 5. Logic
1. Read Auth0 docs.
2. Trace /authorize call.
3. Trace /token call.
## 7. Verification
Diagram renders in Mermaid live editor; each endpoint cites a doc URL.
## 8. Definition of done
- [ ] Diagram covers /authorize and /token with PKCE params.
- [ ] Every endpoint sourced.
"
```

## Example: Multi-Agent Handoff

When one agent finishes a task, it ensures the *next* task in Beads is ready with the template filled.

1. **Agent A** finishes Research.
2. **Agent A** reads `templates/task_template.md`.
3. **Agent A** runs `bd update bd-1.2 --description "..."` to prepare implementation task for **Agent B**.
4. **Agent B** runs `bd show bd-1.2` and has everything needed.

## Example: Self-sufficient Ticket Checklist

- [ ] I read `templates/task_template.md` this session.
- [ ] My ticket has the 6 mandatory sections: 1 Goal, 2 Context, 3 Constraints, 4 Tools, 7 Verification, 8 Definition of done.
- [ ] Optional 5 Logic / 6 Schema present when the executor needs steps or a return format.
- [ ] `scripts/validate-templates.sh <id>` exits 0.
- [ ] I assume the next person to read this has **Goldfish Memory**.
