---
slug: prefer-endo-primitives
category: style-convention
status: improvement-dispatched
count: 6
members:
  - endojs-endo-but-for-bots-pr671-review-9737517c
  - endojs-endo-but-for-bots-pr755-review-a0778b2e
  - endojs-endo-but-for-bots-pr824-review-e4950d9b
  - endojs-endo-but-for-bots-pr836-review-3e0d6210
  - endojs-endo-but-for-bots-pr877-review-1eec395e
  - endojs-endo-but-for-bots-pr882-review-4a754464
prs: [671, 755, 824, 836, 877, 882]
improvement_job: review-improve-prefer-endo-primitives
improved_by: main2 37b04ec909: roles/builder/AGENT.md (@endo-utilities directive) + roles/jurors/purist/AGENT.md (reuse-over-reimplementation axis)
---







Freshly-authored code hand-rolls or re-implements a primitive (hex, ascii, bytes, base64, sha256, error assertions) that an existing @endo/* package already provides; no juror seat or gate carries the @endo utility catalog, so the missed reuse reaches the maintainer.

**Threshold rationale:** # Dispatch rationale — cluster `prefer-endo-primitives`

**Floor met:** count=6, prs={671, 755, 824, 836, 877, 882} — K≥3 misses across ≥2
distinct PRs, with a wide margin (five distinct PRs).

**Judgment above the floor — improvement landed (not held):** across six reviews the
maintainer repeatedly asked that freshly-authored code reuse an existing `@endo/*`
primitive rather than hand-roll it — `@endo/sha256` (#671), `@endo/bytes` +
`@endo/errors` (#755, #882), `@endo/hex` + `@endo/ascii` (#824, #836), `@endo/base64`
(#877, incl. a Rust port that should reuse the JS impl via bundling). Two of these
PRs ran a full panel (pr755-gauntlet, pr882-panel) and still let the missed reuse
through; no seat carried the `@endo` utility catalog. This is the same meta-family as
the existing `endo-errors-over-raw-throw` and `named-imports-over-namespace` clusters
(Endo idiom adherence).

**Improvement shipped at the seat + directive tier** (main2 37b04ec909):
- Prevention: `roles/builder/AGENT.md` gains a "reach for an existing `@endo/*`
  utility before hand-rolling a primitive" directive naming the catalog.
- Sensing: `roles/jurors/purist/AGENT.md` gains a "reuse over re-implementation of
  `@endo/*` primitives" inquiry axis.

**Recommended follow-up (not blocking):** a deterministic `pre-push-gates` probe that
scans added code for hand-rolled hex/base64/ascii/hashing signatures and suggests the
`@endo/*` import — the tier-1 mechanization the seat amendment cannot match. Left as a
builder follow-up because a reliable signature catalog is more than a seat edit.
