---
source: designs/daemon-persistence.md
source_repo: endojs/endo
source_branch: kriskowal-doc-formula-persistence
source_commit: aefc1b87da0cebd09184668effa264fe25e1c0b5
source_date: 2026-03-08
source_authors: [Kris Kowal]
source_pr: endojs/endo#3121
source_pr_state: draft
ingested: 2026-05-14
ingested_by: scholar
section_count: 7
status: current
notes: **First source ingested from an unmerged draft PR.** endojs/endo#3121 is open + draft as of 2026-03-08; the file is on branch `kriskowal-doc-formula-persistence`, not `master`. Standard idempotency check against the default branch returns nothing (`git log -1 master -- designs/daemon-persistence.md` is empty). Re-check freshness against PR head `aefc1b87da0cebd09184668effa264fe25e1c0b5`; treat a force-push to the PR branch as a re-ingest trigger; on merge, rewrite source_branch to default + new source_commit; on close-without-merge, mark all `endo--designs-dp--*` sections as **stale**. See [[journal-library-conventions]] § "Sources from unmerged PRs" for the discipline (added this cycle). This is the **canonical thesis document** for Formula Persistence; the daemon-cross-peer-gc and daemon-locator-terminology designs in `endo-but-for-bots/llm/designs/` are *implementation* designs that operate within this model. To fetch the PR head: `git --git-dir=worktrees/endojs-endo.git fetch origin pull/3121/head:refs/pull/3121/head`.
---

> Abstract: Formula Persistence is the Endo Daemon's persistence strategy. The thesis inverts the conventional relationship between petnames and the underlying capability reference mechanism: **the petname graph IS the persistence root**, not a layer on top of sturdy references / web-keys. The system persists *construction*, not content — each capability is described by a formula (a recipe for reconstructing the live reference and its transitive dependencies). When partition occurs, the system performs **destruction by cohort** (collectively destroy the affected subgraph of live references) and **reconstruction on demand** (rebuild from formulas when a consumer requests them). The formula graph is **acyclic across peers** (admits limited cycles only for co-formula groups like promise/resolver and agent-handle pairs) and **locally reference-counted** — no distributed GC protocol needed. This enables **timely revocation through local reachability**: dropping a petname disincarnates dependent capabilities immediately, before any distributed protocol is consulted. The model introduces a **fourth revocation mechanism** distinct from caretakers / revocation lists / expiry: **revocation by withdrawal of the constructor**. **Coordinated retention across peers** is structured as four tables (local + remote × inviter + accepter) with local agency always authoritative; the petname database models mirrored retention roots as a CRDT kept in sync when sessions are open. The Endo Daemon **chooses** Formula Persistence; other systems on the same Endo components (notably the Agoric chain) choose orthogonal persistence for determinism. The 6/7 Karp/Stiegler/Close aspects of sharing are all supported, with #3 cross-domain, #6 accountable, and #7 revocable specifically benefitting from this model.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [frame-and-position-in-design-space](../sections/endo--designs-dp--frame-and-position-in-design-space.md) | daemon, persistence, capability-security | current |
| [waterken-and-e-as-endpoints](../sections/endo--designs-dp--waterken-and-e-as-endpoints.md) | persistence, capability-security, captp | current |
| [formula-graph-and-cohort-destruction](../sections/endo--designs-dp--formula-graph-and-cohort-destruction.md) | daemon, persistence, capability-security | current |
| [acyclic-formula-graph-and-revocation](../sections/endo--designs-dp--acyclic-formula-graph-and-revocation.md) | daemon, persistence, capability-security, patterns | current |
| [coordinated-retention-and-four-tables](../sections/endo--designs-dp--coordinated-retention-and-four-tables.md) | daemon, persistence, capability-security, ocapn | current |
| [system-fit-and-not-orthogonal](../sections/endo--designs-dp--system-fit-and-not-orthogonal.md) | daemon, persistence, capability-security | current |
| [six-aspects-of-sharing-and-related-work](../sections/endo--designs-dp--six-aspects-of-sharing-and-related-work.md) | capability-security, persistence, ocapn, captp | current |

## See also

- `endo-but-for-bots/llm/designs/daemon-cross-peer-gc.md` (`dcpg`) — the cross-peer retention protocol that runs *within* the formula-persistence model.
- `endo-but-for-bots/llm/designs/daemon-locator-terminology.md` (`dlt`) — the locator URL format + LOCAL_NODE normalization that operates on formula keys.
- `endo-but-for-bots/llm/designs/daemon-retention-paths.md` (`drp`) and `retention-path-notation.md` (`rpn`) — local retention-path graph computation atop the formula graph.
- `endo-but-for-bots/llm/designs/daemon-content-store-gc.md` — content-store sweep GC, complementary to formula GC.
