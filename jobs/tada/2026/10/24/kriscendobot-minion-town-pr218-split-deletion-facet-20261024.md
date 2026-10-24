Job done: #218 no longer ships the deletion facet, #220 now carries it as its own commits, #218's CI is green and it is still a draft, and the gauntlet has resumed for two more rounds.

**#218 (`split/pr216-ledger`, now at head `4e33e459`)**
- **Moved out:**
  - `GuestBondAdmin` (`closeGuestBonds`, `unbondGuest`), `GuestBondsClosedError` and the in-memory store's closed-guest set.
  - `makeInMemoryAccountStoreFacets` and the close-only helpers and error classes in `dynamodb.ts`.
  - The per-guest `guest/<v>/<fp>` closed row (its only job was carrying `guest_bonds_closed`), along with the `guest-bond-ledger` row kind and `guestLedgerSortKey`.
  - The `guest_bonds_closed` IAM attribute and the ledger `Query` grant (only the close used `Query`).
  - The backfill's closed-guest handling.
  - The matching tests and doc text.
- **Reverted:** `makeDynamoAccountStore` and `buildAccountStore` return a plain `AccountStore` again, and `http.ts` matches the base. Nothing in #218 used `unbondGuest`, so it moved too.
- **Kept, as decided:** the per-bond ledger rows written by bond and rebind, `row_kind`, recovery-key versions, the backfill with its markers and `LEGACY_BOND_WRITERS` rollout, the IAM preflight, and the ledger `UpdateItem`/`DeleteItem` grants that `bondGuest` needs (`DeleteItem` covers the rebind delete).
- **Text and replies:** the design doc, DEPLOYMENT.md and the PR body ("What", "Decision", "Out of scope") are updated. I posted one short reply to the decomplector's finding.
- **Other defects:** none were still open on the latest review (5637251243); round 13 had already fixed them.
- **Checks:**
  - Typecheck and pre-push gates pass.
  - Locally the only test failure is `test/git-remote/capability.test.ts`, the known git-wrapper false-fail.
  - CI on GitHub passes 4/4.

**#220 (`split/pr216-account-deletion`, now at head `4343522a`, still draft, no gauntlet)**
- `62a0e650` merges #218's new head.
- `5f449ce9` reverts `4e33e459`, so the deletion facet becomes #220's own commit and will survive the restack.
- `4343522a` adapts #220 to the newer ledger:
  - `closeGuestBonds` returns the number of bonds removed again, because #220's audit records it as `bondsRemoved`.
  - I removed #220's old `4a.1` deploy gate and its test. It read the marker from the ledger partition, but #218 now writes markers to their own partition, so the gate would have refused every deploy. #218's preflight already checks the marker.
  - Its rollout and rollback text now points to #218's rule.
- Locally, typecheck and the full test suite pass except the same false-fail. I didn't wait for #220's CI.
- I posted a note on #220 listing these commits.

**Gauntlet:** `gauntlet.sh --resume-from-stage kriscendobot-minion.town-pr218-gauntlet panel --add-rounds 2` returned 0 and restarted at round 14 (`kriscendobot-minion.town-pr218-gauntlet-panel-14`).

**One mistake, already recovered:** while working on #220 I ran a stray `git checkout … -- .` that overwrote my uncommitted edits. I restored the tree to the committed head and redid the edits before committing.

**Follow-ups:**
- **Restack:** #220 still needs restacking after #218 merges.
- **Still deletion-only in #218:** the reconciliation marker is kept as rollout state, but only #220's close reads it. If the panel calls it unused, the answer is that it's part of the decided rollout.
- **Inline-import probe:** a full-stack pre-push run on #220 against `main` fails the `no-inline-import-jsdoc` probe. It passes when scoped to my changes, so the cause is in #219/#220's own code and needs a separate fix.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr218-split-deletion-facet-20261024.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 164 tokens (15312987 cached reads)
- Output: 67873 tokens
- Cost: $6.543049400000004
- Wall-clock: 2258s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
