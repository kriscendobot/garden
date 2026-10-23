# Fix round 1 for kriscendobot/minion.town PR #218

I fixed most of the panel-1 findings and pushed them to `split/pr216-ledger` as two commits on top of `065ee74c` (`898e556e` and `3d284ba0`). CI on `3d284ba0` is green (`ci-wait-merge` rc 0). Three items are only partly addressed or left as they were; they are listed below.

There was no pre-pass block in the job, so the findings came from the latest panel review on the PR, which reviewed commit `ac3599a6`. A commit already on the branch after that review (`065ee74c`) had handled most of the "deploy runs before the IAM migration" findings by adding a preflight to `deploy-app.sh`. I built on it.

## What changed

**Deploy and rollout (`898e556e`)**
- **IAM action (locksmith):** `dynamodb:TransactWriteItems` is not a real IAM action; AWS authorizes each item in a transaction as its own operation. I removed it from the app role policy. Both items in a bond are updates, so the scoped `UpdateItem` grant covers the transaction. The script now reads the installed policy back and checks that grant. The IAM test no longer fakes a wrapper request, and it now fails on any action outside the documented DynamoDB item actions.
- **Deploy gate (saboteur, breaker, integrator):** the script claimed `deploy-app.sh` checks the provisioning marker, but nothing did. The preflight now reads that marker and refuses to promote or restart the app if it is missing.
- **Reruns and rollback (breaker, wire-watcher):** an ordinary rerun now keeps the reconciliation marker. `LEGACY_BOND_WRITERS=active` removes it before a rollback; `retired` writes it. Unknown values are refused before the script touches the table.
- **Backfill scan (saboteur, engine-realist):** the scan now uses consistent reads, and each page is processed before the next is requested.
- **Script tests (prover, fast-checker):** the test now runs the whole script against a stub `aws`. It covers the marker deletes and writes and their order in all three modes, a failed run, a missing grant, consistent reads and per-page order. A fast-check property covers arbitrary page layouts.
- **Comments (typist, archivist):** the section headings no longer use box-drawing characters.
- **Release note (releaser, integrator, migrator):** `DEPLOYMENT.md` now spells out the three-step rollout and the rollback step. The repo has no changeset system, so this is the deployer-facing note.

**Account store (`3d284ba0`)**
- **Malformed ledger entries (wire-watcher, corner-prober, purist, archivist):** `closeGuestBonds` used to skip a bad entry and report success. It now rejects with a new `GuestBondLedgerMalformedError` unless every entry is exactly a two-string JSON pair, so `["i","s","extra"]` is refused too. Nothing is unbonded, the guest stays closed to new bonds, and the deletion stays pending.
- **Overridden methods (spec-keeper):** entries are walked by index instead of `.flatMap`, and a test shadows `flatMap`, `map`, `forEach` and `filter` on the returned value.
- **Return value (purist):** `closeGuestBonds` returns `Promise<void>` instead of a count.
- **Stale docs (archivist):** the module header and the `makeDynamoAccountStore` summary now describe the ledger grants and the admin interface.
- **Naming (stylist):** `fc` is now `fastCheck` in the two files.

## Not fully addressed

- **Prover's "wire `closeGuestBonds` into production" (must-fix):** there is no guest deletion path to wire it into. The PR body says deletion follows in a separate PR. I took breaker's alternative instead: the docs now say plainly that no production consumer holds `GuestBondAdmin` yet. The next panel may raise this again; it needs a maintainer decision or the deletion PR.
- **Wire-watcher's "bind the marker to a build generation":** a rollback to code older than the ledger runs the old `deploy-app.sh`, which can't check anything. The fix I made is the documented `LEGACY_BOND_WRITERS=active` step before a rollback; it depends on the operator remembering it.
- **Engine-realist's unbounded ledger growth (should-fix):** not done. Each guest's ledger is a single string set that keeps stale entries after a rebond or unbond, and sharding it would be a design change.
- **Purist's SHA-256 note:** no change. The test calls `node:crypto` to recompute the store's HMAC fingerprint; it doesn't reimplement SHA-256. I only corrected the exemption comment to say so.

## Local tests

Typecheck is clean. The full suite has one failure, in `test/git-remote/capability.test.ts`, which this PR doesn't touch; it also fails with `TMPDIR=/tmp`, so it looks environmental on this host. CI passed.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr218-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 90 tokens (5125803 cached reads)
- Output: 39826 tokens
- Cost: $2.954400600000001
- Wall-clock: 1471s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
