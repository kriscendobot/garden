Inbox empty. Work is complete and pushed. Here is my report.

---

## Completion report: `foreman-meter-from-claude-code-session-logs`

**Landed on `main2` as `d52bb1ce2`** (committed `f728bab3d`, rebased onto concurrent fleet pushes via the CAS loop). Built in an isolated worktree off `origin/main2`, explicit-pathspec commit, pushed `HEAD:main2`.

### What changed

**`scripts/jobs/usage-meter.sh` — `meter_window_total` re-pointed at Claude Code session logs (the core ask).**
- Now SUMs billable tokens from `~/.claude/projects/**/*.jsonl` over the trailing `GARDEN_TOKEN_WINDOW_SECS` (default 7d), in plain code (jq over JSONL, `require`-jq), via a new `_meter_session_total` helper. New `GARDEN_CCUSAGE_LOGDIR` config (default `~/.claude/projects`).
- **Billable = input + output + cache_creation** (cache_read excluded; `GARDEN_TOKEN_COUNT_CACHE_READ=1` folds it in — documented, one-knob adjustable).
- **Dedup by message id** (first occurrence wins). This mattered: a single streamed message repeats its final `usage` across many log lines — in the latest live session, 22 usage lines but only 9 distinct ids. Without dedup the meter would have ~2.4×-overcounted.
- Resilient to malformed lines (`jq -R 'fromjson? // empty'`); mtime-prunes the file scan to the window so it scales over the ~2.7k files.
- **Fail-open**: missing/unreadable log dir AND no fallback ledger → returns non-zero → `unknown` → foreman pumps + warns, never wedges.
- The legacy hand-appended ledger is kept as an **optional fallback only**.
- Sanity-checked against real logs: **128.5M billable tokens trailing-7d**, 280M trailing-30d — a real, non-zero signal (the old meter always read 0).

**`scripts/systemd/garden-foreman.service`** — commented `GARDEN_TOKEN_WEEKLY_QUOTA` placeholder + tunables, so the maintainer arms the gate by filling in the number (or via a drop-in).

**`scripts/jobs/foreman.sh`** — doc block updated to name session logs as the source and state the subscription/no-API rationale.

**`scripts/jobs/test/run-test.sh`** — subtest 14b reworked to drive the foreman off synthetic session-log fixtures (under-quota pump / over-quota back-off+throttle / broken-meter fail-open / ledger fallback); new subtest **14c** unit-tests `meter_window_total` directly (in-window deduped sum, old-line exclusion, cache_read toggle, missing-source→unknown, ok/backoff verdicts). **Full suite: 194 passed, 0 failed** on the pushed HEAD.

### Decisions per the spec
- **Admin Usage/Cost API deliberately NOT wired** — it's API-key/Console-billing only, doesn't apply to a Max x20 subscription.
- **Multi-host**: documented **single-host (endolinbot) assumption** with an explicit `TODO(multi-host)` to aggregate per-host trailing-window totals via the journal (per-host `~/.claude` undercounts the global quota if the fleet ever spends on >1 host).
- **Manual pause left untouched** — `pause.conf` is the maintainer's to lift.

### Open question for the maintainer (gate stays OFF until answered)
**What is the Max x20 weekly token allowance for `GARDEN_TOKEN_WEEKLY_QUOTA`?** It isn't machine-readable (Claude Code `/usage` shows usage, not a token cap), so per the spec I did **not** guess a number into the unit. The gate is wired and tested but disarmed (`GARDEN_TOKEN_WEEKLY_QUOTA` unset = meter OFF). Once the number is set in the foreman unit (or a drop-in), the foreman will back off automatically near the weekly limit. For context: current spend is ~128M tokens/trailing-7d. Also unknown is the subscription's exact weekly **reset cadence** — defaulted to a rolling 7-day window (errs toward backing off slightly early, never late).

### Follow-up
- `multi-host token aggregation` if the fleet ever spans hosts on the one subscription (TODO marked in `usage-meter.sh`).
