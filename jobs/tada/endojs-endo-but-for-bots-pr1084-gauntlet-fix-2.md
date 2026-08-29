Inbox empty. The fix stage is complete.

## Gauntlet FIX round 2 — endojs/endo-but-for-bots PR #1084 — complete

**Applied the panel round-2 must-fix items** (all seats returned request-changes) to `designs/exo-stream-adaptive-pacing.md`, plus a companion `designs/README.md` fix, and pushed as a review-feedback follow-up commit (`8bb43e4ab`).

What changed, by finding:

- **Hard memory bound (critic + skeptic + decomplector, the overlapping headline item):** Was asserted unconditionally but (a) depended on the producer's own pre-pull `buffer` — a far-end CapTP knob the consumer cannot enforce — and (b) was a property of the reference controller's private clamp, not the pluggable interface. Now the bound is **enforced loop-side**: `iterateReader` clamps any controller's `fillTarget()` to a new declared `maxCredit` field on the `CreditController` interface, so it holds against a buggy/hostile third-party controller. And it's **explicitly scoped** to a `buffer:0`/small producer, with the nonzero-buffer pairing documented as an unbounded case in Compatibility/Limits/"Where the policy belongs" and added to the verification plan.
- **Alpha monotonicity (critic):** Decoupled the multiplicative decrease into a separate fixed factor `beta` (default 1/2), so the steady-state window is monotone in `alpha` by construction; added the derivation and a beta-sweep test.
- **PR #832 framing (skeptic):** Reframed `ReadableBlob.lines()` as *proposed* on an **open, unmerged** PR throughout; the `lines()` end-to-end verification is now stated as blocked on #832 merging.
- **Unused `fill` (decomplector):** Dropped from the interface, signal table, and growth-driver sentence (and vestigial `tCredit`).
- **`floor()` name collision + siblings (ergonomist):** Renamed `floor()` → `fillTarget()`; added `iterateBytesReader` as the symmetric sibling in Compatibility; named the constructor export point.
- **Newcomer accessibility (novice):** Added a CoDel primer paragraph; expanded AIMD on first use; renamed the detector's `dropping` field to `reducing` with an explanation of the CoDel lineage.
- **Prose (copyeditor + pedant):** Defined `target` at first use; split the run-on worked example; fixed parallel structure and "decouplable"; dropped redundant quote italics; parallel bold labels on open questions; "Per consumed item." period; bracketed the README nested parenthetical.

Anchor links verified against headings; the mermaid diagram edit was a label-text change only.

**CI: GREEN** — `GARDEN_CI_DEADLINE_SECS=3600 ci-wait-merge.sh … --no-merge` returned rc 0 (5/5 checks, 0 failed). Not merged, as instructed. Stopped after one fix pass; did not re-run the panel (the driver re-posts panel-3).

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1084-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 82 tokens (3770083 cached reads)
- Output: 41437 tokens
- Cost: $3.9064735
- Wall-clock: 1045s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
