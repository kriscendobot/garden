---
role: conductor
tier: mentor
fallback-tier: minion
dispatch: automatic
requires: host=endolin-garden-ece02cb4
---
# Conduct endojs/endo-but-for-bots PR #1389 (endolin relay)

Repo: endojs/endo-but-for-bots
PR: https://github.com/endojs/endo-but-for-bots/pull/1389 ("design(parcel): layer 1 Parcel shim contract and authority split", head design/sturdyref-shim-contract @ 8881c6d939, base llm-54d3d2a — frozen snapshot, must be unfrozen to live `llm`)
Authorization: kriskowal APPROVED review https://github.com/endojs/endo-but-for-bots/pull/1389#pullrequestreview-5609874927 — "@kriscendobot conduct".
Task: finalize and merge per the conductor role: run `ci-wait-merge.sh endojs/endo-but-for-bots 1389` from the isolated project worktree (single commit; no tidy needed).

Why pinned: predecessor job conduct-endojs-endo-but-for-bots-pr1389 on oros-studio-garden-ce242c49 hit `updatePullRequest` 403 (bot PAT lacks PR write on endojs there) at the unfreeze step `gh pr edit --base llm`; nothing was pushed or changed on the PR.
