---
kind: review-miss-dismissed
primary_job: kriscendobot-minion.town-pr39-review-fb0be7ca
verdict: not-a-miss
category: new-direction
review_at: 2026-08-17T12:21:43Z
repo: kriscendobot/minion.town
comment_url: https://github.com/kriscendobot/minion.town/pull/39#discussion_r3796289249
identity: kriscendobot/minion.town#39:review:4951516413:retro
---

Maintainer design-tradeoff steer on a design-only PR, landed through the review
surface design PRs are meant to land through. #39 is a design document
(`designs/git-content-substrate.md` is its sole touched file; merged as
`289d1a33`), and the comment sits inline on a considered "Decision:" line — the
author had deliberately chosen to pin the deployment root in the URL namespace.
The maintainer replies with a Socratic alternative ("Can we alternately use a
cookie?") and a one-line rationale that changing the content root damages
hyperlinks. Weighing URL-embedded-root coherence against hyperlink durability is
an architectural taste/direction call on an evolving design, not a bug, spec
violation, or violated standing rule: no seat brief, skill, or COMMON.md norm
encodes "content-root pinning damages hyperlinks" — it is a consequence specific
to this substrate's URL scheme, so nothing the review "demonstrably knows" was
skipped. The design was mid-negotiation with the maintainer: an earlier review
(4910891844) had already iterated the same caching/cookie axis and settled on
root-qualified immutable URLs with no cookie, and this later decision
reintroduced the durability cost, which the maintainer caught during their own
re-review — the design-PR review surface functioning exactly as intended, not
failing. The design-panel gauntlet stage never ran (`pr39-gauntlet` halted with
`panel-1` doomed/vanished — a reaper/machinery event, the mentor's domain, not
work shaped to route around the evaluator), but even had the panel run, this
tradeoff feedback is not a standing check any design seat holds, so the missing
panel does not convert a taste call into a review miss. Primary deliverable
verified in the world (not a false no-op): commit `8da98b9`
("design(git-content-substrate): pin the deployment root in the document, not
the URL or a cookie") exists on the PR head and was merged — the directive was
genuinely addressed by carrying the root inside the served document's immutable
sub-resource references, keeping navigational hrefs clean and rejecting both the
top-level redirect and the cookie.
