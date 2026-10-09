#!/bin/bash
# Regression tests for scripts/validate-templates.sh against a stubbed `bd`.
# Usage: bash tests/validate-templates.test.sh
set -u
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
STUB="$(mktemp -d)"
trap 'rm -rf "$STUB"' EXIT

# Stub bd: `bd show <id> --json` returns BODY_FILE's text as a task with LABELS (JSON value).
cat > "$STUB/bd" <<'STUBEOF'
#!/bin/bash
jq -Rs --argjson l "${LABELS:-[]}" '[{description: ., issue_type: "task", labels: $l}]' < "$BODY_FILE"
STUBEOF
chmod +x "$STUB/bd"

OLD="$STUB/old.md"
printf '## I. Context & Objective\nx\n## II. Input Specification\nx\n## III. Constraints & Guards\nx\n## IV. Step-by-Step Logic\nx\n## V. Output Schema\nx\n## VI. Definition of Done\nx\n' > "$OLD"
NEW="$STUB/new.md"
sed -n '/^# bd-1\.5/,/^"$/p' "$ROOT/examples.md" | sed '$d' > "$NEW"
[ -s "$NEW" ] || { echo "FIXTURE BROKEN: no bd-1.5 example extracted from examples.md"; exit 1; }

FAIL=0
check() { # name expected_exit expected_output_substring body labels
    out=$(BODY_FILE="$4" LABELS="$5" PATH="$STUB:$PATH" bash "$ROOT/scripts/validate-templates.sh" t 2>&1)
    code=$?
    if [ "$code" -ne "$2" ] || ! grep -qF -- "$3" <<<"$out"; then
        echo "FAIL: $1 (exit $code, want $2; want output '$3')"; echo "$out" | sed 's/^/    /'
        FAIL=$((FAIL + 1))
    else
        echo "PASS: $1"
    fi
}

check "filled ticket passes"                0 "follows template"   "$NEW" '[]'
check "old I-VI ticket fails"               1 "MISSING: ## 1. Goal" "$OLD" '[]'
check "gsd-sync labelled ticket skips"      0 "SKIP"               "$OLD" '["gsd-sync"]'
check "gsd-sync among other labels skips"   0 "SKIP"               "$OLD" '["area-x","gsd-sync"]'
check "near-miss label still validated"     1 "MISSING: ## 1. Goal" "$OLD" '["gsd-sync-x"]'
check "unrelated label still validated"     1 "MISSING: ## 1. Goal" "$OLD" '["area-x"]'
check "null labels still validated"         1 "MISSING: ## 1. Goal" "$OLD" 'null'

[ "$FAIL" -eq 0 ] && echo "ALL PASS" || { echo "$FAIL FAILED"; exit 1; }
