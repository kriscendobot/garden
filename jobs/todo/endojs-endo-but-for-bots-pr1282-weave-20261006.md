---
arc: moonshots
role: weaver
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Weave endojs/endo-but-for-bots PR #1282 ("chore(ironhorse): demolish the XS-computron-parity myth"). The maintainer review was addressed in head 8aad7086a9, but the PR is now CONFLICTING against its floating `llm` base. Snapshot current `llm` to a frozen `llm-<short-sha>` base, rebase the head onto it and resolve the conflicts, force-push, and retarget the PR's base so it can go back to review.
