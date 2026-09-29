Fix round 5 for kriscendobot/minion.town#135: I applied every must-fix item from the round-5 panel, pushed the fixes, and CI came back green (3 of 3 checks passed).

**Head moved from `d6048ea` to `a3ca6fc`** in three follow-up commits (`78d931e`, `20e9109`, `a3ca6fc`), pushed with `safe-push-pr-head.sh` as a fast-forward.

**Changes, by the seat that asked for them:**
- **assessor:**
  - `npm-registry-backup.sh` now works out each MANIFEST field (`endo_commit`, `schema_version`, `db_sha256`, `cas_inventory_sha256`, `cas_objects`) in its own assignment before the heredoc. Before, a failure inside the heredoc was silently ignored; now it stops the backup. An empty `schema_version` also stops it.
  - In `deploy-npm-registry-secret.sh`, the wait for the registry to come back after the restart now fails with its own message. Before, it fell through and the failure showed up as a `whoami` error.
- **breaker:** `deploy-npm-registry.sh` now writes the preflight helper to `preflight.sh.new` and renames it into place, the same way it already handles the unit file. A cut-off transfer can no longer leave a partial script at the path systemd runs before each start.
- **corner-prober:**
  - The restore loop now keeps a final `cas.inventory` entry that has no trailing newline. Before, that entry was never checked or copied.
  - Backup and restore now take a `flock` on `$STATE.lock`, so a second run at the same time is refused instead of colliding with the first.
- **pruner:** removed the sentence about how design references work from `deploy/aws/npm-registry/README.md`.

**Tests:** I added four tests to `test/npm-registry-backup.test.ts`:
- a final inventory entry with no newline is checked and copied;
- a malformed final entry with no newline is refused;
- a run is refused while another holds the lock (skipped where `flock` isn't installed);
- a backup whose schema version can't be read restarts the service and writes no MANIFEST.

All four fail against the previous script and pass now. The backup and preflight suites pass (31 of 31), and `npm run typecheck` is clean. The only shellcheck notes on the backup script are info-level (SC2015) and were already there.

**Follow-ups:** I did not change the comment-only notes:
- stylist wants `MINIMUM_FREE_KB` renamed to `MINIMUM_FREE_KIB` and the `cas_*` names spelled out;
- locksmith points out that nothing forces the old grant to be revoked after a rotation;
- engine-realist asks for a stated reason behind `MemoryMax=512M`;
- fast-checker suggests property-based tests;
- saboteur notes that concurrent deploy runs (as opposed to backup/restore) still have no lock.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr135-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (1336929 cached reads)
- Output: 12563 tokens
- Cost: $1.1715978000000002
- Wall-clock: 366s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
