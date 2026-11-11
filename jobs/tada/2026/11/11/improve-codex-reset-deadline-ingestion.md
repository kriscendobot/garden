I made no new commits: the fix this job asks for had already landed on `origin/main2` as `18fc7b17375` ("fix(budget): ingest Codex reset deadlines"), committed about five minutes before I claimed the job. I checked it against the spec and it covers everything asked.

**What's on main2**
- **Ingestion before freezing:** in `scripts/jobs/budget-level.sh`, when a pool's reset window can't be resolved, the new `ingest_codex_reset_deadline` runs before the fallback alert. It only applies to openai percent pools whose cleric is mapped to this host. It reads the newest `token_count` event from the 20 most recently modified Codex rollout files (`$GARDEN_CODEX_LOGDIR`, default `~/.codex/sessions`). It accepts the event only if `rate_limits.primary.resets_at` is a whole number later than now.
- **Recording:** an accepted deadline is appended through `append-reset-event.sh` as `expected-next-scheduled` / `scheduled`, with dedup key `codex-primary-reset-<epoch>`. The ramp is then re-read in the same tick, so a fixed pool clears the freeze instead of alerting.
- **Fallback:** if there is no telemetry, or the newest reading is malformed or already past, the pool stays on the 0.95 fallback with the existing edge-latched alert. An older valid reading never stands in for a newer bad one.
- **Tests:** `scripts/jobs/test/budget-level-codex-reset-ingestion-test.sh` covers the four requested cases: absent (two ticks, one alert), malformed, expired, and refreshed (the event is appended, ingestion is logged, and no fallback warning appears).

**Checks**
- **Test run:** I ran the test in this worktree and it printed `PASS`.
- **Field name:** `resets_at` was checked only against the format the fix itself assumes. Nothing else in the repo reads it; `quota-panel.sh` reads the sibling field `rate_limits.primary.used_percent` from the same events.
- **Real logs:** this host's sandbox has no `~/.codex/sessions` files, so I couldn't test against real Codex logs.

**Follow-ups (optional)**
- Older Codex CLIs may report `resets_in_seconds` rather than `resets_at`. Those readings would be ignored and the pool would fall back safely. A small extension could turn that field into an absolute time using the event's timestamp.
- The fix helps `codex-endolin` only once the leader's root checkout is updated to include `18fc7b17375`.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-codex-reset-deadline-ingestion.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s) (1 unmetered)
- Input: 14 tokens (386208 cached reads)
- Output: 2264 tokens
- Cost: $0.5427376 (1 engagement(s) unpriced)
- Wall-clock: 507s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
