---
kind: result
role: prosecutor
host: endolin-garden-ece02cb4
at: 2026-07-10T20:21:24Z
---
# Review retrospective (prosecutor) — endo-but-for-bots #621 review 4673297710

**Verdict: not-a-miss (new-direction).** Second loop on `endojs/endo-but-for-bots`
PR #621, judging whether the garden review process should have anticipated
kriskowal's COMMENTED review 4673297710. Idempotency clear (no prior misses/ or
dismissed/ record for the primary base).

The review is a single forward-design directive on a **design-only** PR
(`designs/endoclaw-oauth.md`, llm roadmap branch): do another design round that,
on top of the existing dynamic "caretaker" controller facet, lets a capability
holder recursively **partition and delegate** — optionally minting a child
capability + controller facet — under a **monotone narrowing** invariant (child
authority never expands beyond parent); and capture this as a named reusable
pattern in a design skill, composite **"caretaker attenuation."**

**Grounds (from the PR's own history):** #621 ran the full gauntlet — a 7-seat
design panel, a fixer round, and a PASS re-review (`gauntlet-endo-but-for-bots-pr621-endoclaw-oauth`).
The review originates a new architectural direction (recursive capability
delegation with a monotonicity invariant) first stated here, and asks to coin a
pattern name. A design panel reviewing an existing design doc cannot be expected to
invent the maintainer's preferred capability-model extension or name it for him;
that is his design authority, not a defect the panel let ship. Same class as the
**sibling** dismissal on this very PR (review 4672880146) and the #631/#611/#604/#288
design-doc new-direction dismissals. No standing rule bound and failed, so the
severity-bypass is absent.

**What changed:** recorded a durable dismissal
(`review-misses/dismissed/endojs-endo-but-for-bots-pr621-review-659246fc.md` via
`review-miss-record.sh`, comment paraphrased, never pasted), confirmed on
`origin/journal2`. No cluster minted, no threshold evaluation, no improvement job.
No main2 garden-library changes; inbox empty. The primary loop already routed the
directive to a designer and is unchanged.

**Follow-ups:** none. Self-improvement: nothing this time — two consecutive design-
directive dismissals on #621 confirm the discriminator is correctly declining to
manufacture review-process misses out of forward maintainer design direction.
