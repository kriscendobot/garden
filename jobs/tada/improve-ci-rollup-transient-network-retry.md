Pushed cleanly on the first try. Work complete.

## Completion report

**What the job asked:** Wrap the single `gh pr view` call in `scripts/jobs/handlers/ci-rollup-gh.sh` in a bounded retry that fires only on transient-network stderr, never on rate-limiting, and falls through to the existing `exit 1` on budget exhaustion; add a test.

**What I did:**

- **`scripts/jobs/handlers/ci-rollup-gh.sh`** — Replaced the single-shot `gh pr view` with a bounded retry loop mirroring `clone-keeper.sh`'s `bounded_fetch` (up to `GARDEN_FETCH_RETRIES` attempts with `backoff` between them, both already defined in `common.sh`). Added two classifier helpers:
  - `is_transient_network` matches `TLS handshake timeout`, `connection reset`, `i/o timeout`, `unexpected EOF`, `Temporary failure in name resolution` (case-insensitive).
  - `is_rate_limited` matches `rate limit`, `API rate limit exceeded`, `403`.
  
  Logic: a rate-limit stderr (or any non-transient error) exits `1` immediately with no retry — so ci-watcher.sh's cascade circuit-breaker keeps sole ownership of throttling and a retry can't deepen the cooldown. Only a transient blip retries; exhausting the budget falls through to the same `exit 1` (watcher skips, never guesses). Added a `GARDEN_CI_ROLLUP_GH` override seam (defaults to `gh`) so the gh command is stubbable in tests.

- **`scripts/jobs/test/ci-watcher-test.sh`** — Added assertion **L** with a `GARDEN_CI_ROLLUP_GH` counting stub: a transient TLS-timeout stderr retries to the budget (3 attempts) then exits 1; a `403 / API rate limit exceeded` stderr is a single attempt (no retry) then exits 1; a generic non-transient/non-rate-limit error (a 404) is also a single attempt.

**Verification:** Full suite passes **24/24** (was 19, +5 new). Separately confirmed the happy paths are unchanged (green→10, red→0) via a JSON-emitting stub.

**Follow-ups:** none. The change is self-contained; the retry budget/backoff reuse existing `GARDEN_FETCH_RETRIES`/`backoff` knobs, so no new config surface.
