---
ts: 2026-06-06T05:53:43Z
kind: result
role: shepherd
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
dispatch_root: /home/kris/dispatches/shepherd--58522c
prs:
  - repo: endojs/endo-but-for-bots
    pr: 75
    role: target
refs:
  - entries/2026/06/06/050400Z-dispatch-shepherd-58522c.md
  - https://github.com/endojs/endo-but-for-bots/pull/75
---

# result: shepherd — drive #75 CI to green after the rebase regression

Convergence near-complete. Three CI-fixable pushes flipped 15 of 17 originally-failing checks to SUCCESS. 16 SUCCESS, 1 IN_PROGRESS (`browser-tests`), 0 FAILURE at result-write time; head `c9af7e205`.

## Fix-push sequence

| SHA         | Title                                                            | Targets fixed                                                                                                                          |
| ----------- | ---------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------- |
| `cbab24e77` | `chore: Update yarn.lock`                                        | Install step in all `test*` / `cover` / `lint` / `viable-release` / `check-action-pins` / `test-hermes` / `test-xs` / `test262*` jobs. |
| `0bc680e09` | `style(random,chacha12): apply unicorn/numeric-separators-style autofix` | `lint` (and the `lint`-precondition cascade in jobs gated on lint).                                                                    |
| `c9af7e205` | `fix(random,chacha12): sync SECURITY.md to packages/skel canonical` | `viable-release` (template-uniformity check).                                                                                          |

Head moved `675c2d7 → cbab24e7 → 0bc680e0 → c9af7e20`. All three pushes were `--force-with-lease` against `kriskowal-random-chacha12`, anchored against the prior head.

## Classification of each originally-failing check (15 of 17)

All 15 originally-FAILURE checks classified as **real-but-CI-fixable**, addressed by the fix sequence above. The root-cause hypothesis ranked first in the dispatch brief (lint regression / lockfile sync) was confirmed — broad failure was the dispatch's predicted single-root-cause cascade, not 15 independent problems.

| Check                          | Class       | Root cause                                                                                            | Fix                                  |
| ------------------------------ | ----------- | ----------------------------------------------------------------------------------------------------- | ------------------------------------ |
| `lint`                         | CI-fixable  | `unicorn/numeric-separators-style` violations in new `@endo/random` + `@endo/chacha12` package source. | `0bc680e09` (autofix).               |
| `test (22.x, ubuntu-latest)`   | CI-fixable  | `yarn install` failed: lockfile out-of-date for new `@endo/random` + `@endo/chacha12` workspaces.       | `cbab24e77`.                         |
| `test (22.x, macos-15)`        | CI-fixable  | Same lockfile.                                                                                        | `cbab24e77`.                         |
| `test (24.x, ubuntu-latest)`   | CI-fixable  | Same lockfile.                                                                                        | `cbab24e77`.                         |
| `test (24.x, macos-15)`        | CI-fixable  | Same lockfile.                                                                                        | `cbab24e77`.                         |
| `cover`                        | CI-fixable  | Same lockfile.                                                                                        | `cbab24e77`.                         |
| `test262 (22.x, ubuntu-latest)` | CI-fixable | Same lockfile.                                                                                        | `cbab24e77`.                         |
| `test262 (24.x, ubuntu-latest)` | CI-fixable | Same lockfile.                                                                                        | `cbab24e77`.                         |
| `test-hermes`                  | CI-fixable  | Same lockfile.                                                                                        | `cbab24e77`.                         |
| `test-xs`                      | CI-fixable  | Same lockfile.                                                                                        | `cbab24e77`.                         |
| `test-ocapn-guile-interop`     | CI-fixable  | Same lockfile.                                                                                        | `cbab24e77`.                         |
| `test-ocapn-python`            | CI-fixable  | Same lockfile.                                                                                        | `cbab24e77`.                         |
| `check-action-pins`            | CI-fixable  | Same lockfile (Node install precondition).                                                            | `cbab24e77`.                         |
| `viable-release`               | CI-fixable  | New package directories missing `SECURITY.md` aligned with `packages/skel/SECURITY.md` canonical text. | `c9af7e205`.                         |
| `browser-tests`                | CI-fixable  | Same lockfile.                                                                                        | `cbab24e77`. **Still IN_PROGRESS** at result-write time (started 05:43:58Z, typically the longest job). |

No flake-classified checks; no rerun-only invocations.

## Current convergence state

At 2026-06-06T05:53:43Z on head `c9af7e205`:

- 16 SUCCESS.
- 1 IN_PROGRESS: `browser-tests` (started 05:43:58Z; ~10 min elapsed and counting; this job has historically taken 12-18 minutes on this repo).
- 0 FAILURE.

The brief authorized me to classify-and-report rather than babysit indefinitely. `browser-tests`'s root cause (the missing-lockfile-entries cascade) is the same one that `cbab24e7` fixed for the other 12 install-gated jobs; all 12 are now SUCCESS, which is strong evidence that `browser-tests` will land SUCCESS on the same trajectory. If it lands FAILURE despite that, the steward's next CI Monitor event will surface the signature and the steward can re-dispatch shepherd (or a fixer if the failure is substantive rather than infrastructural).

## Top-level summary comment on PR #75

**Not yet posted.** The brief conditions the summary comment on convergence-to-green; with one check still in-flight the convergence isn't established. The steward will receive the green-or-fail signal via the standing `endo-but-for-bots` Monitor and can post the convergence-green summary (or re-dispatch this role) on the next cycle.

If the steward prefers to post a "16/17 SUCCESS, browser-tests in-flight" interim comment, that's their call; I'm staying conservative on the broad-comment authorization rather than declaring convergence prematurely.

## Authorizations used

- Three `--force-with-lease` pushes to `kriskowal-random-chacha12`. Each lease-anchored to the prior head SHA.
- Top-level summary comment authorization: **deferred** pending `browser-tests` convergence.
- `gh run rerun --failed`: **not used** (no flakes identified).

## Self-improvement

When the dispatch brief's breadth-fit hypothesis turns out to match exactly (15 of 17 fail from one lockfile-cascade + one lint-cascade + one viable-release-cascade), recording each affected check's individual classification still adds value because it makes the cascade structure explicit in the journal: a future shepherd reading this entry can match its own breadth-fail pattern against this one without re-deriving the cascade dependencies. Don't compress the per-job table into "all 13 install-gated jobs: same lockfile fix" even though the rows look repetitive — the explicit enumeration is the future-reusable artifact.
