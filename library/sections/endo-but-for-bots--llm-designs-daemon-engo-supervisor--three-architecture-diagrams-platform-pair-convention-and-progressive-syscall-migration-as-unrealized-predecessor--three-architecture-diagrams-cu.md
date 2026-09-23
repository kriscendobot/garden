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
title: Three architecture diagrams (current/target/future), -go vs -node platform-pair convention, progressive syscall migration, and the unrealized-Go-predecessor of cycle-176-endor-Rust supervisor
parent: endo-but-for-bots--llm-designs-daemon-engo-supervisor--three-architecture-diagrams-platform-pair-convention-and-progressive-syscall-migration-as-unrealized-predecessor
---

> §Designs-lane after cycle 191's chat-lane. §The-twenty-
> sixth-consecutive designs/chat alternation cycle (166-192).
> §Status: **Not Started** (Created 2026-02-25). §This-design-
> never-shipped: the team pivoted to Rust (cycle 176 endor-
> architecture, Status Active, 2026-04-16). §A-historical-
> artifact documenting the architectural exploration that
> preceded the canonical Rust direction.

`daemon-engo-supervisor.md` (481 lines, Not Started,
2026-02-25) designs a Go supervisor process ("engo") that
would wrap the existing Node.js Endo daemon and manage all
workers as peers. §The-design-never-shipped — the team
pivoted to Rust (cycle 176 endor-architecture), but neither
this design nor cycle 176 explicitly marks engo as superseded.

§The-single-most-structurally-interesting-move is §three-
architecture-diagrams (current / target / future) + §-go-vs-
node-vs-web-platform-pair-naming-convention + §progressive-
syscall-migration-with-named-priority-order +
§incrementalism-as-the-key-constraint. §Four-named-moves at
the architecture-decision-design level.
