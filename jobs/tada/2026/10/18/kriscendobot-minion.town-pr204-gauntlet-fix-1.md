**Fix round 1 for kriscendobot/minion.town PR #204: done, CI green, no new code pushed.**

**What I found.** The panel-1 review was posted at 05:29Z. Two commits on the PR head (`af7f6eb` and `3fdab3a`, both 06:59Z) already address nearly every must-fix and should-fix item:
- **breaker:** the gate now covers `package-lock.json*` through `rootGlobPrefixes`. A test checks the gate against every Dockerfile `COPY`/`ADD` source.
- **wire-watcher:** `actions/github-script` and the `changes` job's `actions/checkout` are both pinned to a commit SHA.
- **prover, corner-prober and fast-checker:** the predicate now lives in `tools/ci/harness-gate.mjs`. `test/harness-gate.test.ts` covers:
  - an empty change list
  - exact-path and directory-prefix boundaries, plus near-miss names
  - files renamed or moved away, via `previous_filename`
  - the 2999/3000 changed-file cap
  - fast-check properties below and at the cap
- **benchmarker:** the PR body has a *Measurement* section linking baseline and candidate Actions runs.
- **should-fix items (locksmith, integrator, breaker):** the `changes` job runs only on PRs, and the docs now say a skipped matrix creates no per-architecture checks.
- **pruner:** the PR body has already been trimmed to Problem, Change and Measurement.

**What was still missing.** The prover asked for proof that the test fails when the predicate is broken. I ran `test/harness-gate.test.ts` locally (34/34 pass), then broke the predicate five ways, one at a time, restoring the file after each:

| Break | Failing tests |
| --- | --- |
| Drop the `package-lock.json*` glob | 3 |
| Ignore `previous_filename` | 2 |
| Drop the 3000-file cap fallback | 1 |
| Drop the `src/` prefix | 3 |
| Always build | at least 8 |

Every break turned the suite red, on both the build side and the skip side. I posted the table, plus a map of each must-fix item to the change that addresses it, as a PR comment: https://github.com/kriscendobot/minion.town/pull/204#issuecomment-6248062839

**CI.** `ci-wait-merge.sh --no-merge` returned 0. The bot token can't read the PR's check status, so the script fell back to the Actions runs API. That shows one run for head `3fdab3a`, "test (typecheck + vitest)" (39106004034), completed with success. Commit statuses and non-Actions checks aren't visible through that route.

**Follow-ups:** none for this stage. The driver re-posts panel-2.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr204-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s)
- Input: 84 tokens (3234521 cached reads)
- Output: 20140 tokens
- Cost: $2.1945601999999997
- Wall-clock: 4497s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
