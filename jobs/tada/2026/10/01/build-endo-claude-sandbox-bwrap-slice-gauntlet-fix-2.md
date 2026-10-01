Fix round 2 for PR #1408 is pushed, but CI was still running when the 3600s deadline hit (`ci-wait-merge` rc=4). This round is still pending, not done.

**PR:** https://github.com/endojs/endo-but-for-bots/pull/1408. The head moved from `1e58ba5d9b` to `f150d71c9d` through a fast-forward `safe-push-pr-head.sh` push.

**Panel-2 must-fix items** (review 5381238104, three seats requested changes):
- **reexport-auditor:** `43ccfd8180` marks `packages/claude/index.js` with `reexport-policy-exempt`. The file is the package's own entry point, not a compatibility shim, and the marker matches the one in `@endo/agent-mcp-stdio`.
- **integrator, item 1 (should-fix):** `65eb0374c1` corrects the DD6 boundary claim in `designs/endo-claude.md` where it is stated. The "Implementation note" a few lines later no longer contradicts it.
- **integrator, item 2 (comment-only):** `f150d71c9d` adds a comment in `.github/workflows/ci.yml`. It says `@endo/claude` uses the `sandbox-drivers` job only because that job installs bubblewrap.
- **scribe:** I posted the missing summary comment (https://github.com/endojs/endo-but-for-bots/pull/1408#issuecomment-5934284585). It lists which commits answer which findings from rounds 1 and 2; nothing from either round was declined.

I did not run the package tests locally. These changes touch only a comment marker, prose and a CI comment.

**CI:** at the deadline, 2 of 35 checks were still pending: `compare-ironhorse-math` and `test (22.x, macos-15)`. No check had failed.

**Follow-up:** the driver should re-post this stage to finish watching CI. There is nothing left to fix.

<!-- gauntlet-stage-result: fix=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-endo-claude-sandbox-bwrap-slice-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 42 tokens (1255093 cached reads)
- Output: 5942 tokens
- Cost: $0.8369706000000001
- Wall-clock: 3741s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
