---
source: designs/daemon-engo-supervisor.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_url: https://github.com/endojs/endo-but-for-bots/blob/llm/designs/daemon-engo-supervisor.md
section_kind: design
ingested: 2026-06-05
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - daemon
  - capability-security
status_at_ingest: Not Started
genre: §endo-but-for-bots-design §unrealized-predecessor-of-cycle-176
cycle: 192
lane: designs
status: current
title: §Why-this-design-never-shipped (the §unrealized-predecessor relationship)
parent: endo-but-for-bots--llm-designs-daemon-engo-supervisor--three-architecture-diagrams-platform-pair-convention-and-progressive-syscall-migration-as-unrealized-predecessor
---

§The-design-status: **Not Started** (Created 2026-02-25).

§Cycle-176-endor-architecture (Created 2026-04-16, Status
Active): the Rust supervisor that shipped instead. §The-
endor-architecture inherits substantial DNA:

- §Three-worker-platforms (cycle 176's separate-XS + shared-
  XS + Node.js vs cycle 192's Node.js + Go + Wasm in future).
- §Byte-identical-CBOR-envelopes (same framing).
- §Handle-rewriting (same supervisor-router-discipline).
- §Spawn-tree-deadlock-prevention (same §canBlock check).
- §Five-embedded-JS-bundles-via-include_str! (cycle 176 has
  this; cycle 192 doesn't because Go doesn't have the same
  include-string mechanism).
- §Cooperative-not-preemptive-scheduling.

§What-changed-in-the-pivot:

1. §Rust-instead-of-Go for the supervisor (performance +
   memory-safety + Cargo ecosystem alignment).
2. §Endor-supports-shared-in-process-XS-worker as a co-
   resident option; engo's design only contemplated
   subprocess workers.
3. §Endor-uses-bundle-source-+-include_str! for embedded JS
   (Phase 4+ of engo would have needed a different mechanism
   for syscalls).

§Neither-design-explicitly-marks-engo-as-superseded. §The-
engo-design-is-still-marked-Not-Started; cycle 176 endor is
Active. §The-fact-that-engo-was-never-built-and-endor-
shipped-instead is §archived-only-by-the-status-fields-and-
the-existence-of-the-cycle-176-design.

§Compare-to-cycle-190-endo-posix-sandbox's §Supersedes-record-
pattern with §three-named-improvements. §Cycle-192-engo +
cycle-176-endor lack-this-explicit-relationship. §An-§implicit-
supersedes that future maintainers would need to discover by
reading both designs and noting the dates.

§Tier-1-borrowing: §when-pivoting-architectures, write a
§Supersedes-record explicit in the new design (or update the
old design's Status to "Superseded by [link]"). §Cycles-186/
190 do this; cycles 192/176 don't. §The-honest-design-
evolution-discipline (cycles 178/180/183/184 family) applies
at the architecture-decision-layer too.
