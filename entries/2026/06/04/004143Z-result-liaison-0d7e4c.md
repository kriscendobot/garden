---
kind: result
role: liaison
host: endolin
dispatch_root: /home/kris/garden/dispatches/liaison--0d7e4c
ts: 2026-06-04T00:41:43Z
ref_id: 0d7e4c
---

# Cycle 176: endo-but-for-bots daemon-endor-architecture.md (Rust supervisor; three worker platforms)

Cycle 176 — designs-lane after cycle 175's chat-lane.
§Endo-but-for-bots-design genre.

## Source

`endojs/endo-but-for-bots designs/daemon-endor-architecture.
md` on `llm` branch. Author Kris Kowal (prompted). Status:
**Active** (Created 2026-04-16). 806 lines. §Sibling-design
to cycle 141's daemon-cas-management.

## Sections written (1)

`endo-but-for-bots--llm-designs-daemon-endor-architecture--
unified-Rust-binary-with-three-worker-platforms-and-byte-
identical-CBOR-envelopes.md` (464 lines; commit `18aea1ac`).

## Single most structurally interesting move

**§Three-worker-platforms-with-byte-identical-CBOR-
envelopes**: workers run as separate (XS child process;
default) / shared (in-process XS) / node (Node.js child).
§The-supervisor-is-transport-agnostic.

## Structural moves captured

- §Two-crate-decomposition (endo + xsnap).
- §Binary-as-multi-tool: six subcommands.
- §Graceful-downgrade (shared → separate when XS unlinked).
- §Manager-must-be-co-resident (hard requirement).
- §Pool-of-machine-runner-threads with §cooperative-not-
  preemptive scheduling.
- §Blocking-call-authorization-via-parent-tree
  (§deadlock-prevention-by-structure).
- §Suspend-resume-via-CAS-streaming.
- §Unified-runner-four-mode-table.
- §Endor-implements-Ken-properties-implicitly (cycle 162).
- §CESU-8-surrogate-pair-encoding.
- §Six-host-power-modules via cap-std.
- §Five-embedded-JS-bundles via include_str! (cycle 175
  harden-selector embedded in polyfills.js).
- §Path-resolution-mirrors-@endo/where (cycle 167).
- §Renames-from-kind-to-platform.

## §Seven-distinct-design-lifecycle-statuses now represented

| Status | Cycle example |
|--------|---------------|
| Complete | 168 (daemon-checkin-checkout) |
| **Active** | **176 (this; daemon-endor-architecture)** |
| Proposed | 174 (gateway-package) |
| Reference | 170 (daemon-capability-filesystem) |
| Not Started | 145 (formula-inspector) |
| Implemented | 172 (endo-bytes) |
| In Progress | 166 (daemon-mount) |

§The-corpus-now-represents-every-design-lifecycle-status
observed in the design queue.

## §Tier-1 vocabulary borrowing candidates

§Three-worker-platforms + §supervisor-is-transport-
agnostic + §graceful-downgrade + §manager-must-be-co-
resident + §pool-of-machine-runner-threads + §blocking-
call-authorization-via-parent-tree + §suspend-resume-via-
CAS-streaming + §unified-runner-four-mode-table + §five-
embedded-JS-bundles-via-include_str.

## §Synthesis-target

§Slot machine library may need similar §multi-platform-
worker-runtime. §Three-worker-platforms shape borrowable.

## Files written / edited

- `library/sections/...daemon-endor-architecture--unified-
  Rust-binary...md` (464 lines; commit `18aea1ac`)
- `library/sources/...daemon-endor-architecture.md` (new
  source page)
- `library/sources/README.md` (cycle-176 row)
- `library/sections/README.md` (totals 680/221 → 681/222)
- `library/topics/daemon.md` (cycle-176 row)
- `library/keywords.md` (52 new keyword rows)
- `inboxes/endolin/scholar.md` (timestamp bumped)

## Library totals

680 / 221 → **681 sections from 222 source documents**.

## Lane rotation note

Cycle 176 was nominally **designs-lane** (after cycle
175's chat-lane). Papers-lane blocked **70+ consecutive
cycles**.

§Designs/chat-alternation maintained for eleven cycles
(166-176). §Steady-rotation-discipline.

## Cycle 176 — done. Schedule cycle 177.
