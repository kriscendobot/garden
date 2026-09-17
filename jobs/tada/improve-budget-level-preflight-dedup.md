Pushed to `main2` (`0a30deca2b`). Done.

## Completion report

**Job:** `improve-budget-level-preflight-dedup` — stop the monk-preflight config-freeze in `scripts/jobs/budget-level.sh` from warning/alerting on every leveling tick; persist a fingerprint, edge-latch begins/changes, and emit one recovery notice when valid config returns.

**Root cause:** When monk allocation was frozen (`mv=0`), line 84 ran `log "WARN…"` *and* `alert_maintainer budget-level-monk-preflight …` unconditionally every tick. `alert_maintainer`'s hourly throttle still let the folded count climb forever, and no `alert_maintainer_clear` was ever called, so the incident never closed when config was fixed — the reported `oros-studio-garden-ce242c49` failure noticing every tick.

**What changed:**
- `scripts/jobs/common.sh` — added two reusable helpers next to `alert_maintainer`/`alert_maintainer_clear`:
  - `alert_maintainer_edge <key> <fingerprint> <msg>` — persists a fingerprint under the dedup key (`$GARDEN_STATE/alerts/<key>.fingerprint`) and delivers only when the fault **begins** (no stored fp) or **changes** (fp differs); on a change it clears the `.last` throttle marker so a genuinely new reason re-alerts immediately rather than being swallowed by the open window. Returns 0=fired / 1=suppressed so callers can gate their own log line.
  - `alert_maintainer_edge_clear <key> [msg]` — drops the fingerprint and emits exactly one recovery notice via `alert_maintainer_clear`, but only if a fault was latched (no-op → returns 1 otherwise).
- `scripts/jobs/budget-level.sh` — thin `report_freeze`/`report_unfreeze` wrappers that delegate to those helpers and gate the local `WARN`/recovery log on the same edge. The monk-preflight `then`/`else` now calls `report_unfreeze` on recovery and `report_freeze "$bad" …` on freeze.
- `scripts/jobs/test/alert-maintainer-edge-test.sh` — new unit test (no `claude`, no network): asserts begin fires, unchanged repeats collapse to one delivery, a changed fingerprint re-fires, recovery emits exactly one notice and clears the latch, idempotent recovery is a no-op, and the latch re-arms after recovery. Wired into `.github/workflows/checks.yml` focused tests.

**Verification:** `bash -n` clean on both scripts; new test PASS; existing `budget-snapshot-warning-dedup-test` and `reputation-reduce-incremental-test` (both source `common.sh`) still PASS. shellcheck shows only pre-existing informational notes.

**Follow-ups (not done, out of scope):** The cleric-allocation freezes (`log "WARN: cleric allocation frozen…"` at the two `else`/guard sites) still log every tick but never alert the maintainer — a smaller journal-only noise source that could be routed through the same `report_freeze`/`report_unfreeze` pair if desired.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-budget-level-preflight-dedup.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 76 tokens (2867278 cached reads)
- Output: 30911 tokens
- Cost: $3.0721879999999993
- Wall-clock: 461s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
