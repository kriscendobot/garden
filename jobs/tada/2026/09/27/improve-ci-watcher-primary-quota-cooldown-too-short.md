Inbox drain is offline (transient clone timeout, rc=124) — no messages, nothing actionable. My work is committed and pushed. The job is complete.

## Completion report

**Job:** `improve-ci-watcher-primary-quota-cooldown-too-short` — route mirror-closer/ci-watcher primary-quota exhaustion through a full-hour shared cooldown instead of the 900s blip window, and retire mirror-closer.sh's private duplicate in favor of the shared helper.

**What I found (premise partly stale):** The job's headline complaint — ci-watcher's `rollup_hit_primary_quota()` capped at 900s — was already fixed on 2026-09-20 (`91eb85cb75` + `d1bb518590`, both ancestors of main2). common.sh already has `api_primary_quota_secs()` (~3600s) and a `start_api_cooldown` that accepts a requested window clamped to `GARDEN_API_COOLDOWN_MAX_SECS` (7200), plus GraphQL-scoped latches. Both `ci-watcher.sh` and `comment-latency-watch.sh` already route primary-quota through the shared helper. **mirror-closer.sh was the last holdout** still carrying a private duplicate — so that was the remaining actionable work.

**What I changed:**
- `scripts/jobs/mirror-closer.sh`: removed the private cooldown machinery (`MIRROR_QUOTA_MARKER`, `mirror_quota_now`/`_cooldown_secs`/`_cooldown_active`, `start_mirror_quota_cooldown`, `MIRROR_QUOTA_EXPIRY`; ~55 lines). The circuit breaker now arms `start_api_cooldown "mirror-closer:primary-quota" "$(api_primary_quota_secs)"`, and the per-tick skip reads the shared `api_cooldown_active`. Kept `all` (host-wide) scope since mirror-closer makes both GraphQL and REST calls. Net behavior unchanged (still a full-hour cooldown); now a single throttle, so `GARDEN_API_COOLDOWN_SECS=0` governs it too. Updated header docs.
- `scripts/jobs/test/mirror-closer-test.sh`: reworked H1c/H1d to validate persistence/expiry via the shared latch (isolated per-scenario `GARDEN_API_COOLDOWN_DIR`), removed the retired `GARDEN_MIRROR_QUOTA_*` env, and added assertions that the trip arms the shared latch for the full hour.

**Verification:** `bash -n` clean; shellcheck shows only pre-existing info notes. A clean isolated run passes **66/66** (matching the pristine baseline). No lingering references to the retired symbols except the intentional historical note.

**Committed & pushed:** `77e8c7af9f` on `origin/main2` (bot identity, only the two files).

**Incident handled:** A concurrent peer running the same test repeatedly corrupted my worktree — the test uses a *fixed shared* `$TR=/home/kris/.garden-mc-test`, and when a peer wipes it mid-run, `seed_bare`'s `mktemp` collapses to an empty path so `git init ""`/`git add -A`/`commit` executes in the current directory (my worktree), producing bogus "seed" commits mixing journal junk with my changes. It never reached origin. I recovered each time via `git reset --hard origin/main2` + restore, and pushed through a CAS loop with a staged-set guard. To prevent recurrence I **hardened `seed_bare`/`mapping_of`** to fail loudly instead of running git in cwd when `mktemp` fails.

**Follow-ups:**
- The mirror-closer test (and likely other garden tests) hard-codes a fixed shared `$TR`, making it flaky and corruption-prone under concurrent runs on a shared host. My guard blunts the worst case; the real fix is a unique per-run `TR` (`mktemp -d`) — worth a broader sweep. Note `/tmp` is `noexec` here, so `$TR` must stay under `$HOME` for exec'd stubs.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-ci-watcher-primary-quota-cooldown-too-short.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 3 host(s) (2 unmetered)
- Input: 94 tokens (4764291 cached reads)
- Output: 61061 tokens
- Cost: $5.276370499999999 (2 engagement(s) unpriced)
- Wall-clock: 1057s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
