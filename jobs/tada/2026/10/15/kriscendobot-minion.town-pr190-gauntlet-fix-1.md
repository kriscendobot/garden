Fix round 1 for kriscendobot/minion.town#190 is pushed and CI is green: `ci-wait-merge.sh --no-merge` returned 0 with 3 of 3 checks passing. I fixed most of the panel's must-fix items. Two were not fixed: one doesn't apply to this repo, and one I left for the maintainer.

**Pushed to the PR head `clip-gutter-reorder`** (`f8d0511` → `4827a34`, via `safe-push-pr-head.sh`):
- **`9e2a89d` fix(shell): serialize clip-order saves; harden order endpoint**
  - **Save race** (flagged by 8 panel members): saving the gutter order could let an older request overwrite a newer one. `createOrderSaver` in `shell.js` now allows one save at a time, and while one is in flight only the newest order is kept to send next. New tests cover saves finishing out of order and recovery after a failed save.
  - **stylist**: the numeric positions are renamed `sourceIndex` and `destinationIndex`.
  - **purist/warden**: the account cache now copies `clip_order` when it snapshots a record, so a caller can't change cached data through a returned record. There is a test for this.
  - **engine-realist**: if the account store fails during admission on `PUT /account/clips/order`, the endpoint now returns 503 instead of leaving an unhandled rejection. There is a test for this.
  - **prover**: the subject-isolation test now checks Alice's saved order first, then Bob's unchanged default.
  - **fast-check**: added property tests for `moveClip` and for how a saved subset of hashes is listed.
- **`4827a34` docs**:
  - **archivist/integrator/surfacer**: `designs/clip-shell-framework.md`, `designs/account-creation-open-signup.md` and `DEPLOYMENT.md` now cover the reorder UI, the persisted order, the `PUT` route and its request/response contract, and the IAM boundary.
  - **migrator**: `DEPLOYMENT.md` now says to rerun `deploy-accounts-store.sh` before the app/www deploy. This is documented only; the deploy scripts don't enforce the order yet.

Locally, `tsc --noEmit` is clean and the three affected test files pass (84 tests). I didn't run the full suite locally.

**Not fixed** (explained in a reply comment on the PR):
- **releaser**: this repo has no `.changeset/` directory or changesets workflow, so there is nowhere to add a changeset.
- **locksmith** asked for an owner-bound clip-order facet. That restructures how `AccountStore` is handed out. `setClipOrder(iss, sub, …)` follows the same pattern as the existing `bondGuest`/`recoverGuest`, so it fits better as one separate change covering all three. Left for the maintainer to decide.

The panel-2 round may flag these two again. I didn't re-run the panel.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr190-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 62 tokens (2339547 cached reads)
- Output: 17411 tokens
- Cost: $1.4742254000000001
- Wall-clock: 1002s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
