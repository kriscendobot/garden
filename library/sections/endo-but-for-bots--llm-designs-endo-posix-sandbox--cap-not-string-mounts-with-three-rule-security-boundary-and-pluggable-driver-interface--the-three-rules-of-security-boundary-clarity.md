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
title: §The-three-rules-of-security-boundary-clarity
parent: endo-but-for-bots--llm-designs-endo-posix-sandbox--cap-not-string-mounts-with-three-rule-security-boundary-and-pluggable-driver-interface
---

The design names §three-rules-restated-explicitly:

```
1. The plugin never accepts string host paths from the caller.
   Mounts are `Mount` capabilities or nothing.
2. The plugin does not receive the daemon's host-paths power
   transitively, even though it could nominally use it.
3. Network profiles are explicit and named.
   `'private'` does not accidentally upgrade to `'host-net'` on
   misconfiguration; misconfig is an error, not a relaxation.
```

§Rule-1: §cap-not-string-mounts. §`SandboxHandle.mount(cap,
innerPath, mode)` is the only way to bind host state into a
slice. §String-host-paths-are-not-accepted.

§Rule-2: §plugin-does-not-receive-daemon's-host-paths-power.
§Even-though-it-could-nominally-use-it (cycle 170 daemon-
capability-filesystem's §Bazel-style-selective-dependency-
mounting parallel). §The-cap-resolution happens inside the
plugin's `prepareSlice` step; the plugin itself doesn't have
ambient host-paths access.

§Rule-3: §misconfig-is-error-not-relaxation. §Network-profiles
fail-loud-on-unknown-value. §Compare-to-cycle-178-daemon-xs-
worker-snapshot's §suspend-only-when-idle (§avoid-the-problem-
by-design); §rule-3-here-is §avoid-silent-degradation-by-
making-misconfig-an-error.

§Compare-to-cycle-170-daemon-capability-filesystem's §five-
named-disciplines and cycle 174-gateway-package's §eight-
Design-Decisions. §Three-rules is the §security-discipline-
shape; not all designs reach §eight.
