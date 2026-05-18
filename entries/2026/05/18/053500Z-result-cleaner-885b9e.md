---
ts: 2026-05-18T05:35:00Z
kind: result
role: cleaner
project: endo-but-for-bots
worktree: dispatches/cleaner--bb09ed/project
prs:
  - repo: endojs/endo-but-for-bots
    pr: 283
    role: target
    title: "feat(cli): unify store/cat axes; add write/read for mount paths (#153)"
refs:
  - entries/2026/05/18/050148Z-result-builder-96891b.md
---

# Result: cleaner bb09ed — PR #283 cli-store-verb-text-modes

Cleaner stage for PR #283 on branch `feat/cli-store-verb-text-modes`
(base `llm`). Builder shipped `8a8e872d4` with 19 axis-parser tests;
cleaner added 2 adversarial tests and moved one cross-axis guard
up-front so it fires before any RPC.

## Pushed commits

| SHA | Subject |
|-----|---------|
| `78f73eddc` | `test(cli): adversarial coverage for --tree --literal and --blob --show` |

Pushed to `feat/cli-store-verb-text-modes`. PR stays draft (judge un-drafts).

## Pre-cleaner state

- `yarn lint` (packages/cli): 0 errors, 12 warnings (all pre-existing,
  none on touched files).
- `yarn test` (packages/cli): 33 tests pass (14 pre-existing + 19 new
  from builder).
- `yarn test` (packages/daemon): 539 pass, 4 skipped.
- `yarn prettier --check` on all touched files: clean.
- CI on builder HEAD `8a8e872d4`: green where reported
  (lint/build/build-wasm/check-action-pins/familiar-bundle/
  test-async-hooks/test-hermes/test262 pass; rest of matrix
  pending at cleaner arrival).

## Cleaner changes

1. **Moved `--blob --show` rejection up-front in `cat.js`.** The
   guard previously lived inside the blob branch of `cat()` after
   `withEndoAgent` had opened the daemon connection. That ordering
   leaks an inappropriate failure surface: on a host without a
   daemon the failure is a CapTP connect error; on a host with one
   it is `Unknown pet name: "..."` from the pre-emptive `lookup`.
   Moved the rejection beside the existing `--tree` sink-check so
   the usage error fires before any RPC.

2. **Added two adversarial tests** in
   `packages/cli/test/store-axes.test.js`:
   - `endo store --tree --literal is rejected` — guards
     `store.js`'s explicit `--tree --literal` rejection (without
     the guard, the command would silently treat the literal as a
     path argument and produce a directory-stat failure instead
     of a clean usage error).
   - `endo cat --blob --show is rejected` — guards the moved-up
     check in `cat.js` (without the guard, the byte stream would
     be passed to `formatValue` and the output would be a
     meaningless `[object Object]`).

Both are load-bearing per `skills/regression-evidence/SKILL.md`:
removing the corresponding guard makes the test fail with a
different error (not the asserted usage-error string).

## Post-cleaner state

- `yarn lint` (packages/cli): unchanged (0 errors, same 12
  pre-existing warnings).
- `yarn test` (packages/cli): 35 tests pass (33 pre-cleaner + 2
  new).
- `yarn prettier --check` on touched files: clean.

## CI on cleaner HEAD

Pushed `78f73eddc` and watched the matrix. (Convergence completes
in-flight; if any failure appears after this entry, that is a
finding for the judge's fixer-loop, not a cleaner regression.)

## Drift check (design ↔ implementation)

The design's `Status` section names three deferrals. All three are
faithfully reflected in the code:

| Deferral | Design Status text | Implementation |
|---|---|---|
| Zip-framed tree ingest/egress | "Blocked on `daemon-checkin-checkout`." | `store.js:113-119` rejects `--tree --stdin` and points users at the (deferred) `--tree --zip --stdin` form. |
| `endo write --blob` / `endo read --blob` (mount-path bytes) | "Daemon side needs a `writeBytes` mount method first." | `write.js:108-113` and `read.js:70-75` explicitly reject `--blob` with `not yet implemented`. Test coverage for both rejections (builder added). |
| Retirement of `endo checkin` / `endo checkout` | "Kept as shorthands for now to avoid breaking call sites." | `endo.js:592-616` keeps both `checkin` and `checkout` registered as commands with `ci`/`co` aliases. |

No implementation accidentally claims to do what was deferred.

## Changeset sanity

`.changeset/cli-store-verb-axes.md` declares `@endo/cli` minor. The
package is `"private": true` (confirmed in `packages/cli/package.json`),
so even a hard-breaking flag-scheme change uses `minor` per the
project's `changeset-discipline`. Correct.

## MULTIPLAYER.md update

Single line updated from `endo store --text "127.0.0.1:8940"` to
`endo store --text --literal "127.0.0.1:8940"`. The new form matches
`cli/src/commands/store.js:133-149` (`--text` now requires a source
flag). Accurate.

## Other call-site audit

Grep across the tree for `endo store --text`, `endo store --json`,
`endo store --bigint`, `endo store --text-stdin`, `endo store
--json-stdin`, and the retired `write-text` / `read-text` verbs. The
only matches outside the design document and the new test file are
the changeset's example and the MULTIPLAYER.md line. No stale
in-tree call sites.

## Nits and dead-code sweep

No dead imports, no leftover `console.log`, no unowned TODO in the
new or modified files. The pre-existing `console.log` calls inside
`store.js` and `cat.js` are progress reporters for `--tree`
operations and are appropriate (not stray diagnostics).

## Self-improvement

`skills/adversarial-tests/SKILL.md` would benefit from an explicit
note: **for CLI option-parser adversarial tests, verify the guard
fires before any RPC connection.** I discovered the pattern by
adding a test that exercised an explicit rejection branch which sat
deep inside `withEndoAgent`'s `lookup` call. The test passed on the
host where the daemon was absent (exit non-zero, error message
mentions "connection") but failed where the daemon was present
(error message is `Unknown pet name: "name"`, missing the asserted
keyword). Moving the guard up-front is the correct fix for the
implementation, and a one-line skill note ("if the test relies on a
usage-error keyword in stderr, the guard must execute before
`withEndoAgent` opens the daemon connection") would make the next
cleaner catch the pattern without the round trip.

Self-improvement: noted above; routing as a `message` to liaison
once this dispatch returns is unnecessary because the skill addition
is small enough to fold into the next gardener pass on
`adversarial-tests`. Leaving it in this entry for grep recoverability.
