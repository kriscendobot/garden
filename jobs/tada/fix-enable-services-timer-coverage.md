Done. Worktree torn down, inbox empty.

---

## Completion report

**Job:** `fix-enable-services-timer-coverage` — fix `install-units.sh enable-services` so it enables every intended garden timer/service instead of a hand-maintained list that drifts.

**Root cause:** `enable_services()` enabled units from a hand-coded list. New `garden-*.timer`/`.service` units added after the list was written were silently never enabled, so they stayed dormant.

**What I did (SHA `ead82a5bd` on `main2`):**
- Rewrote `enable_services()` to **derive the enable set from the units actually present** in `scripts/systemd/`:
  - every non-template `garden-*.timer` with `WantedBy=timers.target`;
  - every standalone continuous `garden-*.service` (no sibling timer, declares `[Install]`) — i.e. the bulletin and the design-poller.
- **Documented exclusions** (in-script): template units (`garden-*@`, enabled per-instance) excluded structurally by the `@` filter; **`garden-mention-watcher`** excluded by name per the monitoring-safety constraint (left for the maintainer to arm). Retired `garden-bulletin.timer` is still disabled on enable.
- Added **`enable-services --verify`** — an idempotent, read-only drift check that logs any intended unit not currently enabled and exits non-zero (feeds a future watchman/bulletin check).
- Added `scripts/jobs/test/enable-services-test.sh` (15 assertions, mocked systemctl) and taught `mock-systemctl.sh` `is-enabled`. `bash -n` clean; new code shellcheck-clean (remaining notes are the pre-existing `ok/bad` idiom and an untouched line).

**Enabled set (13):** deadmail, follow-up, foreman, gardener-scaler, mentor, mirror-closer, proxy, reaper, repo-watcher, scheduler, watchman (timers) + bulletin, design-poller (services).
**Excluded:** all `garden-*@` templates; `garden-mention-watcher.{timer,service}`.

**Redeployed on endolinbot** (`install` + `enable-services`). The pre-deploy drift check caught **two genuinely dormant services the hand-list had missed**: `garden-bulletin.service` (running but not enabled-at-boot) and `garden-design-poller.service` (**inactive + disabled** — the design-poller that posts build jobs wasn't running at all). Both are now `enabled` + `active`; post-deploy `--verify` reports no drift; `garden-mention-watcher` remains disabled.

**Follow-ups:** The drift `--verify` is ready to be wired into the watchman or bulletin as a periodic check so future unit additions can't go dormant unnoticed — left as a suggestion, not done here.
