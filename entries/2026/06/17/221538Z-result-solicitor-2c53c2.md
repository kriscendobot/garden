---
ts: 2026-06-17T22:15:38Z
kind: result
role: solicitor
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
worktree: dispatches/solicitor--2c53c2/project
prs:
  - repo: endojs/endo-but-for-bots
    pr: 449
    role: target
refs:
  - entries/2026/06/17/220800Z-dispatch-solicitor-2c53c2.md
  - entries/2026/06/17/212643Z-result-solicitor-365835.md
  - entries/2026/06/17/214221Z-result-fixer-a58c91.md
  - entries/2026/06/17/220515Z-result-fixer-d92657.md
next: fixer
---

# Solicitor 2c53c2 round 2 design panel on PR #449

## Pre-dispatch state check

`gh pr view 449 -R endojs/endo-but-for-bots --json state,isDraft,mergedAt`
returned `state=OPEN, isDraft=true, mergedAt=null`. PR is fair game
for round-2 panel. Head: `ba4703bd5` (fixer d92657's two commits on
top of fixer a58c91's five commits on top of round-1 head `ce6108477`).

## Panel-hints output

`bash garden/skills/panel-hints/panel-hints.sh --base origin/master-4a04d07`
emitted the same misclassification as round 1: `Panel-kind: code-panel`
because two `.js` files
(`packages/immutable-arraybuffer/src/lib.js` and
`packages/immutable-arraybuffer/test/shim-amplifier.test.js`) appear
in the diff. Inspection confirms both are one-line edits substituting
`designs/immutable-arraybuffer.md` for `DESIGN.md` in JSDoc / test
comment references (the rename per fixer d92657's structural reorg).
The substantive diff is three design documents:
`packages/immutable-arraybuffer/designs/freezable-typedarray.md`
(952 lines; up from 718 lines round 1 with new *Background*, the
two *view[0]* worked examples, and the *Future adapter withdrawal
from `@endo/bytes`* sub-section), `designs/immutable-arraybuffer.md`
(599 lines; renamed from package-rooted `DESIGN-immutable-arraybuffer.md`
which itself was renamed from `DESIGN.md`; content unchanged from
round 1), and the new `designs/README.md` index (40 lines).

Solicitor judgment overrides the script per the script's own
"strong default, not a constraint" rule, and the dispatch brief
explicitly framed this as design-only.

Full panel-hints output (same as round 1, recorded for the audit
trail):

```
Panel-kind: code-panel

Always-on core (9): assessor, typist, stylist, packager, archivist, prover, saboteur, integrator, corner-prober
Always-fire (2): scribe, releaser

Path-triggered (2): fast-checker, pruner
  fast-checker  packages/immutable-arraybuffer/test/shim-amplifier.test.js
  pruner  packages/immutable-arraybuffer/designs/README.md (+35 lines)

Content-triggered (5): engine-realist, purist, spec-keeper, warden, wire-watcher
  engine-realist  matched: WeakMap
  purist  matched: Object.freeze(
  spec-keeper  matched: shim
  warden  matched: __proto__
  wire-watcher  matched: retire

Cross-panel (2): copyeditor, pedant
  copyeditor  packages/immutable-arraybuffer/designs/README.md (+35 lines outside designs/)
  pedant  packages/immutable-arraybuffer/designs/README.md (+35 lines outside designs/)

Suppressed (8): benchmarker, breaker, changeset-auditor, curator, gateway, migrator, surfacer, locksmith

Recommended total: 20 of 26 code-panel seats (+ 2 cross-panel).
```

Same `panel-hints.sh` open question as round 1: the script's
panel-kind discriminator (`*.md under designs/`) does not match the
endo layout (`packages/<name>/designs/*.md`). Round 1 filed this as
a self-improvement note; reaffirming here.

## Panel composition and execution mode

- **Panel kind:** design-panel (seven seats, by solicitor override).
- **Panel execution:** in-band-fallback (no `Agent` tool in scope;
  the only deferred tools surfaced by `ToolSearch` are
  `EnterWorktree`, `ExitWorktree`, `Monitor`, `NotebookEdit`,
  `TaskStop`, `WebFetch`, `WebSearch`, none of which is `Agent` or
  `Task`). Each of the seven seats' per-juror block was written one
  at a time per the in-band procedure, bounded by its role file
  before the next.
- **Seats dispatched:** critic, skeptic, decomplector, ergonomist,
  copyeditor, pedant, novice. All seven blocks present in the
  submitted review body.

## Verdict

**request-changes**, submitted as `--comment` because the PR is
self-authored (kriscendobot) and GitHub blocks `--request-changes`
on self-authored PRs. Body carries the verdict and a *Must-fix
before merge* heading so the dispatch matrix can key on it.

### Disposition counts

| Disposition         | Count |
| ------------------- | ----- |
| `must-fix-loop`     | 2     |
| `summary-fix`       | 12    |
| `follow-up`         | 0     |
| `acknowledge`       | 7     |
| `drop`              | 0     |
| **Total findings**  | **21**|

Round 1 had 4 must-fix-loop + 13 summary-fix + 2 follow-up + 2
acknowledge = 21 findings. Round 2 likewise has 21 findings with the
loop count dropping from 4 to 2 (and a strong acknowledge column
confirming round-1 work landed cleanly). The two new must-fix items
are not round-1 carryover; they are net-new from the round-2 erights
ask `r3431666901` (permits.js delta unspecified) and the round-2
introduction of the *Future adapter withdrawal from `@endo/bytes`*
sub-section (withdrawal scope undefined).

### Per-seat verdicts

| Seat         | Verdict          | Must-fix-loop | Summary-fix | Follow-up | Ack |
| ------------ | ---------------- | -------------:| -----------:| ---------:| ---:|
| critic       | request-changes  |             1 |           1 |         0 |   1 |
| skeptic      | request-changes  |             1 |           1 |         0 |   1 |
| decomplector | comment-only     |             0 |           1 |         0 |   1 |
| ergonomist   | comment-only     |             0 |           1 |         0 |   1 |
| copyeditor   | comment-only     |             0 |           2 |         0 |   1 |
| pedant       | comment-only     |             0 |           2 |         0 |   1 |
| novice       | comment-only     |             0 |           2 |         0 |   1 |

Two seats (novice, ergonomist) flipped from request-changes to
comment-only because their round-1 must-fix items landed cleanly.

### Must-fix-loop items (drive the loop)

1. **[critic]** `permits.js` delta needs to be spelled out (round-2
   erights ask `r3431666901`). Either inline a before/after snippet
   for the relevant `permits.js` block or add a one-paragraph
   *permits.js delta* sub-section.
   [rule: skills/verify-upstream-state-before-pinning/SKILL.md]
2. **[skeptic]** *Future adapter withdrawal from `@endo/bytes`*
   scope is undefined. Either name one or two adapter functions
   whose withdrawal is anticipated, or rephrase the paragraph to
   defer the enumeration to the withdrawal PR's design.
   [rule: skills/regression-evidence/SKILL.md]

### Additional inline asks to address in the same fixer round

Two round-2 erights asks (`r3431690105`, `r3431697346`) that fixer
d92657 did not enumerate are already addressed in substance by fixer
a58c91 commit `aab2af75d`. The next fixer dispatch should send
inline confirmation replies on both threads so erights sees that the
asks landed by the prior round rather than being silently ignored.
The aggregated review body names both threads explicitly under the
*Additional inline asks to address in the same fixer round* section.

## Review URL

https://github.com/endojs/endo-but-for-bots/pull/449#pullrequestreview-4520012627

Submitted 2026-06-17T22:15:24Z by kriscendobot, state COMMENTED.

## Post-loop actions

This is a **non-terminating round** (2 must-fix-loop items). Per the
solicitor norm:

- summary-fix bundle: **not posted this round** (waits for the
  terminating round to bundle accumulated summary-fix items;
  round-1's 13 items remain accumulated; round-2 adds 12 for a
  running total around 25, which is large but bundling discipline
  defers the post until termination).
- followup ledger: **not appended this round** (waits for the
  terminating round; round-1's 2 items remain on the deferred list).
- gardener proposed-rule message: **not written this round** (one
  new `[proposed-rule]` tag this round from skeptic, accumulating
  with round-1's two from skeptic and decomplector for the
  terminating-round write). The new proposal:
  - skeptic: *"design documents that defer cross-package work to a
    follow-up should name the tracking issue or note 'to be filed'"*
- un-draft: **not run this round** (loop continues).

## Recommended next stage

`next: fixer` for round-3 design-doc loop. Brief the fixer with the
two must-fix-loop items plus the two confirmation-reply threads
(r3431690105, r3431697346). The fixer's edits to the design document
remain design content, so the next panel round on the addressing
push is still a solicitor dispatch (per *Loop until terminating* on
`roles/solicitor/AGENT.md`).

Self-improvement: round 1 already filed the `panel-hints.sh`
panel-kind discriminator gap (the script looks for `designs/*.md`
under the project root; the endo layout puts designs under
`packages/<name>/designs/`). Reaffirming the gap here as it bit a
second time on the same PR. The gardener could pick this up; the
two proposed fixes (widen the path glob to also match
`**/designs/**/*.md` or `**/DESIGN*.md`, and/or treat a `.js` edit
whose diff is purely a comment-string substitution as inert for
panel-kind purposes) both remain valid. The cite-or-propose
discipline's `[proposed-rule]` channel is the right vehicle for the
prose proposal; the script fix is gardener work.
