---
orchestration-failed: true
---
# PR #1527 gauntlet fix round 2: fixes pushed, but CI is red for a cause outside this PR

I applied the panel-2 must-fix items (review 5610594480) and pushed them, then CI went red (`ci-wait-merge` rc=3). The failures are not in this PR's code. GitHub's `ubuntu-latest` runner switched from ubuntu-24.04 to ubuntu-26.04 at about 10:24Z today. On 26.04, two `packages/sandbox` bwrap tests fail on every PR:
- "prlimit nproc cap is enforced inside the slice", with `/bin/sh: ulimit: Illegal option -u`
- "bwrap parent death leaves no owned process group"

Those two tests take down the jobs test 22.x/24.x, cover 22.x/24.x and sandbox-drivers. The unrelated branch `llm-endor-run-unit-tests-ci-lane` fails the same way. This PR only changes `rust/endo` and a design doc, and the fix-1 head was green on the 24.04 image.

**Commits pushed** with `safe-push-pr-head.sh` in advance mode (head `49a6fd78c` → `4ae508178`):
- **`2d847dbd3` `fix(xsnap)`:** `SHOULD_TERMINATE_CHECK` now sits above `run_xs_program`'s doc comment, so the function gets its documentation back. Eleven panel seats flagged this, including typist as must-fix.
- **`4ae508178` `fix(endo)`:**
  - **GC-root timing** (archivist, wire-watcher and engine-realist must-fixes):
    - Both resume paths now hold the lease until the restored worker's first outbound frame, or until its output ends. Before this, `resume_process` released it as soon as the restore payload was queued.
    - The worker sends nothing during its init handshake, and its machine is rebuilt from the snapshot before it can send anything. The first outbound frame therefore shows the snapshot was read.
    - The `GcRootLease` and `gc_roots` docs now state this guarantee once.
    - The SHA-256 arrow in the `gc_roots` doc is now an ASCII `->`.
  - **Registration generation:** `wire_worker_tasks` now takes the generation from its caller's `register_tracked` call. The `None` fallback to an unconditional `unregister` is gone (raised by engine-realist, decomplector and purist).
  - **Early returns:** `resume_shared` now unregisters on its early-return paths.
  - **Repeated suspend:** suspending the same handle twice now releases the replaced record's pin.
  - **New tests** (wire-watcher must-fix):
    - a store-backed resume stays suspended and pins nothing;
    - a failed process resume releases both the root and the registration;
    - a repeated suspend holds one reference.
  - **Design doc:** items 14–16 now match the code, are trimmed, and have consistent blank lines between them.
- **Local run:** `cargo test -p endo --lib` passed 375 of 375, including the round-trip test and the three new tests. I had to put empty placeholders in for the gitignored JS bundles to build it; they are deleted and were not committed.

**PR title and body** (integrator must-fix): this host's token can't edit PRs on endojs (`updatePullRequest` returned 403). I posted job `endojs-endo-but-for-bots-pr1527-gauntlet-fix-2-pr-body`, pinned to `requires: host=endolin-garden-ece02cb4`. It carries the rewritten body, which reflects that the round-trip test is no longer `#[ignore]`d, plus a wider title, and it only applies them if the head is still `4ae508178` or a descendant.

**Follow-ups:**
- I messaged the maintainer about the runner change. The fix is either to stop relying on `ulimit -u` in `/bin/sh` in the sandbox tests, or to pin the workflow to ubuntu-24.04. I posted no fix job, since that needs the maintainer's decision.
- Every gauntlet CI wait will stay red until one of those lands. After that, re-running CI on this head should be enough.
- I saved a memory note about the runner change so future stages can spot it quickly.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1527-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 150 tokens (8788985 cached reads)
- Output: 31262 tokens
- Cost: $3.608229000000001
- Wall-clock: 4990s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
