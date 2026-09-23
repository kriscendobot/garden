---
kind: result
role: prosecutor
host: endolin-garden2-5bcdff64
at: 2026-07-20T14:44:16Z
---
# Review retrospective: kriscendobot/agoric-sdk PR #15 review 4725911405

refs:
- review-misses/misses/kriscendobot-agoric-sdk-pr15-review-396a141c.md
- review-misses/clusters/exo-guard-matches-static-type.md

**Primary:** kriscendobot-agoric-sdk-pr15-review-396a141c (the feedback loop,
unchanged). **Retro identity:** kriscendobot/agoric-sdk#15:review:4725911405:retro.

## Verdict: MISS (spec-violation)

@dckc's review audited PR #15's newly-added exo interface guards and asked why
they are loose `M.any()`/`M.record()` when the methods' static types are precisely
known — directing that each guard match its static type (guards are the runtime
enforcement; static types advisory), per agoric-sdk CONTRIBUTING § TypedPatterns,
with any remaining looseness a documented deliberate exception. This indicts the
review process: PR #15's whole purpose was to pin those guards, yet the 16-seat
gauntlet panel returned unanimous-approve/no-must-fix and *praised* the loose
guards as "compatibility-first" and "upgrade-safe." The maintainer then filed a
cascade of same-theme reviews, one explicitly saying "do a focused panel review
on this aspect." Recorded to cluster `exo-guard-matches-static-type`.

**Structural root cause:** the panel's guard-reading seats (breaker, assessor)
attack a *claimed* invariant; a deliberately-loose `M.any()` guard claims nothing
and is invisible to that lens by construction. The integrator flags the opposite
(runtime guards redundant with types). No seat carries "does each exo guard match
its known static type as tightly as possible, with looseness a documented
exception?" — the exact lens the maintainer wanted.

## Threshold: HOLD (do not dispatch) — recorded rationale

- **Count floor not met.** Cluster is count=1, prs={15}. The floor is K≥3 misses
  across ≥2 distinct PRs. All the guard-tightness feedback came from one PR — the
  textbook "one-PR cluster masquerading as systemic" pitfall the two-PR floor
  exists to prevent. The maintainer's multiple reviews are facets of one work
  product, not a cross-PR pattern.
- **Severity bypass not met.** The bypass fires for a single `severity: major`
  miss whose grounds cite a *garden* standing rule (seat brief, skill, COMMON
  norm) that existed and did not bind — a pure sense-and-correct failure. Here no
  garden seat/skill/norm carried the guard-tightness-vs-known-type lens; the repo
  CONTRIBUTING convention is project-side, not garden review machinery. This is a
  first-observation *capability gap*, not a machinery-had-the-rule-and-missed-it
  failure, so the bypass does not apply.
- **Disposition:** cluster left `open` at count=1. The pattern statement primes a
  future retro: a second instance on a *different* agoric-sdk exo-guard PR trips
  the ≥2-PR floor and (given severity major) should dispatch a `review-improve-
  exo-guard-matches-static-type` builder job — prevention (a guard-audit note in
  the producing role / a panel-hints probe on exo `M.interface()` diffs firing a
  guard-tightness seat) plus sensing (seat-brief line for the seat that gains the
  lens). Holding now avoids over-fitting a new panel capability to one PR.

Self-improvement: nothing this engagement.
