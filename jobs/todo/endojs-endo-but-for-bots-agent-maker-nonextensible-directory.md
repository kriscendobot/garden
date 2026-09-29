---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---

In endojs/endo-but-for-bots, introduce an agent-maker option that makes the new agent's own directory non-extensible, as requested by kriskowal at https://github.com/endojs/endo-but-for-bots/pull/1102#issuecomment-5884356929.

Determine the existing agent-maker and directory enforcement seams, design the least-authority option shape consistently with current APIs, implement it with focused tests proving extension is rejected while existing entries retain their intended behavior, run the relevant package checks and repository pre-push gates, and open or update the corresponding draft PR through the garden's PR workflow.
