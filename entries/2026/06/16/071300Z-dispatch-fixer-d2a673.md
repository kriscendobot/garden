---
ts: 2026-06-16T07:13:00Z
kind: dispatch
role: steward
host: endolinbot
repo: kriscendobot/agoric-sdk
project: agoric-sdk
to: fixer
dispatch_root: /home/kris/dispatches/fixer--d2a673
prs:
  - repo: kriscendobot/agoric-sdk
    pr: 5
    role: target
refs:
  - https://github.com/kriscendobot/agoric-sdk/pull/5
---

# dispatch: fixer — OODA cycle 5 swingset-runner TS errors

OODA cycle 5 on PR #5 head `d019de698e`. lint-primary now red with **20 NEW TS errors** in `packages/swingset-runner/src/` (different signature from cycle 4). Cause: fixer a849e6's commit `c659a1854a` adopted upstream Agoric#12734's `yargs-parser → node:util parseArgs` pattern but the TypeScript types in swingset-runner don't yet match parseArgs's return shape.

## Failing TS errors (20)

All in `packages/swingset-runner/src/`:
- `anylogger-legacy.js:12` — spread argument type
- `dataGraphApp.js:74, 78, 92, 94` — possibly undefined / fallthrough / null assignment
- `kerneldump-entrypoint.js:15` — `.then` on `void`
- `kerneldump.js:109, 110, 114, 124` — possibly undefined / string|undefined to string
- `main.js:327, 370, 394, 490, 642, 743, 814, 820, 920` — string|undefined to null, etc.
- `demo.test.js:49` — `new Promise()` zero-arg

## State at dispatch time

- **PR** `kriscendobot/agoric-sdk#5`, DRAFT, head `d019de698e`.

## Task

In your `project/` worktree at `d019de698e`:

1. **Decide** path:
   - **Path A (revert)**: revert `c659a1854a` for swingset-runner only (keep deployment and solo commits which target different packages). Add `yargs-parser` back to packages/swingset-runner/package.json deps. This is the safer/simpler path if the parseArgs swap can't easily be made type-safe.
   - **Path B (fix types)**: Apply targeted `@ts-ignore` / type guards to the 20 errors. Heavier touch.
   - Choose A unless quick inspection shows B is one-line changes.
2. Verify locally:
   - `corepack yarn workspace @agoric/swingset-runner lint:types` should be clean.
   - `corepack yarn lint:primary` should be clean.
3. Run pre-push-gates.
4. Commit per logical group.
5. Push to `mirror/12527-endo-sync-refresh` (append only).
6. Post a top-level comment on PR #5 at-mentioning @kriskowal:
   - Path chosen + rationale.
   - SHAs.
   - Note continuing the OODA loop.

## Authorizations

- Append-push.
- Top-level comment.
- Do NOT revert Float*Array endow, dual-AVA fix, d8a32b absorb net, OR fixer a849e6's other commits (deployment/solo/etc.).
- Do NOT touch upstream Agoric/agoric-sdk.

## Out of scope

- Do NOT pursue Class A.
- Do NOT pursue test-* cascades (fix lint-primary first; cascades clear via fail-fast resolution).

## Deliverable

A `result` entry under `journal/entries/2026/06/16/` naming:

- Pre/post head SHAs.
- Path chosen + rationale.
- Commit SHAs.
- Local lint:types verification.
- pre-push-gates result.
- PR #5 comment URL.
- A `Self-improvement: ...` line.
- **Recommended next stage**: `next: ooda-observation` when CI settles.

End your turn with a concise summary back to the orchestrator.
