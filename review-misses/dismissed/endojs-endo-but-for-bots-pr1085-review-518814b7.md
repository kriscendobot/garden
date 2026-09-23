---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr1085-review-518814b7
verdict: not-a-miss
category: new-direction
pr: 1085
review_at: 2026-09-05T04:31:07Z
repo: endojs/endo-but-for-bots
surface: pr-review-body
author: kriskowal
comment_url: https://github.com/endojs/endo-but-for-bots/pull/1085#pullrequestreview-5119774721
identity: endojs/endo-but-for-bots#1085:review:5119774721:retro
producing_role: builder
producing_job: endojs-endo-but-for-bots-pr1085-streamgrep-incremental-walk
missed_by: nobody
severity: none
---

Paraphrase: the maintainer (CHANGES_REQUESTED) observed that the PR description
still describes the streaming glob as eager, which removes its advantage over the
eager array glob, and asked the garden to verify the walk was made lazy —
deterministic by sorting each directory locally as it is reached, but explicitly
not atomic or transactional unless traversing a readable-tree snapshot. The
untrusted review body remains available only at `comment_url`.

Grounds: this is a new-direction maintainer decision, not a review-process miss.
The eager-vs-lazy sort of `streamGlob` was not a defect the panel let slip — it
was an OPEN design tradeoff the garden itself deliberately surfaced to the
maintainer for decision, twice, before this review. The `streamgrep-incremental-walk`
builder (commit `10a1531efe`) made `streamGrep` genuinely walk-incremental via a new
`globPaths({ sorted: false })` substrate while deliberately KEEPING `streamGlob` on
glob's global UTF-16 sort (`sorted: true`), and flagged for sign-off — both in the
design doc § Follow-up and on PR thread comment 5536890585 — that restoring
first-match-before-full-walk for `streamGlob` "wants an unsorted `streamGlob` mode"
and was "left as a follow-up rather than changing `streamGlob`'s sort contract
without the maintainer's decision." The sibling `streamgrep-mandatory-file-stream`
builder (commit `aa15e2478`) repeated the same explicit deferral. So at review time
the PR description saying the glob is eager was ACCURATE — code and docs agreed —
and the eager state was an intentional, escalated hold, not drift and not an
un-flagged regression.

The maintainer's review 5119774721 is precisely the answer to that RSVP'd decision:
make `streamGlob` lazy with directory-local sorting. No juror seat, panel-hints
probe, or authoring gate could or should have "caught" this, because there was
nothing wrong to catch — the panel would have had to pre-empt a design decision the
garden had correctly reserved for the maintainer. Pre-empting a deliberately-deferred
maintainer decision is not a review-cycle capability; escalating the tradeoff
on-thread (which the garden did) is exactly the right behavior, so the review process
worked rather than failed. This is not evaluator-gaming: #1085 ran multiple full code
gauntlets (`gauntlet-20260901` and `streamgrep-incremental-walk-gauntlet`, 29 seats,
three panel/fix rounds each) — the evaluator was invoked, not skipped, and the change
did not move what the evaluator measures.

World-grounded, not report-repeating: the primary was NOT a no-op, and its
deliverable genuinely exists — commit `1fc827aa9b2a` ("fix(platform): keep lazy glob
walk directory-sorted (#1085)") is present on the PR and touches
`packages/platform/src/fs/search.js` (the per-directory-local ordering) plus
`designs/mount-stream-glob-grep.md`, `designs/README.md`, and the PR description,
exactly implementing the maintainer's directive. The larger inline request (native
Rust batched grep, fused `glorpStream`, Node/XS/Ironhorse parity) was routed to a
separate orchestration and is a distinct directive tracked under its own identity;
it is out of scope for this review-body retro.

No miss cluster or review-improvement job is warranted.
