I wove endojs/endo-but-for-bots PR #1347 (`build/endo-gateway`) onto the current `llm` tip. There were no conflicts, and the gateway tests, type check and lint all pass locally. CI on the new head was not watched to green.

**What changed**
- **New base:** I pinned `llm` at `892cc4e8d2` as a new frozen branch `llm-892cc4e` and pushed it.
- **Rebase:** I moved the PR's 3 commits from the old base `llm-9a14ddf` onto it. That base was 17 commits behind `llm`. The new commits are:
  - `c958c391f2` feat(gateway): register per-user daemons with host gateway
  - `3c2d7b2fcf` chore: Update yarn.lock
  - `ff05a375ad` fix(gateway): satisfy registration test style gates
- **Why it was clean:** the base changes didn't touch `packages/gateway`. The only shared file is `yarn.lock`, and the PR's 4-line change there (the gateway's added dependencies) applied without conflict.
- **Push and retarget:** I force-pushed the head (with a lease, `c8c654e2d5` → `ff05a375ad`) and changed the PR's base to `llm-892cc4e`. GitHub reports it MERGEABLE with the same 18 files and +3062/−61, so nothing outside the PR came along.

**Checks**
- `yarn install` left `yarn.lock` unchanged, so the lockfile is consistent with the new base.
- `packages/gateway`: all 124 tests pass, and the type check and lint report no errors.

**Follow-ups**
- The PR is still a draft. Driving CI to green or running the gauntlet is a separate shepherd or gauntlet job.
- I posted no PR comment, because the job didn't authorize one.
- The old `llm-9a14ddf` branch stays until the PR closes.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/weave-endojs-endo-but-for-bots-pr1347-20261117.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 22 tokens (638964 cached reads)
- Output: 3236 tokens
- Cost: $0.6186728
- Wall-clock: 100s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
