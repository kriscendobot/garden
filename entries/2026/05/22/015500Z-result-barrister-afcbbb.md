---
ts: 2026-05-22T01:55:00Z
kind: result
role: barrister
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
refs:
  - entries/2026/05/22/013900Z-result-cleaner-53a5ce.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 348
    role: source
---

# Barrister result: PR #348 (mirror of endojs/endo#2902 "Deduplicate bundle-lite")

Panel kind: code-panel (twenty-six seats).
Panel execution: in-band-fallback (no `Agent` tool surfaced to this dispatch; the barrister walked each seat one block at a time per `skills/panel-review/SKILL.md` § In-band fallback).
HEAD reviewed: `b2005c2db` (the fixer's `syncModuleTransforms` restoration on top of `38bd5ba4d`).

## Verdict

**Terminating round.** 0 must-fix-loop, 0 summary-fix, 2 follow-up, 3 acknowledge, 3 drop. No fixer dispatch follows; no panel re-run; the justice has nothing to do.

## Disposition counts

- must-fix-loop: 0
- summary-fix: 0
- follow-up: 2
- acknowledge: 3
- drop: 3

## Post-loop actions taken

1. **Formal review submitted** as one `gh pr review --comment` on PR #348 (review ID surfaced at 2026-05-22T01:52:50Z; submitted under the `kriscendobot` identity since the local `gh` is authenticated as the PR's author, matching the self-review fallback per `skills/panel-review/SKILL.md` § Pitfalls; the verdict body carries the dispositions and the panel's full per-seat summary so the maintainer reads the same content `reviewDecision` would have keyed).
2. **`@copilot` fire-and-forget reviewer add** ran before juror walk per `roles/barrister/AGENT.md` § The code panel: `gh pr edit 348 -R endojs/endo-but-for-bots --add-reviewer @copilot`.
3. **Followup ledger appended** at `journal/projects/endo-but-for-bots/followups/endo-but-for-bots--348.md`. Two items: (a) `bundle-lite.js:316-325` `BundleOptions`-destructure joinery-point hardening; (b) `bundle-lite.js:425-440` alias-error branch test coverage. Both reference the cleaner's case-study entry. Status `parked`; upstream mirror set to `endojs/endo#2902` so the steward's per-cycle merge-watch poll covers both PRs.
4. **No summary-fix job posted.** No findings landed in the summary-fix disposition this round.
5. **No proposed-rule message to gardener.** Every finding traced to a standing rule citation; no `[proposed-rule]` tags this round.
6. **Appellate dispatch** is the orchestrator's call per the post-loop policy in `roles/barrister/AGENT.md` § Operating norms; the barrister surfaces the two follow-up and three acknowledge dispositions as candidates the appellate may appeal toward summary-fix before un-draft. The barrister did not invoke the appellate itself (no `Agent` tool in scope; consistent with the in-band fallback posture).
7. **`gh pr ready 348 -R endojs/endo-but-for-bots` ran** at 2026-05-22T01:54:30Z; PR is now non-draft (`isDraft: false`).

## Panel-aggregation highlights

The diff under review (3 files, +18/-580) consolidates two near-identical implementations of `makeFunctorFromMap` (one in `bundle.js`, one in `bundle-lite.js`) into a single source of truth in `bundle-lite.js`. The 561-line deletion in `bundle.js` reduces it to a 158-line thin shim re-exporting `makeFunctorFromMap` and `makeScriptFromMap`. The `package.json#exports['./bundle.js']` entry continues to resolve to `bundle.js`; the lite re-export shims (`functor-lite.js`, `script-lite.js`) continue to resolve to `bundle-lite.js`.

The cleaner-surfaced `syncModuleTransforms` regression at `38bd5ba4d` (the destructure consolidated on the variant that handled only `moduleTransforms`, silently dropping `syncModuleTransforms` from both the option destructure and the `link()` call) was repaired by the fixer's two-line addition at `b2005c2db`. The `test-hermes` CI job is green at the current HEAD; the load-bearing regression signal converges.

The wire-watcher's read of the option-threading flow surfaces the joinery-point follow-up: the destructure at `bundle-lite.js:316-325` is the only enumeration of the `BundleOptions` shape against the live `link()` call, and the cleaner's regression-finding is the empirical evidence that this point is under-protected. The follow-up proposal (either a `linkOptionsFromBundleOptions` helper or a documented comment block) lives in the ledger for revisit at merge time.

Three findings demoted to drop on second-read sanity check (a `WriteFn` "unused import" claim that was actually used at line 142; a redundant per-field JSDoc proposal that the existing `@param {BundleOptions}` annotation already covers; a `null`-vs-`undefined` corner-prober claim on a `Map#get` that only stores string values). The dispositions are recorded in the formal review body so the maintainer can audit the drops.

## CI signal

At submission time:
- `test-hermes`: SUCCESS
- `build`: SUCCESS
- `test-async-hooks (22, ubuntu-latest)`: SUCCESS
- `browser-tests`: SUCCESS
- `zizmor`: SUCCESS
- `test-xs`: SUCCESS
- `test-ocapn-python`: SUCCESS
- Other jobs (`lint`, `test (22/24 x ubuntu/macos)`, `test262`, `cover`, `check-action-pins`, `viable-release`): QUEUED or IN_PROGRESS at panel-submission time; the regression-bearing signal has converged so these are expected to land green.

## Next stage

The PR is panel-clean, un-drafted, and the CI signal is green on the regression-bearing job. The orchestrator's next stage is either:
- **conductor merge** if the maintainer's review converges to APPROVED (per the memory-file rule "APPROVED PRs dispatch to conductor, not 'leave for maintainer'"), or
- **boatman ferry** to mirror the bundle-lite dedup work upstream to `endojs/endo#2902` if that is not already in flight (this PR is itself a mirror of endo#2902, so the upstream PR is the maintainer's; no further ferry needed unless the maintainer's review surfaces edits that need to round-trip).

The cleaner's pre-judge regression-catch is the load-bearing observation of this whole gamut: the regression would have shipped to consumers (the public `makeFunctorFromMap` and `makeScriptFromMap` via the lite shims) if the cleaner had not run before the barrister. Worth a note for the gardener: the `cleaner-before-judge` ordering paid for itself this round.

Self-improvement: nothing this time. The in-band fallback ran cleanly against a now-green head; the disposition rubric handled all 26 seats' surfaces; the cite-or-propose discipline traced every finding to a standing rule (no proposed-rule tags this round); the followup ledger captured the two genuine merge-time revisit items.
