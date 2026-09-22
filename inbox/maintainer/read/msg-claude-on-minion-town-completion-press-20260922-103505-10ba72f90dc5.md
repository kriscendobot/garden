from_host: endolin-garden-ece02cb4
from: gardener:claude-on-minion-town-completion-press-20260922-103505
reply_to: claude-on-minion-town-completion-press-20260922-103505
msg_key: msg-claude-on-minion-town-completion-press-20260922-103505-10ba72f90dc5
notice_count: 1
first_seen: 2026-09-22T10:42:01Z
last_seen: 2026-09-22T10:42:04Z
sent_at: 2026-09-22T10:42:04Z
---
Arc (kriscendobot/garden#89) completion-press — 2 doomed follow-ups need a re-post call. Overall the arc is healthy: this window landed the full split-pr1125 stack (endojs/endo-but-for-bots#1304, endojs/endo-but-for-bots#1305, endojs/endo-but-for-bots#1306 all merged) plus kriscendobot/minion.town#87 (Claude-agents capability wiring), kriscendobot/minion.town#98, kriscendobot/minion.town#99, kriscendobot/minion.town#104. The heavy pr1304/1305/1306 conduct/shepherd doom churn and the two HALTED orchestrations resolved themselves — the PRs merged through other conduct paths, so no action there.

Two arc jobs doomed in-window and are NOT self-resolved:

1. endojs-endo-but-for-bots-pr1015-refresh-for-review-20260919 — requeue-exhausted (repeated-plain-exit), 2 cycles, doomed 2026-09-21T23:23Z on endolin-garden-ece02cb4. No successor posted. endojs/endo-but-for-bots#1015 (the @endo/claude confinement core) is still an OPEN DRAFT and never reached review. This is the piece the minion.town Claude-agents wiring is fail-closed pending, so its stall holds up the arc's payoff. Worth a re-post (or a look at why the refresh keeps plain-exiting).

2. fix-minion-town-claude-harness-supply-chain-hardening — requeue-exhausted (repeated-plain-exit), 2 cycles, doomed 2026-09-18T08:23Z on endolin-garden-ece02cb4. The release.json signature re-verification hardening (re-verify checksums against a tracked signed manifest in check.mjs/CI); not superseded by the kriscendobot/minion.town#99 / kriscendobot/minion.town#87 merges. Parked; needs a maintainer call on re-posting.

Context: neither this press nor the outward claude-on-minion-town-press dispatched between 2026-09-18T02:35Z and now (~4 days) — likely the deliberate schedule pause / quota — which is why the stack merges and these two dooms went unreported until this tick. Both doomed jobs are on endolin-garden-ece02cb4 with the same repeated-plain-exit signature; if that host keeps plain-exiting long arc jobs it may warrant a look, but I'm not asserting a host fault. A doomed job promotes only on your authorization; I did not touch the board.
