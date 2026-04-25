#!/bin/bash
# Initialize Beads planning for a new session
# Usage: ./init-session.sh "Goal of the task"

set -e

GOAL="${1:-Project Goal}"

echo "Initializing Beads planning..."

if [ ! -d ".beads" ]; then
    bd init
    echo "✓ Initialized Beads"
else
    echo "Beads database already exists."
fi

# Check if an epic already exists
EXISTING_EPIC=$(bd query "type=epic" --json | jq 'length' 2>/dev/null)

if [ "$EXISTING_EPIC" -eq 0 ] || [ -z "$EXISTING_EPIC" ]; then
    ID=$(bd q create "$GOAL" --type epic --priority P1)
    echo "✓ Created Epic: $ID"
    
    # Optional: Create default phases
    bd create "Phase 1: Discovery" --parent "$ID" > /dev/null
    bd create "Phase 2: Planning" --parent "$ID" > /dev/null
    bd create "Phase 3: Implementation" --parent "$ID" > /dev/null
    bd create "Phase 4: Verification" --parent "$ID" > /dev/null
    echo "✓ Created default phases"
else
    echo "Epic(s) already exist, skipping initial creation."
fi

echo ""
echo "Beads planning initialized!"
echo "Run 'bd ready' to see tasks."
