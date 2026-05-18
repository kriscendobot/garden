---
created: 2026-05-13
updated: 2026-05-18
author: liaison, gardener
---

# Skill: monitor-arming

How to arm a `Monitor` tool over a long-lived daemon you do not control end-to-end. The key invariant: silence on a Monitor that wraps a daemon does not entail silence in the underlying source; bridge that gap with active confirmation. The Monitor tool's own help warns that "silence is not success", but that warning is local to the watcher. When the wrapped layer is a daemon written by a different agent, the failure mode can live entirely in the emit path and the Monitor will look healthy throughout.

## When to use

Any time a role arms a `Monitor` over a daemon's log file, especially when the daemon and the Monitor are written by different agents or stewards. The motivating example is the steward's standing-monitors discipline (four bash poll daemons against the GitHub events API, each with its `Monitor` wrapper tailing the daemon's stdout log). The same shape applies to any future "daemon writes lines, Monitor surfaces them" arrangement.

## Patterns

Three patterns, in order of cost. Use as many as the situation warrants; the freshness check is the cheapest catch-all and is the recommended floor.

### Pre-arm probe

Before declaring the Monitor armed, the arming agent issues a deliberate event that the daemon *should* surface, watches the wrapped log for the signal, and only declares the Monitor armed once the signal arrives. The probe anchors the discipline at arm time: a Monitor that never received its probe is not armed, regardless of what its parent session thinks.

Example for the events-poll daemon: after `nohup`-starting the daemon, do not return from the arming routine until the daemon's first `NEW` line lands in the log (or, when none is expected because the repo is quiet, until a synthetic probe known to the daemon has surfaced). The arming agent's report includes the timestamp of the observed probe line, not just "Monitor armed".

### Out-of-band freshness check

The orchestrator's per-cycle survey compares each daemon's last-emitted-line timestamp against current time plus the daemon's cadence plus slack (e.g., 5x cadence). A daemon with cadence 30s that has not emitted in 10 minutes is suspect; verify by independently polling the underlying source (a single REST call confirms whether activity exists). If activity exists and the daemon log is silent, the daemon is broken; surface the condition and stop trusting the Monitor for that daemon until the underlying defect lands.

This is the cheapest pattern (one comparison per cycle plus, on suspicion, one REST call), it catches the broadest class of failure (any emit-path bug, any silent drop), and it would have caught the motivating incident in 2 to 5 minutes. Roles that arm long-lived Monitors should include a freshness check in their per-cycle survey by default.

**Companion check for wrapped skill-script Monitors.** When the wrapped layer is a skill script invoked by absolute filesystem path (the steward's inbox-drain Monitor is the canonical case), the freshness check must also confirm the script exists at the canonical `skills/<name>/<script>.sh` path. Silence on a wrapped-skill-script Monitor has two distinct causes: the underlying daemon stopped emitting (the standard case above) or the script file moved out from under the Monitor's hardcoded path (a working-tree refactor, a rebase-mid state, a stash). The path-fallback shape on `roles/steward/AGENT.md` § Path-fallback discipline for wrapped skill scripts closes the second cause structurally; this freshness-check companion catches the residual case where both paths in the fallback have gone missing.

### Active heartbeat

The daemon emits a periodic heartbeat line that the Monitor's filter matches; the Monitor wakes the parent session on a missing-heartbeat schedule. More state (the daemon needs a heartbeat emitter, the Monitor's filter must accept heartbeat lines without treating them as work), but it guarantees a wake on any failure that stops emission. Probably overkill for the current standing monitors, where the freshness check above suffices. Worth reaching for when the underlying source has long natural quiet periods and the freshness check cannot reliably distinguish "daemon is broken" from "nothing is happening upstream".

## Notes from the field

(Terse and dated. Append; do not rewrite history.)

- _2026-05-13_: the standing-monitors discipline's `monitor-poll.sh` bug (Push-event id range pushes `last_event_id` past every subsequent comment) silently dropped events for ~2 hours before the maintainer hand-delivered the missed comment URL. The Monitor was healthy and the filter was correct; the daemon stopped emitting the matching lines. This is the canonical motivating example for the out-of-band freshness check.
- _2026-05-18_: two same-pattern inbox-drain Monitor outages within 48 hours on `endolinbot` precipitated the path-fallback discipline on `roles/steward/AGENT.md` and the companion-check paragraph in the *Out-of-band freshness check* section above. See `journal/entries/2026/05/17/204600Z-message-steward-58a3c1.md` and `journal/entries/2026/05/18/200000Z-message-steward-c3a91d.md`. Both incidents traced to a stuck interactive rebase on the host pinning the working tree at a commit whose layout differed from the Monitor's hardcoded skill-script path; the fallback shape covers both directions of the move.
