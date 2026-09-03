The work is complete. Here is my report.

---

## Completion report

**Job:** Fix `guard_head()` in `scripts/jobs/root-repo-guard.sh` so a detached root HEAD that is a valid main2 ancestor but has silently regressed *behind* the recorded `deployed_sha` is caught as drift — the bug that left `garden-state-clone-keeper.service` failing rc=127 while the guard reported the root healthy.

**Root cause confirmed:** `guard_head()` accepted HEAD as healthy on `detached AND main2-ancestor` alone, never comparing against `deployed_sha()`. An out-of-band `git reset --hard 252205765d` (an arbitrary older ancestor) therefore passed the check, leaving the tree ~42 commits behind the deployed sha `3cfbeb5ac4` that the rendered systemd units reference.

**Code change (`scripts/jobs/root-repo-guard.sh`):**
- `guard_head()` now computes the recorded deploy point once (resolved to a commit, trusted only when it is itself a certifiable main2 ancestor — respecting deliberate-deploy). Healthy is now `detached AND main2-ancestor AND (no usable deploy point OR HEAD == deploy point)`. A stale-but-valid ancestor falls through to the existing backup-then-`checkout --detach --force` repair, re-detaching onto `deployed_sha`.
- When no usable deploy marker exists, the prior ancestor-only acceptance stands (nothing better to compare against).
- The repair reuses the already-computed deploy point (removed the duplicate `deployed_sha` lookup), and the alert message distinguishes the 2026-09-03 stale-ancestor signature from the 2026-07-17 escape signature.

**Test change (`scripts/jobs/test/root-repo-guard-test.sh`):**
- Added **CASE 4b**: HEAD detached at a valid-but-stale main2 ancestor (not the deployed sha) → asserts re-detach onto the deployed sha, backup ref preserved, maintainer alerted.
- Fixed a latent fixture-hygiene gap: the stall-window cases left `deployed-sha` at an older ancestor; restored it to the main2 tip afterward so the later `fresh_root` healthy cases match their deployed sha (the tightened invariant now cares about that mismatch). All **71** assertions pass; `bash -n` clean; shellcheck shows only pre-existing info-level notes.

**Committed & pushed:** `c2ea79b117` → `origin/main2` (rebase CAS, first try).

**Follow-up surfaced to the maintainer (via `message-user.sh`):** the immediate remediation on host `endolin-garden-ece02cb4` — its deployed root is still at the stale `252205765d`. I deliberately did **not** touch `$GARDEN_ROOT` (git-in-root is forbidden). Requested a deliberate, drained `deploy-garden.sh` run there, which both re-advances the root to the current deployed sha and deploys this guard fix; thereafter the guard self-heals this drift class every tick.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/self-heal-fix-garden-state-clone-keeper-head-deployed-sha-drift.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 42 tokens (1752130 cached reads)
- Output: 15744 tokens
- Cost: $2.156599
- Wall-clock: 229s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
