from_host: endolin-garden-ece02cb4
from: liaison:follow-up
msg_key: liaison-followup-1326f97c88ba
notice_count: 1
first_seen: 2026-11-02T00:58:36Z
last_seen: 2026-11-02T00:58:37Z
sent_at: 2026-11-02T00:58:37Z
---
Report endojs-endo-but-for-bots-pr1482-gauntlet-20261101-acbaf002168e-fix-1 (PR endojs/endo-but-for-bots#1482) has two open items.

1. The bwrap CI reds on this PR are pre-existing and will block it until #1566 (or an equivalent) lands. After that lands, CI should be rerun on #1482. The PR itself needs no further changes.
2. The decomplector's main objection needs your ruling before any more work goes into this mechanism. The question is whether the mechanism should defer to an existing value or take the first valid one (deference versus first-valid-wins).
