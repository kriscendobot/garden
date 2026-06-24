---
title: Open Questions
source: doc/design/ocaps.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [capability-security]
status: current
---

Abstract: The four questions ocaps.md leaves open. **Observer authentication** — notifications go over authenticated sessions, but the exact protocol for proving the observe capability during registration and validating notifications is TBD pending the session-cryptography design. **Delegation transitivity** — can a `delegate_read_cap` holder create another `delegate_read_cap`, or is delegation non-transitive? The current design assumes non-transitive (only root creates delegate caps). **Capability expiration** — should capabilities support time-limited access, encoded in the capability itself or tracked in the capability-set metadata? **Audit logging** — should capability usage (reads, writes, delegations) be logged, and where (per-cell, per-session, or a separate audit section of the root store)?

1. **Observer authentication**: notifications are sent over authenticated sessions, but the exact protocol for proving observe capability during registration and validating notifications is TBD pending session cryptography design.

2. **Delegation transitivity**: can a `delegate_read_cap` holder create another `delegate_read_cap`, or is delegation non-transitive? The current design assumes non-transitive (only root can create delegate caps).

3. **Capability expiration**: should capabilities support time-limited access? This could be encoded in the capability itself or tracked in the capability-set metadata.

4. **Audit logging**: should capability usage (reads, writes, delegations) be logged? Where would logs be stored — per-cell, per-session, or in a separate audit section of the root store?

Source: [doc/design/ocaps.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/ocaps.md) at commit `cdb975d8`.
