---
title: 'endo-but-for-bots designs/endo-posix-sandbox.md — Endo POSIX Sandbox'
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_url: https://github.com/endojs/endo-but-for-bots/blob/llm/designs/endo-posix-sandbox.md
source_paths:
  - designs/endo-posix-sandbox.md
authors:
  - Joshua T Corbin (PLAN)
  - kriscendobot (prompted by kriskowal)
created: 2026-05-07
updated: 2026-05-07
status_at_ingest: In Progress (Phase 3)
ingested: 2026-06-04
ingested_by: scholar
topics:
  - daemon
  - capability-security
  - hardened-javascript
sections:
  - endo-but-for-bots--llm-designs-endo-posix-sandbox--cap-not-string-mounts-with-three-rule-security-boundary-and-pluggable-driver-interface.md
genre: §endo-but-for-bots-design §supersedes-prior-with-relationship-section
cycle: 190
lane: designs
---

# Endo POSIX Sandbox (design)

## §Abstract

572-line **In Progress (Phase 3)** design for an Endo plugin
exposing a "slice of a POSIX-like system" as a CapTP
capability surface. A slice is a §confined-process-namespace +
§writable-filesystem-view + §optionally-private-network, GC-
pinned by its handle.

§Supersedes `daemon-os-sandbox-plugin.md` (2026-02-15, Not
Started → Superseded 2026-05-07) with §three-named-
improvements: split capability surface (4 handles); cap-not-
string mounts; phase plan stages bwrap → podman → fork →
macOS → Windows.

§The-key-mechanism: §cap-not-string-mounts. §`SandboxHandle.
mount(cap, innerPath, mode)` is the only way to bind host
state into a slice; string host paths are not accepted. §The-
plugin-does-not-receive-the-daemon's-host-paths-power — cap-
to-path resolution happens inside `prepareSlice` only.

§Three-rules-of-security-boundary-clarity: (1) never-string-
host-paths; (2) plugin-does-not-receive-daemon's-host-paths-
power-transitively; (3) misconfig-is-error-not-relaxation
(unknown network profile is a hard error).

§Pluggable-backend-driver-interface with five drivers in
scope (bwrap / podman / lima / containerization / wsl).
§Drivers-are-capability-blind: they see only resolved-path
triples; the plugin layer is the single cap-to-path mediator.

§Six-position-network-confinement-ladder: none (default) /
private (recommended; RFC 1918 blocklist) / host-loopback /
host-lan / host-net.

§Genie-integration-as-workspace-not-tool-surface: existing
genie tools unchanged externally; daemon-side wiring swaps
the spawn channel. The slice's network profile drops RFC
1918 + host loopback + filesystem-unreachable-except-via-
explicit-mounts.

§This-design-mirrors-and-tracks `PLAN/endo_posix_sandbox.md`
on `packages/sandbox` working branch. §The-PLAN-is-
authoritative for phase-by-phase status; this design is the
roadmap-aligned mirror for milestone-tracking.

§Status-Phase-3: Phases 0, 1 (bwrap), 1.5, 2 (podman) shipped;
Phase 3 (nested slices via fork()) in progress; Phases 4
(macOS via lima + Apple Containerization), 6 (Windows via
WSL2), 7 (focused tools) remaining.

## §Files and identifiers

| File | Lines | Role |
|------|-------|------|
| `designs/endo-posix-sandbox.md` | 572 | This design |
| `PLAN/endo_posix_sandbox.md` | — | §The-authoritative implementation log |
| `packages/sandbox/src/types.d.ts` | — | M.interface guards (Phase 0 deliverable) |
| `packages/sandbox/src/factory.js` | — | SandboxFactory stub + dispatch |
| `packages/sandbox/src/drivers/{bwrap,podman,lima,wsl}.js` | — | Per-driver implementations |
| `packages/sandbox/src/drivers/path.js` | — | Canonical default $PATH helper |
| `packages/sandbox/README.md` | — | Per-phase status tracking |

## §Dependencies and lineage

- §Supersedes-cycle-NaN-`daemon-os-sandbox-plugin.md` (the
  un-ingested predecessor; Status Superseded 2026-05-07).
- §Cited-by-cycle-170-daemon-capability-filesystem? Not
  directly, but §Bazel-style-selective-dependency-mounting +
  §absence-is-structural-not-policy from cycle 170 are
  reflected here as §plugin-does-not-receive-host-paths-power.
- §Built-on `make-unconfined` daemon mechanism (cycle 133
  daemon-guest-eval-simplification mentions `make-unconfined`
  shape).
- §Genie-integration consumer: `@endo/genie` workspace +
  bash/exec/git tool surfaces.
- §Five-driver-dependencies: bwrap + pasta + podman + lima
  (or `colima`) + wsl.exe.

## §Related sources in the library

- §Cycle 170 (`endo-but-for-bots--llm-designs-daemon-
  capability-filesystem.md`) — §wider-vision-of-capability-
  filesystem. §absence-is-structural-not-policy + §Bazel-
  style-selective-dependency-mounting + §caretaker-facet-
  separation siblings.
- §Cycle 174 (`endo-but-for-bots--llm-designs-gateway-package.
  md`) — §three-design-lifecycle-statuses-now-distinguished
  (Supersedes / Deprecates / Replaces) — cycle 190 shows the
  §Supersedes-record-shape in detail.
- §Cycle 176 (`endo-but-for-bots--llm-designs-daemon-endor-
  architecture.md`) — §three-worker-platforms-with-byte-
  identical-CBOR-envelopes is a §platform-blind-substrate
  sibling to cycle 190's §capability-blind-drivers.
- §Cycle 178 (`endo-but-for-bots--llm-designs-daemon-xs-
  worker-snapshot.md`) — §GC-pinning-with-pre-defined-
  disposal sibling. Both use Endo's existing GC-pinning
  mechanism for resource cleanup.
- §Cycle 182 (`endo-but-for-bots--llm-designs-daemon-xs-
  worker-debugger.md`) — §natural-attenuation-trio sibling.
  Cycle 190's §four-handle-capability-surface is the
  §lifecycle-decomposition variant.
- §Cycle 183 (`endo--packages-init-and-lockdown.md`) —
  §shim-assembly-order is a §ordered-binding-pipeline
  sibling to cycle 190's §$PATH-synthesis-order-matters.
- §Cycle 186 (`endo-but-for-bots--llm-designs-break-dev-
  dependency-cycles.md`) — §review-iteration-archived-in-
  design sibling. Cycle 190's §source-mirror-to-PLAN with
  §named-update-protocol is a different §designs-archive-
  process pattern.
- §Cycle 188 (`endo-but-for-bots--llm-designs-daemon-rust-
  xs-performance.md`) — §working-copy-inventory sibling for
  §navigation-aid-for-multi-design-investigation.

## §Comment fragments worth preserving

```
This rule keeps the capability boundary in one place and
prevents the sandbox from becoming a confused-deputy escape
hatch.
```

§The-§confused-deputy-named-explicitly. §The-§rule-1-rationale
in one sentence.

```
Misconfig is an error, not a relaxation.
```

§Rule-3-paraphrased. §The-§silent-degradation-is-a-bug
discipline. §A-`private`-profile must never auto-upgrade to
`host-net` on misconfig.

```
This is _additional_ defense around inner processes;
the daemon, workers, and CapTP graph remain the authoritative
capability boundary.
The plugin does not replace Endo's own confinement model.
```

§Defense-in-depth-named. §The-sandbox-is-not-the-primary-
boundary; CapTP discipline is.

```
The PLAN is the authoritative phase-by-phase implementation
log; this design is the roadmap-aligned mirror for milestone-
tracking purposes (project velocity, ETD per milestone) per
review comment 3203724907 on PR #119.
```

§Two-documents-with-named-authoritative-source. §Update-
protocol-named-explicitly. §Provenance-of-mirror-decision-
cited (review-comment-3203724907).

```
A caller-supplied env.PATH always wins;
the synthesis only fires when the slice's env does not
include PATH.
```

§Explicit-action-beats-heuristic discipline. §The-synthesis-
is-only-a-fallback.
