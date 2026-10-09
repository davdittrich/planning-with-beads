# [TASK_ID]: [Verb] [Subject]
**Status:** `READY_FOR_EXECUTION`

## 1. Goal
[Core outcome. 1 sentence: input -> output.]

## 2. Context
* **Why:** [Parent goal this step serves.]
* **State:** [Current state of code/data; file:line refs.]
* **Inputs:** [Source + format: path, URL, snippet, TOON.]
* Reader has no prior context. Everything needed is here.

## 3. Constraints
* **Must:** [Hard boundary: scope, format, limits.]
* **Avoid:** [Hack/alternative ruled out + why.]
* **Lock:** `[Task] [Mechanism] ! [Forbidden]`

## 4. Tools
[Allowed or preferred tools / libraries / APIs. Forbidden ones go in 3.]

## 5. Logic (optional — delete if unused)
1. [Action]
2. [Action]

## 6. Schema (optional — delete if unused)
Return:
```toon
task_id: [ID]
success: bool
data:
  key: value
error_log: null | msg
```

## 7. Verification
[Spy/mock/test strategy proving the internal logic. Exact command + expected result.]

## 8. Definition of done
- [ ] [Acceptance criterion / deliverable]
- [ ] [Verification in 7 passes]
