# Beads Planning Examples

## Example: Build CLI Tool

### 1. Init Session
```bash
./scripts/init-session.sh "Build 'spark' CLI"
# Initializes Beads
# Creates Epic: spark-1
# Creates default phases (Discovery, Planning, etc.)
```

### 2. Custom Decompose (Optional)
```bash
bd create "Phase 1.1: Research Argparse" --parent spark-1 --description "Look into subcommands"
# ID: spark-1.5 (if default phases 1-4 exist)
```

### 3. Execution
```bash
bd update spark-1.1 --claim
bd prime
# (Research...)
bd remember --topic argparse "Subcommands allow 'spark add' pattern."
bd update spark-1.1 --status closed --reason "Research done."
```

### 4. Progress & Logging
```bash
bd update spark-1.3 --claim
# (Error during implementation...)
bd comment spark-1.3 --body "Error: ModuleNotFound 'requests'. Fix: Update requirements.txt"
```

### 5. Verify & Finish
```bash
./scripts/check-complete.sh spark-1
# Returns error if spark-1.2, 1.4, etc. still open
# Returns "ALL TASKS COMPLETE" when everything closed
```
