The work is complete. Inbox is empty, and the PR is up.

## Completion report

**Job:** Reconcile the syrups framing design docs to the landed `@endo/syrup-frame` name.

**Verified on `llm` before editing** (did not invent identifiers):
- Package shipped as **`@endo/syrup-frame`** at `packages/syrup-frame/`, version **0.1.1**.
- Exports **`makeSyrupReader`** / **`makeSyrupWriter`** (singular) from `index.js`; test file `test/syrup-frame.test.js`; error messages use singular "syrup". The docs' `makeSyrupsReader`/`makeSyrupsWriter` never shipped.
- `@endo/ocapn` already depends on `@endo/syrup-frame`; the OCapN TCP netlayer migration (a `tcp-syrups` netlayer) has **not** shipped.

**Changes (design docs only):**
- `designs/ocapn-tcp-syrups-framing.md` — flipped the naming recommendation to `@endo/syrup-frame` with the `-frame` suffix rationale (parallel to `@endo/cbor-frame`), keeping `@endo/syrups` in the candidate table as the rejected/retired option; updated all identifiers to `makeSyrupReader`/`makeSyrupWriter`, the `packages/syrup-frame/` directory, and `syrup-frame.test.js`; removed the remaining `@endo/cbors` mentions; set Status to **In Progress (Phase 1 landed)** with a status note distinguishing the shipped package from the still-proposed netlayer migration.
- `designs/syrups.md` — retitled to `@endo/syrup-frame`, inverted the now-backwards rename recommendation, repaired the self-contradicting "earlier reading" paragraph, pointed at the `@endo/cbor-frame` sibling, refreshed status/date.
- `designs/ocapn-noise-session-reconnect.md` — one-line fix of a dangling reference to the never-shipped plural `makeSyrupsReader`/`makeSyrupsWriter` (same naming error, in a doc citing the target design).

Prose kept ASCII (no em-dashes/smart quotes introduced); issue/PR references fully qualified.

**PR:** https://github.com/endojs/endo-but-for-bots/pull/741 (base `llm`, head `design/syrups-naming-reconcile`).

**Follow-ups / notes for the reviewer:**
- **Ordering dependency:** both docs now link `designs/cbor-frame.md` and name `@endo/cbor-frame`, which PR #738 introduces on the same base. #738 should merge first; #738 also does a small `@endo/cbors` sweep of `syrups.md` that this PR's full rewrite supersedes, so expect a trivial conflict there. This is flagged in the PR body.
- I deliberately kept the transport-level identifier `tcp-syrups` and the doc title as-is (they name Syrup-framing over TCP, orthogonal to the package basename).
