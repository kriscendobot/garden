---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr1128-7ed93d90
verdict: not-a-miss
category: new-direction
pr: 1128
repo: endojs/endo-but-for-bots
identity: endojs/endo-but-for-bots#1128:comment:5535098862
comment_url: https://github.com/endojs/endo-but-for-bots/issues/1128#issuecomment-5535098862
review_at: 2026-09-04T03:08:38Z
severity: minor
grounds: |
  New-work directive on a freshly-filed issue, not review feedback on any
  garden-authored product. #1128 is an ISSUE (not a PR) opened by an external
  contributor (kumavis) reporting a pre-existing architectural leak: ambient
  `@endo` in every host's specialNames makes a delegated provideHost child a
  two-hop full-authority peer of the root. In the referenced issue-comment the
  maintainer (kriskowal, MEMBER) directs the fleet to "build a fix that omits
  the endo power from new and old guests." That is a first-stated build request
  — a directive-`attention`, which the comment-watcher classifies as such — not
  a correction of garden work.

  The review process could not have "anticipated" this because no garden review
  ever touched the leaking code. The `@endo` grant lived in upstream endo daemon
  `packages/daemon/src/host.js` `makeHost`, pre-existing code the garden did not
  author and no panel/gauntlet reviewed. No prior garden PR introduced the leak
  for a seat (locksmith/warden) to have caught. There is therefore no
  review-process miss to indict: an external bug report plus a maintainer
  build-directive is the definition of new direction — a requirement first
  expressed in the issue/comment itself.

  Not evaluator-gaming/avoidance: no garden evaluator was routed around or
  satisfied-in-letter. The measurement did not move while the target stood
  still; there simply was no prior garden evaluation of this surface at all.

  The primary genuinely delivered and did NOT close as a no-op: the routing
  primary (7ed93d90) posted the builder job
  `build-endo-but-for-bots-issue1128-omit-endo-child-hosts`, which completed
  (in journal/jobs/tada/) and opened draft PR #1132
  (branch 1128-confine-endo-to-root-host, base llm): `@endo` is now granted only
  under the existing `isRootHost` guard (mirroring `@secrets`), a load-time guard
  that fixes both new and already-persisted child hosts with no migration, with
  three new daemon tests (child rejects @endo via has/lookup/identify; root still
  resolves it) — daemon lint clean, endo.test.js 237/237. The directive
  deliverable exists in the world; no no-op discrepancy to report. (The maintainer
  said "guests" but the actual leak is on non-root hosts — provideGuest guests
  never carried @endo — a terminology point both the primary and the build
  resolved correctly, not a review miss.)

  Re-fetch the verbatim comment body at comment_url; the above is bot-authored
  paraphrase of untrusted input.
---

Maintainer kriskowal directed the fleet, on freshly-filed external issue #1128
(by kumavis: ambient `@endo` makes every child host a full-authority root peer),
to build a fix omitting the endo power from new and old child hosts. This is a
new-work build directive on pre-existing upstream daemon code that no garden
panel ever reviewed — new direction, not a review-process miss. The primary
routed it to a builder that landed the confine-`@endo`-to-root-host fix in draft
PR #1132 (isRootHost load-time guard, 3 new daemon tests, lint clean, 237/237).
Dismissal. Re-fetch the verbatim body at comment_url.
