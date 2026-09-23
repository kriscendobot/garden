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
title: §realpath-at-operation-time-confinement (the security spine)
parent: endo-but-for-bots--llm-designs-daemon-mount--two-formula-type-split-with-shared-exo-interface-and-realpath-at-operation-time-confinement
---

```
function assertConfined(candidatePath, confinementRoot):
  resolved = realpath(candidatePath)
  if not resolved.startsWith(confinementRoot + '/') and resolved != confinementRoot:
    throw error "Path escapes mount root"
```

§Every-filesystem-operation-must-verify-resolved-path-
remains-within-confinement-root. §Realpath-resolves-
symlinks-fully.

§Design-Decision-5: §symlink-confinement-at-operation-time.
§TOCTOU-mitigation. §Checking-symlinks-at-lookup-time-and-
caching-creates-TOCTOU-window where symlink target could
change between lookup and use. §Operation-time-is-the-only-
safe-approach.

§Cycle-161's-filesystem-watchers has a sibling discipline:
§stat-reconciled-rename-events at operation time (filesystem
events don't tell direction; handler must stat at event
time). Both designs commit to §operation-time-verification
because §filesystem-state-can-change.
