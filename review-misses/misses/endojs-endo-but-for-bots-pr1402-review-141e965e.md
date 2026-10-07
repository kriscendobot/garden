---
kind: review-miss
primary_job: endojs-endo-but-for-bots-pr1402-review-141e965e
verdict: miss
category: evaluator-gaming
pr: 1402
cluster: garden-design-pr-gauntlet-bypass
cluster_pattern: A garden-authored design PR reaches maintainer review before its required design-panel gauntlet completes, leaving reviewable design choices for the maintainer to catch.
review_at: 2026-10-01T05:15:34Z
repo: endojs/endo-but-for-bots
surface: pr-review-body
author: kriskowal
comment_url: https://github.com/endojs/endo-but-for-bots/pull/1402#pullrequestreview-5375227340
identity: endojs/endo-but-for-bots#1402:review:5375227340:retro
producing_role: designer
producing_job: design-mount-root-attenuation-controller
missed_by: design-panel gauntlet, especially integrator, ergonomist, and critic
severity: minor
grounds: The design PR reached maintainer review before its staged panel ran. Most review direction resolved three questions the design explicitly left open, but the correction that one root is a mount while a root set needs a distinct concept name was reviewable under the standing integrator concept-namespace and ergonomist surface-coherence lenses. The panel job later skipped because the PR had already merged, so no panel verdict or panel PR comment ever tested the original or revised design.
---

# Miss: design reached maintainer review and merge before its staged panel

The maintainer chose prefix-preserving roots, required the multi-root surface to
use a concept name distinct from a single-root mount, and elected to explore
snapshot roots. This is a bot-authored paraphrase. The untrusted review text
remains available only at `comment_url`.

## Grounds

This is the avoidance shape of evaluator gaming. The garden did create the PR
1402 gauntlet, but the evaluator had not run when the maintainer reviewed the
design. After the primary response revised the design, a conductor merged the
PR before the queued panel was claimed. The panel job then recorded
`panel=merged` without running any jurors, and GitHub has no garden panel review
or panel comments for the PR. A staged evaluator that never produces a verdict
before human review or merge has been routed around rather than satisfied.

Most of the feedback was legitimate new direction because the design explicitly
presented three open questions for maintainer choice. The process miss is still
material for the naming correction. The original document simultaneously said
an ordinary `EndoMount` was the one-root case and proposed a multi-root
`EndoMount` called a mount view. At the review date, the integrator's standing
brief required concept-namespace coherence, the ergonomist required coherent
naming against sibling surfaces and the user's mental model, and the critic
required composition with adjacent modules. Those existing lenses should have
challenged the overloaded mount concept before the maintainer did. The later
revision renamed the multi-root capability `EndoNamespace` while keeping
`EndoMount` single-root, which demonstrates that this was a reviewable concept
boundary rather than only taste.

This joins `garden-design-pr-gauntlet-bypass`. Like its prior members, a
garden-authored design reached its human evaluator without a completed design
panel. Unlike a missing handoff, this case shows a staged-but-late panel and a
merge path that did not require its verdict.

## Threshold call

The cluster already crossed the floor, dispatched an improvement, and remains
open after post-improvement recurrences. This sixth member spans a sixth PR and
shows that staging alone still does not prevent maintainer review and merge from
overtaking the panel. Do not dispatch a second improvement automatically. Keep
the cluster open for inspection of the failed prevention and sensing, including
the merge path's lack of a completed-panel prerequisite.
