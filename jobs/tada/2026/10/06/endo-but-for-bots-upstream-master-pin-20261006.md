I've pinned upstream `master` on endo-but-for-bots and opened the draft PR, and CI does run on it. But it doesn't yet reproduce upstream's failures: every CI job fails at `Install dependencies`, a step that passes upstream.

**What I did**
- **Frozen base:** fetched upstream `endojs/endo` `master` at `356d6e70affc5adfd35cd65adda758119521ec5f` and pushed it to `endojs/endo-but-for-bots` as `master-356d6e7`.
- **Working head:** created `fix-upstream-master-ci` from the same commit. GitHub won't open a PR with no commits between head and base, so I added one empty commit as the bot (`chore: open CI shepherding of upstream master 356d6e7`). The shepherd can drop or squash it later; the net code diff is zero.
- **Draft PR:** opened https://github.com/endojs/endo-but-for-bots/pull/1428 through `ensure-pr.sh`, base `master-356d6e7`, with the job marker and the repo's PR template filled in.
  - **Head SHA:** `75c4c7de2ec1890a9b0557ea91ef46a2e92d6d72`

**CI runs, but fails earlier than upstream**
- Three workflows ran on the head SHA from the `pull_request` event:
  - "Workflow security audit": passed.
  - "Test project mutual dependency versions": passed.
  - "CI" (run `37406462241`): failed.
- All 12 CI jobs failed at `Install dependencies`. Yarn 4.13.0 detects a public pull request and turns on "hardened mode", which rejects a lockfile resolution:
  `YN0078: Invalid resolution configstore@npm:^1.4.0 → npm:5.0.1`
- Upstream's `master` runs come from `push` events, which don't use hardened mode. That's why install passes there and `lint` / `viable-release` / `test (22.x, macos-15)` fail later.
- The jobs also log a secondary `Post Checkout` error (the runner's `node24` binary is missing). It looks like runner noise that follows the install failure.

**Handoff to `endo-but-for-bots-upstream-master-ci-shepherd-20261006`**
- PR: https://github.com/endojs/endo-but-for-bots/pull/1428, head branch `fix-upstream-master-ci`, head SHA `75c4c7de2ec1890a9b0557ea91ef46a2e92d6d72`, base `master-356d6e7`.
- **First blocker:** the hardened-mode install failure on the `configstore` resolution. Fix it either by repairing the resolution or lockfile entry, or by opting out of hardened mode in CI. Opting out is weaker, since it would only exist on our branch. Only after install passes will upstream's three real failures show up.

I did not touch `llm`, and nothing was pushed to `endojs/endo`. My inbox drain timed out cloning the journal, so I couldn't check for incoming messages. That didn't block this work.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endo-but-for-bots-upstream-master-pin-20261006.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (880490 cached reads)
- Output: 5934 tokens
- Cost: $0.704362
- Wall-clock: 487s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
