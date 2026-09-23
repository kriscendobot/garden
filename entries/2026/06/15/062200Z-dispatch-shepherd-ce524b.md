---
ts: 2026-06-15T06:22:00Z
kind: dispatch
role: steward
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: shepherd
dispatch_root: /home/kris/dispatches/shepherd--ce524b
prs:
  - repo: endojs/endo-but-for-bots
    pr: 443
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/443
  - https://github.com/endojs/endo-but-for-bots/pull/443#issuecomment-4705115789
---

# dispatch: shepherd — Rollup retention question on PR #443 per kriskowal

Maintainer directive (kriskowal on PR #443, 2026-06-15T06:20:59Z):

> @kriscendobot Why do we still retain Rollup? Please shepherd this change.

PR #443 is a dependabot bump of the all-minor-patch group (25 updates). The
maintainer's question is substantive: why does the project still depend on
Rollup at all? This appears to be a directional question (perhaps Rollup
should be removed in favor of another bundler), not a CI question.

## State at dispatch time

- **PR** `endojs/endo-but-for-bots#443`, base `llm`, head `ec81c3b7e`.
- **Title**: chore: bump the all-minor-patch group across 1 directory with 25 updates
- **Author**: app/dependabot

## Task

In your `project/` worktree at `ec81c3b7e`:

1. Inspect the dependabot bump diff to see if Rollup is in the update set (`git diff llm..HEAD` on package.json / yarn.lock).
2. Search the codebase for actual Rollup usage:
   - `grep -rE "rollup" --include="*.json" --include="*.js" --include="*.mjs"`
   - Identify which packages depend on Rollup and where it's used in builds.
3. Categorize each Rollup-usage site:
   - Production / runtime dep
   - Build-time dep
   - Test / dev tooling only
   - Transitive (via another tool)
4. For each, evaluate whether the use case could be replaced by another tool the codebase already uses (esbuild, parcel, webpack, swc, etc.), or whether Rollup is load-bearing.
5. Post a top-level comment on PR #443 at-mentioning @kriskowal answering "Why do we still retain Rollup?" with:
   - Per-package Rollup usage map.
   - For each: load-bearing yes/no + rationale.
   - Recommended next step (e.g., open a separate PR to drop Rollup if not load-bearing; or surface the load-bearing constraint for the maintainer to decide).
6. Do NOT merge or close the dependabot PR — the substantive question is upstream of the bump.

## Authorizations

- Read-only on project.
- Top-level comment on PR #443 @-mentioning @kriskowal.
- Do NOT push to project (the dependabot branch is owned by dependabot).
- Do NOT close PR #443.

## Out of scope

- Do NOT remove Rollup in this dispatch (a separate builder PR if the maintainer agrees).
- Do NOT pursue other deps in the bump set.

## Deliverable

A `result` entry under `journal/entries/2026/06/15/` naming:

- Per-package Rollup usage map.
- Load-bearing assessment.
- PR #443 comment URL.
- Recommended next stage (e.g., `next: builder` to drop Rollup, `next: liaison` for maintainer decision).
- A `Self-improvement: ...` line.

End your turn with a concise summary back to the orchestrator.
