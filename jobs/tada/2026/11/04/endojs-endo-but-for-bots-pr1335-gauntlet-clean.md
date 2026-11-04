---
orchestration-failed: true
---
orchestration-failed: true

# Clean stage FAILED for endojs/endo-but-for-bots#1335: CI is red, but not because of this PR

The clean stage failed because CI is red at the PR head. All five failing checks come from bwrap tests in `packages/sandbox`, a package the PR doesn't touch. I didn't run the coverage pass or push anything, since a push to this PR can't turn CI green.

**PR state:** `fix(daemon): bind OCapN gateways to peer sessions`. It is an open draft, mergeable, at head `d2c0bf314e86` on `build/ocapn-gateway-session-binding`, based on `build/guest-locator-adoption-11e726e`. It only changes `packages/daemon/**`, a design doc and a changeset.

**CI result:** `ci-wait-merge.sh --no-merge` returned **rc 3 (RED)**: 33 checks, 5 failed, 12 passed, 16 skipped.

| Check | Failing test |
|---|---|
| `test (22.x, ubuntu-latest)` | `bwrap › bwrap parent death leaves no owned process group`: "Test finished without running any assertions" |
| `test (24.x, ubuntu-latest)` | same as above |
| `sandbox-drivers` | the same parent-death test, plus `bwrap › prlimit nproc cap is enforced inside the slice`: `/bin/sh: 1: ulimit: Illegal option -u` |
| `cover (22.x, ubuntu-latest)` | same two bwrap tests |
| `cover (24.x, ubuntu-latest)` | same two bwrap tests |

**Cause:** these bwrap failures don't work on the GitHub runners and also show up on PRs unrelated to the sandbox. The fix is endojs/endo-but-for-bots#1566 ("fix(ci): install graphviz-tools and make bwrap tests runner-portable"). It is still **open and unmerged**, and it targets the frozen base `llm-204ecd1`, so this PR's stacked base doesn't have it.

**Changes made:** none. No commits and no pushes.

**Follow-ups:**
1. Land #1566 and get its fix into this PR's base, either by weaving `build/guest-locator-adoption-11e726e` and then #1335, or by weaving #1335 onto a base that includes the fix.
2. Then re-run the gauntlet's clean stage. The coverage pass on `packages/daemon` still needs to be done in that run.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1335-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 14 tokens (369607 cached reads)
- Output: 2652 tokens
- Cost: $0.5474494
- Wall-clock: 42s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
