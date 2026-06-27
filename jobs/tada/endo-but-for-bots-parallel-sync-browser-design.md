Inbox empty, worktree torn down. Work complete.

---

## Completion report

**Job:** `endo-but-for-bots-parallel-sync-browser-design` — design-only deliverable for a parallel cis/trans file-tree browser showcase. Wore the **designer** role (a gardener claims a `design` job and wears it).

**What I did:**
- Researched the relevant Endo surfaces (locators, CapTP / three-party handoff, mount capability, petstore/petnames, weblet hosting, the M8 peer-app-sharing flow) via two parallel Explore agents plus direct reads, grounding every claim in the on-branch design corpus.
- Authored `designs/parallel-sync-browser.md` on the `llm` branch, following the project's design conventions (metadata table, motivation, where-it-lives, mount semantics, panel/lock/arrow UX, sync-settings model, the headline CapTP+locator handshake with two mermaid diagrams, dependencies, design decisions, open questions, captured prompt).
- Synced `designs/README.md`: added a summary-table row, an M8 (Peer App Sharing) milestone-table row, and bumped the totals prose (Proposed 28→29, 143→144 designs).
- Committed on branch `design/parallel-sync-browser` and opened **draft PR #551** against `llm`: https://github.com/endojs/endo-but-for-bots/pull/551

**Key design content:** The headline is third-party rendezvous. The orchestrator (a weblet) holds both mount capabilities, computes the sync *plan* from metadata, then brokers a **locator** exchange (`endo://{peerKey}/{formulaAddress}@{hints}?type=mount`) via `locate` / `writeLocator` / `addPeerInfo` so the two mounted daemons dial each other and establish a **direct CapTP channel** — file content streams peer-to-peer and never passes through the orchestrator. The metadata-plan-vs-content-transfer split is the load-bearing boundary. Built on shipped locator/invitation machinery (the lighter baseline); OCapN cryptographic gift-and-deposit handoff is flagged as the hardened variant in open questions.

**Notable judgment call surfaced in the doc:** the minimal `@endo/captp` the daemon runs does **not** implement OCapN's three-party cryptographic handoff (that lives in `packages/ocapn`), so the showcase is deliberately specified on locator-based introduction rather than requiring the stronger unforgeability guarantee. This is recorded as a design decision plus an open question for the maintainer.

**Status:** Draft PR open, design-stage; un-drafting is the maintainer's call after review. No implementation (per the job's design-only scope). Worktree torn down; branch retained on origin for the PR.

**Follow-ups / open questions for the maintainer (in the doc):** OCapN hardened-handoff variant, streaming chunk protocol for large-file transfer, bidirectional-conflict UX, multi-mount-per-panel (VFS) scope, and whether to special-case the same-daemon collapse.

Self-improvement: nothing this time.
