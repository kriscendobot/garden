## Report: ironhorse-ci2-flake-reruns-20261117 (#1364, #1373, #1278)

The macOS daemon-teardown and "Failed to exit" flakes this job was posted for are now green on all three PRs. Before this attempt, the runs already showed attempt 2 (`gh run view` reports `attempt=2` on 1364's run), so I did not rerun anything again. 1278 had one red that a rerun could never clear, and I fixed it. Every other red left on these PRs is a known defect in the base branch or a lane the job said to leave alone, and none comes from the PRs' own changes. Nothing was merged or woven.

**#1364** (endojs:`feat/ironhorse-resource-limit-policy`, base `llm-3aa902d`)
- **Before:** the macOS legs (`test (22.x/24.x, macos-15)`, `test-ironhorse-macos`) all pass. Still red: test/cover 22.x and 24.x, sandbox-drivers, test-xs and the two oracle lanes.
- **Cause:**
  - The test, cover and sandbox-drivers reds are all `packages/sandbox` bwrap tests: "parent death leaves no owned process group", "prlimit nproc cap" (`ulimit: Illegal option -u`) and "timeout reap". The PR doesn't touch `packages/sandbox`; these reds are already in the base, and the fix is #1566, which is still open.
  - test-xs fails because `sesNode/module` ThrowTypeError `intrinsic-metadata` flips in the baseline. This is the Node 26 LTS drift; the fix is d82988084a on #1559 (open), and llm doesn't have it yet.
  - The "Failed to exit" lines in the logs are side effects of those sandbox failures, not a separate cause.
- **After:** no change. No commit pushed.

**#1373** (endojs:`ironhorse-panic-classification-lint`, base `llm-1706e63`)
- **Before:** the macOS legs pass. Still red: the same test, cover, sandbox-drivers and test-xs reds as #1364, the two oracle lanes, plus `build`.
- **Cause:**
  - `build` exits with code 127 because `tred: command not found` (graphviz is missing in `check-dependency-cycles.sh`). That is also fixed by #1566.
  - Everything else has the same signatures as #1364: the bwrap tests and the Node 26 drift.
- **After:** no change. No commit pushed.

**#1278** (kriscendobot:`ironhorse-frame-locals-limit`, base live `llm`)
- **Before:** red on `format-ironhorse`, `cover (22.x)`, test-xs and the two oracle lanes.
- **Cause of `format-ironhorse`:**
  - `check-row-schema.py` failed with "new row release must record the newly advanced wire versions". This is not a code defect in the PR.
  - CI checks against the PR's `base.sha`, `204033b`, which was 406 commits behind llm. In those commits, llm added ledger row 6 (25/37) and later raised `STORE_SCHEMA_VERSION` to 38. Checked against the old base, that looks like an invalid change of wire versions.
  - Locally, the merged tree fails against `204033b` and passes against the llm tip. The PR head passes on its own.
  - A rerun can't fix this, because the stale base SHA travels with the run.
- **Fix:** I pushed a same-tree amend of `487f4a6` as `624a590c31`, with no content change and no rebase. The push refreshed `base.sha`.
- **After:** `format-ironhorse` passes on `624a590c31`. The other reds are the same base defects: the bwrap reap test (#1566), the Node 26 drift (#1559) and the oracle lanes.

The oracle lanes (`test-ironhorse-oracle`, `ironhorse-oracle-sanitizers`) stay red on all three PRs until #1613 reaches the base. I left them alone, as the job said.

**Follow-ups:**
- Landing #1566 on llm and re-pinning the frozen bases would clear the bwrap and `tred` reds on every ironhorse PR.
- Getting the Node 26 baseline fix (d82988084a) onto llm would clear test-xs.
- Neither belongs to this job.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-ci2-flake-reruns-20261117.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 1 host(s) (2 unmetered)
- Input: 50 tokens (1781036 cached reads)
- Output: 10301 tokens
- Cost: $1.1761632000000002 (2 engagement(s) unpriced)
- Wall-clock: 15481s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
