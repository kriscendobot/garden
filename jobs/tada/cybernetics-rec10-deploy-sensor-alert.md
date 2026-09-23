All green. HEAD equals `origin/main2`; the deployed root was left untouched (my earlier stray root edits were fully reverted — a future deliberate deploy will carry these changes in).

## Completion report

Implemented recommendation 10 of `designs/cybernetics-audit.md` (§ 7 [wrong sensor, low urgency]) — making the deliberate-deploy sensing loop's own failures observable. Landed bare on `main2` as `5a5d705275`.

**1. `upgrade-monitor.sh` no longer counts blindness as health.** The three silent `exit 0` paths (fetch of `origin/main2` failed; unresolvable available sha; no deployed sha) now route through a new `silent_skip()` that counts *consecutive* blind ticks in `$GARDEN_STATE/upgrade-monitor/consecutive-silent-skips`. Past `GARDEN_UPGRADE_SILENT_SKIP_ALERT` (default 12 ≈ 1h at the `:02/5` cadence) it raises ONE keyed alert via `alert_maintainer` → `watchdog-notice.sh` (the amend-while-unread discipline, so persistent blindness never duplicates). A readable tick calls `silent_skip_clear()` — resets the counter and closes the episode with a recovery notice. A one-off transient blip stays silent. This surfaces the 07-17..09-01-class silence in ~an hour rather than weeks.

**2. `root-repo-guard.sh`'s stalled-deploy window is now per host class.** The ambient deploy actuator (the liaison's deploy-on-upgrade Monitor) is a leader-only singleton, so a follower host is effectively bot-only for auto-deploy and its Upgrade-ready markers accumulate with no ambient actuator. The fuse now defaults by class via `is_main_host`: `GARDEN_DEPLOY_STALL_DAYS_LEADER` (3) vs `GARDEN_DEPLOY_STALL_DAYS_FOLLOWER` (1). An explicit `GARDEN_DEPLOY_STALL_DAYS` still overrides either direction (backward-compatible).

**Tests:** `upgrade-monitor-test.sh` gains a silent-skip watchdog case (count → threshold alert → recovery) — 25/25 pass. `root-repo-guard-test.sh` gains CASE 6b (follower alerts at ~2d, leader stays quiet, explicit override wins) and pins `GARDEN_LEADER` for offline/hermetic `is_main_host` — 68/68 pass. `bash -n` clean on both scripts; shellcheck shows only pre-existing info-level items (SC1091 source line, SC2015 at an untouched line).

**Verification:** used `local-verify`/`pre-push-gates` shape appropriate to garden shell scripts (syntax + shellcheck + the two dedicated hermetic suites, all green); re-ran post-rebase over an intervening inode-loop commit — no conflict, still green.

**Process note (no follow-up needed):** I initially edited the deployed-root copies by absolute path; I fully reverted those and re-applied the changes in this job's worktree before committing. The root checkout is back to its pristine (older) deployed state; no git command was ever run there.

Follow-ups: none required. The new thresholds are conservative defaults and fully env-overridable; a host that wants different fuses can set the knobs without a code change.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/cybernetics-rec10-deploy-sensor-alert.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 99 tokens (5265632 cached reads)
- Output: 52967 tokens
- Cost: $5.278719999999998
- Wall-clock: 690s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
