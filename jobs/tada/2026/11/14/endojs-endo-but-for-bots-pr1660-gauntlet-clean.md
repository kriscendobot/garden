---
orchestration-failed: true
---
orchestration-failed: true

# Gauntlet CLEAN stage — endojs/endo-but-for-bots#1660: CI is red, from two failures this PR didn't cause

The coverage pass is done and its one new test is pushed, but CI ended red (`ci-wait-merge` rc 3). Neither red check comes from this PR's changes. The PR is `submit-once` against base `llm-48d6f3e`, titled "feat(daemon): submitOnce answers a form at most once per attempt".

## What I did
- **Coverage pass on `packages/daemon`:** The PR's tests covered every new path except one: the `submitOnce` error "Attempt … already answered another form". I added the test `submitOnce refuses an attempt that already answered another form` and pushed it with `safe-push-pr-head.sh` (`c9e50723d4..f323aa7e42`).
  - While writing it I found that `followMessages` replays messages the host already has. So the PR's `sendAnswerForm` helper can't be used to get a *second* form. The new test picks both forms with `listMessages` instead.
  - I ran all 8 `submitOnce` tests locally against a real daemon and they pass. Prettier made no changes, and eslint shows no new warnings.
- **Dead code:** none. `submit` was refactored onto the shared `marshalFormValues` and `makeFormAnswer` helpers, and no code was orphaned.

## CI result (head `f323aa7e42`)
The 4 `test` legs (Node 22/24 on ubuntu and macOS) passed. Two checks failed:

1. **zizmor:** Between 13:55Z and 14:08Z the floating `v8` tag of `peter-evans/create-pull-request` moved from v8.1.1 to v8.1.3. The pin comment `# v8` in `update-action-pins.yml:49` and `update-action-pins-major.yml:49` no longer matches. This will fail every PR on this base until **#1659** ("ci: correct peter-evans/create-pull-request pin comment to v8.1.1") is merged; it is open, ready for review and mergeable. This PR touches no workflow files.
2. **sandbox-drivers:** One test, `bwrap › bwrap timeout and repeated cancellation reap process groups`, failed with "process group … survived bounded cleanup". That's in the sandbox drivers, not daemon mail, so it looks like the known bwrap flake. After CI finished I started a rerun of the failed jobs (run 43604166395); I didn't wait for its result.

## Next steps
- Merge #1659 to clear zizmor.
- Check that the sandbox-drivers rerun came back green.
- Then re-run the gauntlet's clean stage. The coverage work is already on the PR head, so that pass should only need to see CI green.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1660-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 80 tokens (3176319 cached reads)
- Output: 13364 tokens
- Cost: $1.5791037999999997
- Wall-clock: 2754s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
