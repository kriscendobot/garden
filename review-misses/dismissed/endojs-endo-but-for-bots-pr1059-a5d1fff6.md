---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr1059-a5d1fff6
verdict: not-a-miss
category: new-direction
review_at: 2026-08-28T11:53:34Z
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/1059#issuecomment-5452184664
identity: endojs/endo-but-for-bots#1059:comment:5452184664
---

A deep maintainer-driven correctness-and-architecture review of the ironhorse
snapshot-store-seam persistence layer (a Rust VM engine, `rust/engine/ironhorse-*`
and `rust/endo/`). The reviewer, wearing an AI review persona, requested changes
with nine blocking findings, five additional correctness notes, and one
architectural recommendation. The findings are that the snapshot/adoption boundary
is not yet fail-closed: freed-record opacity, free-slot owner bitmap checks,
fallible RegExp restoration, STAC quiescence enforcement on read, iterator
persistence gates, meter-counter restoration, atomic migration ordering, collection
geometry validation, and a missing container format-version bump. The
recommendation is to centralize all of this into a single proof-carrying adoption
pipeline (declarative state registry, one validator, `ValidatedSnapshot` gate).

**Grounds for not-a-miss.** Three grounded reasons, none resting on the primary
report:

1. *No garden gauntlet had jurisdiction here.* No gauntlet/panel job exists for
   #1059 anywhere on the board (`journal/jobs/tada/` holds ~13 fix/rebase/shepherd
   jobs for this PR and zero panel/gauntlet jobs). This PR sits on the ironhorse
   arc, reviewed directly and continuously by the maintainer; the garden's role on
   it is *fixer*, not gauntlet-reviewer, evidenced by the fix-job cascade. There is
   no juror seat with demonstrated jurisdiction over the ironhorse Rust snapshot
   engine's internal binary format — the code panel operates on JS/TS packages and
   design docs. Contrast the `capability-hardening-attenuation` cluster, whose
   misses were about exported JS/exo capability surfaces squarely inside the
   panel's lens; the fail-closed findings here are ironhorse-internal (free-record
   layout, side-table owner bitmaps, schema-v12 migration) that no general seat
   brief would fire on.

2. *The architectural recommendation is new direction.* The proof-carrying
   adoption pipeline / single-validator / declarative-state-registry design is
   first stated in this comment. It is a design fork the maintainer is proposing,
   not a defect a review seat should have anticipated in the diff.

3. *No standing garden rule failed to bind.* There is no existing garden
   seat-brief line, skill, or COMMON.md norm requiring that an ironhorse snapshot
   restore path be fail-closed and version its container format; that discipline is
   being *established* by this very review, not violated against a written rule.
   The severity-bypass condition (a single major miss citing a standing rule that
   already existed and did not bind) is therefore not met.

**Not evaluator-gaming.** Nothing was routed around a gate. The maintainer is the
evaluator and is actively, thoroughly engaged; the review process worked as
intended for a maintainer-driven Rust-engine arc.

**World-check discrepancy (reported, not case-changing).** The primary job
(`endojs-endo-but-for-bots-pr1059-a5d1fff6`) asserted a fixer job
`fix-endojs-endo-but-for-bots-pr1059-failclosed` was verified "in
journal/jobs/doin/". That exact base is not on the board today (todo/doin/plan/
tada/failed). However the fail-closed substance genuinely landed under a
differently-named job, `endojs-endo-but-for-bots-pr1059-review5065895723-fix`
(tada), which pushed fail-closed persistence checks through commit `534bab5ef6`
with CI green. So the directive's deliverable does exist; only the primary's named
handle was inaccurate. This does not alter the not-a-miss verdict.
