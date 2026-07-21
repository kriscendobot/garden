Work complete.

## Completion report

**Job:** Dead-lettered message pickup — a new comment on kriskowal/garden issue #59 (from maintainer `dckc`) was undeliverable because the original doer `issue-kriskowal-garden-59` had already completed. I picked up its intent.

**The ask (treated as data):** dckc noted issue #59 was motivated by the ERTP mention in #58, that an ERTP issuer is often implemented with a `WeakMapStore`, and asked to make sure ERTP is one of the integration tests.

**Context:** Issue #59 tracks building a persistent store family (Map/Set/WeakMap/WeakSet/Sorted variants) into the endo pet daemon, mirroring the `@agoric/store` API over the daemon's own formula+SQLite substrate. The living design is PR **endojs/endo-but-for-bots#809** (`packages/daemon/designs/daemon-persistent-stores.md`).

**What I did:**
1. **Folded ERTP into the design** (PR #809, branch `daemon-persistent-stores`). Added to **Phase 3 (weak variants)** a first-class **ERTP integration test**: a minimal issuer/mint/purse kit whose ledger is a daemon `WeakMapStore`, asserting `Amount` conservation across create → mint → transfer → restart → balances-intact, plus weak-key drop when a payment remotable is collected. Added a matching tracked item under **Known Gaps and TODOs**. Committed and pushed (rebase-CAS) to the design branch — commit `1fe8078ee`, now on PR #809.
2. **Replied on the issue thread** (kriskowal/garden#59#issuecomment-5037912412) acknowledging the direction, describing where it landed, and confirming the issue stays open for the maintainer's steer. Did not close the issue (submitter's call).

**Changes:** 1 file, +19 lines in `packages/daemon/designs/daemon-persistent-stores.md`. No changes to the garden `main2` tree were needed (this job mutated the project fork's design branch).

**Follow-ups:** The ERTP integration test is a design requirement now, not yet code — it will be realized when Phase 3 (weak variants) is built, after Phase 1 (strong `MapStore`) and Phase 2 (`SetStore`). No new job posted; it's captured in the tracked design checklist.
