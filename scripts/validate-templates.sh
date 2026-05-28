#!/bin/bash
# Validate if a bead description follows the mandatory template sections
# Usage: ./validate-templates.sh <bead_id>

BEAD_ID="$1"

if [ -z "$BEAD_ID" ]; then
    echo "Usage: ./validate-templates.sh <bead_id>"
    exit 1
fi

BODY=$(bd show "$BEAD_ID" --json | jq -r '.[0].description')

REQUIRED_SECTIONS=(
    "I. Context & Objective"
    "II. Input Specification"
    "III. Constraints & Guards"
    "IV. Step-by-Step Logic"
    "V. Output Schema"
    "VI. Definition of Done"
)

MISSING=0
for SECTION in "${REQUIRED_SECTIONS[@]}"; do
    if ! echo "$BODY" | grep -q "$SECTION"; then
        echo "❌ MISSING: $SECTION"
        MISSING=$((MISSING + 1))
    fi
done

if [ "$MISSING" -eq 0 ]; then
    echo "✅ Bead $BEAD_ID follows template specification."
    exit 0
else
    echo "❌ Bead $BEAD_ID is missing $MISSING mandatory sections."
    exit 1
fi
