## Shepherd report: endojs/endo-but-for-bots#1591 (`fix/sandbox-bwrap-leader-exit-group-sweep`, base `llm-48d6f3e`)

CI is now fully green on the new head **59f6b24875**. Green CI run: https://github.com/endojs/endo-but-for-bots/actions/runs/43738401333. There are 17 passing checks, including `sandbox-drivers`, `test-xs`, `zizmor`, `lint`, and the `test`/`cover` matrices. The other 18 checks were skipped.

**What was failing on the old head ffc226fb58.** Neither failure came from the PR's own changes. Both are known drift that affects every PR on this base:
- **`test-xs`**: the hardened262 baseline changed for `sesNode/module test/intrinsics/ThrowTypeError/intrinsic-metadata.js` from passed to failed. CI's `lts/*` now resolves to Node 26, which gives `Function.prototype.caller` its own accessors.
- **`zizmor`**: the `peter-evans/create-pull-request` pin had a `# v8` version comment. Upstream moved the `v8` tag to 3ffccacd4605, but the pinned sha 5f6978faf089 is `v8.1.1`. This tripped both `update-action-pins.yml:49` and `update-action-pins-major.yml:49`.
- The many cancelled checks were a duplicate set of workflow runs that GitHub's concurrency cancelled. They were not failures.

**What I did.** I cherry-picked the two existing fixes from #1559's branch onto the PR head. I pushed with `--force-with-lease` against ffc226fb58, and the push was a fast-forward:
- `962a5215d4` test(hardened262): records the Node 26 caller-accessor divergence in the sesNode baseline (from d82988084a).
- `59f6b24875` ci: changes the create-pull-request version comment to the exact tag `v8.1.1`. This is a comment-only change (from 22580d5a4d).

I did not change the PR's own sandbox commits (a543dbd3b9, ffc226fb58). I did not post a comment on the PR, because the job body doesn't authorize one.

**Follow-ups:**
- `llm` still lacks both fixes. Until they land there, every PR that runs `test-xs` or `zizmor` will hit the same failures. Landing d82988084a and 22580d5a4d on `llm` would stop this from recurring.
- When this PR is woven or merged, these two commits will become duplicates of whatever version lands on `llm`, so they'll need to be deduplicated then.
- #1591 is still a draft. The next step is its gauntlet or un-draft, which then unblocks the #1504 sandbox-shell gate.

next: none
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/shepherd-endojs-endo-but-for-bots-pr1591.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 28 tokens (910555 cached reads)
- Output: 5893 tokens
- Cost: $0.813395
- Wall-clock: 781s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
