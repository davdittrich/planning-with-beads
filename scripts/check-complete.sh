#!/bin/bash
# Check if all tasks in a Beads epic are complete
# Usage: ./check-complete.sh <epic_id>
# Exit 0 if complete, exit 1 if incomplete

EPIC_ID="$1"

if [ -z "$EPIC_ID" ]; then
    # Try to find the latest epic if none provided
    EPIC_ID=$(bd query -a "type=epic" --json | jq -r '.[-1].id' 2>/dev/null)
fi

if [ -z "$EPIC_ID" ] || [ "$EPIC_ID" == "null" ]; then
    echo "ERROR: No Epic ID provided and none found in beads database."
    exit 1
fi

echo "=== Beads Task Completion Check: $EPIC_ID ==="
echo ""

# Get counts
OPEN_TASKS=$(bd children "$EPIC_ID" --json | jq '[.[] | select(.status == "open" or .status == "in_progress" or .status == "blocked")] | length')

if [ "$OPEN_TASKS" -eq 0 ]; then
    echo "ALL TASKS COMPLETE"
    
    # Audit active beads memories to prevent context pollution
    MEMORIES=$(bd memories 2>/dev/null || true)
    if [ -n "$MEMORIES" ]; then
        echo ""
        echo "=== Active Beads Memory Audit ==="
        echo "Note: Global memories in 'bd remember' persist across sessions and inject into prompt context post-compaction."
        echo "Please audit memories below and run 'bd forget <key>' for any transient task memories before final closure:"
        echo "$MEMORIES"
    fi
    exit 0
else
    echo "TASK NOT COMPLETE: $OPEN_TASKS tasks still open/in_progress."
    bd children "$EPIC_ID" --json | jq -r '.[] | select(.status != "closed") | "- \(.id): \(.title) ([\(.status)])"'
    exit 1
fi
