from_host: endolin-garden2-5bcdff64
from: gardener:kriscendobot-minion-town-pr130-conduct-prod-validate-20260928-resume
reply_to: kriscendobot-minion-town-pr130-conduct-prod-validate-20260928-resume
msg_key: msg-kriscendobot-minion-town-pr130-conduct-prod-validate-20260928-resume-f6ef4f78484c
notice_count: 1
first_seen: 2026-09-29T22:39:24Z
last_seen: 2026-09-29T22:39:26Z
sent_at: 2026-09-29T22:39:26Z
---
kriscendobot/minion.town#130 conduct STALLED: needs weave (or close as superseded).

- Your APPROVED review on kriscendobot/minion.town#130 (head d24effe) is present, but main moved to 7e87a44: kriscendobot/minion.town#139 ("endo daemon probes must not auto-start a stray daemon") merged 21:59Z. It rewrote the same deploy-endo-daemon.sh probe/rollback blocks, so kriscendobot/minion.town#130 now has a code conflict in that file. A conductor may not resolve a code conflict, so I did not unfreeze, rebase, or merge.
- kriscendobot/minion.town#139 already covers kriscendobot/minion.town#130's main fix: probes run only against a socket that accepts connections, with auto-start sandboxed away from :8920 and the real state, plus a reap of stray processes outside the unit cgroup. kriscendobot/minion.town#139's CD run https://github.com/kriscendobot/minion.town/actions/runs/36636831952 is green, and POST https://minion.town/api/guest returns 201 now.
- What kriscendobot/minion.town#130 adds on top of kriscendobot/minion.town#139: `endo stop` after `systemctl stop`, which reaps pid-file workers; stopping the daemon before the /opt/endo swap (start instead of restart); and a regression test in endo-pin-drift.test.ts. kriscendobot/minion.town#137 (ExecStartPre port reaper) is a third overlapping fix that is still open.
- Deciding question: is kriscendobot/minion.town#130's `endo stop` pid-file reap still wanted on top of kriscendobot/minion.town#139's cgroup reap? If yes, reply "weave kriscendobot/minion.town#130" and it will be rebased onto kriscendobot/minion.town#139 and then conducted. If no, close kriscendobot/minion.town#130 as superseded by kriscendobot/minion.town#139.
- I have not acted on your review note ("investigate ways to make the daemon controls more idempotent upstream"). Conductors do not post follow-ups, so please have it posted as a job, e.g. an endo design or research job on idempotent start/stop in the daemon CLI.
