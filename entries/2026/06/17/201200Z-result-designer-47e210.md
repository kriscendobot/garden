---
ts: 2026-06-17T20:12:00Z
kind: result
role: designer
host: endolinbot
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
dispatch_root: /home/kris/dispatches/designer--47e210
short_id: 47e210
to: liaison
refs:
  - entries/2026/06/17/195947Z-result-researcher-fe4754.md
  - entries/2026/06/17/200500Z-dispatch-designer-47e210.md
  - projects/endo-but-for-bots/followups/endo-but-for-bots--435.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 449
    role: this
    head_sha: d8b8a93fb7c08bc1e31116842d21caf26cfd82ce
    branch: design/immutable-arraybuffer-freezable-typedarray-emulation
    base: master
    state: OPEN
    draft: true
  - repo: endojs/endo-but-for-bots
    pr: 435
    role: predecessor
    state: MERGED
    merge_commit: 855a8f7bcf23224755deba41cfca387e9186f2e7
---

# result: designer drafted PR #449 for the delayed freezable TypedArray emulation (47e210)

Drafted a single-file design document at
`packages/immutable-arraybuffer/DESIGN-freezable-typedarray.md`
(710 lines, sibling to PR #435's `DESIGN.md`) and opened it as draft
PR #449 against master.
The design captures the TypedArray-side analog of PR #435's
drop-the-pseudo-prototype redesign, per erights's "delayed freezable
TypedArray emulation" comment on PR #435 (2026-06-17T10:55Z).

## Deliverables

- **PR**: <https://github.com/endojs/endo-but-for-bots/pull/449>
- **Branch**: `design/immutable-arraybuffer-freezable-typedarray-emulation`
- **Head SHA**: `d8b8a93fb7c08bc1e31116842d21caf26cfd82ce`
- **Base**: `master` (pre-#435; the design is independent of #435's exact diff)
- **State**: OPEN, DRAFT
- **Author**: kriscendobot
- **Diff**: +710 lines, 1 file (the new design document)

## Design summary

The design covers the eight sections the dispatch asked for:

1. **Problem.** The proposal's TypedArray-can-be-frozen guarantee needs
   a shim layer because the native `T` constructors reject emulated
   immutable ArrayBuffers (or silently coerce them into degraded
   views).
2. **API surface.** After `import '@endo/immutable-arraybuffer/shim.js'`,
   `new T(immutableAB)` yields an emulated freezable wrapper for each
   of the eleven concrete TypedArray flavors; `__proto__` is
   `T.prototype` directly (no intermediate prototype).
3. **Semantics.** Mutator methods throw `TypeError`; indexed assignment
   is silently swallowed (proposal-level constraint); `Object.isFrozen`
   returns `true` after `Object.freeze`; `view.buffer` returns the
   immutable wrapper via `virtualTypedArrayBufferGetter`;
   `[Symbol.toStringTag]` decision deferred to *Open questions* § 3.
4. **Implementation outline.** File table (lib edit, shim edit, three
   new test files, README update, permits entry extension, changeset);
   the lib gains `hiddenTypedArrays`, `amplifyTypedArray`,
   `virtualTypedArrayBufferGetter`, `makePseudoTypedArrayConstructor`,
   `freezableTypedArrayLibProperties`; the shim install replaces each
   of the eleven concrete global TypedArray constructors under PR
   #435's stage-3 detect-then-skip gate.
5. **Test plan.** Lib-level (4 tests translated from experiment),
   shim-level (8 tests translated), per-flavor parameterized matrix
   across all eleven TypedArray flavors, ses-side integration
   (`Object.isFrozen(view) === true` after `lockdown`), cross-package
   consumer sweep against `@endo/pass-style` and `@endo/marshal`.
6. **Scope (depends on #435).** PR #435 must merge before the builder
   fires; the design (this PR) is independent and can be reviewed in
   parallel.
   PR #435 has already merged (commit `855a8f7bc`); the builder can
   fire once the project's frozen-base branch is updated.
7. **Open questions.** Four explicit calls the maintainer (or erights)
   may want to revisit before the builder fires (three primary,
   surfaced in the PR body and `@`-mentioned in the body's question
   block, plus a fourth on `internal-heir.js` inline vs separate that
   the builder defaults on).
8. **Out of scope.** `DataView` emulation (separate follow-up);
   subclass support on the emulated branch; cross-realm; a new
   `%FreezableTypedArrayPrototype%` SES intrinsic (the
   drop-the-pseudo-prototype shape obviates it); `view.freeze()` /
   `view.toImmutable()` API; native engine work.

## Three open questions surfaced in the PR body

1. **Confirm "delayed" = sequencing, not runtime lazy.**
   The design reads erights's "delayed" as a sequencing word per the
   researcher's hypothesis; freezable-TypedArray-ness is
   constructor-time-determined by the backing buffer's immutability.
   Confirmation or correction welcome from @erights before the builder
   fires.
2. **DESIGN.md placement: extend vs sibling.**
   This design lives at `DESIGN-freezable-typedarray.md` as a sibling
   to PR #435's `DESIGN.md` (rationale: design branch descends from
   pre-#435 master where `DESIGN.md` doesn't exist locally; sibling
   avoids rebase conflicts).
   The alternative is to extend #435's `DESIGN.md` with a "Phase 2:
   TypedArray-side" section (one document but longer).
   Maintainer's call.
3. **`[Symbol.toStringTag]` decision parallel to #435.**
   PR #435 restored the tag as an own-property after a regression
   broke 13 ocapn codec tests; the parallel decision on the
   freezable-TypedArray side is (a) match the restoration shape, (b)
   defer to the genuine TypedArray's tag, or (c) install on
   `%TypedArrayPrototype%` (almost certainly wrong).
   Design's working assumption is (a) with a builder-level smoke-test
   against `@endo/pass-style` and `@endo/marshal`; the maintainer or
   @erights may prefer (b).

The PR body @-mentions both @kriskowal and @erights for review.

## Recommended next stage

The standard PR-creation-flow chain for a design-only PR:

1. **cleaner** (typo + comment sweep on the design document).
   The design is 710 lines and was written in one pass; a cleaner
   sweep catches the inevitable rough edges before solicitor sees it.
2. **solicitor** (judge for design work; design panel + fixer-loop).
   The solicitor's design panel reviews the design document for
   internal consistency, scope clarity, and answerability of the open
   questions.
3. **fixer-loop** if the panel returns disposition `follow-up` or
   `summary-fix`.
4. **un-draft** (the solicitor un-drafts on panel termination per
   `roles/solicitor/AGENT.md`).

The design's value as a maintainer-feedback target outweighs running
the full code panel chain on a 710-line markdown file; the solicitor
is the right judge.

**Gating before the builder fires** (separate dispatch chain, after
this design lands):

- PR #435 must have merged onto the active master / frozen-base
  branch (already true as of 2026-06-17T10:54Z).
- This design must have landed (un-drafted by solicitor or accepted by
  the maintainer in the design PR review).
- The three open questions must have explicit resolutions (either
  maintainer review on this PR, or the builder defaults documented
  in the design plus a comment-acknowledged risk).

## Authorizations exercised

Per dispatch prompt: push to
`design/immutable-arraybuffer-freezable-typedarray-emulation`, open
DRAFT PR, top-level comment.
Branch pushed; DRAFT PR opened; no top-level comment posted (the PR
body covers the maintainer-feedback ask, and @-mentions are inline in
the body rather than as a separate comment).

The `@kriskowal` and `@erights` mentions are inside the PR body's
*Three open questions* section; this is the standard shape for a
design PR seeking maintainer input.
Per `journal/projects/endo-but-for-bots/README.md` § Standing
authorizations, the garden's roles may post comments and mentions on
this repo without per-action authorization.

## Self-improvement: nothing this time

The design's structure follows
[`roles/designer/AGENT.md`](../../../roles/designer/AGENT.md) cleanly:
single markdown file, project conventions matched against PR #435's
`DESIGN.md`, mermaid diagram, length within the 1-to-3-screen
guideline modulo the rich open-questions section (the section is
load-bearing because it surfaces the maintainer-decision shape this
PR is for), all dates absolutized, open questions explicit.

The researcher's *Library and project references* section was fully
inlined in the dispatch prompt; the designer's library lookups were
limited to verifying the experiment branch source files matched the
researcher's summary (they did) and confirming PR #435's merge state
(it merged at 10:54Z, 9 hours before the dispatch, but origin/master
has not yet caught up).
No new library writeback this engagement; the researcher's prior
keyword shortcuts (entries 6484-6508) covered the lookup needs.
