---
ts: 2026-06-17T22:44:00Z
kind: result
role: solicitor
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
prs:
  - repo: endojs/endo-but-for-bots
    pr: 449
    role: target
next: appellate
refs:
  - entries/2026/06/17/220800Z-dispatch-solicitor-2c53c2.md
  - entries/2026/06/17/221538Z-result-solicitor-2c53c2.md
  - entries/2026/06/17/212643Z-result-solicitor-365835.md
---

# Solicitor d78ca1 round 3 design panel on PR #449

## Pre-dispatch state check

`gh pr view 449 -R endojs/endo-but-for-bots --json state,isDraft,mergedAt`
returned `state=OPEN, isDraft=true, mergedAt=null`. PR is fair game
for round-3 panel. Head: `f16f143bc` (the three fixer commits since
round 2: `cc55ec895` + liaison-direct reply + `f16f143bc`).

## Panel-hints output

`bash garden/skills/panel-hints/panel-hints.sh --base origin/master`
emitted the same `Panel-kind: code-panel` misclassification as rounds
1 and 2 (the two `.js` files in the diff are purely reference-string
renames; the worktree HEAD at dispatch is `d8b8a93fb`, not the PR's
remote head `f16f143bc`, so the `designs/` subdirectory structure is
not yet visible to the script). The solicitor's judgment overrides per
the script's strong-default-not-a-constraint rule; the dispatch brief
explicitly framed this as design-only for the third consecutive round.

Full panel-hints output:
```
Panel-kind: code-panel

Always-on core (9): assessor, typist, stylist, packager, archivist, prover, saboteur, integrator, corner-prober
Always-fire (2): scribe, releaser

Path-triggered (1): pruner
  pruner  packages/immutable-arraybuffer/DESIGN-freezable-typedarray.md (+591 lines)

Content-triggered (5): engine-realist, purist, spec-keeper, warden, wire-watcher
  engine-realist  matched: WeakMap
  purist  matched: Object.freeze(
  spec-keeper  matched: shim
  warden  matched: __proto__
  wire-watcher  matched: retire

Cross-panel (2): copyeditor, pedant
  copyeditor  packages/immutable-arraybuffer/DESIGN-freezable-typedarray.md (+591 lines outside designs/)
  pedant  packages/immutable-arraybuffer/DESIGN-freezable-typedarray.md (+591 lines outside designs/)

Suppressed (9): benchmarker, breaker, changeset-auditor, curator, fast-checker, gateway, migrator, surfacer, locksmith

Recommended total: 19 of 26 code-panel seats (+ 2 cross-panel).
```

The same `panel-hints.sh` gap noted in rounds 1 and 2 recurs: the
script's panel-kind discriminator does not match the endo layout
(`packages/<name>/designs/*.md`). Third consecutive recurrence on the
same PR; the gardener should pick up the self-improvement note from
round 1.

## Checklist verification

- **permits.js delta sub-section:** Landed in `cc55ec895`. The
  `#### permits.js delta` sub-section (line 387 onward on `f16f143bc`)
  directly answers erights's r3431666901 question with the existing
  `buffer: getter` entry, an explanation of getter-to-getter and
  fn-to-fn coverage, and the no-new-row conclusion.
- **@endo/bytes adapter withdrawal scope:** Landed in `cc55ec895`.
  The `#### Future adapter withdrawal from @endo/bytes` sub-section
  names `bytesToImmutable` (from `packages/bytes/src/to-immutable.js`)
  and `bytesFromImmutable` (from `packages/bytes/src/from-immutable.js`)
  by name with source paths and explains the direct-construction
  alternative.
- **Table row at line 143:** Changed in `f16f143bc`. Now reads
  `view[0] = 42; view.at(0)` with result `0`, replacing the prior
  split. `view.at(0)` always delegates to the hidden genuine TypedArray,
  demonstrating the buffer invariant without depending on frozen state.
- **Inline erights threads r3431819321 / r3431825665 / r3431832085:**
  r3431819321 (erights questions analysis) and r3431825665 (erights
  retracts) were handled by the liaison-direct reply at 22:26Z. The
  r3431832085 ask (use `view.at(0)` in the table) was addressed in
  `f16f143bc`. No design-doc follow-up required.

## Panel composition and execution mode

- **Panel kind:** design-panel (seven seats, by solicitor override).
- **Panel execution:** in-band-fallback (no `Agent` tool in scope;
  `ToolSearch` surfaced `EnterWorktree`, `ExitWorktree`, `Monitor`,
  `NotebookEdit`, `TaskStop`, `WebFetch`, `WebSearch` as deferred
  tools; no `Agent` or `Task` tool available).
- **Seats dispatched:** critic, skeptic, decomplector, ergonomist,
  copyeditor, pedant, novice. All seven blocks written one at a time,
  each bounded by its role file.

## Verdict

**comment-only** (zero `must-fix-loop` items). The loop terminates.
Submitted as `--comment` because the PR is self-authored (kriscendobot)
and GitHub blocks `--request-changes` on self-authored PRs.

### Disposition counts

| Disposition         | Count |
| ------------------- | ----- |
| `must-fix-loop`     | 0     |
| `summary-fix`       | 8     |
| `follow-up`         | 0     |
| `acknowledge`       | 16    |
| `drop`              | 0     |
| **Total findings**  | **24**|

### Per-seat verdicts

| Seat         | Verdict      | Must-fix-loop | Summary-fix | Follow-up | Ack |
| ------------ | ------------ | -------------:| -----------:| ---------:| ---:|
| critic       | comment-only |             0 |           1 |         0 |   2 |
| skeptic      | comment-only |             0 |           1 |         0 |   2 |
| decomplector | comment-only |             0 |           1 |         0 |   2 |
| ergonomist   | comment-only |             0 |           1 |         0 |   2 |
| copyeditor   | comment-only |             0 |           2 |         0 |   1 |
| pedant       | comment-only |             0 |           2 |         0 |   1 |
| novice       | comment-only |             0 |           1 |         0 |   2 |

The heading title-case finding (copyeditor + pedant) bundles as one
summary-fix item; net distinct items: 8.

## Review URL

https://github.com/endojs/endo-but-for-bots/pull/449#pullrequestreview-4520138235

Submitted 2026-06-17T22:41:14Z by kriscendobot, state COMMENTED.

## Post-loop actions (terminating round)

1. **Summary-fix job:** posted to `journal/jobs/open/` as
   `20260617T224219Z--350bef--pr-449-design-summary-fix.md`.
   Bundles all three rounds' accumulated summary-fix items
   (17 items, with deduplication reducing to approximately 15
   distinct actions for the fixer).

2. **Follow-up ledger:** created at
   `journal/projects/endo-but-for-bots/followups/endo-but-for-bots--449.md`
   with two round-1 items:
   - Frozen-base refresh discipline (verify post-#435 master
     before the builder's implementation dispatch fires).
   - README caveat language for silent-swallow indexed assignment
     (both non-frozen and frozen cases, using this design's worked
     examples as ready-to-paste prose).

3. **Gardener message:** written at
   `entries/2026/06/17/224332Z-message-solicitor-19ed82.md`
   with three proposed-rule proposals accumulated across rounds 1-3
   (cite spec sections; acknowledge mixed-concern property records;
   name tracking issues or "to be filed" for cross-package deferrals).

4. **Un-draft:** `gh pr ready 449 -R endojs/endo-but-for-bots` ran
   successfully. PR is now marked as ready for review.

## Recommended next stage

`next: appellate`. The loop terminates with zero must-fix-loop items
and 8 summary-fix + 2 follow-up dispositions pending. The orchestrator
may dispatch the appellate to review whether any summary-fix or
follow-up items can be appealed into a different disposition before
the PR enters the maintainer's review queue.

Self-improvement: the `panel-hints.sh` misclassification (design
files under `packages/<name>/designs/` not matched by the
`designs/*.md` glob) has now occurred on the same PR across three
consecutive solicitor rounds. The fix is clear: widen the glob to
also match `**/designs/**/*.md` (or equivalently, update the
`--design-paths` flag default to include the endo layout). The
gardener message at `entries/2026/06/17/224332Z-message-solicitor-19ed82.md`
does not include this (it covers only the proposed-rule proposals);
a separate self-improvement message to the gardener should carry the
script fix. I am flagging it here for the audit trail; the liaison or
steward can forward to the gardener on the next cycle.
