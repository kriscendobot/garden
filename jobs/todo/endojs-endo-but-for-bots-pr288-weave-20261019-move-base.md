---
role: weaver
tier: mentor
requires: host=endolin-garden-ece02cb4
fallback-tier: minion
dispatch: automatic
---
Move the base of https://github.com/endojs/endo-but-for-bots/pull/288 to the frozen snapshot `llm-330cf99`. That is the whole task. Weave job endojs-endo-but-for-bots-pr288-weave-20261019 already rebased the head onto it. That job ran on oros-studio, where the bot token gets a 403 on `updatePullRequest`.

Before you change anything, check that:
- the PR head is still `3ee08149e7727ee259dd5d6b37ebb63f929b1024` (`gh pr view 288 -R endojs/endo-but-for-bots --json headRefOid`);
- `llm-330cf99` exists on endojs/endo-but-for-bots at `330cf996c0b9b3a2cd8a9c007751499286bb8a80`, which is the head's merge base.

If both hold, run:
    gh pr edit 288 -R endojs/endo-but-for-bots --base llm-330cf99
Then confirm `/Users/dom/garden/scripts/jobs/gardening/assert-pinned-base.sh pr endojs/endo-but-for-bots 288` exits 0.

If the head has moved, stop. Report the new head instead of editing.

Do not rebase, push, or comment. Nothing besides the base field changes.
