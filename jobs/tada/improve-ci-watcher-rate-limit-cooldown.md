Job complete. Report follows.

---

## Completion report — `improve-ci-watcher-rate-limit-cooldown`

**What the job asked:** the per-repo `ci-watcher` / `dependabot-watcher` / `approval-reconciler` / `issue-inbox-watcher` instances all hit the same gh-api 5xx/rate-limit blip in lockstep (a self-inflicted thundering herd). `comment-watcher.sh` already had a per-instance host-shared cooldown; extract it into a shared `common.sh` helper and wire it into the four other watchers.

**What I did:**
- **Extracted the mechanism into `common.sh`**: `start_api_cooldown [tag]` (first detector records a finite window, owns the one warning) and `api_cooldown_active` (every sibling tick skips before its API call), plus `_api_cooldown_secs` (validate/clamp). Keyed off a new `GARDEN_API_COOLDOWN_SECS` (default 300s, capped 900s, 0 disables) and a **single HOST-WIDE marker** `$GARDEN_STATE/gh-api-cooldown/marker` — deliberately *not* per-watcher-kind, so one blip quiets every kind out of one window. flock-atomic expiry/re-arm; observers never extend a live window; cursor untouched (fail-closed "never guess").
- **Wired all five watchers**: added the `api_cooldown_active && exit 0` early-skip guard and wrapped each `is_transient_gh_source_error` handler in `if start_api_cooldown "<kind>:$slug"; then log …` in `ci-watcher.sh` (first, most-affected), `dependabot-watcher.sh`, `approval-reconciler.sh`, and `issue-inbox-watcher.sh`.
- **Migrated `comment-watcher.sh` off its private copy** onto the shared helper (kept a one-line compat shim honoring the legacy `GARDEN_COMMENT_API_COOLDOWN_SECS` override) so all gh-api watcher kinds truly share **one** window, not one-per-kind.
- **Tests**: added shared-cooldown assertions to `ci-watcher-test.sh` (host-wide marker path, silent sibling-skip without invoking the source, cross-kind `api_cooldown_active` predicate); repointed `comment-watcher-test.sh`'s CD test at the new shared marker path.

**Verification:** all five suites green — ci-watcher 67/0, dependabot 43/0, approval-reconciler 15/0, issue-inbox 43/0, comment-watcher 349/0. `bash -n` + `shellcheck -S error` clean on all touched scripts.

**Landed:** commit `dddd6f6d80` on `origin/main2`.

**Note (handled, no follow-up needed):** early in the session I mistakenly applied my edits to the deployed garden root (`/home/kris/garden/...`) instead of my worktree. I never ran git there. I restored all eight deployed-root files byte-for-byte to their committed content (verified via `cmp` against blob `c2ea79b117`), re-applied the work cleanly in the worktree, and confirmed the deployed root is unmodified. No git corruption occurred.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-ci-watcher-rate-limit-cooldown.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 138 tokens (6127912 cached reads)
- Output: 46094 tokens
- Cost: $5.498655999999999
- Wall-clock: 936s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
