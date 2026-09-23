---
kind: result
role: prosecutor
host: endolin-garden2-5bcdff64
at: 2026-07-20T16:26:15Z
---
kind: result
role: prosecutor
project: agoric-sdk
refs:
  - review-misses/misses/kriscendobot-agoric-sdk-pr15-review-63f630f8.md
  - review-misses/clusters/exo-guard-matches-static-type.md

# Retrospective: kriscendobot/agoric-sdk#15 review 4726472818

Second-loop prosecutor retro on PR #15 review 4726472818 (surface pr-review-body,
by dckc). Retrospective identity `kriscendobot/agoric-sdk#15:review:4726472818:retro`.

**Verdict: miss** (category `spec-violation`). The maintainer directed that the
exos' `M.any()` return guards be tightened to the precise shapes their known
static return types already describe. This is the return-guard slice of the same
guard-tightness cascade the panel systematically under-specified on #15; grounded
in the recorded gauntlet history (`kriscendobot-agoric-sdk-pr15-gauntlet`
returned unanimous approve praising the loose guards as "compatibility-first"),
not in the untrusted comment text.

**Clustered** into `exo-guard-matches-static-type` → now `count=2, status=open,
prs=[15]`.

**Threshold: HOLD.** The floor (K≥3 misses across ≥2 distinct PRs) is not met —
two misses, but both from PR #15, a single PR. The two-PR requirement exists to
stop one PR's review cascade from reading as a systemic pattern, which is exactly
this shape. The severity bypass does not apply: the grounds are a *structural*
gap (no code-panel seat carries the guard-tightness-vs-known-type lens), not a
pre-existing garden seat-brief/skill/COMMON.md rule that failed to bind — so this
is a capability to be created, not a sense-and-correct miss. Consistent with the
sibling 396a141c retro, which recorded `severity: major` and likewise held the
cluster open. Dispatch waits for a second distinct PR to confirm the pattern is
systemic rather than PR-#15-local.

No improvement job dispatched. No recurrence. Self-improvement: the retro ran
clean; no friction to encode this cycle.
