I applied the panel-7 must-fix items and the two should-fix items that two reviewers both flagged, then pushed them to the PR #93 head (`186007f..e0cc943`). CI is green: `ci-wait-merge.sh` returned rc 0 with all 3 checks passing. The gateway tests (189) pass locally and the type check is clean. In the full local suite, one git-remote test fails in this sandbox: `capability.test.ts` "propagates a git failure…" expects git to fail on a path that doesn't exist, but here git appears to find the enclosing garden repository instead. This change doesn't touch git-remote code, and CI passed.

**Commits**
1. `1e7670e` refactor(gateway): renames for the stylist's two must-fix items.
   - `dir` → `shardDirectory` in `internBlob` (`content-store.ts`), the name `content-gc.ts` already uses.
   - `ageMs` → `ageMilliseconds` in the test helpers.
2. `6e47356` fix(gateway): a delete-mode sweep now refuses to run when the git partition store is missing. This fixes the fail-open that the saboteur and breaker both raised.
   - **Before:** a missing directory read as "no git roots", so a mistyped or relocated `GIT_REMOTE_PARTITIONS_DIR` could make `--delete` remove live git content.
   - **Now:** `runGc` requires the partitions directory to exist when `--delete` is set. Only a missing `content-roots/` inside an existing store counts as empty, and audit mode still accepts a missing store.
   - The `gc.env` that `deploy-endo-gateway-gc.sh` creates now sets `GIT_REMOTE_PARTITIONS_DIR` to the same directory as `minion-git-remote.service`.
   - `DEPLOYMENT.md` and the design doc describe the new rule, and there is a new regression test.
3. `e0cc943` docs(gc): for the archivist's must-fix, rewrote design § B.7 so it no longer cites `vhostTtlMs` as the naming pattern.
   - The environment variable and flag keep the deployed `*_MS` suffix, matching `GATEWAY_VHOST_TTL_MS`.
   - New code names spell the unit out; `vhostTtlMs` predates that rule.
   - This also answers the stylist's should-fix on `--grace-ms` / `GATEWAY_GC_GRACE_MS`: the names stay as they are, with the reason now in the design.

**Not addressed, left for later rounds or the maintainer** (all should-fix or comment-only):
- The `unpublish` takedown that can strand a pet name; the assessor suggests a tombstone or retry marker.
- Proving the ACL mask on files created under `content-roots`.
- Audit mode exits 0 when some records could not be resolved.
- One guest can block GC for every tenant through a bad `front`.
- Errors swallowed in the `parseVhostRecord` and `utimes` catches.
- A concurrent-run lockfile.
- The pruner's runbook-scope suggestions for `DEPLOYMENT.md`.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr93-gauntlet-20261010-fix-7.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 54 tokens (1950176 cached reads)
- Output: 11697 tokens
- Cost: $1.2221432000000005
- Wall-clock: 922s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
