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
title: §Pluggable backend driver with capability-blind drivers
parent: endo-but-for-bots--llm-designs-endo-posix-sandbox--cap-not-string-mounts-with-three-rule-security-boundary-and-pluggable-driver-interface
---

§Drivers-do-not-receive-Endo-capabilities-directly. §The-
plugin-layer-is-the-single-mediator: it resolves each granted
`Mount` to a host path on the daemon side, then hands the
driver a §plain-{hostPath,innerPath,mode}-triple. §The-driver-
does-the-bind-mount/volume-mapping.

```ts
interface SandboxDriver {
  name: string
  probe(): Promise<{ available, reason?, version? }>
  prepareSlice(spec: SliceSpec): Promise<DriverSliceContext>
  spawn(slice, argv, opts): Promise<DriverProcess>
  teardown(slice): Promise<void>
}
```

§Five-method-driver-interface. §Compare-to-cycle-187-shim-
cluster's §Indenter-trait-with-two-implementations (5 methods:
open / line / next / close / done). §Both-are-§polymorphic-
interface-with-named-shapes; cycle 190's driver-interface is
the §runtime-pluggable-implementation pattern.

§Five-drivers-in-scope:

| Driver | OS | Phase |
|--------|-----|-------|
| `bwrap` | Linux | 1 (Complete) |
| `podman` | Linux | 2 (Complete) |
| `lima` | macOS | 4 (Not Started) |
| `containerization` | macOS 15+ | 4 (Not Started) |
| `wsl` | Windows | 6 (Not Started) |

§Capability-blind-drivers = §drivers-see-only-resolved-paths.
§This-keeps-drivers-simple-and-keeps-the-capability-boundary-
in-one-place. §A-driver-that-doesn't-handle-capabilities-
correctly cannot escape the slice via cap-abuse.

§Compare-to-cycle-176-daemon-endor-architecture's §three-
worker-platforms-with-byte-identical-CBOR-envelopes. §Both-
are-§platform-blind-substrate patterns where the layer above
provides the common interface and the layer below provides
the platform-specific machinery.
