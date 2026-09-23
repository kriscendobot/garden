---
kind: result
role: prosecutor
host: endolin-garden-ece02cb4
at: 2026-09-17T10:46:35Z
---
refs: endojs/endo-but-for-bots#264:review:5106219501:retro

# Review-retrospective: endojs/endo-but-for-bots PR #264 (review 5106219501)

Second loop on kriskowal's `rsvp` review (CHANGES_REQUESTED) of the design PR
`design(compartment-mapper): import-attributes propagation proposal`. Grounded in
the re-fetched PR, not the primary report: the primary handed off to designer job
`endojs-endo-but-for-bots-pr264-design-rsvp`, whose deliverable genuinely landed
(commit `db011c31a`, inline reply on each of the four threads) — verified, not a
#721-style false no-op.

**Verdict: one miss, three new-direction.** The review's four inline comments
split: three (moduleMapHook shape, `with`-vs-`withAttributes` naming + ordering,
`default`-vs-`specifier` key) are the maintainer deciding this design's
explicitly-flagged open questions — the open-questions review-PR carve-out working
as intended, unanticipable new-direction. The fourth is a **docs-drift miss**: the
doc characterized the existing `@endo/compartment-mapper` archive as "typically a
`tar.gz`" when it is a **zip** — a definite, in-repo-verifiable technical claim
contradicting both the implementation and the doc's own later "zip file" text.

Recorded to `review-misses/misses/endojs-endo-but-for-bots-pr264-review-1da7ebe7.md`
joining cluster `docs-claim-contradicts-code-semantics` (missed_by archivist —
the docs-prose-accuracy seat, corrected from the two prior members' `scribe`
attribution). That took the cluster to **count=3 across PRs [475, 877, 264]**,
tripping the K≥3/≥2-PR floor. Judgment above the floor: dispatch — three PRs, two
producing roles (builder ×2, designer ×1), one exact shape, a genuine systemic
gap. Dispatched builder job `review-improve-docs-claim-contradicts-code-semantics`
(identity `review-cluster:docs-claim-contradicts-code-semantics`) with the
two-part contract (prevention: cross-verify definite in-repo technical claims in
fleet-authored prose before landing; sensing: archivist seat check + panel-hints
probe) and the per-member re-litigation test; cluster marked
`improvement-dispatched`. recurrence=0.

Self-improvement: noted the `scribe`-vs-`archivist` seat mismatch in the existing
cluster records and routed the new miss and the improvement job to the accurate
docs-prose-accuracy seat; also flagged the harmless `tier: opus` post-job warning
(builder's role default already resolves to Opus).
