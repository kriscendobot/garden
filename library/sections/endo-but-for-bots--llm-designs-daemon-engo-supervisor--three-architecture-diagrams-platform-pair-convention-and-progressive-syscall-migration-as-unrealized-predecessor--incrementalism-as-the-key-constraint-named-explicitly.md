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
title: §incrementalism-as-the-key-constraint (named explicitly)
parent: endo-but-for-bots--llm-designs-daemon-engo-supervisor--three-architecture-diagrams-platform-pair-convention-and-progressive-syscall-migration-as-unrealized-predecessor
---

```
The key constraint is **incrementalism**: the existing Node.js
daemon must continue to work unmodified under `endo start`.
Engo is an alternative supervisor that hosts the daemon as a
subprocess and manages all workers as peers.
```

§The-§key-constraint named-explicitly. §Three-properties:

1. §Existing-Node.js-daemon-continues-to-work-unmodified.
2. §`endo start` continues to work.
3. §Engo-is-an-alternative-supervisor (additive, not
   replacement).

§The-§rollback-trivial section reinforces this:

> Because engo wraps the existing daemon without modifying it,
> rolling back is trivial: stop the engo-managed daemon and
> start one directly with `endo start`. No state migration is
> needed.

§The-`-node`-modules-remain-alongside-the-`-go`-modules. §Two-
implementations-coexist; the user-or-CLI chooses which.

§Compare-to-cycle-186-break-dev-deps' §sink-only-synthetic-
test-packages (§don't-touch-the-existing-packages); cycle
192's incrementalism is at the §process-architecture-layer
rather than the §workspace-dependency-graph layer.

§Compare-to-cycle-178-snapshot's §two-init-paths-one-entry-
point (init vs restore). §Both-are-§two-coexisting-shapes
patterns at different scales.
