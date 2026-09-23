---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr1059-beaff99f
verdict: not-a-miss
category: new-direction
review_at: 2026-08-31T03:35:45Z
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/1059#issuecomment-5473372336
identity: endojs/endo-but-for-bots#1059:comment:5473372336
---

Another round of the maintainer-driven ironhorse snapshot-store-seam review arc (the
Rust VM engine, `rust/engine/ironhorse-snapshot` and `rust/engine/ironhorse-vm`),
delivered by kumavis through an AI review persona against `dbd7d21`. The comment raises
two P1 blockers in the Rust snapshot restore/validation path: (1) a restore-ordering
bug where the generic `FUNC` cluster is validated before `IBFN` (Intl-bound) records
are installed, so an honest machine that retains `collator.compare.bind(...)` can
checkpoint but not resume (`resume_from_store` returns a `Corrupt` "malformed retained
function state"); and (2) a generator-PC validation gap in `image.rs` that only bounds
`resume_pc`/`target_pc` against segment length, accepting the segment end, a PC inside
an instruction operand, or a PC in a sibling function body, so the adoption boundary can
admit a machine whose next `.next()` dispatches at an invalid PC. Both are internal
binary-snapshot restore-and-validation defects in a hand-written Rust engine.

**Grounds for not-a-miss.** The same arc as the five prior dismissed rounds on this PR
(comments 5452184664 -> `...-a5d1fff6`; 5486686006 -> `...-1e30a92e`; 5486439971 ->
`...-6cbbd9d4`; 5474067434 -> `...-ac4e65b2`; 5473017451 -> `...-43d08bdd`); the grounds
hold:

1. *No garden review surface has jurisdiction.* No gauntlet/panel job for #1059 exists
   anywhere on the board -- `journal/jobs/tada/` holds only fix/rebase/shepherd and
   review-fix jobs for this PR and zero panel/gauntlet jobs. Under the manual-gauntlet
   regime the garden staged no automatic gauntlet and none was requested; the garden's
   role on this PR is *fixer*, and the maintainer is the continuous, engaged evaluator.
   This is not a `process` miss -- no gauntlet was owed.

2. *No juror seat's lens reaches the domain.* Although the taxonomy would route a
   correctness/edge-case finding to `breaker`/`corner-prober`/`prover`, those seats
   reason about JS/TS packages and design docs, not an ironhorse Rust snapshot engine's
   internal instruction encoding and side-table restore ordering. A restore-order
   dependency between `IBFN` and `FUNC` rows, and instruction-start membership over a
   `cur_func` body range via `instruction_len`, require deep Rust snapshot-engine domain
   expertise no garden seat is scoped to hold.

3. *No standing garden rule failed to bind.* There is no seat brief, skill, or COMMON.md
   norm requiring the ironhorse restore path to install callable dependencies before
   validating the function cluster, or to validate generator PCs against exact
   instruction boundaries. That fail-closed canonicalization discipline is being
   *established* round by round by this review, not violated against a written rule, so
   the single-major-miss severity bypass (a standing rule that already existed and did
   not bind) is not met.

4. *Iterative expert review, not evaluator-gaming.* Nothing was routed around a gate and
   no measurement moved while the target stood still. Each round the garden fixes and the
   domain-expert maintainer reviews again and names the next completeness layer of a
   hand-written binary-format validator. That is the review process working as intended
   for a maintainer-driven Rust-engine arc.

Recording as a dismissal keeps the discriminator's calibration auditable and stops this
comment being re-litigated; it mints no cluster and dispatches nothing.

**World-check (deliverable confirmed, no discrepancy).** The primary job
(`endojs-endo-but-for-bots-pr1059-beaff99f`) closed as a verified no-op: both P1
blockers were already resolved by peer commits on the PR head -- `c2c433138` ("restore
Intl-bound callables before FUNC") and `0f6ffb0ba` ("bound generator PCs to the owning
body"). I confirmed both commits exist upstream with matching messages, and that the
primary's promised follow-up (issue-comment 5473484823, authored by kriscendobot,
2026-08-31T03:54:28Z) is present on the thread acknowledging both fixes. PR #1059 is now
**merged** (2026-09-01, head `48c92dadf`, base `llm`). Deliverable confirmed; no
primary-report discrepancy.
