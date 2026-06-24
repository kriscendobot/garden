---
ts: 2026-06-14T10:52:30Z
kind: result
role: justice
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
worktree: dispatches/justice--1eed16/project
refs:
  - entries/2026/06/14/104800Z-dispatch-justice-1eed16.md
  - entries/2026/06/14/095115Z-result-barrister-103358.md
  - entries/2026/06/14/104357Z-result-fixer-9bf98b.md
---

# Justice result: PR #440 code-panel re-run (round 2) terminates loop

PR endojs/endo-but-for-bots#440 (`feat(daemon,cli,chat): drop @info name hub for formula-inspector design (#439)`), branch `feat/formula-inspector`, head `93b399160`, base `llm`. Round 2 of the code-panel chain (justice). The barrister's round 1 verdict (`095115Z-result-barrister-103358.md`) issued 3 must-fix-loop + 5 summary-fix + 5 follow-up + 4 acknowledge + 2 drop; the fixer `9bf98b` addressed all must-fix-loop and summary-fix items in three commits plus three out-of-band fixes (HostInterface guard, randomHex512 typo, write/storeIdentifier receiver).

## Pre-dispatch state probe

`gh pr view 440 -R endojs/endo-but-for-bots --json state,isDraft,mergedAt` returned `state=OPEN, isDraft=true, mergedAt=null`. Proceeded.

## Panel-hints output (verbatim, against the fixer's delta)

```
$ bash garden/skills/panel-hints/panel-hints.sh --base 888951a9f
Panel-kind: code-panel
Always-on core (9): assessor, typist, stylist, packager, archivist, prover, saboteur, integrator, corner-prober
Always-fire (2): scribe, releaser
Path-triggered (3): breaker, fast-checker, migrator
  breaker  packages/daemon/src/interfaces.js (M.interface / makeExo / ## Invariants)
  fast-checker  packages/chat/test/component/inventory-component.test.js
  migrator  3 packages touched
Content-triggered (2): spec-keeper, warden
  spec-keeper  matched: .call(
  warden  matched: __proto__
Cross-panel (0): -
Suppressed (12): benchmarker, changeset-auditor, curator, gateway, pruner, surfacer, engine-realist, locksmith, purist, wire-watcher, copyeditor, pedant
Recommended total: 16 of 26 code-panel seats.
```

## Panel composition (16 seats)

- Always-on core (9): assessor, typist, stylist, packager, archivist, prover, saboteur, integrator, corner-prober.
- Always-fire (2): scribe, releaser.
- Path-triggered (3): breaker, fast-checker, migrator.
- Content-triggered (2): spec-keeper, warden.
- **Override (additions)**: none. Per the justice norm (must-fix-loop items must be re-verified by the seat that raised them), the round 1 must-fix-loop-raising seats (assessor, prover, corner-prober, archivist, integrator) are already in the recommended set.
- **Override (subtractions)**: none.

Panel execution: **in-band-fallback** (no `Agent` tool surfaced in this dispatch; `ToolSearch` for `select:Agent,Task` returned no match). Each seat composed as a per-seat block against the seat's role file under `roles/jurors/<seat>/AGENT.md`, aggregated after every block landed.

Panel kind: **code-panel**.

Round 2 dispatch size (16) is below the round 1 dispatch (23) because the delta is small (9 files, 147+/79-) and the cross-panel design seats (copyeditor, pedant) that round 1 added on the substantial PR-body markdown are not re-fired (PR body edits in this round were small targeted corrections, not bulk markdown).

## Closure status of prior must-fix-loop items

| # | Item | Closure | Commit |
| --- | --- | --- | --- |
| 1 | `formula-record.js` unreachable `make-bundle` arm + missing `make-archive`/`make-from-tree`; broken `host` case | **Closed** (arm removed; two new cases land with correct properties per `formulateArchive`/`formulateFromTree`; `host` case rewritten to surface every `HostFormula` field per `types.d.ts:141-153`) | `ef6fb7950` |
| 2 | `inspect-formula.js` regex re-derivation from real `make-archive` output | **Closed** (all four regexes updated; 64-hex length corrected from the wrong 128) | `275480ecb` |
| 3 | `formula-view-registry.js` + canonical-list test `keypair` orphan claim | **Closed** (canonical-list updated; registry comment marks keypair as reserved with pointer to design's Forward compatibility section; privacy-suppression test for `privateKey` retained as registry-shape coverage) | `93b399160` |

## Closure status of prior summary-fix items

| # | Item | Closure |
| --- | --- | --- |
| 1 | Daemon-side per-type catalog vs registry empty-state | **Deferred** (carried as round 1 follow-up; this round broadens it to include the new host case alignment and posts a fresh `summary-fix` job) |
| 2 | `{ __proto__: null, ... }` for `REGISTRY` | **Closed** (`93b399160`; matches `eventual-send/src/message-breakpoints.js:108-109` precedent including the `@ts-expect-error confused by __proto__` comment) |
| 3 | `make-bundle` removal from registry | **Closed** (`93b399160`) |
| 4 | PR body open-question 1 `make-bundle` claim | **Closed** (PR body edited; researcher acknowledged) |
| 5 | PR body cut 3 paragraph 1 `keypair` framing | **Closed** (PR body edited) |
| 6 | JSDoc on `valueComponent` back-face mount-point optionality | **Closed** (`93b399160`; new paragraph above the param block) |
| 7 | Gear icon visibility tied to `showValueFormula` | **Closed** (`93b399160`; gear button now conditionally rendered; test renamed to `gear is omitted when showValueFormula is not provided` with new contract assertions) |

The fixer's out-of-band finds (HostInterface `getFormula` guard, `randomHex512` -> `randomHex256` typo correction, `E(host).write` -> `E(host).storeIdentifier`) are not panel findings but bring the daemon test suite back to green. Verified: `randomHex256` exists at `daemon-persistence-powers.js:79,137`; `storeIdentifier` is the host-side method at `host.js:252,270,292,355,390,...`; the `interfaces.js` `HostInterface` now correctly enumerates `getFormula: M.call(IdShape).returns(M.promise())`.

CI at round-2 time: all completed jobs SUCCESS (lint, test, build, browser-tests, test-async-hooks, test262 22.x/24.x, test-hermes, viable-release, check-action-pins, build-wasm, test-xs, test-ocapn-python, familiar-bundle); still-running cover/sandbox-drivers/test-matrix are mid-run re-runs not introduced by this PR.

## Disposition counts (round 2)

| Disposition | Count |
| --- | --- |
| must-fix-loop | 0 |
| summary-fix | 1 |
| follow-up | 1 |
| acknowledge | 5 |
| drop | 0 |
| **Total findings** | **7** |

The loop terminates on this round (zero must-fix-loop).

### Summary-fix items (1)

1. **Chat-side registry `host` entry `propertyList` alignment with daemon's rewritten host case.** The chat-side `formula-view-registry.js` host entry's `propertyList` still lists the older `worker` field; the daemon now emits `handle`, `hostHandle`, `mainWorker`, `nodeWorker`. The fallback path renders the new references in the unknown-properties tail, so this is presentation polish rather than correctness, but landing it before un-draft keeps the registry and the daemon's record producer coherent on day one. Posted to `jobs/open/20260614T105226Z--ea095b--endo-but-for-bots-440-r2-summary-fix.md`.

### Follow-up items (1)

1. **Chat-side registry host propertyList alignment**, appended to `projects/endo-but-for-bots/followups/endo-but-for-bots--440.md` as a round-2 item. The ledger entry is the merge-watch belt-and-suspenders: if the summary-fix job ages out unclaimed and the PR merges, the steward's per-cycle survey will pick up the follow-up at merge time.

### Acknowledge items (5)

- `formula-record.js:74-96` host case: correctly surfaces every `HostFormula` reference per `types.d.ts:141-153`.
- `formula-record.js:98-117` `make-archive` and `make-from-tree` cases: correct property emission per `formulateArchive`/`formulateFromTree`.
- `interfaces.js:455` `getFormula` guard: matches the implementation; argument shape is `IdShape`.
- `formula-view-registry.test.js:19-49` canonical-list update: inline comment about why `keypair` is excluded prevents the next reader from re-introducing the false claim.
- `endo.test.js:2406-2435` rewrite: correctly uses `storeIdentifier`; the `randomHex512` -> `randomHex256` substitutions match the 64-hex length contract.

### Drop items (0)

No round-2 findings dropped.

## Post-aggregation actions

- **Formal review submitted** as `gh pr review 440 -R endojs/endo-but-for-bots --comment` (the `--request-changes` fallback per `skills/panel-review/SKILL.md` § Pitfalls: PR author and reviewing identity are both `kriscendobot`, so GitHub blocks `--request-changes`; the verdict heading "must-fix-loop (0)" carries the disposition in the body).
  Review URL: <https://github.com/endojs/endo-but-for-bots/pull/440#pullrequestreview-4492801941>.
- **`@copilot` reviewer added** via `gh pr edit 440 -R endojs/endo-but-for-bots --add-reviewer @copilot` (fire-and-forget, idempotent on re-rounds).
- **summary-fix job posted** at `jobs/open/20260614T105226Z--ea095b--endo-but-for-bots-440-r2-summary-fix.md`. Eligible roles: `fixer, steward`.
- **Followup ledger appended** at `projects/endo-but-for-bots/followups/endo-but-for-bots--440.md` (1 new round-2 item; `last_appended_at` bumped to `2026-06-14T10:52:00Z`).
- **Proposed-rule message to gardener**: none (every round-2 finding traces to an existing rule).
- **Did NOT un-draft** (per dispatch brief: orchestrator handles after appellate runs on terminating round).
- **Did NOT push to project** (per dispatch brief).

## Recommended next stage

The jury-fixer loop terminates on this round (zero must-fix-loop). Recommended post-loop chain (orchestrator handles): **appellate** review (per the orchestrator's policy of running an appellate on terminating rounds; the appellate has one summary-fix and one follow-up to consider appealing into summary-fix-bundled form) -> **un-draft** -> **conductor** for merge after maintainer approval.

`next: appellate then un-draft then conductor`.

Self-improvement: nothing this time. The dispatch brief was complete; `post-job.sh` failed in this dispatch root because the script resolves `GARDEN_ROOT` relative to its own location and expects `journal/` to be a subdirectory of `garden/`, while the dispatch-root triple sets `garden/` and `journal/` as siblings; I worked around by writing the job file directly under `journal/jobs/open/`. The structural lesson, if any, is that `post-job.sh` could fall back to `JRN=$(dirname "$SCRIPT_DIR")/../../journal` or accept a `--journal-root` flag for the dispatch-root case; sending as a `message: justice -> gardener` would be overkill for a one-off; noting here in case a future judge dispatch hits the same friction and the pattern is worth lifting.
