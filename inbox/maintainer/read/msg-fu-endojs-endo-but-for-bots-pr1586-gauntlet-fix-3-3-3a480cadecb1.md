from_host: oros-studio-garden-ce242c49
from: gardener:fu-endojs-endo-but-for-bots-pr1586-gauntlet-fix-3-3
reply_to: fu-endojs-endo-but-for-bots-pr1586-gauntlet-fix-3-3
msg_key: msg-fu-endojs-endo-but-for-bots-pr1586-gauntlet-fix-3-3-3a480cadecb1
notice_count: 1
first_seen: 2026-10-31T18:52:10Z
last_seen: 2026-10-31T18:54:20Z
sent_at: 2026-10-31T18:54:20Z
---
endojs/endo-but-for-bots: the recurring red check `bwrap › bwrap timeout and repeated cancellation reap process groups` ("process group N survived bounded cleanup") is a real containment race in the bwrap driver, not a CI flake. It also turned https://github.com/endojs/endo-but-for-bots/pull/1586's cover job red. Your merge of https://github.com/endojs/endo-but-for-bots/pull/1542 is what clears it.

- Cause: a group SIGTERM that lands during bwrap's namespace setup kills the outer launcher before the sandbox init arms `--die-with-parent`. The init is a pid-namespace init, so it ignores the SIGTERM. It then either stays stuck in the group (the CI signature) or calls `setsid` and runs the sandboxed command orphaned.
- I reproduced it against real bwrap 0.9 on oros. Leaked sandboxes per 350 kills, 0–30ms after spawn:
  - group SIGTERM (the current driver): 65
  - group SIGKILL: 3
  - SIGTERM, then a group SIGKILL when the leader exits (the https://github.com/endojs/endo-but-for-bots/pull/1591 approach): 12
  - group SIGKILL plus SIGKILL of the init pid reported by bwrap's status fd: 0, across 700 trials
- https://github.com/endojs/endo-but-for-bots/pull/1542 (green, un-drafted, waiting on your merge since 2026-10-24) takes the init-kill approach via `--info-fd` and adds a setup-window regression test. https://github.com/endojs/endo-but-for-bots/pull/1591 is the weaker leader-exit sweep. Its viability stage already called it superseded by https://github.com/endojs/endo-but-for-bots/pull/1542, and these numbers back that up.
- Ask: merge https://github.com/endojs/endo-but-for-bots/pull/1542 and close https://github.com/endojs/endo-but-for-bots/pull/1591. PRs on the `llm-9a14ddf` base, https://github.com/endojs/endo-but-for-bots/pull/1586 among them, need a weave to pick up the fix. Meanwhile, job `fu-endojs-endo-but-for-bots-pr1586-gauntlet-fix-3-3-rerun` (pinned to endolin) reruns https://github.com/endojs/endo-but-for-bots/pull/1586's cover job and reports on the PR.
