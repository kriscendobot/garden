## Press report — npm-via-CAS registry proxy (endojs/endo-but-for-bots, base `llm`)

**Assessment.** This tick's previous incarnation (dispatched 15:35, reaped mid-run) had already pressed the next unblocked increment: it opened **DRAFT PR #785** ("entry-point run assembly over CAS and registry table — Phase 4 acquisition", branch `feat/endor-run-entry-assemble`, stacked #276 → #772 → #782 → one new commit `205f81554c`) at 15:50, then died before filing its report. The PR delivers everything short of execution: entry-package location, transitive MVS resolution/fetch content-addressed into the CAS, entry-tree ingestion (no `node_modules` consulted), and a deterministic compartment map with `cas:sha256:` module locations; the design doc's status section is advanced in the same commit.

**What I did (this incarnation).**
- Confirmed no live peer holds any arc branch; drained an empty inbox twice.
- **Independently verified #785 with real execution** in a fresh isolated worktree (CI's 24 green checks are JS-side only — no Rust CI on this base, so local execution is the only real evidence). Applied the known base-build workaround (moddable submodule init + stubbed gitignored XS boot bundles):
  - Hermetic: `cargo test -p endo --lib` → **125 passed, 0 failed**.
  - End-to-end CLI: built `endor`, fresh `/tmp/endor-cas` + fresh registry table, real registry.npmjs.org fetch of `is-odd@3.0.1` + `is-number@6.0.0` — package tree hashes (`a46a5a58…`, `51e96a7a…`) **exactly match** the PR body's independent run — then `endor run --offline` reproduced every hash byte-identically with zero network.
- Posted the verification as PR comment endojs/endo-but-for-bots#785#issuecomment-5005157789.
- Confirmed the base-build blocker (in-tree XS boot-bundle generators) lives on PR **#124**'s `slot-machine` branch (commit `45bb0e96a9`) and is already tracked on the board by parked plan jobs (`endojs-endo-but-for-bots-pr124-shepherd`, `ebfb-124-resume-rebase-review-fixups`, `ebfb-124-sqlite-*`) — no duplicate job posted.

**Arc state after this tick.** #276 (Phase 2): un-drafted, CI green, awaiting merge decision. #772 (Phase 4 resolver core), #782 (Phase 5 offline/.npmrc), #785 (Phase 4 acquisition): all DRAFT, MERGEABLE/CLEAN, verified. Registry-capability edge (#403/#671/#563) stays with the byte-array arc, untouched.

**Follow-ups.**
1. The **only** remaining finish-line piece is the XS execution half of Phase 4 (`moduleMapHook`/`importHook` over the CAS host functions + actually running the compartment map). It is gated on #124 landing the boot-bundle generators (and `rust-endor.yml` CI); the next tick should check #124's parked shepherd jobs for movement and press the wiring the moment the base builds in-tree.
2. #276 still needs a merge decision; once it lands, #772/#782/#785 each collapse to one commit on rebase.
