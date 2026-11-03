I pinned `.node-version` to `24` in a standalone draft PR, endojs/endo-but-for-bots#1646. Its test-xs check passes on Node 24, so the hardened262 baseline is back to what it was. Seven test/coverage matrix checks were still running when I stopped.

**The PR**
- It changes one file, `.node-version` (`lts/*` → `24`), on branch `chore/pin-node-version-24`.
- It targets the frozen base `llm-48d6f3e`, which is the same commit as `llm` (48d6f3e08b). The PR-opening script refuses a bare `llm` base.
- The body names the blocked PRs (#1633, #1639, #667, #1588). It says that real Node 26 compatibility for the hardened262 `caller`/`arguments` assertions is a separate, deliberate follow-up.

**Checks**
- **Cause confirmed:** on Node 24.22.2, `Function.prototype.caller` and `.arguments` share one accessor (getter and setter are the same function). On Node 26.13.0 neither is true, so `caller` is no longer `%ThrowTypeError%`.
- **Targeted run on Node 24:** `node scripts/test.js --agent sesNode test/intrinsics/ThrowTypeError` in `packages/hardened262` gave `ok` for both `sesNode module` and `sesNode module lockdown`. That run covers the `caller` assertion and the `arguments` assertion after it.
- **Local Node 26 did not reproduce the failure:** the same targeted command also reported `ok` there. That is probably a stale local build, though I didn't confirm it. The CI log for job 125718398161 does show the baseline flip on v26.13.0.
- **Full `yarn test:xs`:** I didn't run it locally, because this host's `xst` is 17.9.1 and CI uses Moddable 9.0.0. The PR's own CI covered it instead: test-xs passed on v24.22.1 with no baseline change (job 125745982878, run 41584227374).
- **Other checks:** 17 passed and 10 were skipped. The seven still running were `cover` (22.x/24.x), `test` (22.x/24.x on ubuntu and macos-15) and `test-thixotrope-ironhorse`. The `cover` and `test` jobs set their Node version in their own matrix, so the pin doesn't affect them.

**Other workflows that read `.node-version`**
These now get Node 24 instead of 26, as listed in the PR:
- several jobs in `ci.yml`, including test-xs
- `release.yml`
- `copilot-setup-steps.yml`
- `update-action-pins.yml` and `update-action-pins-major.yml`

Nothing outside `.github/workflows` reads the file.

**Gauntlet:** I recorded `endojs-endo-but-for-bots-pr1646-gauntlet` on #1646, which runs viability, clean, panel review, fix loop and un-draft.

**Follow-ups**
- Once #1646 merges, the blocked PRs need test-xs re-run on the new base; some may first need a weave onto it.
- Node 26 compatibility for the hardened262 `caller`/`arguments` assertions still needs a deliberate fix: update the test or baseline, or repair it in SES. Nobody has picked that up yet.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pin-node-version-24.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 54 tokens (1768824 cached reads)
- Output: 10910 tokens
- Cost: $1.1150128
- Wall-clock: 1280s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
