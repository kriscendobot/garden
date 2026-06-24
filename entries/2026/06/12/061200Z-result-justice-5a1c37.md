---
ts: 2026-06-12T06:12:00Z
kind: result
role: justice
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
worktree: dispatches/justice--5a1c37/project
prs:
  - https://github.com/endojs/endo-but-for-bots/pull/438
refs:
  - entries/2026/06/12/060500Z-result-fixer-6abce3.md
  - entries/2026/06/12/060000Z-dispatch-fixer-6abce3.md
  - entries/2026/06/12/055700Z-result-barrister-821970.md
  - entries/2026/06/12/053500Z-dispatch-barrister-7d0508.md
  - https://github.com/endojs/endo-but-for-bots/pull/438#pullrequestreview-4482896738
  - https://github.com/endojs/endo-but-for-bots/pull/438#pullrequestreview-4482982987
---

# result: justice — round-2 code panel on #438 (clean; PR stays DRAFT pending maintainer routing)

Re-run of the twenty-six-seat code panel on the tsgo migration draft
PR #438 after fixer `6abce3` addressed the two `must-fix-loop` items
and the one `summary-fix` from barrister `821970`'s first-round
verdict. The panel returns clean; per the dispatch brief the PR
stays DRAFT pending the maintainer's routing call on Gap 1 (the
tsgo strict-mode JSDoc cascade across 39 of 49 packages) and Gap 2
(the tsgo Go-runtime panic on `typecheck-all`).

## Pre-dispatch state check

`gh pr view 438 -R endojs/endo-but-for-bots --json state,isDraft,mergedAt,headRefOid`:
`state=OPEN`, `isDraft=true`, `mergedAt=null`, `headRefOid=a619bea05303bff62320e12ea37c87a9089df682`.
Proceeded.

## Panel composition

`panel-hints.sh --base 4dc641a27` (barrister-head, not master) on
the docs-only delta to `AGENTS.md` recommended 12 of 26 seats:

- Always-on core (9): assessor, typist, stylist, packager, archivist,
  prover, saboteur, integrator, corner-prober.
- Always-fire (2): scribe, releaser.
- Path-triggered (1): breaker (false-positive on AGENTS.md substring;
  delta does not touch those lines).
- Suppressed (14): benchmarker, changeset-auditor, curator,
  fast-checker, gateway, migrator, pruner, surfacer, engine-realist,
  locksmith, purist, spec-keeper, warden, wire-watcher, copyeditor,
  pedant.

Justice-side overrides:

- Both round-1 must-fix-loop raisers (stylist for MFL-1, scribe for
  MFL-2) are in the recommended set; no addition needed.
- No removals. The breaker false-positive is recorded as such in
  its per-juror block; the seat fires for transparency.
- The smaller-than-round-1 seat count (12 vs round 1's 17) reflects
  the much smaller delta (35-line AGENTS.md docs-only change vs the
  7-commit scaffold). Round 1's content-triggered seats
  (`benchmarker`, `gateway`, `migrator`, `wire-watcher`, `spec-keeper`)
  did not re-fire on the docs-only delta; this is per the justice
  norm of running panel-hints against the round's delta rather than
  the cumulative diff.

Final composition: 12 seats.

## Execution mode

Panel kind: code-panel. Panel execution: **in-band-fallback**. The
`Agent` tool was not in scope for this dispatch; each seat ran as
a single in-band block per `skills/panel-review/SKILL.md` §
In-band fallback. `@copilot` fire-and-forget reviewer-add ran
alongside.

## Closure of round-1 items (verified)

1. **MFL-1 (`AGENTS.md:110` em-dash)**: closed at SHA `9dc8128c9`
   (`docs(agents): rewrite tsgo em-dash in Testing section`).
   Em-dash replaced by comma; verified via
   `grep -nP '\xe2\x80\x94' AGENTS.md` returns no match. Stylist
   verdict: approve.
2. **MFL-2 (`AGENTS.md:17-43` sentence-per-line)**: closed at SHA
   `a619bea05` (`docs(agents): one sentence per line in new tsgo
   section`). Two prose paragraphs split onto separate physical
   lines; three Notes bullets use continuation-line form;
   multi-sentence table cells use `<br>` to honor the discipline
   without breaking table rendering; `typecheck-packages` Why cell
   tightened to fit one sentence per line. Scribe verdict: approve.
3. **Summary-fix (PR body `pre.js`/`@ts-nocheck` narrowing)**:
   closed via `gh pr edit --body-file`. Item 2 of *Design
   departures and gaps* now states correctly that only `pre.js`
   carries `// @ts-nocheck`; `post.js`, `commit.js`, and
   `commit-debug.js` do not and would be type-checked under
   `typecheck-all` once the Gap 2 panic is resolved. Matches
   ground truth in the worktree. Assessor confirmed against the
   narrowed framing.

## Disposition counts

- `must-fix-loop`: 0
- `summary-fix`: 0
- `follow-up`: 0 (round-1's three follow-up items remain
  orchestrator-owned per the barrister's note; this justice run
  does not introduce new ones)
- `acknowledge`: 2
- `drop`: 0

## Acknowledge dispositions

1. **PR-body Material gap framing**. The narrowed `@ts-nocheck`
   claim and the three-option enumeration on each Material gap
   (Gap 1: cost-favored option (a) root-cause JSDoc fix vs option
   (b) documented exclusion vs option (c) `continue-on-error`;
   Gap 2: option (c) yarn `resolutions` hold-back paired with an
   upstream bisect) preserve the routing decision's load-bearing
   shape. Assessor noted; no work warranted. [rule:
   `skills/panel-review/SKILL.md` § Aggregation]
2. **No changeset on this PR**. The work is internal tooling
   (compiler swap, lockfile churn, AGENTS.md doc). Releaser
   confirmed no upgrading-user surface; the `changeset-discipline`
   skill's scope-by-package heuristic answers no. [rule:
   `skills/changeset-discipline/SKILL.md` § scope-by-package]

## CI status

CI run [27397891342](https://github.com/endojs/endo-but-for-bots/actions/runs/27397891342):

- `lint` (contains `typecheck-all` and `typecheck-packages`):
  **fail** by design. `Run yarn lint` passed; `Run yarn
  typecheck-all` failed (the documented Gap 2 Go-runtime panic);
  `Run yarn typecheck-packages` was skipped due to fail-fast on
  the prior step. This is the documented load-bearing signal to
  the maintainer.
- `build`, `cover`, `check-action-pins`, `test-hermes`,
  `test-ocapn-guile-interop`, `test-ocapn-python`, `test-xs`,
  `test262 (22.x, ubuntu-latest)`, `test262 (24.x, ubuntu-latest)`,
  `viable-release`, `zizmor`: pass.
- `test (22.x, 24.x; ubuntu/macos)`: pending at review time
  (orthogonal to the documented gaps).

`typecheck-all` and `typecheck-packages` remain RED per design;
this is the PR's load-bearing signal to the maintainer that a
routing decision is pending.

## Formal review submission

Submitted as `--comment` via:

```sh
gh pr review 438 -R endojs/endo-but-for-bots --comment --body-file /tmp/justice-5a1c37/panel.md
```

Review URL:
<https://github.com/endojs/endo-but-for-bots/pull/438#pullrequestreview-4482982987>.

`--request-changes` was unavailable (GitHub blocks it on
self-authored PRs; the reviewing identity `kriscendobot` is also
the PR author). `--approve` was inappropriate because two
`acknowledge`d Material gaps remain pending the maintainer's
routing call. `--comment` carries the clean round-2 verdict and
the closure confirmations without forcing un-draft.

`@copilot` reviewer-add fired alongside (idempotent re-request on
the new head).

## Loop termination

The panel terminates clean. No `must-fix-loop` dispositions
remain. The two `acknowledge`d Material gaps from round 1
(Gap 1: tsgo strict-mode JSDoc cascade; Gap 2: tsgo Go-runtime
panic on `typecheck-all`) are the maintainer's routing call and
do not block panel termination on their own.

## PR-state contract: DRAFT pending maintainer routing

Per the dispatch brief: **the PR stays DRAFT**. The justice does
**not** un-draft, does **not** push, does **not** re-request
review, and does **not** post a summary-fix job (none needed).
The standard `gh pr ready` post-loop action is suppressed because
the two routing decisions are pre-conditions for un-draft per the
PR body's *Design departures and gaps* enumeration and per the
brief.

## Post-loop actions

| Action | Status |
| --- | --- |
| Submit disposition-tagged review | done (`--comment`; review 4482982987) |
| Post `summary-fix` job | skipped (no summary-fix items this round) |
| Append followup ledger | skipped (no new follow-up items; round-1 three items remain orchestrator-owned per barrister's framing) |
| Write gardener proposed-rule message | skipped (no proposed-rule findings this round) |
| Dispatch appellate | skipped (orchestrator policy on this stage was not invoked; routing-pending state pre-empts appellate's purpose) |
| `gh pr ready 438` | suppressed by brief; PR stays DRAFT |

## Recommended next stage

**Stalled on maintainer routing**. The gamut stalls until the
maintainer routes on:

- **Gap 1 (tsgo strict-mode JSDoc cascade, 39 of 49 packages)**:
  pick (a) root-cause JSDoc fix in `@endo/harden`, `@endo/pass-style`,
  `@endo/eventual-send` then re-survey; OR (b) staged exclusion list
  for the cascade; OR (c) `continue-on-error` on the `typecheck-all`
  / `typecheck-packages` CI steps. Panel's round-1 cost-to-clear
  preference: (a). Maintainer's call.
- **Gap 2 (tsgo Go-runtime panic on `typecheck-all`)**: pick (a)
  wait for upstream fix; OR (b) reduce `typecheck-all`'s scope; OR
  (c) yarn `resolutions` hold-back to a known-good earlier
  nightly. Panel's round-1 preference: (c) paired with an upstream
  bisect. Maintainer's call.

The orchestrator records the gamut as stalled and parks #438 on
the maintainer-routing dashboard until either routing call is
made. When the maintainer routes, a fixer dispatch on the routing
direction lands; if the routing collapses the CI gates, the
justice re-runs once more; otherwise the routing implies a final
fixer + barrister pass on whichever code change implements the
decision before the gamut un-drafts.

Self-improvement: nothing this time.
