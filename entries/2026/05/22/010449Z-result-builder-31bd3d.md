---
ts: 2026-05-22T01:04:49Z
kind: result
role: builder
project: endo-but-for-bots
refs:
  - entries/2026/05/22/004732Z-dispatch-liaison-31bd3d.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 345
    role: mirror
  - repo: endojs/endo
    pr: 3032
    role: source
---

# Result: mirror of endojs/endo#3032 opened as endojs/endo-but-for-bots#345

Draft PR: <https://github.com/endojs/endo-but-for-bots/pull/345>
Head SHA: `78e29b255c5a08b7b221b80845551ed710952950`
Branch: `mirror/3032-cancel`, base `llm`.

## Commit shape

Followed shape (b) per the dispatch: per-package re-formation rather than preserving the upstream's 7-commit grouping. Three commits on top of `llm`:

1. `feat(cancel): @endo/cancel cancellation primitive` (full new package, 26 files, +1671)
2. `refactor(daemon,cli): adopt makeCancelKit` (call-site swap across daemon and CLI, +17 / -28 across 8 files)
3. `chore: Update yarn.lock` (separate lockfile commit per the project's convention)

Tried shape (a) first (cherry-pick of `46c3763c8..690621478`). The hierarchical-cancellation commit landed clean; the `refactor(daemon,cli)` commit hit 6 conflicts, and the `feat(pass-style)` commit hit a context-drift collision in `packages/daemon/test/endo.test.js` that duplicated a test. Resolved the conflicts inline, then soft-reset and re-formed into the three grouped commits above for a tidier mirror diff. Discovered along the way that the upstream's follow-up commit (`690621478` "Addressing feedback") reverts the pass-style relaxation entirely, so the net pass-style diff is empty and no `feat(pass-style)` commit was needed.

## Conflict resolutions on the llm-vs-master boundary

- `packages/cli/package.json`: union of llm's `@endo/bytes` dep and the upstream's new `@endo/bundle-source` + `@endo/cancel` deps.
- `packages/cli/src/context.js`: kept llm's broader signal handling (`SIGINT` / `SIGTERM` / `SIGQUIT` loop from `feat(cli): normalize external termination`) and replaced the inner `makePromiseKit` plumbing with `makeCancelKit`.
- `packages/daemon/index.js`: kept llm's `waitForExit` / `waitForMessage` / `waitForSpawn` imports and dropped the now-unused `makePromiseKit` import (already replaced by `makeCancelKit` in `terminate`).
- `packages/daemon/package.json`: union of llm's `@endo/bytes` and upstream's `@endo/cancel` deps.
- `packages/daemon/src/daemon-node.js`: kept llm's `E` import (used in `host`/`identify` calls), dropped `makePromiseKit`, kept `makeCancelKit` at its original llm position; pruned an unused `Builtins` from the `@import` line.
- `packages/daemon/test/endo.test.js`: the cherry-pick's context drift inserted a duplicate `test('persist confined services...')` body. Kept llm's existing `testNeedsNodeWorker('persist confined services...')` (which uses `reverseLocate` and `doMakeArchive`), removed the duplicate. Also propagated the `makeCancelKit(cancelled)` substitution into the llm-renamed `testNeedsNodeWorker('persist unconfined services...')` body that the cherry-pick missed.

## Local validation

| Command | Result |
| --- | --- |
| `yarn install` | pass (yarn.lock regenerated, separate commit) |
| `yarn workspace @endo/cancel test` (34 tests) | pass |
| `yarn workspace @endo/pass-style test` (57 tests) | pass |
| `yarn workspace @endo/daemon ava test/endo.test.js --timeout=120s` (154 tests) | pass |
| `yarn lint` (root) | pass (0 errors, 1760 pre-existing warnings) |
| `yarn workspace @endo/daemon lint:eslint` | pass (0 errors) |
| `yarn workspace @endo/daemon lint:types` | one pre-existing TS error in `@libp2p/kad-dht`'s vendored `.d.ts` (`adaptive-timeout.js` module not found); not introduced by this PR |
| `pre-push-gates.sh --summary` | format and lint --fix passed; probes report pre-existing findings on files unrelated to this PR (daemon-node.js stutter, bus-daemon-rust-xs.js inline-jsdoc, SECURITY.md uniformity, sentence-per-line drift in design docs). The gate auto-fix also touched several files outside this PR's scope (SES, evasive-transform, daemon internals); those changes were restored before commit so the mirror diff stays focused. |

## Out of scope (intentional, per dispatch)

- No comment on endojs/endo#3032.
- No un-draft of the mirror PR; steward's PR-creation-flow scan picks it up.
- No upstream ferry; boatman handles that later if and when authorized.

Self-improvement: the cherry-pick on a fork with a divergent branch can wedge unrelated test bodies into the conflict region when the upstream test file restructured around a same-titled test; future mirror dispatches should preview each commit's conflict surface before deciding between shape (a) and shape (b), since shape (b) was cheaper here even though the dispatch's precedent leaned (b) only "unless conflicts make (a) cheaper." Worth a note on the mirror playbook (no skill exists yet) that the gate's auto-fix sweep can touch files outside the mirror's scope and the builder should restore-staged those before committing.
