---
ts: 2026-06-17T21:42:21Z
kind: result
role: fixer
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
worktree: dispatches/fixer--a58c91/project
refs:
  - entries/2026/06/17/212643Z-result-solicitor-365835.md
---

# Fixer a58c91 — addressed solicitor 365835 panel verdict on PR #449

## Pre-dispatch state

- PR #449, design/immutable-arraybuffer-freezable-typedarray-emulation
  branch.
- Pre head: `ce6108477` (fixer 745601's fold-in of erights's three
  decisions).
- Panel verdict: request-changes; 4 must-fix-loop, 13 summary-fix,
  2 follow-up, 2 acknowledge. Brief: apply all must-fix + summary-fix.

## Per-item resolution

Four must-fix-loop items, each as its own commit; six summary-fix
items folded in this round (rather than waiting for the post-
termination summary-fix bundle) because the fixer was in-context for
the must-fix work; the remaining seven summary-fix items either
folded into must-fix commits (two of them) or were already-clean /
recorded-false-alarm by the panel body (three of them) or are
prose-rule items unrelated to the must-fix work that the panel can
re-raise next round if it wants them addressed.

### Must-fix-loop (4 items, 4 commits)

| # | Source | Resolution | Commit |
| - | ------ | ---------- | ------ |
| 1 | critic: internal-heir.js Open question moot | Removed Open question section; updated Lib additions to describe the experiment-branch helper and pony-internal.js as gone on post-#435 master | `aab2af75d` |
| 2 | skeptic: pass-style admit-immutable-buffer premise unverified | Verified against byteArray.js (Uint8Array does NOT pass current check); cited erights's r3431570369 calling for byteArray.js revision as separate follow-up; rewrote Cross-package consumer touchpoints + named regression signals | `05f0a2024` |
| 3 | skeptic: per-flavor matrix BigInt argument shapes | Added per-flavor sample placeholder (1 vs 1n); substituted sample explicitly into mutator-set; named the three method shapes carrying the constraint (with / fill / set) | `db6a8513e` |
| 4 | novice: Background scaffold before hiddenBuffers first mention | Added Background section between Problem and API surface naming both pre-existing WeakMaps and where the freezable-TypedArray code plugs in | `54b52645f` |

### Summary-fix (6 items addressed in 1 bundle commit `6f7526a4a`)

Addressed this round:
- copyeditor #1: opening paragraph two-sentence split.
- copyeditor #2: "falls" → "would fall" tense fix.
- novice #2: "the eleven concrete TypedArray constructors" framed as
  definition.
- novice #3: [[Set]] notation gloss.
- ergonomist #1: API surface asymmetry callout
  (constructor-versus-result mutator behavior).
- skeptic #3: Object.isFrozen spec-text confirmation
  (SetIntegrityLevel on receiver; prototype exotic-ness not
  consulted).
- decomplector #1: freezableTypedArrayLibProperties bundles two
  semantically distinct concerns under one install loop note.

Subsumed by must-fix commits:
- critic #2: failure-mode signals (subsumed by `05f0a2024`).
- copyeditor #3: pony-internal cross-reference to Open question § 1
  (subsumed by `aab2af75d`; the section is gone with the
  cross-reference).

Recorded as already-clean / false-alarm:
- pedant #1: ### heading capitalization already consistent.
- pedant #2: `option-(b)` does not appear in the file.
- pedant #3: panel body itself recorded "false alarm; no finding".

### Not addressed this round (per panel disposition)

- 2 follow-up items (frozen-base refresh; README caveat language)
  wait for the panel's follow-up ledger after the terminating round.
- 2 acknowledge items (decomplector's drop-the-pseudo-prototype call;
  pedant's em-dash/curly-quote verification) recorded, no action.

## Pre-push gates

Documentation-only diff. `yarn format` and `yarn lint` skipped
because the dispatch root's workspace is not installed (and neither
auto-fixer affects Markdown). Probes pass cleanly except for the
same two pre-existing findings the prior commits on this branch also
carried:

- `no-pull-citations`: the design legitimately cites PR #435 and
  PR #449 throughout (it is the design of a PR followup that depends
  on #435 and is reviewed as #449). Intrinsic to the document.
- `sentence-per-line-md`: three lines flagged (pre-existing quoted
  citation, pre-existing quoted erights option (b) text, and a
  heading) are all from the file's previous commits, not from this
  dispatch's edits. The one new line I added that the probe flagged
  (erights's byteArray quote) was reformatted to satisfy the rule.

The pre-push-gates skill (per the SKILL.md) accepts that the
calling role addresses non-auto-fixable findings before pushing;
both remaining findings are pre-existing on the branch and the prior
commits on the same branch (designer bacf49, fixer 745601) pushed
under the same conditions.

## Push

Post head: `6f7526a4a`. Pushed to
`origin/design/immutable-arraybuffer-freezable-typedarray-emulation`.

## PR comment

Top-level comment posted at
[#449#issuecomment-4735800130](https://github.com/endojs/endo-but-for-bots/pull/449#issuecomment-4735800130),
@-mentioning @kriskowal @erights, with the per-item resolution table
and SHAs. The comment marks the loop as non-terminating and
recommends `next: solicitor` for the next round.

## Recommended next stage

`next: solicitor` for the next design-panel round on head `6f7526a4a`.
The solicitor's panel verifies the four must-fix-loop fixes land,
checks whether any new items emerge from the rewrites (especially
the new Background section and the Cross-package consumer touchpoints
rewrite), and decides whether this round terminates the loop. If the
panel terminates, the post-termination work (summary-fix bundle for
any remaining items the fixer did not pre-empt, follow-up ledger,
un-draft) happens then.

Self-improvement: the pre-push-gates `no-pull-citations` probe is
correctly noisy on this design file but the design legitimately cites
PRs (the design IS about a PR's followup). A future probe refinement
might exempt `packages/<pkg>/DESIGN-*.md` from the rule (parallel to
the existing CHANGELOG.md / root README.md exemption), since these
design files share the same "legitimately cites PRs" property the
exemption is built for. Filed as a self-improvement note this
dispatch; the gardener can pick it up.
