---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr1059-1e30a92e
verdict: not-a-miss
category: new-direction
review_at: 2026-09-01T00:25:45Z
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/1059#issuecomment-5486686006
identity: endojs/endo-but-for-bots#1059:comment:5486686006
---

Round two of the maintainer's iterative review of the ironhorse snapshot-store-seam
persistence validator (a Rust VM engine, `rust/engine/ironhorse-snapshot/src/image.rs`).
Wearing an AI review persona, the maintainer approved the prior fail-closed work as
"much better" and requested changes for three narrower findings in `validate_store`:
one correctness bug (a combinator's `remaining` field is lower-bounded by `pending`
but not upper-bounded by the results-array length, so a crafted `remaining = u32::MAX`
passes validation and then hangs `all`/`allSettled`/`any`) and two canonicality gaps
(the atom-grammar check accepts omitted required atoms and valid-but-empty encodings
of optional compound atoms; and non-Combine reactions accept arbitrary `a`/`b` payload
fields the writer always emits as zero, so multiple encodings decode to the same
machine). All three are binary-snapshot-format canonicalization-completeness gaps in a
Rust validator.

**Grounds for not-a-miss.** This is the same maintainer-driven ironhorse arc the prior
round (comment 5452184664, `endojs-endo-but-for-bots-pr1059-a5d1fff6`) was already
dismissed against; the grounds hold and strengthen here:

1. *No garden review surface has jurisdiction.* No gauntlet/panel job for #1059 exists
   anywhere on the board (`journal/jobs/tada/` holds only fix/rebase/shepherd jobs for
   this PR and zero panel jobs). The garden's role on this PR is *fixer*, not
   gauntlet-reviewer, and the maintainer is the continuous, engaged evaluator. No juror
   seat's lens reaches the ironhorse Rust snapshot engine's internal binary format — the
   code panel operates on JS/TS packages and design docs. A crafted-`remaining` bound
   check and required-atom/zero-field canonicality rules live inside a Rust combinator
   validator and its container grammar; no general seat brief (`breaker`, `wire-watcher`,
   `corner-prober`, etc.) would fire on Rust snapshot-image internals it has never been
   scoped to read.

2. *No standing garden rule failed to bind.* There is no seat-brief line, skill, or
   COMMON.md norm requiring the ironhorse validator to reject every non-canonical or
   crafted encoding (upper-bound crafted counts, enforce version-specific required atoms,
   zero-check unused reaction fields). That canonicalization discipline is being
   *established* by this very review round, not violated against a written rule, so the
   single-major-miss severity bypass (a standing rule that already existed and did not
   bind) is not met.

3. *Iterative expert review, not evaluator-gaming.* Nothing was routed around a gate.
   Each round the garden fixes and the domain-expert maintainer reviews again and finds
   the next completeness layer of a hand-written binary-format validator. That is the
   review process working as intended for a maintainer-driven Rust-engine arc, not a
   measurement moved while the target stood still.

Recording as a dismissal (not a miss) keeps the discriminator's calibration auditable
and stops this comment being re-litigated; it mints no cluster and dispatches nothing.

**World-check (deliverable confirmed, no discrepancy).** The primary job
(`endojs-endo-but-for-bots-pr1059-1e30a92e`) reported PR head `48c92dadf` resolves all
three directives (combinator upper-bound + race equality; required and non-empty
canonical atoms; zeroed non-Combine reaction payloads) with focused crafted-input tests.
Unlike the prior round's named-handle discrepancy, this primary's asserted deliverable
is on the PR head — confirmed, not case-changing.
