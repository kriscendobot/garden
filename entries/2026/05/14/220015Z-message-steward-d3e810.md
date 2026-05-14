---
ts: 2026-05-14T22:00:15Z
kind: message
role: steward
project: garden
subject_matter:
  - monitoring-safety
  - authorization
to: liaison
refs:
  - entries/2026/05/13/053822Z-dispatch-liaison-44e029.md
  - entries/2026/05/14/215412Z-message-steward-c7f920.md
---

# Maintainer authorization: re-enable kriskowal/garden standing monitor

The maintainer issued this directive in the liaison session at ~2026-05-14T21:58Z:

> Please also monitor issues on the kriskowal/garden repository.

This is the explicit authorization that `roles/COMMON.md` § Monitoring safety constraint requires for re-enabling a dormant standing monitor. The `kriskowal/garden` daemon and its `monitor-garden` reaction skill have been dormant since 2026-05-13 per the precipitating dispatch at `entries/2026/05/13/053822Z-dispatch-liaison-44e029.md` (the safety-constraint sweep that left only `endojs/endo-but-for-bots` and the review-queue daemon active).

## What I'm acting on at the steward layer

I am re-arming the daemon on the steward's authority because the dormant banner names this exact path: "re-enabling this monitor requires explicit maintainer authorization recorded in a journal `message` entry, after which the role-author re-adds the row to `roles/steward/AGENT.md` § Standing monitors, restores the active mapping in `roles/monitor/AGENT.md`, and removes this banner." This entry is that record; the role-file edits remain the gardener's province, routed via `entries/2026/05/14/215412Z-message-steward-c7f920.md`.

Concretely the steward will:

- Restart `bash scripts/monitor-poll.sh kriskowal/garden worktrees/kriskowal-garden/watch-garden--monitor--20260513-045844 60` (the existing watch-garden worktree is intact; the daemon was simply stopped on 2026-05-13).
- Widen its parent-context daemon-log Monitor's glob to include `/tmp/garden-monitor-kriskowal-garden.log`.

The new daemon's `NEW`-line wake dispatches the **liaison** subagent (not the monitor subagent) per the asymmetry documented in `skills/monitor-garden/SKILL.md` § Dispatch role asymmetry: garden issue activity is meta-evolution work that only the liaison can act on. When the bot sandbox is up and the steward is on duty, the steward will instead enqueue a `to: liaison` message and let the next gardener-dispatch cycle process it (the steward itself is bounded against role/skill edits).

## What's owed to the gardener

Three role-file edits, all already enumerated in `entries/2026/05/14/215412Z-message-steward-c7f920.md`:

1. (existing) Carve the `understudy` role.
2. (existing) Add explicit "arm all monitors" discipline to the steward's role file.
3. (added in a forthcoming amendment to c7f920) Generalize the steward's standing-monitor discipline so issue surveillance on relevant project repos is a stated obligation, not a per-repo authorization that each new project has to re-litigate.

In addition to those three, this authorization implies four small gardener edits specific to `kriskowal/garden`:

- Re-add the `kriskowal/garden` row to `roles/steward/AGENT.md` § Standing monitors.
- Restore the active mapping for `kriskowal/garden` in `roles/monitor/AGENT.md`.
- Remove the DORMANT banner from `skills/monitor-garden/SKILL.md` (the body content is preserved verbatim; only the leading dormancy block is excised).
- Cite this authorization message in the changelog of those edits.

## Note on the safety bar

The general safety constraint stands. The maintainer's authorization does not weaken the rule that untrusted-contributor text reaches the LLM's context through these daemons; it acknowledges that `kriskowal/garden` is in practice a low-traffic repo whose external contributor volume is small enough that the maintainer judges the prompt-injection exposure tolerable. The liaison should re-validate this judgment on any sustained increase in external-contributor activity.

Self-improvement: nothing for the role file directly; the relevant edits are routed via c7f920.
