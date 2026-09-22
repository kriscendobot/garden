Done. Pushed to `main2` as `c0369b58a5`.

## Completion report

**Job:** `improve-comment-cursor-retry` — capture cursor-set diagnostics and add a bounded retry/classification path before leaving the comment-watcher's poll cursor unchanged.

**Root cause addressed:** Both `comment-watcher.sh` and `triager.sh` advanced their journal poll cursor with a bare `printf … | cursor-set.sh … ; else rc=$?` one-liner. The captured rc could neither identify *why* the write failed nor re-attempt it, so on a busy host (kriscendobot-minion.town) a persistent `rc=1` — cursor-set's own 50-attempt CAS loop losing to a contention burst — left the cursor unchanged and **replayed the same comment range every tick**, behind a warning that couldn't distinguish a transient journal-write failure from a structural fault.

**What changed:**
- **`common.sh` — new `advance_cursor_with_retry` helper** (+ `_cursor_advance_diag_tail`, + `GARDEN_CURSOR_ADVANCE_RETRIES` default 3). It buffers the cursor body, captures cursor-set's stderr, and classifies the failure:
  - `GARDEN_OFFLINE_RC` (latched outage / busy cursor-IO lock) → skip **quietly**, no retry (a retry only short-circuits to the same verdict).
  - a positively-identified **DEFINITE** failure (auth / gone-upstream / corruption / local, via the existing `journal_diagnostic_is_definite_failure` boundary) → one loud WARN carrying the signature, **not retried** (a re-poll can't fix it).
  - the ambiguous **CAS-contention** shape → a bounded number of **fresh** cursor-set invocations under `backoff`, then a single transient WARN if still failing. Returns an rc (never `exit`s) so the caller keeps the tick.
- **`comment-watcher.sh`** and **`triager.sh`** now call the helper instead of the inline one-liner, so their advance-failure handling cannot drift.
- **`comment-watcher-test.sh`** — rewrote the CURSOR-SET section to assert all three verdicts and their retry counts (offline: quiet + 1 call; definite/auth: loud + 1 call; ambiguous: retried to the bound + transient WARN).

**Verification:**
- `bash -n` clean on all three scripts; shellcheck clean on the new helper (only pre-existing unrelated warnings elsewhere).
- `triager-test.sh`: 143 passed, 0 failed.
- `comment-watcher-test.sh`: 366 passed, **1 failed** — that one failure (`MP2b … does not start at stage: clean`) is a **pre-existing, unrelated** drift: `gauntlet.sh` now begins at a `viability` stage before `clean`, which my change does not touch.

**Follow-up (optional):** the pre-existing `comment-watcher-test.sh` MP2b assertion should be updated to the gauntlet's current `viability`-first initial stage — separate from this job.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-comment-cursor-retry.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 118 tokens (5118967 cached reads)
- Output: 34112 tokens
- Cost: $4.763942499999999
- Wall-clock: 746s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
