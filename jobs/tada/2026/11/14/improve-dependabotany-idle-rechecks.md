No new commit was needed: commit `b8e75c3974b` ("fix(dependabotany): suppress unchanged idle rechecks"), which is already on `origin/main2`, does what this job asks. It was pushed at 03:32Z, after the job was posted at 03:21Z, most likely by an earlier attempt at this job that stopped before signalling completion. I checked it against the spec and re-ran its tests in this worktree; both suites pass.

**How it matches the spec**
- **Per-project snapshot:** `scripts/jobs/dependabotany-preflight.sh` now saves one small file per project and repo under `$GARDEN_STATE/dependabotany-preflight/snapshots/`. Each line is a PR number, its head commit, its base commit, and a fingerprint (a hash) of whatever is blocking the merge. The snapshot also records whether a ledger row is due, so an embargo reaching its maturity date counts as a change.
- **Bounded:** at most 64 PRs (`GARDEN_DEPB_STATE_MAX_PRS`), each read has a 15-second timeout, cached files have a size limit, and the file is replaced in one atomic write.
- **Skip when unchanged:** if the current reading matches the saved one exactly, the preflight exits 2 before it reaches the old due-MERGE-NOW dispatch (the line 677 path), so no botanist job runs.
- **Dispatch on change or missing data:** the preflight dispatches if any value changes, if there is no saved snapshot or it can't be read or written, if the PR-state read fails, or if there are more than 64 PRs.
- **New handler, `scripts/jobs/handlers/dep-recheck-state-gh.sh`:** one GitHub query per PR returns that line. The fingerprint covers draft status, mergeability, review decision, and every check that hasn't passed (success, neutral and skipped are ignored). Check names are hashed and never leave the handler. A closed, malformed, or paginated PR makes it return an error, which leads to a dispatch.

**Tests**
- `scripts/jobs/test/dependabotany-preflight-test.sh`: 76 passed, 0 failed. This includes: unchanged state → exit 2; missing cache → dispatch; failed state read → dispatch; the embargo maturity date → dispatch even when GitHub state hasn't changed.
- `scripts/jobs/test/dep-recheck-state-gh-test.sh`: passed.

**Follow-ups:** none. The live effect (a quiet #1646 recheck) only starts once each host deploys `b8e75c3974b`; if unchanged rechecks still appear in the journal, check that first.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-dependabotany-idle-rechecks.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s) (1 unmetered)
- Input: 10 tokens (253521 cached reads)
- Output: 2013 tokens
- Cost: $0.5078442 (1 engagement(s) unpriced)
- Wall-clock: 707s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
