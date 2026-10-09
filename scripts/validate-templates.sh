#!/bin/bash
# Validate if a bead description follows the mandatory template sections
# Usage: ./validate-templates.sh <bead_id>

BEAD_ID="$1"

if [ -z "$BEAD_ID" ]; then
    echo "Usage: ./validate-templates.sh <bead_id>"
    exit 1
fi

JSON=$(bd show "$BEAD_ID" --json)
BODY=$(echo "$JSON" | jq -r '.[0].description')
TYPE=$(echo "$JSON" | jq -r '.[0].issue_type')

# gsd-beads beads-sync renders these bodies from PLAN.md; SKILL.md exempts them.
if echo "$JSON" | jq -e '(.[0].labels // []) | index("gsd-sync")' >/dev/null; then
    echo "⏭️ SKIP: $BEAD_ID is labelled gsd-sync (PLAN.md-rendered by gsd-beads); template gate exempt."
    exit 0
fi

# Required headers come from the matching template: every "## " line not marked "(optional".
TEMPLATE_DIR="$(dirname "$0")/../templates"
TEMPLATE="$TEMPLATE_DIR/task_template.md"
[ "$TYPE" = "epic" ] && TEMPLATE="$TEMPLATE_DIR/epic_template.md"
mapfile -t REQUIRED_SECTIONS < <(grep '^## ' "$TEMPLATE" 2>/dev/null | grep -v '(optional')
if [ "${#REQUIRED_SECTIONS[@]}" -eq 0 ]; then
    echo "❌ VALIDATOR BROKEN: no required headers derived from $TEMPLATE"
    exit 2
fi

MISSING=0
for SECTION in "${REQUIRED_SECTIONS[@]}"; do
    if ! echo "$BODY" | grep -qF "$SECTION"; then
        echo "❌ MISSING: $SECTION"
        MISSING=$((MISSING + 1))
    fi
done

# Unfilled placeholders: any bracketed token copied verbatim from a template fails.
while IFS= read -r TOKEN; do
    if echo "$BODY" | grep -qF -- "$TOKEN"; then
        echo "❌ PLACEHOLDER: $TOKEN"
        MISSING=$((MISSING + 1))
    fi
done < <(grep -ho '\[[^]]*[A-Za-z][^]]*\]' "$TEMPLATE_DIR"/*.md | sort -u)

# Anti-blob guards: a terse summary that happens to contain a keyword must still fail.
LINES=$(echo "$BODY" | grep -c .)
if [ "$LINES" -lt 10 ]; then
    echo "❌ TOO SHORT: $LINES non-empty lines (min 10). Self-sufficient ticket, not a summary blob."
    MISSING=$((MISSING + 1))
fi

if [ "$MISSING" -eq 0 ]; then
    echo "✅ Bead $BEAD_ID follows template specification."
    exit 0
else
    echo "❌ Bead $BEAD_ID has $MISSING violations."
    exit 1
fi
