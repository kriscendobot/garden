from_host: endolin-garden2-5bcdff64
from: gardener:claude-on-minion-town-completion-press-20260919-025019
reply_to: claude-on-minion-town-completion-press-20260919-025019
msg_key: msg-claude-on-minion-town-completion-press-20260919-025019-2682b23ba6f9
notice_count: 1
first_seen: 2026-09-19T03:00:51Z
last_seen: 2026-09-19T03:00:56Z
sent_at: 2026-09-19T03:00:56Z
---
**Arc (kriscendobot/garden#89) completion press — leader-host fault now bottlenecks the endojs/endo-but-for-bots#1125 stack (4th consecutive tick).**

Good news first: **endojs/endo-but-for-bots#1304 (CapTP slice 1/3) MERGED** this window (21:05Z) — but you merged it BY HAND; the bot's authorized conductors doomed. Receipt landed.

The bad news is the same host fault, unremediated: **3 arc conductor/review jobs doomed in-window, all `requeue-exhausted` / `repeated-plain-exit` / `deadline_overruns:0` on the LEADER host `endolin-garden-ece02cb4`:**
- `endojs-endo-but-for-bots-pr1305-conduct` @ 21:33Z
- `endojs-endo-but-for-bots-pr1306-conduct` @ 22:13Z
- `endojs-endo-but-for-bots-pr1306-review-3ed76637` @ 22:43Z

**What it blocks:** endojs/endo-but-for-bots#1306 (2/3) is un-drafted, `mergeable=CLEAN`, base=`llm`, head `9e16e50b1` — ready to merge but its conductor dies on ece02cb4 (also awaits your re-approval: the rebase narrowed the approved surface by retiring the forgeable `isReadOnlyDirectoryFormula`). endojs/endo-but-for-bots#1305 (3/3) is `mergeable=CLEAN`, stacked on the 2/3 branch. Both are one clean conductor run from landing; they can't get one on that host. `pr1306-retcon` has been in `doin` ~4h (your "Shepherd, retcon, conduct" comment) — watching, not yet alarming.

**The pattern:** every long conductor/review job routed to `endolin-garden-ece02cb4` exits clean-early before completing (the `deadline_overruns:0` + `repeated-plain-exit` signature is consistent with quota/credit exhaustion on that host — shorter jobs and jobs on other hosts complete fine). This is why you've had to hand-merge endojs/endo-but-for-bots#1304 and hand-drive the stack. NO remediation job exists on the board for that host; its last sysop-log entry is 09-07. It needs a look (quota/throttle/gc) before the doomed conducts are worth re-posting — promoting them onto the same host will re-doom. I observe only; the call is yours.
