Done. Work complete and pushed to `main2`.

## Completion report

**Job:** `improve-ci-outage-warning-dedup` — deduplicate stale-shepherd "journal fetch failed" warnings across per-repo CI watchers with a host-scoped outage latch and recovery notice.

**Problem:** In `scripts/jobs/ci-watcher.sh`, the stale-shepherd re-validation sweep's `verify_fetch fresh` failure emitted `WARN: stale-shepherd sweep skipped this tick — journal fetch failed`. Each watched repo runs its own `garden-ci-watcher@<slug>` unit, so one *shared* journal outage produced N indistinguishable WARN lines — once per repo, every tick — making a single total-outage fault read as N unrelated per-repo problems.

**What I did:**
- Added a **host-scoped edge latch** (`GARDEN_CI_JOURNAL_OUTAGE_LATCH`, default `$GARDEN_STATE/ci-watcher/journal-outage`) — deliberately *not* keyed by slug, since the whole point is dedup across repos. Two helpers modeled on `common.sh`'s `worker_health_gate` healthy/unhealthy edge latch:
  - `note_journal_outage` — atomic `mkdir`; the first watcher to hit the outage wins and warns loud + records `since`/`first`; every later watcher (any repo, same host) logs a quiet, *non-WARN* deduped line.
  - `note_journal_recovered` — atomic `mv`; the first watcher to see the journal reachable again clears the latch and emits one recovery notice.
- Wired them into the sweep: `note_journal_recovered` on the success branch, `note_journal_outage` replacing the raw WARN on the failure branch.
- Degrades safe: unwritable state still logs; the happy path is one cheap `[ -d ]` test with no extra I/O.

**Changed files:**
- `scripts/jobs/ci-watcher.sh` — latch config default, two helpers with a documenting comment block, sweep wiring.
- `scripts/jobs/test/ci-watcher-test.sh` — new **case R** (7 assertions): arm+loud-warn, latch marker created, deduped line on a second differently-slugged watcher sharing host state, no re-emitted loud WARN, recovery notice + latch cleared, and no spurious recovery on a subsequent healthy tick.

**Verification:** `bash scripts/jobs/test/ci-watcher-test.sh` → **59 passed, 0 failed**. `bash -n` clean on both files; `shellcheck -x` introduces no new findings (only pre-existing ones remain). Committed and pushed to `main2` on the first CAS attempt.

**Follow-ups:** none.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-ci-outage-warning-dedup.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 49 tokens (2134157 cached reads)
- Output: 17642 tokens
- Cost: $2.3785435
- Wall-clock: 259s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
