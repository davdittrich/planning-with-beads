# Beads Planning Examples

## Example: Build CLI Tool

### 1. Init
```bash
bd init
bd create "Build 'spark' CLI" --type epic --priority P1 --description "$(cat templates/epic_template.md)"
# ID: spark-1
```

### 2. Decompose
```bash
bd create "Phase 1: Research" --parent spark-1 --description "Argparse subcommands"
# ID: spark-1.1
bd create "Phase 2: Core Impl" --parent spark-1
# ID: spark-1.2
```

### 3. Execution (Phase 1)
```bash
bd update spark-1.1 --claim
bd prime
# (Research...)
bd remember --topic argparse "Subcommands allow 'spark add' pattern."
bd update spark-1.1 --status closed --reason "Research done."
```

### 4. Progress
```bash
bd update spark-1.2 --claim
# (Error...)
bd comment spark-1.2 --body "Error: ModuleNotFound 'requests'. Fix: Update requirements.txt"
```
