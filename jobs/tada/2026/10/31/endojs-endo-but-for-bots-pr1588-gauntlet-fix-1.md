---
orchestration-failed: true
---
orchestration-failed: true

# Fix round 1 for endojs/endo-but-for-bots PR #1588: probes pass, CI is red on one test outside the PR

CI came back red (`ci-wait-merge.sh` rc=3), so this round is recorded as an orchestration failure. The only failing test is in `packages/sandbox`, which this PR does not touch. I pushed nothing this round.

**Probe findings.** The PR head (`endo-fetch-split-confined-plugin`, `0c55ae5d6`) already has fixes for both failing probes, from earlier commits on the branch:
- `98b7ab72b` moves the `Delay` typedef in `packages/exo-http-client/index.js` to a top-of-file `@import` tag. It also adds a `spell-out-exempt` marker to `packages/http-confine/test/http-confine.test.js`, because `ok` there is the fetch Response field that the transport fakes have to carry.
- `0c55ae5d6` renames that `@import` to `CancellableDelay`, so the generated `index.d.ts` no longer declares `Delay` twice (TS2440).

I re-ran both probes against the PR base `llm-9a14ddf` (`PRE_PUSH_BASE_REF`), and both now pass.

**Advisory pruner comment.** I kept the long comment at `packages/confined-fetch/src/index.js:2`. It documents which capabilities the plugin looks up by name (`fetch`, `fetch-store`, `timer`, and an optional `fetch-policy-authority`), that `env` applies only on first provisioning, and who owns revival. That contract isn't obvious from the code.

**CI.** Run 41240553924 on `0c55ae5d6`: 36 checks, 1 failed. `test (24.x, ubuntu-latest)` failed only in `@endo/sandbox#test`. The test in `packages/sandbox/test/bwrap.test.js:1099` that kills a cancelled spawn timed out in `waitForProcessGroupGone` (`bwrap.test.js:266`). This looks like the known ubuntu-26.04 runner breakage, since the PR diff has no files under `packages/sandbox`. The base already contains the earlier sandbox fix (`27705a4cd`), but this other process-group cleanup test still fails on the new runner.

**Follow-up.** This needs a separate sandbox or runner fix job on the base branch, not more work in this PR. Once that fix lands, rerunning CI or weaving the PR should turn it green.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1588-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s)
- Input: 138 tokens (4930034 cached reads)
- Output: 19401 tokens
- Cost: $2.5092588
- Wall-clock: 8184s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
