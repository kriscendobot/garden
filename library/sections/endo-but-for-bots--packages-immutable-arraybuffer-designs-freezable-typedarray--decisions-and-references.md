---
title: Decisions and references
source: packages/immutable-arraybuffer/designs/freezable-typedarray.md
source_repo: endojs/endo-but-for-bots
source_branch: feat/narrow-bytearray-to-uint8
source_commit: c8007ce9c9f7e9dad2d129f4586ae0cb8fecef97
source_pr: endojs/endo-but-for-bots#475
source_pr_state: open
source_date: 2026-08-25
source_authors: [Kriscendo Bot]
ingested: 2026-08-27
ingested_by: scholar
topics: [hardened-javascript]
status: current
notes: Unreviewed archive captured at maintainer direction before deletion from the PR.
---

> Abstract: Records sequencing, document-structure, and tag-fidelity decisions plus the proposal, issue, PR, and test references that motivated the design.

## Decisions

Three framing questions on the original draft were resolved by
erights on PR #449
([issuecomment-4735477238](https://github.com/endojs/endo-but-for-bots/issues/comments/4735477238),
2026-06-17).
This section records the resolutions so a future reader does not have
to reconstruct them from PR thread history.

### Decision 1: "Delayed" means sequencing of PRs (confirmed)

erights confirmed the researcher's hypothesis: the "delayed freezable
TypedArray emulation" phrasing is a *sequencing* word, not a
runtime-lazy semantic.
A follow-up PR that *follows* PR #435's merge and *delays* the
TypedArray-side work to its own design and builder cycle is what was
asked for.
Freezable-TypedArray-ness is *constructor-time-determined by the
backing buffer's immutability*; there is no `view.freeze()` or
`view.toImmutable()` API and no runtime detection that flips the
view's mode after construction.
The two alternative readings the researcher ruled out (a lazy
`view.freeze()` / `view.toImmutable()` API; a "delayed install" /
detect-then-skip framing already decided by PR #435) are accordingly
out of scope.

### Decision 2: Two design files with parallel naming (confirmed)

erights confirmed the sibling-files shape and asked for parallel
naming.
Both designs now sit at:

- `packages/immutable-arraybuffer/designs/immutable-arraybuffer.md`
  (PR #435's design; renamed from the generic `DESIGN.md` on this
  PR's branch as part of this resolution).
- `packages/immutable-arraybuffer/designs/freezable-typedarray.md`
  (this design).

The rename uses `git mv` so the immutable-arraybuffer design's file
history is preserved.
The alternative shape (extending PR #435's `DESIGN.md` with a
*"Phase 2: TypedArray-side"* section) is ruled out: keeping the two
designs in separate files avoids merge conflicts on future
amendments and keeps each document within the *Length: aim for 1 to
3 screens* guideline in `roles/designer/AGENT.md` section *Operating norms*.

### Decision 3: `[Symbol.toStringTag]`: defer to the genuine tag (confirmed)

erights chose option (b): *"(b) is best.
It does have the hazard you mention, but I'm happy not to add
complexity to avoid it until we find out if it is an actual
problem."*

The shim therefore does **not** install
`[Symbol.toStringTag] = 'FreezableTypedArray'` on the emulated
wrapper, and does not replace the genuine `this`-sensitive
`%TypedArrayPrototype%[Symbol.toStringTag]` getter.
Because that getter reads the receiver's `[[TypedArrayName]]` slot,
which the plain-object wrapper lacks, it returns `undefined` for the
wrapper, so `Object.prototype.toString.call(view)` reads as
`'[object Object]'` — a fidelity loss relative to a genuine view's
`'[object Uint8Array]'`. See section *`[Symbol.toStringTag]`* above for
the client-contract consequences and the pin test that guards them.
This deliberately diverges from PR #435's ArrayBuffer-side
post-departure recovery (which installed
`'emulated immutable ArrayBuffer'` as an own-property on each emulated
immutable buffer).

The risk acknowledged in erights's reply (a downstream consumer like
`concordance` routing on `'[object Uint8Array]'` and treating it as a
license to mutate or to call `Buffer.from`) is real but not blocking.
The builder runs the same cross-package consumer sweep PR #435 used
(per *Test plan* section *Cross-package consumer touchpoints*, against
`@endo/pass-style` and `@endo/marshal`).
If the sweep surfaces a concrete regression, the builder escalates
back to the maintainer rather than installing the tag unilaterally;
adding the own-property tag is a small, reversible follow-up if it
ever becomes necessary.

The experiment branch's original shape installs the tag on the
would-be intermediate prototype; that install is dropped during the
post-#435 translation.

## References

- [erights's "delayed freezable TypedArray emulation" comment on PR #435](https://github.com/endojs/endo-but-for-bots/pull/435)
  (2026-06-17T10:55Z): the framing this document expands.
- [PR #435 `designs/immutable-arraybuffer.md`](https://github.com/endojs/endo-but-for-bots/pull/435/files)
  (renamed from `DESIGN.md` on this PR's branch per *Decisions* section 2):
  the drop-the-pseudo-prototype shape this design adopts on the
  TypedArray side.
  Specifically the section *Out of scope* names the work this PR
  does (quoting the "TypedArray-side analog (drop
  `%FreezableTypedArrayPrototype%` similarly), separate PR, separate
  design" clause).
- [erights's resolution of open questions 1, 2, 3 on PR #449](https://github.com/endojs/endo-but-for-bots/issues/comments/4735477238)
  (2026-06-17): the comment that pinned the sibling-files shape, the
  parallel-naming convention, and option (b) on the
  `[Symbol.toStringTag]` decision.
  Recorded in *Decisions* above.
- The experiment branch
  `experiment/no-spackle-immutable-arraybuffer-417`
  (origin remote, head `1ef6c174d` plus four review-response
  fixups): the working prototype this PR translates.
  Foundational commits: `721c68a3` (initial freezable-typedarray pony
  scaffolding), `e02ec0d0` (shim install body), `1ef6c174`
  (shim-level tests).
- [TC39 *Immutable ArrayBuffer* proposal](https://github.com/tc39/proposal-immutable-arraybuffer)
  (Stage 2.7 as of 2026-06): the proposal text that includes the
  "A `DataView` or `TypedArray` using an immutable buffer as its
  backing store can be frozen and immutable" guarantee this PR
  realises at the shim layer.
- README.md *Caveats* section: the existing caveat "Perhaps follow-on
  shims might modify `DataView` and `TypedArray` to emulate that as
  well, but that is hard and beyond the ambition of this ponyfill +
  shim" is the readme-side anchor; this PR rewrites that caveat to
  point at the new section.

Source: [freezable-typedarray.md](https://github.com/endojs/endo-but-for-bots/blob/c8007ce9c9f7e9dad2d129f4586ae0cb8fecef97/packages/immutable-arraybuffer/designs/freezable-typedarray.md) at PR head `c8007ce9` (unreviewed archive).
