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
EXISTING_EPIC=$(bd query -a "type=epic" --json | jq 'length' 2>/dev/null)

if [ "$EXISTING_EPIC" -eq 0 ] || [ -z "$EXISTING_EPIC" ]; then
    # Create epic with template hint
    EPIC_BODY="Fill using templates/epic_template.md"
    ID=$(bd create "$GOAL" --type epic --silent --priority P1 --description "$EPIC_BODY")
    echo "✓ Created Epic: $ID"
    
    # Create default phases with template hints
    TASK_BODY="Fill using templates/task_template.md"
    bd create "Phase 1: Discovery" --parent "$ID" --description "$TASK_BODY" > /dev/null
    bd create "Phase 2: Planning" --parent "$ID" --description "$TASK_BODY" > /dev/null
    bd create "Phase 3: Implementation" --parent "$ID" --description "$TASK_BODY" > /dev/null
    bd create "Phase 4: Verification" --parent "$ID" --description "$TASK_BODY" > /dev/null
    echo "✓ Created default phases"
else
    echo "Epic(s) already exist, skipping initial creation."
fi

echo ""
echo "CRITICAL: You MUST now update these tasks with full descriptions."
echo "Use 'templates/task_template.md' for tasks and 'templates/epic_template.md' for epics."
echo ""
echo "Beads planning initialized!"
echo "Run 'bd ready' to see tasks."
