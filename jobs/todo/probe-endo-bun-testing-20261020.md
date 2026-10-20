---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
role: builder
kind: probe (gap-revealing-build, skills/gap-revealing-build/SKILL.md)

Repo: endojs/endo (fork endojs/endo-but-for-bots), BASED ON `master` (not `llm`). Open the DRAFT PR against a master-based head; it stays draft.

Task (time-boxed exploratory probe; "don't try too hard" - the goal is to discover whether this is economical, not to finish):
1. Add Bun test support: a `test:bun` script (root and/or per package) that runs the existing test suites under Bun.
2. Add a CI job that runs the `test:bun` scripts.
3. Ensure coverage for the Bun runs (c8 / bun's own coverage - whichever works), or report why not.

Blockers to investigate and report (the main deliverable is the gap report):
- Does Ava support Bun? (Ava worker_threads/child_process model, ESM loader flags, `--import` of ses lockdown, etc.)
- If not, would a different, portable runner be needed (node:test, bun:test, or a thin shim over the Ava API)? Estimate the cost of making tests runner-portable.
- SES/lockdown compatibility on Bun (JavaScriptCore) - which packages pass, which fail, and why.
- Rough economics: how many packages run green under Bun with minimal effort, and what the per-package conversion cost looks like.

Stop once the picture is clear; deliver a structured gap report in the PR description.
