All work complete and landed on `main2`. No inbox messages; the primary suite is green on the final tree.

## Completion report

**Task:** Extend `scripts/jobs/common.sh` clone self-heal so a present-but-corrupt journal clone is repaired instead of FATAL-looping every tick.

**Context found on arrival:** Prior commits had already added a corruption classifier (`_fetch_stderr_is_corrupt` / `GARDEN_CORRUPT_CLONE_SIGNATURES`) and a **single-stage** re-clone heal in `sync_clone` (HEAD commit "single-stage, spec-faithful", landed 20 min before this job was claimed). This job's spec explicitly asks for a **two-tier** heal — a cheap in-place repair *in front of* the existing re-clone — which is what actually fixed `.garden-state/gardeners/6/journal`. I implemented that.

**What I did:**
1. **`scripts/jobs/common.sh` — `sync_clone` two-tier heal (both under the held `clone_lock`):**
   - **Tier 1 (cheap repair):** `rm -f` the `.git/gc.log`, the corrupt `refs/remotes/origin/$JOURNAL_BRANCH` + its reflog, and drop any `packed-refs` line for it (via `sed`, exact refname column), then re-fetch — no history re-download. Plain `rm -f`/`sed` on the ref *file* is deliberate: git refuses `update-ref -d` on a ref it calls a `bad object`.
   - **Tier 2 (fallback):** only if Tier 1's re-fetch still fails, the existing atomic `rm -rf` → `ensure_clone` (temp-clone→mv) re-clone, then re-fetch once. Heals at most once, then `die`s loud (no reclone loop). Connectivity races on either re-fetch still take the EX_TEMPFAIL clean-skip path.
   - Logs `WARN: <dir> journal clone corrupt (<sig>); self-healing by repair` / `… by re-clone` so the acting tier is visible.
   - This lives in `sync_clone`, the single fetch gate every board op (claim/complete/post) routes through — so it fires on the claim path before FATAL, satisfying the wiring requirement.

2. **`scripts/jobs/test/fetch-timeout-test.sh` — SUBTEST 5** rewritten to assert both tiers (cheap repair keeps the clone in place: poison survives, gc.log removed, 2 fetches; fallback wipes: poison gone, 3 fetches). The mock now restores the tracking ref on success, faithful to a real fetch.

3. **`scripts/jobs/test/run-test.sh` — SUBTEST 24** corrupt block (A/B/C) realigned from single-stage to two-tier. Property A now proves Tier 1 end-to-end with a **real** `git fetch` on a real null-sha corruption (clone kept in place).

**Verification:** fetch-timeout-test.sh **15 passed, 0 failed**. SUBTEST 24 corrupt block, run in isolation (run-test.sh aborts early here on the unrelated systemd/scaler SUBTEST 4): **3 passed, 0 failed**. Sibling suites (signal-kill-classifier, bot-identity-bootstrap, scholar-preflight) all green.

**Changes landed:** two commits on `origin/main2` — `7ccfe92e62` (the heal) and `7a63107588` (SUBTEST 24 realign).

**Follow-up / note:** run-test.sh could not be run end-to-end in this worktree sandbox — it aborts at SUBTEST 4 (gardener-scaler; needs systemctl/scaler mocks) and `/tmp` is noexec here (stub scripts must live under `$HOME`, which run-test.sh's `TR=/home/kris/.garden-test` already does). The corrupt-path coverage was verified via the isolated harness; a full run should be exercised on a normally-provisioned host.
