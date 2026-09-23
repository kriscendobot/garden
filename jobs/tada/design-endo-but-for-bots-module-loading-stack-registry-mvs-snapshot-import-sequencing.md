Completion report — design job `design-endo-but-for-bots-module-loading-stack-registry-mvs-snapshot-import-sequencing`

**What I did.** Reconciled the four Proposed designs of the M3 daemon-worker `importLocation` stack in `endojs/endo-but-for-bots` (`registry-capability`, `mvs-resolver`, `snapshot-mapper`, `daemon-worker-import-from-mount`) into one accepted, dependency-ordered phased build plan, and opened **draft PR endojs/endo-but-for-bots#659** (branch `design/module-loading-stack-sequencing`, base `llm`, commit `bf28f79b97`, 5 files, +165/−21).

**What changed.**
- All four designs flip **Proposed → Not Started** (accepted, no implementation begun — confirmed by grep: no `registry.js`, `map-snapshot.js`, or `makeFromPackage` exists under `packages/daemon/src/`).
- `daemon-worker-import-from-mount` § Phased Implementation is now the **canonical stack-wide build plan**: a phase/owner/deliverable/builds-on table. Phases 1–4 are the serial critical path (registry+MVS → mapper+worker dispatch → host method+CLI → live-mount snapshot lifetime); phase 5 (Rust drop-in) and phase 6 (XS) are parallel-lane follow-ups. The "worker can importLocation from a mount" criterion is met at Phase 2 for readable-tree sources, Phase 3 for `endo run <mount>`. All external substrate is already landed (`EndoMount.snapshot()` in `mount.js`, `makeFromTree`, CAS verbs), so no phase gates on another design's implementation.
- Four real inter-doc gaps closed: (1) workspace-root discovery had no owner (the resolver receives opaque bytes; now pinned to `mapSnapshot`, with a new § Workspace-root discovery and `workspaceRoot` threading); (2) workspace members had no documented `RegistryResolution` entry shape (now: bare-name key, `workspace: true`, no `integrity`, hash via subtree content hash); (3) `mapSnapshot`'s ambiguous resolve contract pinned to a single `E(registry).resolve` call; (4) Phase 2's readable-tree fixture stance disambiguated from Phase 4's live-mount snapshot delivery.
- `designs/README.md` synced per its own conventions: header pass description, summary-table rows, M3 milestone rows, and an honest totals recount (prose had drifted: 145 → 147 designs, In Progress 24 → 26). Dependency-graph edges were already correct; per-design estimates unchanged.

**Verification status.** Design-only markdown diff; nothing executable, so no runtime verification applies. Claims about landed/absent code were checked by grep against the `llm` checkout (cited in the PR body). Not verified: nothing (no runtime surface).

**Follow-ups.**
- Un-drafting #659 is the maintainer's design-disposition call; after acceptance, Phase 1 (`registry-capability` + `mvs-resolver`, one builder job) is the first buildable unit, then Phase 2–4 serially.
- Journal `result` entry pushed to `journal2` (`entries/2026/07/10/...-result-designer-*.md`); project worktree torn down; inbox drained (empty).

Self-improvement: nothing this time.
