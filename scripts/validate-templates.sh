#!/bin/bash
# Validate if a bead description follows the mandatory template sections
# Usage: ./validate-templates.sh <bead_id>

BEAD_ID="$1"

if [ -z "$BEAD_ID" ]; then
    echo "Usage: ./validate-templates.sh <bead_id>"
    exit 1
fi

BODY=$(bd show "$BEAD_ID" --json | jq -r '.[0].description')
TYPE=$(bd show "$BEAD_ID" --json | jq -r '.[0].issue_type')

# Select required sections based on bead type
if [ "$TYPE" = "epic" ]; then
    REQUIRED_SECTIONS=(
        "Goal"
        "Success Criteria"
        "Context & Background"
        "Sub-Agent Strategy"
    )
else
    # Default to task sections for task/feature/bug/unknown types
    REQUIRED_SECTIONS=(
        "I. Context & Objective"
        "II. Input Specification"
        "III. Constraints & Guards"
        "IV. Step-by-Step Logic"
        "V. Output Schema"
        "VI. Definition of Done"
    )
fi

MISSING=0
for SECTION in "${REQUIRED_SECTIONS[@]}"; do
    if ! echo "$BODY" | grep -q "$SECTION"; then
        echo "❌ MISSING: $SECTION"
        MISSING=$((MISSING + 1))
    fi
done

# Anti-blob guards: a terse summary that happens to contain a keyword must still fail.
LINES=$(echo "$BODY" | grep -c .)
if [ "$LINES" -lt 10 ]; then
    echo "❌ TOO SHORT: $LINES non-empty lines (min 10). Hermetic ticket, not a summary blob."
    MISSING=$((MISSING + 1))
fi

# Tasks must carry a fenced TOON output schema (Section V); epics are exempt.
if [ "$TYPE" != "epic" ] && ! echo "$BODY" | grep -q '```toon'; then
    echo "❌ MISSING: fenced \`\`\`toon output-schema block (Section V)."
    MISSING=$((MISSING + 1))
fi

if [ "$MISSING" -eq 0 ]; then
    echo "✅ Bead $BEAD_ID follows template specification."
    exit 0
else
    echo "❌ Bead $BEAD_ID is missing $MISSING mandatory sections."
    exit 1
fi
