Inbox is empty. Work complete.

---

## Completion report

**Job:** `improve-follow-up-classify-inner-claude-failure`

**Problem:** `follow-up-claude.sh` treated *every* non-zero `claude -p` exit as a blind tick failure that `follow-up.sh` retried against the same digest indefinitely — the 2026-06-27 07:53–08:44 outage re-rolled one bad digest ~6 times.

**What I did:**

1. **`scripts/jobs/common.sh`** — Factored the gardener's inline inner-claude regex into a shared single-source-of-truth helper, placed next to the offline classifier:
   - `GARDEN_TRANSIENT_CLAUDE_SIGNATURES` (the canonical regex: `overloaded|rate[ _-]?limit|connection error|\b(429|5[0-9][0-9])\b|api[ _-]?error|econnreset|etimedout`)
   - `is_transient_claude_signature()` — returns 0 for a transient blip, 1 for a genuine failure.

2. **`scripts/jobs/gardener.sh`** — Replaced its duplicated inline `grep -qiE '...'` (formerly at line 170) with a call to the shared helper, so the two lists can never drift.

3. **`scripts/jobs/handlers/follow-up-claude.sh`** — Rewrote the inner-claude failure path to classify:
   - **Transient signature** → `die` (fail the tick), so `follow-up.sh` keeps the seen-marker and retries the same digest next cadence — the historical behavior, now scoped to transient failures only.
   - **Non-transient** (genuine crash / malformed prompt / auth) → route the captured stderr+stdout to the maintainer inbox via the existing `route_rejected` / `inbox-send.sh maintainer` path, then `exit 0` so the seen-marker advances and the bad digest stops wedging the service.
   - Moved the `route_rejected` definition above the `claude -p` invocation so the failure path can reuse it.

4. **`scripts/jobs/test/run-test.sh`** — Added SUBTEST 13b cases (C) and (D): transient inner-claude failure → tick fails / marker not advanced; non-transient → routed to maintainer + exit 0 / marker advanced (driven via the existing `fake-claude.sh` `FAKE_CLAUDE_FAIL`/`FAKE_CLAUDE_STDERR` hooks).

**Verification:** Full `run-test.sh` suite passes (`178 passed, 0 failed`), including the 3 new assertions. Also unit-checked the classifier against 9 transient/genuine signatures (all correct).

**Landed:** Commit `af320c0af` pushed to `origin/main2` (built in an isolated worktree off `origin/main2` per garden infra-job discipline, committed with explicit pathspecs; shared tree restored to base, worktree removed).

**Follow-ups:** None. The gardener and follow-up handler now share one classifier; future signature additions go in `GARDEN_TRANSIENT_CLAUDE_SIGNATURES` and both paths inherit them.
