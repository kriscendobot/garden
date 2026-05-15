# Presence index

The presence directory carries one file per long-running session whose presence the steward (or another agent) must detect. Today only the understudy uses it, but the shape is general: any reachable session that another role needs to detect can write a file here.

## Path

```
presence/<host>/<role>.md
```

`<host>` is `hostname -s`, matching the convention used by `worktrees/<host>/` and `inboxes/<host>/`. Each host has at most one session per role at a time.

## Frontmatter schema

```yaml
---
hostname: <host>                       # short hostname
role: <role>                           # the role whose presence this file declares
status: present                        # present | ended
session_started: <ISO>                 # UTC, set once at session start
last_heartbeat: <ISO>                  # UTC, bumped each Monitor tick
cadence_seconds: <int>                 # the session's own heartbeat interval; informs the consumer's staleness threshold
---

<optional prose: what the user named this session for, scope hints>
```

The optional prose body is free-form. Consumers do not parse it; it is for human or LLM context only.

## Lifecycle

- **Start.** On the session's first turn, the session writes the file with `status: present`, fresh `session_started`, and `last_heartbeat = session_started`. The session also sends a session-start `message: <role> -> <consumer-role>` entry (see the role's own AGENT.md for the convention). The file and the message are complementary: the file is the heartbeat signal, the message is the start signal.
- **Heartbeat.** On each tick of the session's continuous Monitor, `last_heartbeat` is bumped. The Monitor command may run a small inline heartbeat-writer, or the session may bump the field on each wake the LLM session itself processes; both shapes satisfy the discipline. Each heartbeat is a cheap single-line edit committed via `skills/journal-sync/SKILL.md`.
- **Stop.** On clean shutdown, the session sets `status: ended` and commits. An unclean shutdown leaves `status: present` with a stale `last_heartbeat`; consumers treat that as absent via a staleness threshold.

## Consumer discipline

A consumer (e.g. the steward, when deciding whether to shunt eligible work to a present understudy) reads every file in `presence/<host>/` whose role matches the one it cares about. For each file:

1. If `status` is not `present`, the session is not reachable.
2. If `status` is `present` but `last_heartbeat` is older than the consumer's staleness threshold (default 3x the session's `cadence_seconds`, capped at 5 minutes), the session is treated as absent (probably uncleanly ended).
3. Otherwise the session is reachable; the consumer may shunt or otherwise interact per its own role's rules.

The staleness threshold is the consumer's standing rule, not a per-session knob. The session's `cadence_seconds` is advisory and informs the default threshold; the consumer can be stricter if its work is time-sensitive.

## Per-role tenants

- **understudy**: `presence/<host>/understudy.md`. The steward reads this file each cycle; see `roles/understudy/AGENT.md` § Presence file and `roles/steward/AGENT.md` § Understudy presence and shunting.
- **general-contractor**: `presence/<host>/general-contractor.md`. No autonomous consumer as of authoring date; the file is the maintainer's signal (and any liaison session asking "is a contractor running on this host") that the four-day contractor adoption is live. See `roles/general-contractor/AGENT.md` § Presence file for the producer-side discipline.

Other roles may join the index as their presence becomes consumer-relevant. New tenants add a row here and document the producer-side and consumer-side rules on the respective role files.
