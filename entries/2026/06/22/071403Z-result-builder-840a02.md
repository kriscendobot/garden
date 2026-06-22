---
ts: 2026-06-22T07:14:03Z
kind: result
role: builder
worktree: dispatches/builder--840a02/project
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
pr_number: 503
---

Reconstructed the passable-byte-arrays slice from merged #468 and #473
as a single draft PR suitable for boatman ferry to `endojs/endo`.

**PR #503** opened against frozen-base
`master-a7ff191` (snapshot of `endojs/endo@a7ff1913f`, the upstream
master tip — the natural base the boatman will target).
Branch: `feat/passable-byte-arrays`.

**Commits (3)**:
- `8170ec5c8` `feat(immutable-arraybuffer): freezable TypedArray emulation`
  — full code of #468 (lib.js, shim.js, README, 3 new tests + 5 modified tests,
  ses integration test).
- `d4b87d12a` `feat(pass-style): validate plain frozen Uint8Array on
  immutable buffer as byteArray` — full code of #473
  (byteArray.js, passStyleOf.js, byteArray.test.js).
- `fd7e3d978` `chore: add changeset for passable-byte-arrays feature`.

**Packages touched**: `@endo/immutable-arraybuffer`, `@endo/pass-style`,
`ses` (test only).

**Tests / gates**: 217 pass in immutable-arraybuffer, 41 in pass-style;
format, lint, lint:types clean on both; pre-push gates pass (one
pre-existing `test-package-no-main` finding on `chacha12-fast-check-test`
inherited from master, not introduced).

**Scope decisions**:
- Excluded `packages/immutable-arraybuffer/designs/` (bot-fork-only
  design artifacts).
- Excluded design-doc-rename commit `db6f0c5c0`; reverted the two
  comment-path updates to keep upstream-canonical `DESIGN.md`
  references.
- Retained the changeset (`freezable-typedarray-emulation.md`) since
  upstream uses the same changeset config.

**Boatman work at ferry time**:
- Attribution rewrites for erights-review-response commits (currently
  endolinbot-authored).
- Changeset slug may need renaming to a fresh upstream-generated slug.
- Design documents under `packages/immutable-arraybuffer/designs/`
  intentionally absent and should not be ferried.

The PR is DRAFT; cleaner / judge / fixer / un-draft did not run per
the dispatch brief. Boatman ferry can be dispatched separately from
a kriskowal-credentialed host (this work was prepared on endolinbot).

Self-improvement: builder noted that for upstream-ferry preparation
the correct frozen base is `endo-upstream/master`, not bot-fork
master, so the PR diff is clean against the upstream baseline. That
heuristic is implicit in the existing skill, so no edit needed; this
result captures it as field evidence.
