---
kind: result
role: liaison
host: endolin
refid: 7609d9
dispatched_at: 2026-06-04T08:10:00Z
completed_at: 2026-06-04T08:17:09Z
cycle: 190
lane: designs
---

# Cycle 190 — designs-lane: `endo-but-for-bots designs/endo-posix-sandbox.md`

Ingested the 572-line In Progress (Phase 3) design for the
Endo POSIX Sandbox — a CapTP capability surface exposing a
"slice of a POSIX-like system" for confining native processes
(genie's bash/exec/git, future build sandboxes).

## Section file (cohesion-honest single section)

- `endo-but-for-bots--llm-designs-endo-posix-sandbox--cap-not-string-mounts-with-three-rule-security-boundary-and-pluggable-driver-interface.md`
  (~590 lines)
- Headline: **Cap-not-string mounts with three-rule security
  boundary, pluggable backend driver interface, capability-
  blind drivers, and design as mirror of authoritative PLAN**
- §The-single-most-structurally-interesting-move: §cap-not-
  string-mounts + §three-rule-security-boundary-clarity +
  §pluggable-backend-driver-with-capability-blind-drivers.

## §Supersedes daemon-os-sandbox-plugin

This design supersedes `daemon-os-sandbox-plugin.md`
(2026-02-15, Superseded 2026-05-07) with §three-named-
improvements:

1. Split capability surface (4 handles).
2. Cap-not-string mounts.
3. Phase plan stages bwrap → podman → fork → macOS → Windows
   (with macOS/Windows using in-guest backend + host-side
   proxy pattern via lima/WSL, rather than maintaining a
   parallel SBPL backend).

The prior design was un-ingested but is preserved in the
designs/ index as a historical proposal.

## Topics worked

- `daemon` (primary; added new row)
- `capability-security`
- `hardened-javascript`

## Tier-1 borrowings worth re-noting

- §cap-not-string-mounts (the load-bearing constraint)
- §three-rules-of-security-boundary-clarity (never-string-
  host-paths + plugin-does-not-receive-daemon's-host-paths-
  power-transitively + misconfig-is-error-not-relaxation)
- §pluggable-backend-driver-with-capability-blind-drivers
  (drivers see only resolved-path triples; plugin layer is
  single cap-to-path mediator)
- §three-named-network-profiles + §three-explicit-host-opt-
  ins = §six-position-confinement-ladder
- §anti-shadowing-rule (caller-granted mounts land after
  rootfs-derived $PATH; extend but can't override)
- §living-phase-list-records-its-own-renumbering (Phase 5
  intentionally absent; each promoted/demoted phase notes its
  prior numbering)
- §supersedes-record-pattern with §three-improvements-named-
  explicitly
- §source-mirror-to-PLAN with §named-update-protocol (PLAN is
  authoritative phase-by-phase log; this design is roadmap-
  aligned mirror; named §update-protocol avoids §two-
  documents-drift)
- §four-handle-capability-surface for §lifecycle-decomposition
- §GC-pinning-and-disposal-protocol with §SIGTERM-grace-
  SIGKILL
- §five-cross-phase-invariants as test-side-discipline
- §plugin-explicitly-refuses-power-it-could-have
- §non-goals-discipline (six explicit scope-limits)

## §Sibling-disciplines across the corpus

- §Cycle 170 daemon-capability-filesystem: §Bazel-style-
  selective-dependency-mounting + §absence-is-structural-not-
  policy. Cycle 190 implements these as concrete rules.
- §Cycle 174 gateway-package: §three-design-lifecycle-statuses
  Supersedes/Deprecates/Replaces. Cycle 190 shows the
  §Supersedes-record-shape in detail.
- §Cycle 176 endor-architecture: §three-worker-platforms-with-
  byte-identical-CBOR-envelopes is a §platform-blind-substrate
  sibling to §capability-blind-drivers.
- §Cycle 178/182/184 xs-worker trio: §GC-pinning-with-
  disposal + §natural-attenuation-trio.
- §Cycle 183 init/lockdown: §shim-assembly-order = §ordered-
  binding-pipeline sibling to §$PATH-synthesis-order-matters.
- §Cycle 186 break-dev-deps: §"illusion of an option" cousin
  + §review-iteration-archived-in-design (cycle 190 has
  §source-mirror-to-PLAN as a different §designs-archive-
  process pattern).
- §Cycle 188 perf: §working-copy-inventory navigation-aid
  sibling.

## Library counts after cycle 190

- 695 sections from 236 source documents.
- §designs-chat-alternation maintained 24 cycles (166–190).
- §papers-lane blocked 84+ consecutive cycles.

## Self-pacing

Cycle 191 wakeup scheduled in 1500s. Pattern: cycle 191 should
be chat-lane (alternating from cycle 190's designs-lane).
