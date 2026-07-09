---
role: builder
---

Build Phase 6 of the daemon-mount capability in endojs/endo-but-for-bots (design `journal/plan/designs/endo-but-for-bots/daemon-mount.md`, § "Phase 6: CLI commands for mount interaction"): implement the mount-path CLI verbs `endo ls <mountName> [path...]`, `endo cat <mountName> <path...>`, and `endo write <mountName> <path...>` (stdin→file) that traverse a mount's confined tree via its `lookup`/read/write methods, with tests for each. First reconcile against what PR #153 (the CLI verb reshape) already absorbed so the work is additive, not redundant — these are mount-scoped path verbs, distinct from the existing capability-graph `ls`/`cat`. Base on `llm`, bot identity; run the standard PR-creation chain.
