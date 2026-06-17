---
ts: 2026-06-17T21:26:43Z
kind: result
role: solicitor
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
worktree: dispatches/solicitor--365835/project
refs:
  - entries/2026/06/17/212238Z-dispatch-solicitor-365835.md
  - entries/2026/06/17/211915Z-result-fixer-745601.md
---

# Solicitor 365835 — design panel on PR #449 (round 1)

## Pre-dispatch state check

`gh pr view 449 -R endojs/endo-but-for-bots --json state,isDraft,mergedAt`
returned `state=OPEN, isDraft=true, mergedAt=null`. PR is fair game
for panel. Head: `ce6108477` (fixer 745601's fold-in of erights's
three decisions on top of designer bacf49's two commits).

## Panel-hints output

`bash garden/skills/panel-hints/panel-hints.sh --base origin/master-4a04d07`
emitted `Panel-kind: code-panel` because two `.js` files
(`packages/immutable-arraybuffer/src/lib.js` and
`packages/immutable-arraybuffer/test/shim-amplifier.test.js`) appear in
the diff. Inspection shows both are one-line edits substituting
`DESIGN-immutable-arraybuffer.md` for `DESIGN.md` in JSDoc / test
comment references (the rename per *Decisions* § 2). The substantive
diff is the two design documents
(`DESIGN-freezable-typedarray.md` new at 718 lines;
`DESIGN-immutable-arraybuffer.md` renamed from `DESIGN.md` at 599
lines). Solicitor judgment overrides the script per the script's own
"the script's output is a strong default, not a constraint" rule, and
the dispatch brief explicitly framed this as a design-only PR. Wrote
the design panel; the panel-hints output is recorded here for the
audit trail.

Full panel-hints output:

```
Panel-kind: code-panel

Always-on core (9): assessor, typist, stylist, packager, archivist, prover, saboteur, integrator, corner-prober
Always-fire (2): scribe, releaser

Path-triggered (2): fast-checker, pruner
  fast-checker  packages/immutable-arraybuffer/test/shim-amplifier.test.js
  pruner  packages/immutable-arraybuffer/DESIGN-freezable-typedarray.md (+599 lines)

Content-triggered (5): engine-realist, purist, spec-keeper, warden, wire-watcher
  engine-realist  matched: WeakMap
  purist  matched: Object.freeze(
  spec-keeper  matched: shim
  warden  matched: __proto__
  wire-watcher  matched: retire

Cross-panel (2): copyeditor, pedant
  copyeditor  packages/immutable-arraybuffer/DESIGN-freezable-typedarray.md (+599 lines outside designs/)
  pedant  packages/immutable-arraybuffer/DESIGN-freezable-typedarray.md (+599 lines outside designs/)

Suppressed (8): benchmarker, breaker, changeset-auditor, curator, gateway, migrator, surfacer, locksmith

Recommended total: 20 of 26 code-panel seats (+ 2 cross-panel).
```

Open question for `panel-hints.sh`: a design-only PR whose diff
includes a rename-only `.js` edit should not be misclassified as
code-panel. The script's panel-kind determinator
(`*.md under designs/`) does not match this layout
(`packages/<name>/DESIGN*.md`, not `<project>/designs/`); the
`--design-paths` flag defaults to `designs/`. Worth a self-improvement
flag (see below).

## Panel composition and execution mode

- **Panel kind:** design-panel (seven seats, by solicitor override).
- **Panel execution:** in-band-fallback (no `Agent` tool in scope this
  dispatch; tool-availability probe returned `EnterWorktree` and
  `ExitWorktree` from `ToolSearch` but no `Agent` / `Task`).
- **Seats dispatched:** critic, skeptic, decomplector, ergonomist,
  copyeditor, pedant, novice. All seven blocks written one at a time
  per the in-band procedure, each bounded by its role file before
  moving to the next.

## Verdict

**request-changes**, submitted as `--comment` because the PR is
self-authored (kriscendobot) and GitHub blocks `--request-changes` on
self-authored PRs. Body carries the verdict and a *Must-fix before
merge* heading so the dispatch matrix can key on it.

### Disposition counts

| Disposition         | Count |
| ------------------- | ----- |
| `must-fix-loop`     | 4     |
| `summary-fix`       | 13    |
| `follow-up`         | 2     |
| `acknowledge`       | 2     |
| `drop`              | 0     |
| **Total findings**  | **21**|

### Per-seat verdicts

| Seat         | Verdict          | Must-fix-loop | Summary-fix | Follow-up | Ack |
| ------------ | ---------------- | -------------:| -----------:| ---------:| ---:|
| critic       | request-changes  |             1 |           1 |         1 |   0 |
| skeptic      | request-changes  |             2 |           1 |         0 |   0 |
| decomplector | comment-only     |             0 |           1 |         0 |   1 |
| ergonomist   | comment-only     |             0 |           1 |         1 |   0 |
| copyeditor   | comment-only     |             0 |           3 |         0 |   0 |
| pedant       | comment-only     |             0 |           3 |         0 |   1 |
| novice       | request-changes  |             1 |           2 |         0 |   0 |

### Must-fix-loop items (drive the loop)

1. **[critic]** *Open question* § 1 about `internal-heir.js` is moot
   on post-#435 master (file does not exist); rephrase or remove.
   [rule: skills/verify-upstream-state-before-pinning/SKILL.md]
2. **[skeptic]** Pass-style admit-immutable-buffer premise is
   asserted, not verified; verify or downgrade to explicit risk.
   [rule: skills/regression-evidence/SKILL.md]
3. **[skeptic]** Per-flavor matrix needs BigInt-distinct argument
   shapes for `with`, `fill`, `set`. [rule:
   skills/coverage-driven-testing/SKILL.md]
4. **[novice]** Background scaffold needed before first
   `hiddenBuffers` / `reverseHiddenBuffers` mention. [rule:
   skills/process-documents/SKILL.md]

## Review URL

https://github.com/endojs/endo-but-for-bots/pull/449#pullrequestreview-4519751581

Submitted 2026-06-17T21:26:27Z by kriscendobot, state COMMENTED.

## Post-loop actions

This is a **non-terminating round** (4 must-fix-loop items). Per the
solicitor norm:

- summary-fix bundle: **not posted this round** (waits for the
  terminating round to bundle accumulated summary-fix items).
- followup ledger: **not appended this round** (waits for the
  terminating round per the same bundling discipline).
- gardener proposed-rule message: **not written this round** (two
  `[proposed-rule]` tags raised by skeptic and decomplector; they
  also accumulate to the terminating round). The two proposals:
  - skeptic: *"design documents that defer to a spec for behavior
    should cite the spec section, not just name it"*
  - decomplector: *"when a property record bundles semantically
    distinct concerns under one install loop, the design
    acknowledges the bundling rather than presenting the concerns
    as uniform"*
- un-draft: **not run this round** (loop continues).

## Recommended next stage

`next: fixer` for design-doc loop. Brief the fixer with the four
must-fix-loop items above; the fixer's edits to the design document
remain design content, so the next panel round on the addressing
push is still a solicitor dispatch (per *Loop until terminating*
on `roles/solicitor/AGENT.md`).

Self-improvement: `panel-hints.sh` misclassifies a design-only PR
whose diff includes a rename-only `.js` edit as `code-panel`. The
panel-kind discriminator looks for `*.md` files under `designs/` but
the endo repo's design files live at `packages/<name>/DESIGN*.md`,
not under a top-level `designs/` tree. Two fixes worth proposing to
the gardener: (a) widen the path glob to also match
`**/DESIGN*.md`; (b) treat a `.js` edit whose diff is purely a
JSDoc/comment-string substitution as inert for panel-kind purposes
(harder to encode, may be too clever). Filed as a self-improvement
note this dispatch; the gardener can pick it up.
