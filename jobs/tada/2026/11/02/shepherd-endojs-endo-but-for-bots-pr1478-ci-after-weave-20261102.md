**Shepherd report: endojs/endo-but-for-bots#1478 (ocapn-noise session outbound queue)**

**Result:** CI is green on head `1b750a1d47`. All 6 workflows passed; check-runs show 18 success and 18 skipped. The PR is MERGEABLE and still a draft, so the gauntlet can resume.

**What was red after the weave (head `583a7793a8`), and why**
1. **ironhorse-oracle-sanitizers** failed on two attempts, including my re-run. The failures were the stage3-math 054/055 asinh/acosh disagreements on an `ubuntu-26.04` runner. That is the known runner-image drift; the fix is upstream PR #1613, which is still open.
   - The job shouldn't have run at all: the PR only touches `packages/ocapn-noise`. It ran because the weave force-pushed the head before moving the PR's base field. The push's event therefore carried the old base SHA, and `scripts/ci-changes.py` diffed against it. That diff swept in all of llm's newer changes, including `ci.yml`, so every job was selected.
   - Re-running doesn't help, because a re-run reuses the same event.
2. A duplicate set of runs for the same head was cancelled by concurrency (harmless).

**What I did**
- Confirmed the PR's base field is now current (`e530cc47`, the head of PR #1476).
- Re-committed the top commit with an identical tree and only a new committer date. I force-pushed it to `build/ocapn-noise-session-queue` with lease (old `583a7793a8` → new `1b750a1d47`). The content is unchanged.
- The new event selected only the jobs this PR affects, and the sanitizer workflow passed.
- One new red appeared: `cover (22.x, ubuntu-latest)` in `packages/sandbox`, test "bwrap timeout and repeated cancellation reap process groups" ("process group survived bounded cleanup"). This PR doesn't touch that package, and the test passes on the base, so I classed it as a timing flake. One re-run turned it green.
- I didn't close/reopen the PR as a way to re-trigger CI, because `mirror-closer.sh` and `unblock.sh` react to closed PRs.

**Green runs on `1b750a1d47`**
- CI: https://github.com/endojs/endo-but-for-bots/actions/runs/41403444426 (cover passed on the re-run)
- IronHorse oracle sanitizers: https://github.com/endojs/endo-but-for-bots/actions/runs/41403444546
- OCapN Guile interop, Floot Android, Workflow security audit, Test project mutual dependency versions: all passed.

**Classification:** `next: none`. Both failures came from outside this PR: the runner-image drift exposed by the post-weave job selection, and a sandbox bwrap timing flake. No PR comment was posted, since the job body didn't authorize one.

**Follow-ups**
- Any PR whose CI selects the oracle lanes stays red on `ubuntu-26.04` runners until #1613 (pin those lanes to ubuntu-24.04) lands on llm. That needs maintainer review.
- **Weave ordering:** every weave triggers a full-CI run against a stale base, so unrelated red lanes can appear after it. A small weaver change could avoid this, either by moving the base before force-pushing the head or by re-triggering CI after the base moves. I didn't post a job for it.
- The bwrap cleanup flake is covered by open PR #1566.
- I saved a memory note on the post-weave full-CI behaviour and the same-tree re-push fix.

## Panel-head freshness

Disposition: **review required**. The last completed panel reviewed `750929d3b57e04b46ccca07225c8844dc4ab7df8`; this job presented `1b750a1d47c5c833550bbc3b323f989dad04fcba`. The old panel verdict does not cover the current head. No gauntlet was staged; the maintainer review docket received a deduplicated re-review action.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/shepherd-endojs-endo-but-for-bots-pr1478-ci-after-weave-20261102.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 78 tokens (3046402 cached reads)
- Output: 15770 tokens
- Cost: $1.5982484000000003
- Wall-clock: 4776s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
