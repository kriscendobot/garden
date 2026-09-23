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
title: §Plugin-shape-in-Endo
parent: endo-but-for-bots--llm-designs-endo-posix-sandbox--cap-not-string-mounts-with-three-rule-security-boundary-and-pluggable-driver-interface
---

```
A make-unconfined formula loaded from the daemon, mirroring
the shape of lal, jaine, and the existing networks plugins.

Powers needed:
- child_process.spawn of an allow-listed binary set (bwrap,
  pasta, podman, lima, wsl.exe — plus the rootfs caller's
  chosen interpreter).
- Read access to a config dir.
- Writable scratch path via the daemon's provideScratchMount.
- Not the host-paths power.
```

§Four-powers-needed and §one-power-explicitly-not-needed.
§The-§not-the-host-paths-power explicit refusal reinforces
Rule 2 ("plugin does not receive the daemon's host-paths
power transitively").

§Compare-to-cycle-170-daemon-capability-filesystem's §absence-
is-structural-not-policy. §Both-encode-the-§deny-by-omission
discipline.

§Allow-listed-binary-set: bwrap + pasta + podman + lima +
wsl.exe + caller's-chosen-interpreter. §Six-binaries the
plugin can spawn. §Other-binaries-must-go-through-a-slice's-
SandboxHandle.spawn-not-direct-child_process.
