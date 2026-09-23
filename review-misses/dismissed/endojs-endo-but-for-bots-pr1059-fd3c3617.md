---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr1059-fd3c3617
verdict: not-a-miss
category: new-direction
review_at: 2026-08-31T23:40:42Z
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/1059#issuecomment-5486321806
identity: endojs/endo-but-for-bots#1059:comment:5486321806
---

The third round of the maintainer's iterative review of the ironhorse
snapshot-store-seam persistence validator (a Rust VM engine,
`rust/engine/ironhorse-snapshot/src/{image.rs,atom.rs}`). The reviewer, wearing an
AI review persona ("GPT 5.6 Sol"), requested changes with four
snapshot-binary-format canonicalization-completeness findings: (P1) validate the
Promise reaction *capability graph* — resolve/reject pairs must reference the same
promise and guard, Combine reactions must carry no capability slots, else a crafted
image settles the wrong promise or halts; (P1) require `remaining == pending`
exactly for an unfinished combinator so an inflated count cannot leave
`Promise.all`/`allSettled`/`any` pending forever; (P2) enforce a version-specific
*ordered* canonical atom allowlist (not just tag uniqueness) so a reordered or
junk-tagged container is not a second accepted encoding of the same machine; and
(P2) reject a present-but-empty `ESTK` atom under the same present-and-non-empty
rule as other optional atoms. All four are one-machine/one-CAS-encoding
canonicalization gaps inside a hand-written Rust binary-format validator.

**Grounds for not-a-miss.** This is the same maintainer-driven ironhorse arc that
the two prior rounds — comment 5452184664 (`...-a5d1fff6`) and comment 5486686006
(`...-1e30a92e`) — were already dismissed against. The grounds hold and strengthen;
this comment adds a third data point that the pattern is stable, not new:

1. *No garden review surface has jurisdiction.* No gauntlet/panel/juror job for
   #1059 exists anywhere on the board (`journal/jobs/tada/` holds only
   fix/rebase/shepherd jobs and two prior `-retro` jobs for this PR, and zero panel
   jobs). The garden's role on this PR is *fixer*, not gauntlet-reviewer, and the
   domain-expert maintainer is the continuous, engaged evaluator. No juror seat's
   lens reaches the ironhorse Rust snapshot engine's internal binary format — the
   code panel operates on JS/TS packages and design docs. A promise-capability-graph
   coherence check, a combinator `remaining` bound, an ordered atom allowlist, and a
   zero-row `ESTK` rejection all live inside a Rust combinator validator and its
   container grammar; no general seat brief (`breaker`, `wire-watcher`,
   `corner-prober`, `prover`) is scoped to read ironhorse snapshot-image internals.

2. *No standing garden rule failed to bind.* There is no seat-brief line, skill, or
   COMMON.md norm requiring the ironhorse validator to reject every non-canonical or
   crafted encoding (validate the capability pairing, upper-bound the combinator
   count, enforce a version-specific ordered atom allowlist, zero-check optional
   atoms). That one-machine/one-CAS-encoding canonicalization discipline is being
   *established* iteratively by these very review rounds, not violated against a
   written rule, so the single-major-miss severity bypass (a standing rule that
   already existed and did not bind) is not met.

3. *Iterative expert review, not evaluator-gaming.* Nothing was routed around a
   gate; the measurement did not move while the target stood still. Each round the
   garden fixes and the domain-expert maintainer reviews again and finds the next
   completeness layer of a hand-written binary-format validator. That the primary
   *refuted* one of the four findings (the exact `remaining == pending` requirement)
   with a recorded post-GC counterexample — a swept never-settleable element leaves
   an honest machine at `remaining > pending` — is legitimate technical pushback in
   an expert dialogue, the opposite of shaping work to satisfy the reviewer.

Recording as a dismissal keeps the discriminator's calibration auditable and stops
this comment being re-litigated; it mints no cluster and dispatches nothing.

**World-check (deliverable confirmed, no discrepancy).** The primary job
(`endojs-endo-but-for-bots-pr1059-fd3c3617`, in `journal/jobs/tada/`) reported PR
head `c32e6b97664d69c1eca1da8a23240b17226c5605` resolving three findings and
refuting the fourth. That commit genuinely exists in the repo (dated
2026-08-31T23:53:22Z, message "fix(ironhorse-snapshot): validate reaction
capabilities; canonical atom grammar"), landing the capability-pair/Combine/guard
checks, the in-order `CANONICAL_ATOM_ORDER` subsequence gate, the non-empty `ESTK`
rule, and the recorded `remaining == pending` refutation, with regression locks in
`crafted_row_refusals.rs`. The corroborating disposition comments (5486439971 by
kumavis, 5486465531 by kriscendobot) exist, and PR #1059 subsequently merged
(2026-09-01, merge commit 818c63ed). The directives' deliverable exists on the
merged head — confirmed, not case-changing.
