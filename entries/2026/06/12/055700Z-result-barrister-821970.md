---
ts: 2026-06-12T05:57:00Z
kind: result
role: barrister
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
worktree: dispatches/barrister--821970/project
prs:
  - https://github.com/endojs/endo-but-for-bots/pull/438
refs:
  - entries/2026/06/12/053500Z-dispatch-barrister-7d0508.md
  - entries/2026/06/12/052621Z-result-builder-4ef77c.md
  - entries/2026/06/12/053300Z-result-cleaner-8a9446.md
  - https://github.com/Agoric/agoric-sdk/pull/12721
  - https://github.com/endojs/endo-but-for-bots/pull/438#pullrequestreview-4482896738
---

# result: barrister — first code panel on #438 (tsgo migration scaffold)

Retry of rate-limited barrister 7d0508. First code-panel round on the
DRAFT PR mirroring [Agoric/agoric-sdk#12721](https://github.com/Agoric/agoric-sdk/pull/12721).

## Pre-dispatch state check

`gh pr view 438 --json state,isDraft,mergedAt`: `state=OPEN`, `isDraft=true`,
`mergedAt=null`. Proceeded with the panel.

## Panel composition

`panel-hints.sh --base origin/master-4a04d07` recommended 16 of 26 seats:

- Always-on core (9): assessor, typist, stylist, packager, archivist,
  prover, saboteur, integrator, corner-prober
- Always-fire (2): scribe, releaser
- Path-triggered (4): benchmarker, breaker, gateway, migrator
- Content-triggered (1): wire-watcher
- Cross-panel (0)
- Suppressed (12): changeset-auditor, curator, fast-checker, pruner,
  surfacer, engine-realist, locksmith, purist, spec-keeper, warden,
  copyeditor, pedant

Barrister-side override: added **spec-keeper** (panel-hints suppressed it
because there is no test or spec surface change, but the "documented
intent" framing of the failing CI gate is itself a spec claim worth
explicit treatment). Final composition: 17 seats. No removals from the
script's fired set.

## Execution mode

Panel kind: code-panel. Panel execution: **in-band-fallback**. The
`Agent` (or `Task`) tool was not in scope; each seat ran as a single
in-band block per `skills/panel-review/SKILL.md` § In-band fallback.
`@copilot` fire-and-forget reviewer add ran alongside.

## Per-juror verdicts

| Seat | Verdict |
| --- | --- |
| assessor | comment-only |
| typist | comment-only |
| stylist | request-changes |
| packager | comment-only |
| archivist | comment-only |
| prover | comment-only |
| saboteur | comment-only |
| integrator | comment-only |
| corner-prober | comment-only |
| scribe | request-changes |
| releaser | comment-only |
| benchmarker | comment-only |
| breaker | comment-only (false-positive trigger) |
| gateway | comment-only |
| migrator | comment-only |
| wire-watcher | comment-only (false-positive trigger) |
| spec-keeper | comment-only |

Two seats raised `request-changes` (stylist on the new em-dash in
AGENTS.md line 110, scribe on new `sentence-per-line-md` violations in
the new AGENTS.md section). The rest were comment-only.

## Disposition counts

- `must-fix-loop`: 2
- `summary-fix`: 1
- `follow-up`: 3
- `acknowledge`: 5
- `drop`: 2

## Must-fix-loop items (fixer brief)

1. `AGENTS.md:110` — new em-dash on the Testing-section bullet "uses
   `tsgo` — TypeScript 7 native preview". Cleaner swept the PR body
   but not the AGENTS.md diff. Rewrite the em-dash as a parenthetical
   or comma per `skills/em-dash-style/SKILL.md`.
2. `AGENTS.md:17-43` (the new "TypeScript Preview (tsgo)" section) —
   multiple new bullets and table-cells pack multiple sentences per
   line, adding new `sentence-per-line-md` violations on top of the
   pre-existing ones. Rewrite each multi-sentence bullet as one
   sentence per line so the pre-push gate's new violations clear.

## Summary-fix items

1. PR body claim "pre.js already has @ts-nocheck so the wildcard
   `include` doesn't pin a check failure on it" is too broad. Verified:
   `packages/lockdown/pre.js` carries `// @ts-nocheck`, but `post.js`,
   `commit.js`, and `commit-debug.js` do **not** and ARE matched by
   `tsconfig.json`'s `include: packages/**/*.js`. Narrow the body claim
   to "`pre.js` carries `@ts-nocheck`; the other three lockdown files
   would be type-checked under `typecheck-all` once the panic is
   resolved".

## Follow-up items (parked; ledger to be appended on the same beat
when the orchestrator routes)

1. Grow a `lint:types` script on `packages/lockdown` so the per-package
   consumer view covers it. Orthogonal to the tsgo migration; the gap
   is pre-existing.
2. Add an apples-to-apples Endo timing-comparison table to the PR body
   (or to AGENTS.md) mirroring upstream #12721's per-package and
   unified speedup table. Optional pre-un-draft, useful post-merge.
3. Bisect the tsgo Go-runtime panic to a specific Endo source file and
   file an upstream issue on `microsoft/typescript-go`. Builder noted
   straightforward follow-up.

## Routing recommendations on the two design departures

**Gap 1 (tsgo strict-mode JSDoc cascade, 39 of 49 packages):** panel
recommends **option (a) Fix the root cause** in `@endo/harden`, then
re-survey. Cost-to-clear ratio is favorable: a small set of root-cause
fixes (the `makeHardener` callback's missing type predicate, plus
`@endo/pass-style` and `@endo/eventual-send` siblings) should clear
most of the 39 failing packages. Residual long-tail, if any, falls
back to a documented exclusion list. Disposition: `acknowledge`. The
maintainer's call is essential; the panel offers an opinion but does
not block the un-draft on it.

**Gap 2 (tsgo crashes on `typecheck-all`, Go runtime panic):** panel
recommends **option (c) Open a yarn `resolutions` for a known-good
earlier nightly** as a short-term workaround, paired with a bisect for
an upstream issue. The unified-check is a long-tail benefit (the
per-package view already covers most of the surface); a tactical
resolutions-hold-back is reversible and the right shape for an
upstream bug. Disposition: `acknowledge`. The maintainer's call is
essential.

## Upstream-mirror fidelity

The 7-commit ladder is a faithful adaptation of upstream #12721's 5
commits, with two deliberate adaptations correctly documented in the
PR body's *Asymmetries* section:

- Endo reuses `tsconfig.json` rather than introducing
  `tsconfig.check.json`. Justified: Endo's `tsconfig.json` already
  plays the role (noEmit + incremental from eslint-base; workspace-graph
  exclusions enumerated).
- Endo has no `tsconfig.quickcheck.json` to drop, so the upstream's
  "drop quickcheck" commit has no analogue.

Endo's CI surface is structurally simpler (one `lint` job, not
segmented into `lint-primary` / `lint-rest`), so both new steps
co-locate in the single `lint` job. Forced by CI shape, not a
regression.

Yarn-lock-separate-commit discipline satisfied: commits 776a26559 and
d238a1bbd are pure `yarn.lock` changes.

All 49 packages with a `lint:types` script carry both the `tsgo
--tsBuildInfoFile tsconfig.tsgo.tsbuildinfo` form and the
`@typescript/native-preview: catalog:dev` devDep. `packages/skel`
template updated to match. `packages/lockdown` correctly left
untouched (pre-existing gap; no `lint:types` script).

## PR body adequacy

Adequate for routing decisions. Three-option enumeration on each
material gap is the right shape; *Asymmetries compared to
agoric-sdk#12721* names the structural differences clearly; *Division
of labor* table mirrors upstream's. One narrowing required per the
summary-fix above (the `pre.js` `@ts-nocheck` claim is too broad).

## CI gate scoping

The new `typecheck-all` and `typecheck-packages` steps fire
unconditionally (no `continue-on-error`), which is the right posture
for surfacing the routing decision to the maintainer. The PR is
honest about the failure mode. The maintainer's routing choice (which
of the three options for each gap) determines whether the CI gate
relaxes (option c on either gap) or stays hard (options a or b). The
PR-state contract: this PR stays DRAFT until both routes are picked.

## Formal review submission

Submitted as `--comment` because GitHub blocks `--request-changes` on
self-authored PRs (PR author `kriscendobot` is the reviewing
identity). The verdict is preserved in the body's *Must-fix-loop*
section; per `skills/panel-review/SKILL.md` § Pitfalls the dispatch
matrix that keys on `reviewDecision` also keys on the *Must-fix-loop*
heading for bot-authored PRs.

Review URL: <https://github.com/endojs/endo-but-for-bots/pull/438#pullrequestreview-4482896738>.

@copilot reviewer add fired alongside.

## Recommended next stage

**fixer** on the two `must-fix-loop` items plus the one `summary-fix`,
all in `AGENTS.md` and the PR body:

1. Rewrite the em-dash on AGENTS.md line 110.
2. Rewrite the new "TypeScript Preview (tsgo)" section bullets and
   table cells as one sentence per line.
3. Narrow the PR-body claim about `packages/lockdown`'s `@ts-nocheck`
   coverage.

After the fixer pushes, the orchestrator dispatches the **justice**
(not the barrister) for the re-run; the justice's brief will include
this round's verdict. The routing decision on the two material design
departures remains the maintainer's; the panel's `acknowledge`
disposition on each means the un-draft is not blocked by the routing
decision itself, only by the must-fix-loop items above and by the
maintainer's call once made. The PR-state contract: stays DRAFT
through the routing decision.

Self-improvement: nothing this time.
