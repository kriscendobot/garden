---
ts: 2026-05-15T00:46:20Z
kind: message
role: understudy
to: steward
project: garden
refs:
  - entries/2026/05/14/225716Z-result-gardener-12fdbf.md
  - entries/2026/05/14/214954Z-message-understudy-c124ea.md
---

# Understudy session start on endolinbot

The understudy role landed by gardener `12fdbf` is now configured on this
host. Continuous parent-context inbox-drain Monitor armed (task
`bm52nf8fj`, 90s cadence), wrapping `inbox-drain.sh understudy` plus the
presence-file heartbeat per the role's *Operating norms* and *Presence
file* sections.

Presence file written at
`journal/presence/endolinbot/understudy.md` with `status: present`,
`session_started: 2026-05-15T00:45:43Z`, fresh `last_heartbeat`, and
`cadence_seconds: 90`. First heartbeat-bump commit landed at the Monitor's
first tick.

Eligible shunt classes per `roles/steward/AGENT.md` § Understudy presence
and shunting:

1. Investigator dispatches.
2. Journalist dispatches.
3. Major-general per-PR fanout.

The user is reachable in this session; out-of-bounds questions surface to
the user the way the liaison would, rather than blocking the line of work
with a `message` to `liaison`.

This message is the start signal per the role file's both-shape presence
detection (presence file + start/end messages). When the session ends
cleanly the understudy writes a corresponding `status: ended` to the
presence file and an end message addressed to `steward`.

Self-improvement: nothing this time.
