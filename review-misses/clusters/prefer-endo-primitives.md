---
slug: prefer-endo-primitives
category: style-convention
status: closed
count: 9
members:
  - endojs-endo-but-for-bots-pr671-review-9737517c
  - endojs-endo-but-for-bots-pr755-review-a0778b2e
  - endojs-endo-but-for-bots-pr824-review-e4950d9b
  - endojs-endo-but-for-bots-pr836-review-3e0d6210
  - endojs-endo-but-for-bots-pr877-review-1eec395e
  - endojs-endo-but-for-bots-pr882-review-4a754464
  - endojs-endo-but-for-bots-pr1336-review-b8dfc07e
  - kriscendobot-minion.town-pr140-review-8f6d6ac9
  - kriscendobot-minion.town-pr146-review-64a01f1e
prs: [671, 755, 824, 836, 877, 882, 1336, 140, 146]
improvement_job: review-miss-prefer-endo-primitives-round2
improved_by: main2 1f090cba7a7 (round 2: procurer @endo not-a-dependency should-fix, export-index-providers seeded, abort-controller idiom, builder/purist unpublished-upstream rule) + main2 37b04ec909 (round 1: builder @endo-utilities directive, purist reuse axis)
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

**Threshold rationale:** # Round 2 — closed 2026-10-07 (job `review-miss-prefer-endo-primitives-round2`)

Maintainer approved all of round 2 (kriskowal, liaison muster 2026-10-07).

**Reconciliation of the three misses since round 1 (2026-08-04, main2 37b04ec909):**
- endojs/endo-but-for-bots#1336 (`b8dfc07e`, 2026-09-24): copied promise-kit
  helpers. Covered by the build-vs-buy detector (export index + name pass +
  procurer seat, landed 2026-09-24), which postdates the review; the replay in
  `build-vs-buy-probe-test.sh` reports the copy as a strong hit.
- kriscendobot/minion.town#140 (`8f6d6ac9`, 2026-10-01): a raw platform
  `AbortController` where `@endo/cancel` owns cancellation; zero panel rounds ran
  (cluster `builder-pr-gauntlet-bypass`). Round 2 adds idiom row
  `abort-controller` (waived when the file imports `@endo/cancel`) and names
  `@endo/cancel` in the builder catalog.
- kriscendobot/minion.town#146 (`64a01f1e`, 2026-10-02): a vendored TypeScript
  port of the unpublished `@endo/cancel` `makeCancelKit`, approved by two panel
  rounds. Root causes: no `config/export-index-providers` (endo exports never
  indexed for minion.town) and blocked `provider-not-a-dependency` hits silenced.

**Round-2 improvements (main2 1f090cba7a7, journal config):**
- (a) journal `config/export-index-providers` seeded:
  `kriscendobot/minion.town endojs/endo-but-for-bots@llm`. Replaying the
  procurer gate on #146's reviewed head 1258647 (base af7af618) now indexes
  endo-but-for-bots@llm and finds `src/endo/cancel-kit.ts:46 makeCancelKit`.
  Also fixed: `ensure-export-index.sh --providers` now prints
  `<index>=<provider clone>`; both callers had passed provider indexes without
  a readable repo root.
- (b) the procurer maps a blocked `provider-not-a-dependency` hit on an
  `@endo/*` package with a distinctive name to **should-fix** ("add the
  dependency and consume it"; comment-only when waived). The #146 replay yields
  `request-changes` with that finding.
- (c) builder rule and purist juror axis: an unpublished upstream is no license
  to vendor a copy; consume it (dev registry, workspace/file/link, pinned git
  dependency, fix packaging upstream) or block and ask.

Any later miss in this cluster is a recurrence of a closed cluster.
