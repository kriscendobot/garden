I applied the panel's must-fix items on PR #204 and pushed them, but CI was still pending when the 3600 s deadline ran out (`ci-wait-merge` rc 4). `changes` and `test` passed. The two harness legs (amd64 and arm64) were still waiting for a free slot on the single self-hosted runner, and had been since 07:22Z.

**Pushed to `ci/harness-path-gate`** (`9b952c48` → `3fdab3ae`, via `safe-push-pr-head.sh`):
- **`af7f6eb8` fix(ci):**
  - **Gate moved into a tested helper (prover, corner-prober, fast-checker).** The gate logic now lives in `tools/ci/harness-gate.mjs` with a type file, and the workflow loads it from a sparse checkout. `test/harness-gate.test.ts` has 34 tests:
    - every local Dockerfile `COPY` source, read from the Dockerfile itself, so a new input fails the test until the gate covers it;
    - exact-name and directory-prefix boundaries, and look-alike paths that must not match;
    - renamed files, matched on old or new path, and an empty change list;
    - the 2999 / 3000 / 3001 changed-file cutoff;
    - two fast-check property tests.
  - **Lockfile glob (breaker).** The gate now matches `package-lock.json*` the way the Dockerfile does. With the old exact match, 3 tests fail; I also confirmed that removing the 3000-file fallback turns a test red.
  - **Action pinning (wire-watcher).** `actions/github-script` is pinned to `f28e40c7` (v7.1.0) and the new checkout to `11d5960a` (v4.4.0), with `persist-credentials: false`.
  - **Should-fix (locksmith).** The `changes` job now runs only on pull requests, so pushes never get its `pull-requests` token. The harness job uses `!cancelled() && (push || harness == 'true')` so pushes to `main` still build.
- **`3fdab3ae` docs (breaker and integrator should-fix):** `DEPLOYMENT.md` and the workflow header now say that a skipped matrix creates no per-architecture checks, because the job-level `if` is evaluated before the matrix expands.

**PR body:**
- **Trimmed (pruner):** removed the file-by-file tour, the contrast paragraphs and the endpoint-by-endpoint branch-protection investigation.
- **Measurement section added (benchmarker):**
  - Baseline: recent `main` runs spent 21 runner-minutes on the matrix (amd64 4 min + arm64 17 min), 7 min with a warm cache.
  - Candidate: on docs-only PR #205 the `changes` job took 6 s and the matrix was skipped.

**Checks:** typecheck is clean, the new tests and the pin-drift tests pass, and zizmor shows no new findings for the `changes` job. In CI run 39106004034, `changes` passed (10 s) and `test` passed (9m46s, including the new tests).

**Left as is:** integrator's optional note about folding `9b952c48` into `b82fe98f`. Coverage-auditor's note (no c8 report) is informational only.

**Next:** the driver re-posts this fix stage to wait out the harness legs.

<!-- gauntlet-stage-result: fix=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr204-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 64 tokens (2652742 cached reads)
- Output: 15592 tokens
- Cost: $1.5283083999999996
- Wall-clock: 4400s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
