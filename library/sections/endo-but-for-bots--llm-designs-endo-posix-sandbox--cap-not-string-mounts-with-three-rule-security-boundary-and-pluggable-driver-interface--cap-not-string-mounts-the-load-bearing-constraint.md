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
title: §Cap-not-string-mounts (the load-bearing constraint)
parent: endo-but-for-bots--llm-designs-endo-posix-sandbox--cap-not-string-mounts-with-three-rule-security-boundary-and-pluggable-driver-interface
---

```
`SandboxHandle.mount(cap, innerPath, mode)` is the only way to
bind host state into a slice.  String host paths are not
accepted.  The factory does not receive the daemon's host-paths
power; `Mount` capabilities are resolved to host paths inside
the factory's `prepareSlice` step, where the cap-to-path
resolution is the only privileged operation.

This rule keeps the capability boundary in one place and
prevents the sandbox from becoming a confused-deputy escape
hatch.
```

§Why-strings-are-dangerous: a caller that can pass a string
"/etc/passwd" or "/home/user/.ssh" as a mount-source is just
exercising ambient host-paths authority laundered through the
sandbox. §The-cap-discipline ensures the caller already had
authority to that path before the sandbox could mount it.

§Confused-deputy-named-explicitly. §The-sandbox-must-not-
become-a-confused-deputy-escape-hatch.

§Compare-to-cycle-170-daemon-capability-filesystem's §realpath-
at-operation-time-confinement + §caretaker-facet-separation.
§Both-are-§capability-discipline-in-the-filesystem-layer;
cycle 170 is the wider design, cycle 190 is the concrete
slice-bounded slice.
