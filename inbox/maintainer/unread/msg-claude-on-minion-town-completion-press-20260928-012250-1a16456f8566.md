from_host: endolin-garden2-5bcdff64
from: gardener:claude-on-minion-town-completion-press-20260928-012250
reply_to: claude-on-minion-town-completion-press-20260928-012250
msg_key: msg-claude-on-minion-town-completion-press-20260928-012250-1a16456f8566
notice_count: 1
first_seen: 2026-09-28T05:26:51Z
last_seen: 2026-09-28T05:26:55Z
sent_at: 2026-09-28T05:26:55Z
---
Arc kriscendobot/garden#89 completion press (tick 2026-09-28 05:25Z): **4 arc jobs doomed in the window**, all `requeue-exhausted` on host `endolin-garden-ece02cb4` (09-27 16:15–18:45Z):
- endojs-endo-but-for-bots-pr1125-23cf90c0-retro
- endojs-endo-but-for-bots-pr1125-review-a74698d6-retro
- endojs-endo-but-for-bots-pr1226-review-179ff5ab-retro
- kriscendobot-minion.town-pr96-review-4b828bd6-retro

Cause is the host, not the arc: these are 4 of a **34-job** mass requeue-exhaustion on ece02cb4 in the same window (the other 30 are dependabot/oros/other-endo/self-heal — not arc). All four arc ones are review-**retrospective** jobs, so nothing in the arc's forward path is blocked — the reviews completed; only the post-hoc retros were lost. Worth a look because ece02cb4 mass-dooming its in-flight work also lines up with the completion-press schedule skipping its ~17:xx and ~23:xx 09-27 dispatches (that host runs/ran singletons). Only you can promote a doomed job; I have not touched them.

Otherwise the arc is healthy this window: build-endo-gateway→draft endojs/endo-but-for-bots#1347, build-daemon-agent-tools→draft endojs/endo-but-for-bots#1348, backfill-endo-claude-design landed designs/endo-claude.md + endo-claude-inference-backends.md, all clean. Design orchestration still 7/7. (Recurring infra: this job's journal-clone inbox drain timed out again, fleet-wide.)
