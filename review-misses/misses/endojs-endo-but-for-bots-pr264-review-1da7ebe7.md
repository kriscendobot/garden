---
kind: review-miss
primary_job: endojs-endo-but-for-bots-pr264-review-1da7ebe7
verdict: miss
category: docs-drift
pr: 264
cluster: docs-claim-contradicts-code-semantics
review_at: 2026-09-03T20:05:35Z
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/264#pullrequestreview-5106219501
identity: endojs/endo-but-for-bots#264:review:5106219501
producing_role: designer
producing_job: endojs-endo-but-for-bots-pr264 (design(compartment-mapper) import-attributes proposal; doc designs/compartment-mapper-import-attributes.md, reviewed head 9d68588c0)
missed_by: archivist
severity: minor
---

PR #264 is a *design proposal* PR (author kriscendobot) presented for review under
the open-questions carve-out. The maintainer's `rsvp` review (CHANGES_REQUESTED)
left four inline comments on `designs/compartment-mapper-import-attributes.md`.
The record's dominant verdict is the first; the other three are new-direction,
noted here but not separately filed (the store keys one record per primary).

**Filed miss (docs-drift).** The doc's opening description of the existing
`@endo/compartment-mapper` characterized its replayable archive as "typically a
`tar.gz`". That is a definite, in-repo-verifiable technical claim and it is
false: the compartment-mapper archive format is a **zip**, and the very same doc
later (its "Archive" leg) already said "zip file" — so the claim contradicted
both the implementation and the doc's own prose. The maintainer flagged it with
"Actually `.zip`." A docs-prose-accuracy review lens cross-verifying the doc's
definite technical claims against the code (and against the doc's own text) would
have caught it; nobody did. Recorded as a miss, not a dismissal, on that ground.
Not `evaluator-gaming`: nothing was shaped to satisfy a rubric — a factual
characterization was simply wrong. It is the **identical shape** to the cluster's
two founding members (#475: a README brand-check claim contradicted by
`@endo/pass-style`; #877: a header comment claiming `@endo/base64` omits
atob/btoa, contradicted by that package's actual exports), so it joins
`docs-claim-contradicts-code-semantics`. Severity minor (a Proposed design doc,
already self-contradicting, cheap to fix), but the third distinct PR in the
pattern.

Seat note: the two prior members attributed the miss to `scribe`; on the seat
briefs the accurate lens is the **archivist** (docs-prose accuracy — "reads what
the PR's prose says"), not the scribe (note-taking-closure). Both are listed under
`docs-drift` in the taxonomy. `missed_by: archivist` is set accordingly; the
improvement job should route the sensing check onto the archivist.

**Not filed — new-direction (comments 2–4).** The remaining three comments are
the maintainer deciding this design's explicitly-flagged open questions, which is
exactly what the open-questions review-PR carve-out exists to collect and which
no panel can or should pre-decide:
  - L189: a design question about whether `moduleMapHook` is the right hook given
    it currently shares `importNowHook`'s signature and the two may collapse.
  - L332: naming/precedent taste — the companion field is our invention, prefer
    the spelling `with` over `withAttributes`, and want an after-`default`
    ordering rule.
  - L336: prefer `default` over `specifier` for the internal target-record key
    (semantics unchanged for engines that ignore the new properties).
These are taste and direction on undecided design forks, first-stated in the
review; nobody could have anticipated them, so they are new-direction, not review
misses.

Ground-truth: the primary review job handed off to designer job
`endojs-endo-but-for-bots-pr264-design-rsvp`, whose deliverable genuinely landed
(commit `db011c31a` on `design/compartment-mapper-import-attributes` corrects the
archive to `zip` and folds the three design steers into Open Questions; an inline
reply was posted on each of the four threads). This retro is grounded in the
re-fetched PR, not in the primary's assertion.
