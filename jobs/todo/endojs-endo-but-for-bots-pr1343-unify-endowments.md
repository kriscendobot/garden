---
role: fixer
handler-budget-role: review
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---

Champion the arbitrary guest-endowment work in endojs/endo-but-for-bots#1343, as directed by kriskowal at https://github.com/endojs/endo-but-for-bots/pull/1102#issuecomment-5884356929.

Replace the separate ordinary-name and special-name injection surfaces with one endowment mapping. The map's guest-side names determine policy: names beginning with `@` are special and indelible; other names are ordinary and mutable. Agent-facing values are providing-host pet names, never formula identifiers; resolve formula identifiers only behind the daemon boundary. Preserve retained-agent idempotence, restart persistence, formula-graph reachability, and clear failure behavior. Rebase before the follow-up, run the daemon tests plus lint/types and the repository pre-push gates, reply to applicable review threads with actual SHAs, and post a top-level completion summary.

PR endojs/endo-but-for-bots#1102 is the redundant design-only branch and is being closed so endojs/endo-but-for-bots#1343 is the sole champion.

<!-- garden-reaped: 0 -->
