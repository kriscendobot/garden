---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-07-12T18:01:36Z
---
# result — prosecutor retro: endojs/endo-but-for-bots PR #138 review 4680309727

**Verdict: dismissal (not-a-miss / new-direction).** No cluster minted, no
improvement job dispatched.

PR #138 is a **designer** output — the design document
`designs/ocapn-daemon-integration.md`, whose body carried an explicit "10 Open
Questions" section soliciting maintainer direction. kriskowal's CHANGES_REQUESTED
review is an empty body plus 15 inline comments, each answering one of those open
questions with a first-stated architectural decision (Transports-as-formula,
per-transport port + shared identity-routed instance, route-on-Ed25519,
throw-on-unregistered-scheme, retire `@nets`, close-sessions-on-collection, two
planned follow-up designs, etc.).

Grounds (from the PR's actual history, not the comment text): (1) no
gauntlet/panel/build/fix job ran on #138 — the code panel does not and should not
run on a pure design doc, since its seats lens over code correctness/style/spec/
packaging/types, none of which can pre-decide the maintainer's transport model;
(2) every directive is the maintainer's design authority exercised in review, not
a convention a seat knew and failed to bind — encoding those answers *is* the
design work this PR exists to elicit. The primary loop absorbed all 15 directives
into resolved "Design Decisions" correctly (a new-direction absorption, not a
corrective fix). Structurally of a piece with the #135 (review-63a86be1) and #124
(review-a736154b) dismissals: pre-gauntlet, maintainer-directed PRs whose feedback
is forward architectural direction.

Recorded durably at
`review-misses/dismissed/endojs-endo-but-for-bots-pr138-review-86c2eb0e.md` so the
same review is never re-litigated.

Self-improvement: nothing to change — the design→maintainer-review loop is the
intended workflow here, and the discriminator, threshold, and idempotency guards
all behaved as designed.
