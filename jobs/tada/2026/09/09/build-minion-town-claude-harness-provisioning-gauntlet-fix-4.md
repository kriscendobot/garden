CI is GREEN (rc 0). The fix stage is complete.

## Completion report

**Stage:** FIX round 4 — kriscendobot/minion.town PR #99 ("feat(deploy): provision pinned Claude harness")

**Applied the round-4 panel's must-fix items** in one review-feedback follow-up commit (`02b3e55`, pushed to `build/claude-harness-provisioning` via `safe-push-pr-head.sh`):

- **assessor (must-fix)** — `deploy/aws/scripts/deploy-app.sh`: guarded every `mv` in the rollback chain (and the promote `mv` its note flagged) behind an explicit `if`, so a failing `mv` under `set -e` can no longer strand the box with **no** `/opt/minion-town`. Each failure path recovers to a box that still has an application tree before exiting non-zero.
- **stylist (must-fix)** — renamed `write_receipt`'s `local dir` → `directory` (maintainer standing-reject, endojs/endo-but-for-bots#650).
- **scribe (must-fix, must-fix-loop)** — posted the long-missing retroactive summary comment naming `a15a117`, its four round-1 findings (assessor/wire-watcher/engine-realist/transplanter) and verification status, plus the round-4 fix summary (issue-comment `5594764097`).

**Should-fixes folded in** (all from request-changes seats, to reduce re-flags):
- **stylist** — `CLAUDE_RELEASE_B64` → `CLAUDE_RELEASE_BASE64`.
- **breaker** — chown the *containing* directories (`/opt/minion-town`, `share`, `share/minion-town`) to root as well as the leaves, so a `minion-mcp`-uid process can't `rm`+recreate `bin/claude` via the parent dir's write bit; the ownership invariant now holds via DAC, not only the systemd `ReadOnlyPaths` bind-mount.
- **migrator** — documented the root `>=20.12` vs harness `>=22.15.0` Node-floor disparity in `DEPLOYMENT.md`.
- **archivist** — qualified the receipt guarantee to "each deploy that reaches the promotion step" (a staged-smoke failure writes none) in `DEPLOYMENT.md` + harness README; "builds" → "provisions" for the harness step.

**Verification:** `bash -n` on `deploy-app.sh` and its extracted inner remote script both pass; `node --test tools/claude-harness/{install,release-verifier}.test.mjs` → 30/30 green (no `.mjs` production logic changed). Reverted an unrelated auto-generated `package-lock.json` drift from the warm-cache install to keep the commit focused.

**CI:** GREEN — all 3 checks (test, Claude harness amd64, Claude harness arm64) pass on head `02b3e55`; `ci-wait-merge.sh` returned rc 0.

**Follow-up:** none from this stage. The driver re-posts panel-5 to re-verify against the new head. Note the on-box behaviors (rollback recovery, root-owned dirs) are provisioning-script logic exercised only at real AWS deploy time, not in CI.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-minion-town-claude-harness-provisioning-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 88 tokens (3921313 cached reads)
- Output: 23468 tokens
- Cost: $3.5713315000000003
- Wall-clock: 475s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
