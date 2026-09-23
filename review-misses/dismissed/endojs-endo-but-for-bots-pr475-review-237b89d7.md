---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr475-review-237b89d7
verdict: not-a-miss
category: new-direction
review_at: 2026-08-18T18:26:59Z
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/475#pullrequestreview-4963804507
identity: endojs/endo-but-for-bots#475:review:4963804507:retro
producing_role: builder (endo-byte-array-press campaign)
missed_by: none
severity: minor
---

Top-level review body on #475 (narrow byteArray to a plain frozen Uint8Array).
The maintainer, addressing the immutable-`ArrayBuffer` / freezable-TypedArray
emulation shim, asks for three forward-looking pieces of work plus a workflow
directive: (1) a separately reviewable commit that *fixes* the `toStringTag`
fidelity loss by replacing the emulated `TypedArray.prototype[Symbol.toStringTag]`
getter; (2) elevating `README.md` to the canonical, rigorous documentation of the
`ArrayBuffer.isView` infidelity — the one convention libraries may indefinitely
rely on to tell a genuine view from an emulated one — and revising the repeated
equivalent statements in code comments to briefly note the infidelity and cite the
README section; (3) copying/adapting the suite into test262 style under
hardened-test262 with platform front-matter, so assertions distinguish behaviors
that hold only because the platform lacks native immutable `ArrayBuffer` from those
that survive once native support ships. The body closes with a coordination
directive: park the response until @erights follows up, then dispatch a fixer and a
gauntlet, and retcon only after reviewing the follow-up commits.

Grounds: not an indictment of the garden's review process. The garden DID review
this increment — the `endojs-endo-but-for-bots-pr475-gauntlet-20260819` five-lens
panel ran and correctly judged the change mature and merge-worthy (byteArray
correctness/adversarial, downstream serialization, packaging, coverage, types/docs;
no production must-fix, only nits), and it explicitly validated the `isView`
discriminator as coherent per-platform. What this review asks for is not a defect
the panel let slip but maintainer-prescribed *direction* on a novel, still-evolving
shim, first stated here:

- **`toStringTag` fidelity is a prescribed refinement, not a violated rule.** The
  maintainer's model separates the one *permanent* infidelity to be documented
  (`isView`) from a *fixable* one to be closed (`toStringTag`). Which reflective
  infidelities of a bespoke TypedArray emulation to fix versus indefinitely
  document is specialized shim-fidelity design that no seat brief, skill, or
  standing instruction encodes; a grep of roles/skills/designs finds no lens that
  demonstrably knows "replace the emulated `Symbol.toStringTag` getter." The panel
  passing the shim as coherent was correct on the merits.
- **The README-as-canonical-doc convention is established in this comment.** "Make
  the README the rigorous canonical statement and have comments cite its section"
  is a documentation-organization preference the maintainer sets now; it is not a
  docs-drift or convention violation the `scribe`/`archivist`/`pruner` lens could
  have anticipated, because the convention did not exist to violate.
- **The test262 migration is a remedy prescription, not a newly-missed defect.**
  The underlying platform-blind test assumption *was* caught: it is already the
  recorded `cross-platform-test-coverage` miss (`...-pr475-54294cd3`, missed_by
  engine-realist). This review prescribes a *structural form* for the fix — port to
  hardened-test262 with platform annotations so tests self-declare which engine
  reality they assume. Prescribing the shape of a fix is new direction; the defect
  it addresses is already in the corpus, so re-recording it as a fresh miss would
  double-count.
- **The park/fixer/gauntlet/retcon lines are workflow coordination**, not review
  content, and were handled correctly by the primary.

No false-resolution discrepancy to report: the primary (`...-review-237b89d7`)
honored the "park the response" directive rather than acting, and durably parked a
successor, `endojs-endo-but-for-bots-pr475-review-237b89d7-followup`, which exists
on `origin/journal2` (`jobs/plan/`) carrying the full checklist gated on @erights's
follow-up. The deliverable the primary claimed genuinely exists in the world.
