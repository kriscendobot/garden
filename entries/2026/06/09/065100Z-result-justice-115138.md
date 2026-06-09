---
ts: 2026-06-09T06:51:00Z
kind: result
role: justice
host: endolinbot
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
dispatch_root: /home/kris/dispatches/justice--115138
short_id: 115138
to: steward
refs:
  - entries/2026/06/09/064100Z-result-fixer-7d740b.md
  - entries/2026/06/09/055200Z-result-barrister-f35f52.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 435
    role: reviewed
---

# result: justice round-2 code-panel verdict on #435 (115138). CHAIN CLOSED + un-drafted

## Pre-dispatch state check

`gh pr view 435 -R endojs/endo-but-for-bots --json state,isDraft,mergedAt` at top-of-dispatch returned `state: OPEN`, `isDraft: true`, `mergedAt: null`. Panel proceeded.

The dispatch arrived stale at `53e276c66`; per the brief's directive, fetched `build/immutable-arraybuffer-drop-the-pseudo-prototype` and checked out the actual head `448fa0298ec644dab7ec7d6ccc500c6bdab9390c` before any analysis. All findings are against the fixer-augmented branch.

## Inputs read

- Barrister round-1 verdict at `entries/2026/06/09/055200Z-result-barrister-f35f52.md` (3 MFL items, 7 summary-fix items, 3 follow-ups, 3 acknowledges, 2 drops).
- Fixer 7d740b result at `entries/2026/06/09/064100Z-result-fixer-7d740b.md` (8-commit pass `87a00bd0b .. 448fa0298`, cascading `e65d8dc42` pass-style fix, pre-push-gates compliance).
- Existing followup ledger at `journal/projects/endo-but-for-bots/followups/endo-but-for-bots--435.md` (3 parked items from round 1).
- The delta `9dc8bd5d50 .. 448fa0298e` (+337 / -91 LOC across 10 files).

## panel-hints output (round 2 delta, `--base 9dc8bd5d`)

```
Panel-kind: code-panel

Always-on core (9): assessor, typist, stylist, packager, archivist, prover, saboteur, integrator, corner-prober
Always-fire (2): scribe, releaser

Path-triggered (4): changeset-auditor, fast-checker, migrator, pruner
Content-triggered (3): spec-keeper, warden, wire-watcher
Cross-panel (2): copyeditor, pedant

Suppressed (8): benchmarker, breaker, curator, gateway, surfacer, engine-realist, locksmith, purist

Recommended total: 20 of 26 code-panel seats (+ 2 cross-panel).
```

Re-verification scope: round-1 contested seats (spec-keeper, engine-realist re-added for cross-engine MFL-1 verification, saboteur, warden, typist) plus delta-novelty seats above. The `@copilot` fire-and-forget reviewer add via `gh pr edit 435 --add-reviewer @copilot` was made at panel kickoff this round (idempotent re-request on the new head). Total verified: 21 seats (the panel-hints recommendation minus seats whose primary surface saw no delta-novel content, plus engine-realist re-added for cross-engine MFL-1 closure verification).

## Panel execution mode

**in-band-fallback** per `skills/panel-review/SKILL.md` § In-band fallback. The `Agent` tool was not in scope at top-of-dispatch (`ToolSearch query="select:Agent"` returned no matching deferred tools); per the skill the justice composed each contested seat's lens against the delta one at a time before aggregation. No justice-side overrides to the recommendation.

## Verdict

**comment** (zero `must-fix-loop` items; loop terminates).

`gh pr review --request-changes` is blocked on bot-self-authored PRs, so submission fell back to `gh pr review --comment` per `skills/panel-review/SKILL.md` § Pitfalls. The verdict above (zero must-fix-loop) is the authoritative read; the review body explicitly labels the loop-termination decision.

Review submitted at https://github.com/endojs/endo-but-for-bots/pull/435 (review `submittedAt: 2026-06-09T06:50:04Z`).

## Disposition counts (round 2)

- must-fix-loop: **0** (all three round-1 items closed; no new substance defects surfaced in the delta)
- summary-fix: 0 (all seven round-1 summary-fix items closed; no new items surfaced)
- follow-up: 0 new (the three round-1 follow-ups remain parked; item 2 partially closed by `0d0442a7b`)
- acknowledge: 1 (the `test (22.x, macos-15)` `endo › lifecycle` `EPIPE` flake)
- drop: 0 new

## Closure status of prior must-fix-loop items

| # | Item | Fix | Closure | CI |
|---|---|---|---|---|
| MFL-1 | shim `console.warn` unguarded + resizable-proposal accessors trigger overwrites list | `87a00bd0b` (both barrister options applied: expanded `expectedOverwrites` + `typeof console` guard) | **closed** | `test-hermes` SUCCESS, `test-xs` SUCCESS |
| MFL-2 | `[Symbol.toStringTag]` removal breaks concordance | `2bf4eb32b` (defineProperty per-instance, writable=false / enumerable=false / configurable=false) + `e65d8dc42` (cascading pass-style allow-list) | **closed** | `test (22.x, ubuntu-latest)` SUCCESS, `test (24.x, ubuntu-latest)` SUCCESS, `cover` SUCCESS |
| MFL-3 | TS type errors in `src/lib.js` | `0d92fb1c3` (smaller-diff: `@this {ArrayBuffer}` JSDoc annotations) + `f948d7cc8` (companion `@param` annotations) | **closed** | `lint` SUCCESS |

All three are closed in substance; CI corroborates each fix.

## Cascading-fix scoping (`e65d8dc42`)

The MFL-2 fix tripped `packages/pass-style/src/byteArray.js`'s `ownKeys(candidate).length === 0` invariant (the barrister had surfaced this as a `follow-up` load-order risk, not a substance regression on the assertion itself). The fixer caught the cascade after running the ocapn suite locally (67 broken tests) and shipped `e65d8dc42`.

Scoping verdict: **appropriate**. The fix replaces the prior strict zero-keys assertion with `const allowedOwnKeys = new Set([Symbol.toStringTag])` and iterates `for (const key of ownKeys(candidate))` rejecting anything else. The allow-list is exactly one symbol; defense-in-depth shape preserved. The cascade does not weaken the `immutableGetter` capture (the load-order risk the warden surfaced in round 1 remains as parked follow-up item 1, unchanged in scope by this commit). The 2-package footprint (immutable-arraybuffer + pass-style) is the minimum needed to land MFL-2 without breaking ocapn.

## Closure status of prior summary-fix items

All seven closed by `ae3b59b6e` (docs alignment) + `f948d7cc8` (test tightening + dedupe):

- SF-1, SF-2, SF-7 (changeset/README/Purposeful Violation misalignment): closed by `ae3b59b6e`. The README's *Purposeful Violation* section is restored under the own-property-only shape; the changeset now describes the actual pending-premise-2 exports surface and the toStringTag departure observable.
- SF-3 (no-op four-mutator test): closed by `f948d7cc8`. Replaced with a steady-state contract test on all eight shim-installed properties.
- SF-4 (missing positive-case coverage on read accessors): closed by `f948d7cc8`. Two new tests plus the negative companion for the brand accessor.
- SF-5 (amplifier not isolation-tested): closed by `f948d7cc8`. New internal-test export `_amplifyArrayBufferForTests` (underscore-prefix, doc'd as internal, not in `index.js` re-export); three contract tests.
- SF-6 (duplicated setup-rationale): closed by `f948d7cc8`. Hoisted to `test/_lib-setup.md`; single-line pointer in each test file.

## DESIGN.md design-departure annotations (`0d0442a7b`)

Both departures recorded: Move 2 paragraph 7 (toStringTag-as-own-property restoration) and Move 4 paragraph 4 (expectedOverwrites expansion + console-guard). The annotation shape is correct: appends an explicit **Design departure (recorded post-implementation, barrister panel round 1)** subsection rather than rewriting in place, preserving the historical rationale. The *Out of scope* item for "Retiring the concordance purposeful-violation note in the README" is reworded to reflect that the section now applies in modified form.

## Pre-push-gates compliance (`448fa0298`)

Three pre-push-gate findings the substantive bundle introduced: U+00A7 in `src/lib.js` replaced with ASCII "Move"; `_lib-setup.md` multi-sentence line split per `sentence-per-line-md`; `shim-amplifier.test.js` `t.is(...)` re-flowed per `yarn format`. All correctly scoped; no substance touched.

## CI classification on `448fa0298`

15 jobs total: 14 SUCCESS, 1 FAILURE.

The single FAILURE is `test (22.x, macos-15)`: `endo › lifecycle` in `packages/daemon` rejected with `Error: write EPIPE`. Classification: **environment-acknowledge (well-known flake)**.

Three corroborating signals:

1. **Out-of-scope surface.** PR touches `packages/immutable-arraybuffer`, `packages/pass-style`, plus docs. Does NOT touch `packages/daemon`, `packages/captp`, or `packages/marshal`. No mechanism by which the immutable-arraybuffer changes could affect the daemon's captp socket lifecycle.
2. **Single-matrix-cell pattern.** Only 22.x macOS-15 failed; 22.x Ubuntu, 24.x macOS, 24.x Ubuntu all pass on the same head. A real regression would land on multiple cells.
3. **Documented prior occurrence.** The garden's journal records the same `endo › lifecycle` / `write EPIPE` flake on this cell in `entries/2026/05/15/033400Z-result-fixer-ea1194.md` (cites the same single-cell pattern) and `entries/2026/06/04/053900Z-result-fixer-533a68.md` (rerun cleared an unrelated `RemoteError: write EPIPE` flake on the same cell). The investigator's macos-15 survey at `entries/2026/05/15/030128Z-result-investigator-9a5955` identified captp/daemon tests on this cell as a known ~15 % flake. The git history also carries `d7f095e59 fix(daemon) alleged fix for EPIPE / SES unhandled` naming this exact failure mode in this subsystem.

Textbook `environment-acknowledge` shape. The justice does not block the loop on it; no shepherd dispatch needed (this is not "broken CI to repair", it is a long-tail flake that re-runs typically clear).

## Post-loop actions executed

Per `roles/justice/AGENT.md` § Post-loop actions on terminating rounds:

- [x] `@copilot` fire-and-forget reviewer add via `gh pr edit 435 --add-reviewer @copilot` (round-2 idempotent re-request on the new head).
- [x] Formal review submitted via `gh pr review 435 --comment --body-file ...` (verdict tagged by disposition, prior MFL closure table, cascading-fix scoping verdict, summary-fix closure, CI flake classification, loop-termination decision spelled out).
- [x] `summary-fix` job-board posting: **NOT applicable** (zero `summary-fix` items survived round 1; nothing to post).
- [x] Followup ledger append: **NOT needed** (no new follow-ups surfaced; item 2 partially closed by `0d0442a7b` recorded in the review body but the ledger item itself remains parked for the post-merge sweep).
- [x] Gardener proposed-rule message: **not warranted** this round. The fixer surfaced one self-improvement observation (when restoring a previously-dropped own-property, exercise downstream brand-check assertions in verification scope) which is captured below; the panel-side observation about token cost of in-band-fallback at 20+ seats was already flagged in the barrister round-1 self-improvement; no novel pattern this round meets the dispatch-time gardener-message threshold.
- [x] Appellate dispatch: **NOT applicable**. Zero `follow-up` or `acknowledge` dispositions in this round's panel that an appellate could lift to `summary-fix` (the one acknowledge is a CI-cell flake, not a small-and-in-context source item).
- [x] `gh pr ready 435`: **executed**. PR is now `draft: false`.
- [x] Re-request `kriskowal` as reviewer via `gh api repos/endojs/endo-but-for-bots/pulls/435/requested_reviewers -X POST` with `{"reviewers": ["kriskowal"]}`: **executed**. `requested_reviewers: [kriskowal]` confirmed in the post-call JSON.

## Termination state

**CHAIN CLOSED**. PR #435 un-drafted at 2026-06-09T06:50:29Z, maintainer (`kriskowal`) re-requested as reviewer. The PR-creation-flow chain (designer -> builder -> cleaner -> barrister -> fixer -> justice) has completed for this PR. Next stage owed: maintainer review. After APPROVED reviewDecision, the orchestrator dispatches conductor to merge.

The orchestrator records termination and reports closure on PR #430 per the maintainer directive in the brief, and tears down this dispatch root on return.

## Self-improvement

The MFL-2 + cascading-fix pattern is worth flagging for the gardener-loop's future pattern recognition (not as a new rule on its own this round, but as a corroborating data point for the fixer's surfaced observation): when a fixer-loop restores a previously-dropped own-property to a value that downstream brand checks consume, the fixer's verification scope should expand to those downstream brand checks. The fixer's round-1 self-improvement on `entries/2026/06/09/064100Z-result-fixer-7d740b.md` § Self-improvement names this exact pattern; the justice's round-2 confirmation that the cascade scope was correct and the verification path was complete supports landing a one-line addition under the `regression-evidence` skill ("when restoring a feature that was intentionally dropped, exercise every downstream brand check that consumed the dropped feature"). Below the threshold to dispatch a gardener message from this justice on its own; surfaces here for accumulation if the pattern recurs.

The in-band-fallback panel discipline at 20+ seats remains workable on a delta-scoped re-run round: the round-2 re-verification scope of 21 seats composed cleanly in-context because most lenses became closure-confirmations on prior items rather than fresh full-diff reads. The token cost stays bounded when the delta is small.

Self-improvement: nothing this time.
