# Planning with Beads

A persistent task and knowledge management skill for AI agents, based on Manus context engineering principles and powered by the **Beads (`bd`)** system.

## Overview

Planning with Beads replaces volatile file-based planning with a structured, graph-based issue tracker. It ensures that your AI agent maintains a consistent goal, tracks every discovery, and never repeats failed attempts—even across multiple sessions or after context window resets.

## Key Features

- **Persistent Memory**: Uses Beads to store tasks, findings, and decisions on disk.
- **Context Engineering**: Implements Manus principles like "Attention Manipulation via Recitation" using `bd prime`.
- **Atomic Workflows**: Enforces one ticket per atomic task and immediate bug tracking.
- **Fail Pattern Prevention**: Includes explicit rules to prevent repetitive mistakes.
- **2-Action Rule**: Ensures every discovery is captured before it's lost from the agent's memory.

## Getting Started

1. **Initialize Beads**:
   ```bash
   bd init
   ```

2. **Start a Task**:
   ```bash
   bd create "Feature Goal" --type epic --priority P1
   ```

3. **Decompose**:
   ```bash
   bd create "Phase 1: Research" --parent <epic_id>
   ```

4. **Claim and Prime**:
   ```bash
   bd update <task_id> --claim
   bd prime
   ```

## Manus Principles Integration

This skill is designed around the 6 Manus Principles for high-performance AI agents:
1. KV-Cache Optimization
2. Masking vs. Removal
3. Filesystem as External Memory
4. Attention Manipulation via Recitation
5. Persistence of "Wrong Turns"
6. Anti-Few-Shotting Resilience

## Documentation

- [SKILL.md](SKILL.md): Core rules and command reference.
- [reference.md](reference.md): Deep dive into Manus principles with Beads.
- [examples.md](examples.md): Practical workflow examples.

## License

MIT
