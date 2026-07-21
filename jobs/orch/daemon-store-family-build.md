---
order: serial
children: daemon-store-phase1-mapstore daemon-store-phase2-setstore daemon-store-phase3-weak-ertp daemon-store-phase4-sorted daemon-store-phase5-parity daemon-store-phase6-cli-wui
on-child-failure: halt
state: running
created_by: gardener
created_at: 2026-07-21T23:24:56Z
---

# Orchestration: build the persistent @agoric/store-style store family in the endo pet daemon

Supervise builders across all phases of the persistent-stores design
(`packages/daemon/designs/daemon-persistent-stores.md`, PR #809, approved by
@kriskowal — the approving review explicitly asked to "dispatch an orchestrator
to supervise builders over all phases"). Serial, halt on the first child
failure, each phase a stacked PR on the prior phase's branch.

Phases (design § Phased Implementation):
1. durable strong MapStore (closes kriskowal/garden#59)
2. durable strong SetStore
3. weak variants (WeakMapStore / WeakSetStore) + the family ERTP integration test
4. sorted variants + range queries
5. parity polish (addAll/clear, lazy iterators, optional replication)
6. human surfaces (CLI + WUI command vocabulary)

Spine: issue-kriskowal-garden-59 (submitter dckc). Each child opens a DRAFT PR
against endojs/endo-but-for-bots and auto-runs the gauntlet; halt surfaces to the
maintainer so a phase that reveals a design gap pauses the chain instead of
grinding on.
