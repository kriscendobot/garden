---
source: designs/endo-posix-sandbox.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_url: https://github.com/endojs/endo-but-for-bots/blob/llm/designs/endo-posix-sandbox.md
section_kind: design
ingested: 2026-06-04
ingested_by: scholar
contributors:
  - Joshua T Corbin (PLAN)
  - kriscendobot (prompted by kriskowal)
topics:
  - daemon
  - capability-security
  - hardened-javascript
status_at_ingest: In Progress (Phase 3)
genre: §endo-but-for-bots-design §supersedes-prior-with-relationship-section
cycle: 190
lane: designs
status: current
title: §Phase-progression with §living-phase-list-records-its-own-renumbering
parent: endo-but-for-bots--llm-designs-endo-posix-sandbox--cap-not-string-mounts-with-three-rule-security-boundary-and-pluggable-driver-interface
---

```
| Phase | Description                                  | Status       |
| 0     | Driver interface design                      | Complete     |
| 1     | bwrap driver on Linux                        | Complete     |
| 1.5   | bwrap hardening (Landlock, seccomp, cgroups) | Not Started  |
| 2     | podman driver                                | In Progress  |
| 3     | Nested slices (fork())                       | In Progress  |
| 4     | macOS via lima and Apple Containerization    | Not Started  |
| 6     | Windows via WSL2                             | Not Started  |
| 7     | Focused tools and renderer integration       | Deferred     |
```

§Phase-5-intentionally-absent. §The-design-records-its-own-
renumbering:

> the original Phase 5 (Apple Containerization) has been
> folded into Phase 4, and the original Phase 4 (Windows /
> WSL2) was renumbered to Phase 6 so macOS lands before
> Windows.

§Each-phase-with-renumbering-context is named in its
description: "Phase 3 (Was Phase 5; promoted ahead of multi-
platform work)", "Phase 4 (Was Phase 3; combined with...)",
"Phase 6 (Was Phase 4; deferred until after macOS lands)".

§Living-phase-list-records-its-own-renumbering is a §design-
evolution-discipline. §Compare-to-cycle-178-snapshot's
§revised-scope-discussion-2026-04-15 and cycle 188-perf's
§working-copy-inventory. §All-three-record-how-the-design-
state-arrived-at-its-current-shape.

§The-§Phase-7-Deferred status appears for §scoped-only-after-
production-use items (genie-side spawn tool surface; Familiar
renderer access; OCI-pull rootfs via skopeo; sandbox-exec
defense-in-depth around macOS native worker). §Defer-with-
condition-named (production-use).
