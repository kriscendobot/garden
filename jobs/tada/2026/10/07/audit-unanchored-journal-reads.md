Empty inbox. Work is complete and pushed. Here is the completion report.

---

## Job complete: audit-unanchored-journal-reads

**Root cause fixed in `scripts/jobs/usage-meter.sh` (pushed to `main2` as `823eddff5ba`).** Unanchored journal reads — those with no journal-dir argument — discovered their clone with the glob `"$GARDEN_STATE"/*/journal` and took the **alphabetically-first** match. On 2026-10-07 that was the 36h-stale `accountant` clone still carrying the retired `config/token-backoff-fraction` pin, which held the foreman at `backoff` for 90 min. Commit `0c64481` patched only the one foreman call site; this job fixes the root and every sibling.

### Inventory & disposition

**Root-cause sites (the "first clone found" glob) — fixed:**
| Site | Disposition |
|---|---|
| `budget_pool_file` glob fallback | Now resolves via new `_meter_discover_journal`: caller's own clone (`GARDEN_WORKER_CLONE`/`GARDEN_PRODUCER_CLONE`) wins; else the `$GARDEN_STATE/*/journal` whose **journal2 commit is newest**; no readable candidate → fail closed (callers already treat as missing config). |
| `subscription_reset_file` glob fallback | Same `_meter_discover_journal`. |
| `_token_backoff_journal_dir` | Already routed through `budget_pool_file("")`, so inherits the fix automatically. |

**Callers that had a synced clone in scope but passed `""`/no dir — anchored:**
| Caller | Fix |
|---|---|
| `handlers/foreman-claude.sh` (4 reads: provider-key, codex, anthropic) | `meter_dir="${GARDEN_PRODUCER_CLONE:-}"` threaded into every `meter_quota_status`/`budget_pool_for_provider_host`. |
| `handlers/mentor-claude.sh` | `meter_quota_status "" "$dir"`. |
| `quota-panel.sh` (4 reads) | All read from the single discovered `panel_directory`, so the panel can't mix two clones' views. |
| `accountant-statement.sh`, `accountant-reslice-nudge.sh`, `triager-pace.sh` | `meter_week_anchor_epoch`/`meter_next_reset_epoch` now take an optional `[journal-dir]`; passed the in-scope `$dir`/`$directory`. |
| `budget_hold_wrap` ← `post-job.sh`, `scheduler.sh` | New optional `[journal-dir]` arg, threaded from each producer's synced `$DIR`. |

**Verified already-correct (dir threaded end to end):** `budget_fleet_status`, `budget_fleet_next_reset_epoch`, `meter_quota_status`, `subscription_used_percent`, `token_backoff_fraction_for`, `budget_pool_for_provider_host`, `resolve_token_backoff_fraction` — all accept and forward `dir`; their callers (`foreman.sh`, `gauntlet.sh`, `claim-job.sh`, `deadline-nudge.sh`, `budget-level.sh`, `budget-refresh.sh`) already pass `$DIR`.

**Left unanchored by design (documented):** `post-plan.sh:284` runs `meter_next_reset_epoch` during arg-parsing, *before* `DIR` is resolved/synced — no clone exists to anchor to, and it is now covered by the freshest-clone discovery fallback. Other glob sites (`state-clone-keeper.sh`, `_journal_remote_from_state_clones`) are not quota reads — they sweep/scan clones deliberately and are out of scope.

### A second, latent defect found and fixed
The discovery scan must read each clone's commit time without the fleet git **wrapper** (which takes a per-clone lock and, under ~100-gardener load, blocks seconds behind in-flight syncs). My first cut routed through a binary that resolved to the **worktree's own** `scripts/jobs/bin/git` wrapper (first on PATH), making the scan take **36s**. Fixed by skipping any candidate resolving to `*/scripts/jobs/bin/git` (catches the root and every per-job worktree wrapper) and resolving the raw binary **once**, not per-clone. Measured: **36s → 91ms** across 46 clones.

### Tests
- **New:** `scripts/jobs/test/stale-sibling-journal-clone-test.sh` — 10 cases, all pass. Pins that a stale sibling's old pin can't flip a verdict (`ok`, not `backoff`, at 10% use), that explicit dirs / the caller's own clone stay authoritative, that freshness (not name) decides, and that discovery fails closed. Confirmed it **fails on clean HEAD** (8/10 cases) and **passes with the fix**.
- **Affected suites pass** (`TMPDIR` set to an exec dir; run serially): `token-backoff-ramp`, `quota-panel`, `subscription-used-percent-per-subscription`, `quota-calibration`, `weekly-capacity-calibration`, `scheduler-admission`, `gauntlet-panel-quota`, `triager-pacing`, `foreman-provider-order` (43/0), `detect-quota-resets`, `meter-journal-cutoff`, `provider-quota-backoff`, `accountant-arc-apportionment`, `deadline-nudge` (59/0), `worker-health-gate` (74/0), `live-budget-admission`, `mentor-transient-backoff`, and more.
- **Pre-existing failures (NOT mine):** 12 suites fail identically on clean HEAD and my tree (same pass/fail counts) — environmental (this host lacks systemd/worktree/gh fixtures; parallel runs hit `fork: Resource temporarily unavailable`): `gardener-worktree`, `project-worktree-isolation`, `botany-worktree-scripts-disabled`, `kimi-*`, `monk-claude-tree-reap`, `productive-cycle`, `claude-session-limit-classifier`, `review-rounds`, `handler-budget`, `budget-live-percent-label`. `foreman-edge-kick`'s one failure is exactly the documented "did not complete to tada/ when the kick failed" case the spec said to leave alone.

### Follow-ups
- None required. Optional cleanup someday: move `post-plan.sh`'s budget-reset computation after `DIR` resolution so it, too, anchors explicitly rather than relying on the (now-safe) discovery fallback.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/audit-unanchored-journal-reads.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s) (1 unmetered)
- Input: 74 tokens (5107827 cached reads)
- Output: 28231 tokens
- Cost: $4.808918500000002 (1 engagement(s) unpriced)
- Wall-clock: 3145s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
