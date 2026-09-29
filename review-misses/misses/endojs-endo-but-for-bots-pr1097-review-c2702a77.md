---
kind: review-miss
primary_job: endojs-endo-but-for-bots-pr1097-review-c2702a77
verdict: miss
category: process
pr: 1097
cluster: outstanding-maintainer-directive-dropped
cluster_pattern: A still-live maintainer directive on a PR is dropped (its feedback stage withdrawn as superseded on grounds covering only a sibling ask, or an unresolved maintainer thread deferred by the panel as out-of-diff), so the PR reaches approval with the ask undone and the maintainer must re-ask.
review_at: 2026-09-29T05:21:57Z
repo: endojs/endo-but-for-bots
surface: pr-review-body
author: kriskowal
comment_url: https://github.com/endojs/endo-but-for-bots/pull/1097#pullrequestreview-5348027197
identity: endojs/endo-but-for-bots#1097:review:5348027197:retro
producing_role: gardener
producing_job: endojs-endo-but-for-bots-pr1097-drop-base64-20260904
missed_by: feedback-stage withdrawal (pr1097-drop-base64-20260904) and the code-panel gauntlet (benchmarker deferred the open thread as out-of-diff)
severity: moderate
grounds: The review has two asks. Advancing the base pin is routine drift and is not a miss by itself. The streamBase64 migration is not new direction. On 2026-08-31 the maintainer left an inline thread on this PR saying that passable byte arrays had arrived and every base64 streaming facility could be trimmed. The garden routed it to the stage job pr1097-drop-base64-20260904. That job was later withdrawn as superseded, but the recorded reason covered only the dead getInfo rename; nothing addressed the base64 ask. The thread stayed unresolved. The 2026-09-28 gauntlet (panel rounds 1 to 4 in journal/jobs/tada) saw it: benchmarker noted the maintainer's base64-streaming thread was unresolved and deferred it as outside the diff. The panel then passed. The PR reached approval with a standing maintainer directive undone, and the maintainer had to ask again. This is a process miss. A live ask was dropped by a withdrawal whose grounds did not cover it, and the panel noticed the open maintainer thread but did not treat it as blocking or route it.
---

# Miss: a live maintainer base64-trim directive was dropped and then deferred by the panel

The maintainer asked for the base pin to be advanced. They also asked for the
PR's streamBase64 usage to move to plain `stream()` over passable byte arrays,
since streamBase64 is or will be deprecated, followed by a retcon and a
conduct. This is a bot-authored paraphrase. The untrusted review is available
only at `comment_url`.

## Grounds

The same direction already appeared in the maintainer's inline thread of
2026-08-31, which said to trim every base64 streaming facility now that
passable byte arrays exist. The feedback orchestration's
`drop-base64-20260904` stage was withdrawn with a reason about the getInfo
rename being superseded. That reason did not supersede the base64 ask, and no
other job picked the ask up. During the 2026-09-28 gauntlet, benchmarker
flagged the maintainer's unresolved base64 thread and classed it as a
follow-up outside the diff. No follow-up was posted, and the panel passed. The
maintainer then had to re-issue the ask at approval time. The base pin half of
the review is ordinary drift and is not counted.

## Primary deliverable check

I checked the world directly. The primary `endojs-endo-but-for-bots-pr1097-review-c2702a77`
and its child `pr1097-stream-bytes-20260929` are in `jobs/tada/`. PR 1097
merged at 2026-09-29T18:07:54Z (merge commit `7ff30afbce`). Its commits add a
byte-array `stream()` to exo-stream bytes readers and populate the platform
read cache through `stream()`. A garden comment on the PR reports the base pin
advanced to `llm-1706e63`. The directive was delivered.

## Threshold call

Hold without dispatch. This is the first member of a newly minted cluster
from one PR, below the floor of three misses across two PRs. Severity is
moderate, so the major bypass does not apply. Candidate prevention and
sensing if the cluster grows: (a) a withdrawal must enumerate each maintainer
ask the withdrawn stage carried and name where each is covered; (b) the panel
(or a deterministic panel-stage check) must treat an unresolved maintainer
review thread on the PR as blocking, or route it to a job, rather than
deferring it as out-of-diff.
