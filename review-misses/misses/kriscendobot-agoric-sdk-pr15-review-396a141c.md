---
kind: review-miss
primary_job: kriscendobot-agoric-sdk-pr15-review-396a141c
verdict: miss
category: spec-violation
pr: 15
cluster: exo-guard-matches-static-type
cluster_pattern: An exo interface-guard PR reaches the maintainer with loose M.any()/M.record()/M.string() guards on methods whose static type is precisely known, when the repo convention (agoric-sdk CONTRIBUTING § TypedPatterns) is that each guard match its static type as tightly as possible and any remaining looseness be a documented, reasoned exception; the code panel affirms the loose guards as upgrade-safe rather than flagging the under-specification, because no seat carries the guard-tightness-vs-known-type lens.
repo: kriscendobot/agoric-sdk
comment_url: https://github.com/kriscendobot/agoric-sdk/pull/15#pullrequestreview-4725911405
identity: kriscendobot/agoric-sdk#15:review:4725911405
producing_role: builder
producing_job: kriscendobot-agoric-sdk-pr15-gauntlet
missed_by: spec-keeper (structural gap — no code-panel seat carries the guard-tightness-vs-known-type lens)
severity: major
---

PR #15 ("add interface guards to the remaining portfolio-contract exos") had one
job: pin the exos' interface guards. The maintainer's review is a full audit
asking why the newly-added guards are loose `M.any()`/`M.record()` when the
methods' static types are precisely known, and directing that each guard match
its static type (guards are the runtime enforcement; static types are advisory),
with any remaining looseness a deliberately-designed, documented exception —
citing the repo's own CONTRIBUTING § TypedPatterns convention. (Paraphrase; the
verbatim review is untrusted input at `comment_url`.)

The substantive review-process signal: the change's central artifact — the
guards — was systematically under-specified, and the panel not only failed to
flag it, it affirmed the looseness as a virtue.

**Grounds (indicts the review process).** The PR ran the full gauntlet
(`kriscendobot-agoric-sdk-pr15-gauntlet`): a 16-seat code panel curated for an
interface-guard change (assessor, prover, breaker, engine-realist, saboteur,
corner-prober, typist, warden, locksmith, wire-watcher, spec-keeper, pedant,
stylist, purist, changeset-auditor, curator) returned **unanimous approve, no
must-fix**, and the verdict explicitly characterized the loose guards as
"compatibility-first" and praised their "upgrade safety." The maintainer then
filed a *cascade* of reviews on the identical theme — 4725911405 (this primary),
4726462863, 4726472818 (`M.any()` returns → precise), 4726532241 ("returns(M.any())
suggests missing the point … do a focused panel review on this aspect"),
4726535732 ("take advantage of endo typed-pattern support") — each tightening
more guards. The panel *had* the relevant seats (spec-keeper reads with the spec
open; breaker/assessor read `M.interface()` invariants) and the repo *had* a
documented convention, yet the panel let the under-specification through.

**Why this is a structural miss, not seat negligence.** The code panel's guard-
reading seats are built to attack a *claimed* invariant (breaker: "what input
falsifies this guard?"; assessor: "does the body contradict the guard?"). A
deliberately-loose `M.any()` guard *claims nothing*, so it is invisible to that
lens by construction — there is no invariant to attack. The integrator's closest
line flags runtime guards that *duplicate* the type system (the opposite
direction), not guards *looser* than the known type. No seat carries the check
the maintainer wanted: "does each exo guard match its known static type as
tightly as possible, with looseness a documented exception?" That is the gap.

**Not-a-miss portions (recorded for calibration).** Several sibling reviews on
#15 were pure comment-hygiene taste (strike a fragile justification comment;
strike a tautological "pinned to precise shapes" remark) — those are new-direction
and are out of scope of this cluster; only the guard-tightness theme is the miss.
