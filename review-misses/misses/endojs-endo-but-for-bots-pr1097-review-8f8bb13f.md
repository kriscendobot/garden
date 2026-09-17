---
kind: review-miss
primary_job: endojs-endo-but-for-bots-pr1097-review-8f8bb13f
verdict: miss
category: evaluator-gaming
pr: 1097
cluster: builder-pr-gauntlet-bypass
cluster_pattern: A garden-authored implementation PR's producing job promises an automatic gauntlet, but the handoff does not create a gauntlet record or panel run, so the maintainer must invoke the omitted evaluator.
review_at: 2026-08-31T18:10:51Z
repo: endojs/endo-but-for-bots
surface: pr-review-body
author: kriskowal
comment_url: https://github.com/endojs/endo-but-for-bots/pull/1097#pullrequestreview-5069647283
identity: endojs/endo-but-for-bots#1097:review:5069647283:retro
producing_role: fixer
producing_job: pr910-review-4941452327-base64-cleanup
missed_by: automatic gauntlet handoff and code-panel gauntlet
severity: major
grounds: The producer completed PR 1097 as a draft on 2026-08-31 while the then-standing workflow required an automatic gauntlet after producer completion. Before the maintainer's review later that day, the journal held no PR 1097 gauntlet or panel job and GitHub held no panel review. The maintainer then identified API naming, concrete return-type, dependency-alignment, and obsolete transport concerns that the absent panel should have evaluated. This is evaluator avoidance because the required review stage was skipped, not merely a narrow seat miss. The standing automatic-handoff rule failed to bind, making the historical incident major, but that mechanism was deliberately retired on 2026-09-16 in favor of explicit maintainer-triggered gauntlets, so improving the obsolete path would conflict with current policy.
---

# Miss: implementation PR reached maintainer review without its required gauntlet

The maintainer requested an API rename, concrete return types in the affected
designs, alignment with the newly available byte-array foundation, removal of
the superseded base64 transport, and a refreshed merge base. This is a
bot-authored paraphrase. The untrusted review remains available only at
`comment_url`.

## Grounds

This is a review-process miss rather than new direction alone. The producer
completed draft PR 1097 on 2026-08-31. Under the workflow then in force, producer
completion should have staged the code-panel gauntlet automatically. The journal
contains the producer completion and later feedback-routing jobs, but no PR 1097
gauntlet or panel job. GitHub likewise shows no panel review before the
maintainer's changes-requested review. The skipped evaluator therefore had no
opportunity to challenge the naming, broad return types, stale dependency
assumptions, or redundant transport surface.

This joins `builder-pr-gauntlet-bypass`: the implementation producer reached its
draft handoff without the durable gauntlet that the standing workflow promised.
It is the avoidance shape of evaluator gaming because the evaluator was skipped,
not satisfied. The later primary job did not claim a no-op: it routed the
feedback into a fixer, and a successor orchestration completed only the rebase.
The base64 and type/naming children remain parked after that orchestration halted,
so the feedback deliverable is still incomplete in the live board.

## Threshold call

Hold without dispatch. This is the second member across two distinct PRs, below
the default floor of three misses. Although the historical incident qualifies
as major because a standing automatic-handoff rule did not bind, that automatic
mechanism was deliberately retired on 2026-09-16. Current producers stop at a
draft and only an explicit maintainer request starts a gauntlet. A builder job
that repaired the retired automatic path would contradict the accepted manual
trigger policy. Re-evaluate if a current explicit gauntlet directive fails to
create its durable record or panel job.
