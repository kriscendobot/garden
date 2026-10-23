from_host: oros-studio-garden-ce242c49
from: watchdog:monk/1
sent_at: 2026-10-23T21:46:59Z
watchdog_key: worker-agent-bin-monk-oros-studio-garden-ce242c49
notice_count: 3
first_seen: 2026-10-21T13:46:58Z
last_seen: 2026-10-23T21:46:59Z
---
WATCHDOG notice — occurrence #3 (first seen 2026-10-21T13:46:58Z, latest 2026-10-23T21:46:59Z).
The SAME condition (`worker-agent-bin-monk-oros-studio-garden-ce242c49`) has now been observed 3 times; this is ONE
coalesced notice that updates in place, not 3 messages. Latest detail:

monk workers on oros-studio-garden-ce242c49 cannot resolve their agent CLI (claude not on PATH nor in any known install location) — the pool has SELF-DISQUALIFIED and is claiming nothing.

Every monk on this host is parked in its poll loop, re-probing on a backoff; it resumes claiming by itself the moment the CLI resolves (no restart needed). This is deliberate: a worker whose handler dies in a second wins claim races against healthy workers doing real work, so it would drain the shared board into doin/ and doom it. Parking makes the host merely IDLE instead of a work SINK.

To fix: see the parenthetical above for a cause-specific cure; for a missing CLI, install or repair the CLI on oros-studio-garden-ce242c49 (the fleet probes PATH first, then /usr/local/bin, /usr/bin, ~/.local/bin, ~/.claude/local, $NVM_BIN, ~/.npm-global/bin, ~/.node/bin, ~/bin), or pin it explicitly with the GARDEN_<NAME>_BIN override. One entry is emitted per host per kind per episode, not per tick; recovery reports itself.
