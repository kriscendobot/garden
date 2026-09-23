---
source: designs/daemon-mount.md
source_repo: endojs/endo-but-for-bots
source_url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/daemon-mount.md
source_path: designs/daemon-mount.md
section_kind: design
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - daemon
  - capability-security
  - patterns
genre: §endo-but-for-bots-design
cycle: 166
lane: designs
status: current
title: Two-formula-type split with shared exo interface and realpath-at-operation-time confinement
parent: endo-but-for-bots--llm-designs-daemon-mount--two-formula-type-split-with-shared-exo-interface-and-realpath-at-operation-time-confinement
---

> §Endo-but-for-bots-design genre (designs-lane; breaks the
> §ocap-kernel-mini-series streak after cycles 162-165).
> Status: **In Progress** (Phases 1-3 + 5 shipped 2026-03-21
> via commit `e22f71327`; Phases 4 and 6 open as PRs #135 /
> #127 / #277). The **direct prerequisite design** for
> cycle 161's filesystem-watchers.md (which adds
> `followNameChanges` to EndoMount via PR #277).

`designs/daemon-mount.md` (708 lines) defines the
**§live-mutable-filesystem-as-capability** primitive for
the daemon. The single most structurally interesting move
is the §two-formula-type-split (`mount` for external host-
managed directories; `scratch-mount` for daemon-managed
workspace) sharing one exo interface, with the entire
security surface anchored on §realpath-at-operation-time-
confinement.
