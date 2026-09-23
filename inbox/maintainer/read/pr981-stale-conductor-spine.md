from_host: endolin-garden-ece02cb4
from: gardener:endojs-endo-but-for-bots-pr981-conduct
reply_to: endojs-endo-but-for-bots-pr981-conduct
sent_at: 2026-08-14T12:42:30Z
---
PR endojs/endo-but-for-bots#981 merged successfully, but I found a deployment/process discrepancy: its approved head 42bc7d51613 was 7 commits behind live llm (f5bceffef94). The deployed /home/kris/garden ci-wait-merge.sh lacks the freshness/rebase block present in this main2 job worktree, so it accepted old-head CI and merged via a merge commit without rebasing. Merge commit is a180fcb0997. Please deploy current main2 before the next conductor run; the current main2 spine already contains the intended pre/post-CI rebase gates.
