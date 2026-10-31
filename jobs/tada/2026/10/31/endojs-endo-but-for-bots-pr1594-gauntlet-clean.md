Clean stage for endojs/endo-but-for-bots#1594: **still pending.** I made no changes, but CI did not finish before the deadline (`ci-wait-merge.sh` returned rc 4 after 3300s), so this stage needs to be re-posted.

**Coverage and dead code:** nothing to do. The PR (`refactor(daemon): rename Daemon/Mignonic to Manager/Worker`, draft, base `llm-9a14ddf`) only renames identifiers, comments, docs and tooling, so there is no new behaviour to cover.
- No code is left orphaned. The only remaining old names (`makeDaemon`, `DaemonDatabase`, `WorkerFacetForDaemon`, `workerDaemonFacet`, `daemonDb`) are local test helpers in `packages/thixotrope` that have nothing to do with this rename.
- The new `@deprecated` re-export of `WorkerFacetForManagerInterface` from `interfaces.js` is still used by `test/xs-worker-facet.test.js`.

**CI:**
- **Head moved twice during the wait.** Someone else pushed `cd1cd2923a` and then `c13ac3d27a` (both "leave Rust-side comments to their own follow-up"). The current head is `c13ac3d27a`, and each push restarted CI.
- **Four checks still running** at the deadline: the four `test` legs (22.x and 24.x, on ubuntu and macos-15).
- **`sandbox-drivers` failed** at `c13ac3d27a` (run 41219504708, job 124591078684). The one failing test is `bwrap › bwrap timeout and repeated cancellation reap process groups`, with `Error: process group 12208 survived bounded cleanup`. It passed on earlier attempts in the same job, failing only once. This looks like the known, already-existing bwrap flake (the fix is #1566), not something this rename caused.
- That run was still in progress, so the failed job couldn't be re-run yet. The next run of this stage should re-run `sandbox-drivers` with `--failed` before treating it as a real failure.

<!-- gauntlet-stage-result: clean=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1594-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 40 tokens (1276228 cached reads)
- Output: 5601 tokens
- Cost: $0.8438975999999999
- Wall-clock: 4019s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
