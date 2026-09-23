---
title: "daemon-os-sandbox-plugin — Superseded historical proposal for OS-level sandboxing of native programs; introduces LLM-discoverability discipline"
source-slug: endo-but-for-bots--llm-designs-daemon-os-sandbox-plugin
url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/daemon-os-sandbox-plugin.md
authors: [Kris Kowal (prompted), Joshua T Corbin (revised)]
repo: endojs/endo-but-for-bots
path: designs/daemon-os-sandbox-plugin.md
total-lines: 544
status: Superseded by endo-posix-sandbox (2026-05-07; retained as historical proposal)
ingest-cycle: 228
ingest-date: 2026-06-08
lane: designs
---

# daemon-os-sandbox-plugin

A 544-line **Superseded** design (2026-02-15 → 2026-05-07). The §parent-design that became a §historical-proposal when `endo-posix-sandbox` landed as the successor. §Retained-as-a-historical-proposal with explicit roadmap calibration via git blame.

## Key design moves

- **§Status-Superseded-by-named-successor** — new design-evolution-record shape.
- **§Roadmap-calibration-via-git-blame** — named commit hashes + dates + message summaries preserve the design history archaeologically.
- **§No-further-implementation-phase-is-planned-against-this-document** — explicit deprecation statement.
- **§LLM-discoverability section** with §two-mechanisms (comprehensive help() + maximally specific interface guards).
- **§help()-text-narrative + §Interface-guards-machine-readable-schema** — together must be sufficient for an LLM to construct valid calls without out-of-band documentation.
- **§M.splitRecord-for-LLM-discoverable-shapes** distinguishing required from optional fields.
- **§Capability-flow as ASCII tree** with nested indentation showing creation hierarchy.
- **§Two-platform-backends** (macOS SBPL + Linux bwrap+seccomp) with §named-endowment-to-rule-mapping-table per backend.
- **§Apple-deprecation-acknowledgment** + §two-named-future-replacement-APIs (Endpoint Security framework + user-space FUSE).
- **§Per-rule-network-filtering-limitation** as honest disclosure + §three-named-future-paths to fix + §fallback-behavior + §named-warning.
- **§Three-named-future-stronger-isolation-mechanisms** (Landlock + container runtimes + Lightweight VMs).
- **§Test-Plan with §Maybe-subsection** for not-required-but-suggested tests.
- **§Five-section-Considerations** (same template as cycle 218).
- **§Profile-generation-is-security-critical** — name the injection risk + canonicalization requirement.
- **§The-plugin-itself-is-unconfined** — honest acknowledgment + named mitigation (only host holds SandboxMaker).

## Section files

- [§Status-Superseded + §roadmap-calibration + §LLM-discoverability + §two-platform-backends + §Test-Plan-with-Maybe](../sections/endo-but-for-bots--llm-designs-daemon-os-sandbox-plugin--Status-Superseded-by-named-successor-and-roadmap-calibration-via-git-blame-and-LLM-discoverability-with-help-and-interface-guards-and-two-platform-backends.md) — full design ingest.

## Ingest scope

Cycle 228 (designs-lane): full 544-line ingest. §Nine-different-shapes-of-design-evolution-record now (cycle 228 adds the eighth and ninth: Status-Superseded-by-named-successor + Roadmap-calibration-via-git-blame). §Seven-cycles-on-confinement-substrates now spans capability-framing down to OS-syscall-level.
