I wove PR #1594 onto the current `llm` without conflicts, but the PR is still not green. Zizmor still fails because of a new base-wide drift that this weave can't fix, and `test-xs` is also red for a known base-wide reason.

**What changed**
- I snapshotted `llm` at its current tip `48d6f3e08b` as the frozen base `llm-48d6f3e`. That branch already existed at the same commit.
- I rebased the 11 PR commits with `git rebase --onto llm-48d6f3e llm-9a14ddf` (the old frozen base). The base moved forward 8 commits: the zizmor-action 0.8.0 bump (#1630), the eslint-plugin-unicorn bump (#1635), the all-minor-patch group bump (#1631) and two claude-sandbox and ava test fixes.
- `git range-diff` shows all 11 commits are patch-identical after the rebase. None were dropped or emptied. The PR still touches the same 83 files (+632/−590).
- None of the files the new base changed contain the old `Mignonic*` / `DaemonPowers` names, so the rename has nothing new to catch up on.
- I force-pushed with `--force-with-lease` (head `fbded5f805` → `d43ee2e4ea`) and changed the PR's base field from `llm-9a14ddf` to `llm-48d6f3e`. The PR stays draft. I posted no PR comment because the job didn't authorize one.

**CI after the weave**
- **Zizmor still fails.** The 0.8.0 fix it was meant to inherit is now in the branch. The new failure is in `update-action-pins.yml:49` and `update-action-pins-major.yml:49`: the version comment on the `peter-evans/create-pull-request` pin (`# v8`) no longer matches, because that action moved its floating tag. This is the same on `llm` itself. Open PR #1659 (`ci: correct peter-evans/create-pull-request pin comment to v8.1.1`, not a draft, waiting to be merged) fixes it. Once #1659 lands, #1594 needs another weave to pick it up.
- **`test-xs` fails** in `@endo/hardened262`: `sesNode/module ThrowTypeError/intrinsic-metadata.js` flipped from pass to fail. This is the known drift from Node 26 becoming the current LTS. The fix is on #1559 and isn't on `llm` yet, so this failure doesn't come from this PR. The same step also hit a timing assertion (`Expected 14499.9936 to be less than 10000`) that looks like a timing flake.
- `lint`, `sandbox-drivers` and the rest of the early checks passed. The node and macOS test and coverage runs were still pending when I stopped waiting. I ran no local tests.

**Follow-ups**
- Merge #1659, then weave #1594 again so zizmor goes green.
- Get the hardened262 Node 26 fix from #1559 onto `llm` so `test-xs` turns green across all PRs.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/weave-endojs-endo-but-for-bots-pr1594.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 38 tokens (1164335 cached reads)
- Output: 6014 tokens
- Cost: $0.8280510000000002
- Wall-clock: 674s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
