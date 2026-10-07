---
role: orchestrator
split_eligible: true
split_reason: deadline-overrun
split_source_role: ordinary
split_source_handler_timeout: 7200
split_orchestration: improve-journal-deepen-retry-expanded-window-expanded-window-split
reposted_by: reaper:endolin-garden2-5bcdff64
reposted_at: 2026-10-07T20:23:17Z
---

# Deliberate overrun decomposition for `improve-journal-deepen-retry-expanded-window-expanded-window`

This ordinary job hit its applied 7200s handler wall once without productive progress. That one deterministic overrun is sufficient cause to split; do **not** continue implementing the original work in this claim.

Read `roles/orchestrator/AGENT.md` and `skills/orchestration/SKILL.md`. Your first and only substantive act is to decide whether the original work genuinely decomposes, then use the existing journal primitives:

- **Divisible:** create at least two self-contained child jobs, park every child with `post-plan.sh --orchestrated --orchestrated-by improve-journal-deepen-retry-expanded-window-expanded-window-split`, then record `improve-journal-deepen-retry-expanded-window-expanded-window-split` with `post-orchestration.sh`.
- **Indivisible:** choose a concrete reason and a timeout strictly greater than 7200 and no greater than 14339; park exactly one child with `post-plan.sh --orchestrated --orchestrated-by improve-journal-deepen-retry-expanded-window-expanded-window-split --split-indivisible-reason REASON --split-indivisible-handler-timeout SECONDS improve-journal-deepen-retry-expanded-window-expanded-window-expanded-window BODY-FILE` so both child fields land atomically. Record the same reason as `split-indivisible-reason:` and the same timeout as `split-indivisible-handler-timeout:` in the orchestration description, then record the single-child orchestration. Do not hand-author the child fields; a generic "too large" assertion is not a reason.
- In either case, finish only after the parked child set and orchestration record exist durably. Declare the exact handoff `<<<GARDEN-JOB-HANDED-OFF: improve-journal-deepen-retry-expanded-window-expanded-window-split>>>` immediately before the completion signal so completion verifies the successor.
- Do not apply this split protocol to any gauntlet stage; gauntlet retries belong exclusively to its driver.

## Original job specification

---
tier: mentor
handler-timeout: 7200
split-indivisible-reason: 'single-function edit to journal_deepen_from_root plus stderr threading through _journal_root_seed_fetch and its one regression test file; the retry predicate, diagnostic capture, and test fixtures depend on each other, so any split leaves an untested or unimplemented half; prior overrun came from running the full test suite rather than the targeted seed-from-root test'
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-10-07T18:16:05Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Bounded jittered retry for journal_deepen_from_root (expanded window)

Implement this single coherent change in the garden repository. Do not split it
again.

In `scripts/jobs/common.sh`, change `journal_deepen_from_root` so its
`_journal_root_seed_fetch "$dir" --unshallow` operation retries a bounded number
of times (new knob such as `GARDEN_JOURNAL_DEEPEN_ATTEMPTS`, default 3), with a
small jittered delay controlled by a test-injectable knob such as
`GARDEN_JOURNAL_DEEPEN_RETRY_BASE`. Retry only transient root-repository
lock/contention failures: diagnostics such as `index.lock` or another `.lock`
existing, `Unable to create ... .lock`, `cannot lock ref`, `shallow.lock`, or a
packed-refs lock. A non-transient failure must immediately use the existing
fallback.

Capture stderr from the fetch without changing existing callers' behavior (for
example, add an optional error-file argument to `_journal_root_seed_fetch`). Add
the final trimmed, non-empty git diagnostic to the existing WARN line. Preserve
the shallow fallback and return contract: rc 0 means complete; rc 1 means the
usable clone remains shallow until a later sync.

Extend only `scripts/jobs/test/journal-clone-seed-from-root-test.sh` to cover:

- transient lock failure followed by success: retries and returns 0;
- persistent lock failure: bounded attempts, WARN includes the git diagnostic,
  returns 1, and the clone remains usable;
- non-transient failure: no retry.

Set the retry delay to zero in tests. Run only that targeted test, not the full
suite (the full suite caused the prior 5400-second overrun). Also run `bash -n`
and ShellCheck on `scripts/jobs/common.sh` if ShellCheck is available.

Commit explicit pathspecs and push to `main2` with the required
`garden_repo_lock` fetch/rebase/push CAS loop.
