---
source: doc/design/membership-next-steps.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-25
ingested_by: scholar
section_count: 3
status: current
---

> Abstract: The roadmap document framing CASK's access control as three ordered gates — **membership** (may this peer connect at all?), **session** (an authenticated encrypted channel, only for members), and **capability** (what this session may do, scoped to cells the peer holds a capability for) — and laying out the staged plan to enforce them. The invited-guest principle: CASK is not an open service. Identity is the stable 32-byte `node_id`; the MVP recommends a `CASK_MEMBERSHIP` file/env of hex node_ids and a `CASK_ROOT` bootstrap root user, with `ini6` gaining a node_id field and a `statusNotMember` status, deferring CASK-persisted membership (caskset / Rabin-chunked sorted array) and cryptographic node_id proof. Capability-gated read/write (gate 3) is deferred to CELLS.md.

| Section | Topics | Status |
|---------|--------|--------|
| [three-gate-access-model](../sections/cask--membership-next-steps--three-gate-access-model.md) | capability-security, networking | current |
| [membership-mvp-roadmap](../sections/cask--membership-next-steps--membership-mvp-roadmap.md) | networking, capability-security | current |
| [capability-gated-read-write](../sections/cask--membership-next-steps--capability-gated-read-write.md) | capability-security, networking | current |
