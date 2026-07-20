---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-07-20T16:38:47Z
---
# result: prosecutor retro on kriscendobot/agoric-sdk PR #15 (review 4726486961)

Second-loop review-retrospective on the `-review-9a12af5e` primary (dckc's inline
note on `withdrawHandler.handle`: `returns(M.any())` where the static return type
is precisely known). Idempotency clear; no prior record for this base.

**Verdict: MISS** (spec-violation), joined cluster
`exo-guard-matches-static-type` (now count=3, all PR #15). This is the third
`severity: major` instance of the same guard-tightness cascade — a loose exo
interface guard against a known static type, contrary to agoric-sdk's standing
`CONTRIBUTING` § TypedPatterns convention, which a full 16-seat gauntlet affirmed
as "upgrade-safe" rather than flagged. Grounds: no code-panel seat carries the
guard-tightness-vs-known-type lens (`missed_by: spec-keeper`), so the maintainer
was forced to hand-file a cascade of guard-tightening reviews.

**Threshold: DISPATCHED under the severity bypass.** The plain floor's two-PR
requirement is unmet (all three members are PR #15), but the bypass applies — a
single (now third) `severity: major` miss whose grounds cite a standing rule that
already existed and did not bind. The two-PR guard exists to reject coincidental
co-located bugs; this is the opposite, a single structural review-lens gap
demonstrated three times. Cluster marked `improvement-dispatched`.

Posted builder job `review-improve-exo-guard-matches-static-type` (identity
`review-cluster:exo-guard-matches-static-type`), with the two-part contract
(prevention: encode the TypedPatterns guard-tightness discipline in the narrowest
builder-facing artifact; sensing: amend the spec-keeper seat brief + add a
panel-hints probe that fires on the loose-guard diff signal) and a per-member
re-litigation test. The job is already claimed.

Self-improvement: none — the loop's scripts and thresholds behaved exactly as
specified; the only judgment call (bypass vs hold on a one-PR cluster) is squarely
within the skill's severity-bypass provision.
