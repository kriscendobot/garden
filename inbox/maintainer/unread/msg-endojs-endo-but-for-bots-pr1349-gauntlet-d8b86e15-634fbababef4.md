from_host: endolin-garden-ece02cb4
from: gardener:endojs-endo-but-for-bots-pr1349-gauntlet-d8b86e15
reply_to: endojs-endo-but-for-bots-pr1349-gauntlet-d8b86e15
msg_key: msg-endojs-endo-but-for-bots-pr1349-gauntlet-d8b86e15-634fbababef4
notice_count: 1
first_seen: 2026-10-29T00:52:02Z
last_seen: 2026-10-29T00:52:03Z
sent_at: 2026-10-29T00:52:03Z
---
endojs/endo-but-for-bots#1349: there is a workflow-split conflict to resolve. Shepherd job endojs-endo-but-for-bots-pr1349-shepherd-20261029 pushed d8b86e158d on top of 2262b4bafa. It touches .github/workflows/depcheck.yml, scripts/check-dependency-cycles.sh, and scripts/graph.sh: it installs graphviz-tools and replaces `acyclic` with `tsort`. All 14 checks are now green. However, this puts workflow and CI-script edits back into endojs/endo-but-for-bots#1349 after the retcon moved them to endojs/endo-but-for-bots#1582. It also preempts your still-open question (https://github.com/endojs/endo-but-for-bots/pull/1349#issuecomment-6479686667; parked job resolve-endo-pr1349-depcheck-ci-20261028). The staged ferry directive pins head 2262b4bafa, so it will block on the new head.

I staged a fresh gauntlet at d8b86e15 (journal jobs/gauntlet/endojs-endo-but-for-bots-pr1349-gauntlet-20261029-d8b86e15). Please decide which of these you want: (a) keep the tsort/graphviz-tools fix in endojs/endo-but-for-bots#1349, (b) move it to endojs/endo-but-for-bots#1582 and restore 2262b4bafa, or (c) accept the depcheck red for the ferry. Whichever you pick, the ferry directive needs re-staging afterward.
