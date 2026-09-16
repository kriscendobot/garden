---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr1072-review-bb54af10
verdict: not-a-miss
category: new-direction
review_at: 2026-08-28T03:32:25Z
repo: endojs/endo-but-for-bots
pr: 1072
surface: pr-review-body
author: kriskowal
comment_url: https://github.com/endojs/endo-but-for-bots/pull/1072#pullrequestreview-5047696655
identity: endojs/endo-but-for-bots#1072:review:5047696655:retro
producing_role: gardener
producing_job: deadmail-issue-comment-5447781817
severity: none
---

The maintainer's review body was empty and carried one inline follow-up on the
OCapN-Noise design. Paraphrased, it asked the document to explain the purpose
of advertising several connection hints: peers on different platforms can use
different transports, direct TCP and browser-reachable routes have different
constraints, a LAN can retain a direct route while partitioned from the
internet, and later relay hints can support speculative connection attempts.
See `comment_url` for the verbatim review.

Grounds: this is new design rationale first supplied by the maintainer, not a
defect or an existing requirement the review process should have anticipated.
At the reviewed commit, the design already said that a location can carry
hints for several transports, that connection chooses a matching transport,
and that preference is configurable. Neither that document nor the producing
job, a juror brief, a skill, or a standing instruction stated the detailed
cross-platform motivation or the prospective relay and connection-racing
direction. The requested explanation therefore adds the design owner's domain
context instead of identifying a bug, specification breach, missed edge case,
or convention that failed to bind.

The world history also shows no panel verdict to second-guess. PR #1072 was
opened as a draft, and its producing job explicitly left the code panel and
gauntlet for a later manual trigger. The journal has no #1072 gauntlet or panel
job, and the PR thread has no panel review comment. That absence is not
evaluator avoidance: the garden's standing workflow requires an explicit
"run the gauntlet" request, the draft was never promoted, and this maintainer
review arrived while the PR was still in its advertised draft review phase.
A panel could assess whether stated rationale was coherent, but it could not
invent platform and roadmap facts not yet stated by the design owner.

World-grounded deliverable check: the primary job did not merely assert a
resolution. Commit `da0428084` added a dedicated design subsection covering
the requested platform filtering, browser, direct TCP, partitioned-LAN, relay,
and speculative-connection rationale. That commit is in the current PR head's
ancestry, the section remains in the current file after later revisions, and a
threaded reply points to the change. There is no discrepancy to report.

No cluster is minted, no threshold applies, and no improvement job is posted.
