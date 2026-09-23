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
title: Cap-not-string mounts with three-rule security boundary, pluggable backend driver interface, capability-blind drivers, and design as mirror of authoritative PLAN
parent: endo-but-for-bots--llm-designs-endo-posix-sandbox--cap-not-string-mounts-with-three-rule-security-boundary-and-pluggable-driver-interface
---

> §Designs-lane after cycle 189's chat-lane. §The-twenty-
> fourth-consecutive designs/chat alternation cycle (166-190).
> §Status: **In Progress (Phase 3)** — Phases 0, 1, and 1.5
> shipped (bwrap driver); Phase 2 (podman driver) shipped;
> Phases 3 (nested slices) in progress; Phases 4 (macOS via
> lima), 6 (Windows via WSL), and 7 (focused tools)
> remaining.
> §Supersedes the cycle-NaN-`daemon-os-sandbox-plugin` open
> proposal that was superseded 2026-05-07 when this design
> landed.

`endo-posix-sandbox.md` (572 lines, Created 2026-05-07,
Updated 2026-05-07) designs an Endo plugin that exposes a
"slice of a POSIX-like system" as a CapTP capability surface.
A slice is a §confined-process-namespace + §writable-filesystem-
view + §optionally-private-network, GC-pinned by its handle.

§The-key-consumer: `@endo/genie` — the plan runs a genie's
entire workspace and `bash`/`exec`/`git` tools inside a slice
so an off-the-rails model cannot exfiltrate via host shell
access. §This-is-additional-defense; the daemon, workers, and
CapTP graph remain the authoritative capability boundary.

§The-single-most-structurally-interesting-move is §cap-not-
string-mounts + §three-rule-security-boundary-clarity +
§pluggable-backend-driver-with-capability-blind-drivers.
§Three-disciplines composed.
