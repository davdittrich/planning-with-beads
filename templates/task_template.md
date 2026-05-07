# [TASK_ID]: [Verb] [Subject]
**Status:** `READY_FOR_EXECUTION`

## I. Context & Objective
* **Objective:** [In/Out 1 sentence].
* **Why:** [Step goal].
* **Reference Data:** [String, URL, snippet, TOON].
* **Philosophy:** Sub-agent = Goldfish Memory. All info here.

## II. Input Specification
* **Expected Input:** [Data type/source].
* **Format:** [TOON, String, List].

## III. Constraints & Guards
| Type | Guard |
| :--- | :--- |
| **Logic** | [If X, return Y. No guess.] |
| **Format** | [Strict TOON. No fluff.] |
| **Boundary** | [Max X word. Only analyze Y.] |
| **Tone** | [Tech, terse, no fluff.] |

## IV. Step-by-Step Logic
1. [Action 1]
2. [Action 2]
3. [Action 3]
4. Check Guards.

## V. Output Schema (Strict)
Sub-agent MUST return:
```toon
task_id: [ID]
success: bool
data:
  key: value
error_log: null | msg
```

## VI. Definition of Done
- [ ] Logic match Guard.
- [ ] Output match Schema.
- [ ] No hallucination.
