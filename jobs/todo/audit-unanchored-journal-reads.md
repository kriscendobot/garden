---
role: fixer
tier: mentor
fallback-tier: minion
arc: garden-upkeep
handler-timeout: 7200
dispatch: automatic
---
**Role: fixer.** Audit and fix **unanchored journal reads** in the garden's own scripts (repo `kriscendobot/garden`, branch `main2`; push directly, no PR).

**Background (2026-10-07 incident, fixed at the foreman call site in main2 `0c64481`).** `scripts/jobs/handlers/foreman-claude.sh` called `meter_quota_status` with no journal dir. `budget_pool_file` (`scripts/jobs/usage-meter.sh`, ~line 505) then fell back to `GARDEN_WORKER_CLONE`/`GARDEN_PRODUCER_CLONE` and finally to the glob `"$GARDEN_STATE"/*/journal`, taking the alphabetically-first clone: `.garden-state/accountant/journal`, which was 36h stale and still held the retired `config/token-backoff-fraction` pin. The anthropic verdict read `backoff` (live use ~10%) and the foreman logged `handler-transient rc=75` for ~90 min, pumping nothing. `_token_backoff_journal_dir` inherits the same fallback.

**Task.**
1. Inventory every path that resolves journal state without an explicit, freshly-synced dir: the `budget_pool_file` glob fallback and every caller of it, `_token_backoff_journal_dir`, `meter_quota_status` / `subscription_used_percent` / `token_backoff_fraction_for` / `budget_pool_for_provider_host` / `resolve_token_backoff_fraction` called with `""` or no dir, and any other `$GARDEN_STATE/*/journal` glob or "first clone found" pattern in `scripts/`.
2. Fix it at the root. Preferred: anchor each caller to the clone it just synced (as `0c64481` did for the foreman), AND make the glob fallback refuse to trust a stale clone (pick the freshest by journal2 commit time, or fail closed to `unknown`, which callers already handle). Don't silently change any verdict semantics beyond that.
3. Add a regression test showing that a stale sibling clone carrying an old pin can't change a verdict.
4. Run the affected test suites under `scripts/jobs/test/` (note: `/tmp` is noexec on this host, so set `TMPDIR` to an exec-capable dir). `foreman-edge-kick-test` already fails one case ("the job did not complete to tada/ when the kick failed") with or without these changes; leave it alone unless it's related.

**Done when:** the inventory, with each site's disposition, is in the tada report; the fixes and test are pushed to `main2`; suites pass.
