I diagnosed the timeout and found no new defect, so I changed no code and opened no PR. The frozen base `609821f7` is one fix commit behind its own source branch, and that fix is already on PR #1396's head with green CI.

**Root cause:** the Ironhorse worker boot replaces `@endo/init`, but at `609821f7` it does not install the Parcel shim before `lockdown()`. When the worker handles its first message, OCapN's `isParcel` check loads `@endo/parcel` after lockdown. That package refuses to install Parcel that late, so the worker throws and the daemon dies before replying. The tests then hang until their timeouts. This is a real, deterministic bug in the stack, not a CI-resource flake and not a regression on `llm`. Commit `16bb8a11b` ("fix(thixotrope): install the Parcel shim in the Ironhorse boot") fixes it. It landed on `build/sturdyref-captp-construct` (PR #1396) right after `609821f7` was frozen, together with a `chore: Update yarn.lock` commit.

**Evidence (from the CI logs):**

| Commit | `test-thixotrope-ironhorse` | Notes |
| --- | --- | --- |
| `609821f7` (frozen base; CI run 38849968709, job 116818041222) | cancelled at the 20-minute limit | 9 reachability/reliability tests each hit the 2-minute "Test timeout exceeded"; the reliability ones also show `daemon exited before reply` (`reliability.js:69`) after only SES lockdown output |
| `9a9ac8c6f` = `609821f7` + `16bb8a11b` + yarn.lock (current #1396 head; run 38856071316) | **passes** in about 10 min | same commit range with the fix added |
| `61cd656cb` (live `llm` head; run 38909012390) | passes in about 9 min | every reachability/reliability test takes 5–10 s |
| `863a9957f` (older base, where `llm` and the stack diverge; run 38683310142) | CI run passed | the stack's Parcel changes come after this point |

The only difference between failing and passing is the 4-file fix: `packages/thixotrope/scripts/bundle-ironhorse-worker.mjs`, `package.json`, `tsconfig.composite.json` and `yarn.lock`.

**Recommendation:** re-pin the halted PRs onto the fixed base (a weave):
1. Weave #1397: snapshot `build/sturdyref-captp-construct` at `9a9ac8c6f` (or its tip at that time) to a new `build/sturdyref-captp-construct-9a9ac8c`, rebase #1397 onto it, and move its base.
2. Then weave #1398. Its base is `build/sturdyref-ocapn-enliven-8f3d801`, a freeze of #1397's old head, so it inherits the same bug. Re-freeze it from #1397's new head after step 1.

Both are recurring verbs, so the jobs need the `-YYYYMMDD` suffix.

**Restack stages:** neither the #1397 `summary` stage nor the #1398 `summary` stage should resume on its current base, because both bases still lack the fix and would fail the same way. Each can resume once its weave has landed and `test-thixotrope-ironhorse` is green: #1397's first, then #1398's. As instructed, I did not resume or re-post those stages, and I did not post the weave jobs; that is the liaison's or maintainer's call.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endo-parcel-base-thixotrope-timeout-diagnose-20261016.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 28 tokens (687807 cached reads)
- Output: 5938 tokens
- Cost: $0.6612894
- Wall-clock: 136s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
