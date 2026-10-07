---
tier: mentor
handler-timeout: 5400
split-indivisible-reason: 'single-function edit to journal_deepen_from_root plus stderr threading through _journal_root_seed_fetch and its one regression test file; the retry predicate, diagnostic capture, and test fixtures depend on each other, so any split leaves an untested or unimplemented half; prior overrun came from running the full test suite rather than the targeted seed-from-root test'
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-10-07T16:37:42Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Bounded jittered retry for journal_deepen_from_root (expanded window)

Scope (single coherent change; do not re-split):

`scripts/jobs/common.sh` `journal_deepen_from_root` (~line 5086) performs exactly
one local `_journal_root_seed_fetch "$dir" --unshallow` and, on failure, leaves
the clone shallow (observed 2026-10-07T14:53:23Z). Change it to:

1. Retry the `--unshallow` fetch a bounded number of times (new knob, e.g.
   `GARDEN_JOURNAL_DEEPEN_ATTEMPTS`, default 3) with jittered sleep between
   attempts (e.g. `GARDEN_JOURNAL_DEEPEN_RETRY_BASE` seconds plus random jitter;
   keep total wait small, a few seconds) — but ONLY when the failure is transient
   root-repository lock/contention (stderr matching `index.lock`/`*.lock` exists,
   `Unable to create ... .lock`, `cannot lock ref`, `shallow.lock`, packed-refs lock,
   etc.). Non-transient failures fall straight to the existing fallback.
2. Capture git's stderr from the fetch (`_journal_root_seed_fetch` currently
   discards it — thread a stderr capture through, or add an optional err-file
   argument, without changing its existing callers' behavior) and include the final
   diagnostic (last non-empty line(s), trimmed) in the existing WARN log line.
3. Keep the existing shallow fallback and rc contract (rc 0 complete, rc 1 stays
   shallow until a later sync).

Tests: extend `scripts/jobs/test/journal-clone-seed-from-root-test.sh` (run ONLY
that test, not the whole suite — the full suite is what consumed the previous
2400s window) to cover: transient lock failure then success (retried, rc 0);
persistent lock failure (bounded attempts, WARN includes the git diagnostic,
rc 1, clone usable); non-transient failure (no retry). Make sleep injectable /
zero in tests (e.g. set the base delay to 0) so the test stays fast. Also run
`bash -n` and shellcheck on common.sh if available.

Commit explicit pathspecs; push to main2 with the garden_repo_lock CAS loop.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-10-07T16:37:50Z
